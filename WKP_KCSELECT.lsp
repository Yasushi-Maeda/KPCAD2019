;;;2008/09/03YM@DEL;;;<HOF>************************************************************************
;;;2008/09/03YM@DEL;;; <�t�@�C����>: SCSelect.LSP                                                  
;;;2008/09/03YM@DEL;;; <�V�X�e����>: ****�V�X�e��                                                
;;;2008/09/03YM@DEL;;; <�ŏI�X�V��>: 00/03/15 ���� ���L                                            
;;;2008/09/03YM@DEL;;; <���l>      : �Ȃ�                                                          
;;;2008/09/03YM@DEL;;;************************************************************************>FOH<
;;;2008/09/03YM@DEL;@@@(princ "\nSCSelect.fas ��۰�ޒ�...\n")
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL;<HOM>*************************************************************************
;;;2008/09/03YM@DEL; <�֐���>    : C:SRSelect
;;;2008/09/03YM@DEL; <�����T�v>  : ���i�I��
;;;2008/09/03YM@DEL; <�߂�l>    : �Ȃ�
;;;2008/09/03YM@DEL; <�쐬>      :
;;;2008/09/03YM@DEL; <���l>      : �Ȃ�
;;;2008/09/03YM@DEL;*************************************************************************>MOH<
;;;2008/09/03YM@DEL(defun C:SRSelect (
;;;2008/09/03YM@DEL    /
;;;2008/09/03YM@DEL    #key #kenmei$ #i #no
;;;2008/09/03YM@DEL    #dcl_id
;;;2008/09/03YM@DEL    #SRQry$ #SRQry$$
;;;2008/09/03YM@DEL    #ret$
;;;2008/09/03YM@DEL    #loop
;;;2008/09/03YM@DEL    #seri$
;;;2008/09/03YM@DEL    SG_SERIES_CHG
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL  (if (= CG_CDBSESSION nil)
;;;2008/09/03YM@DEL    (progn
;;;2008/09/03YM@DEL      (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
;;;2008/09/03YM@DEL    );_(progn
;;;2008/09/03YM@DEL  );_if
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL  (setq #SRQry$$
;;;2008/09/03YM@DEL    (DBSqlAutoQuery CG_CDBSESSION
;;;2008/09/03YM@DEL      "select * from SERIES where ���j�b�g�L��='K' order by \"SERIES�L��\""
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL  );_setq
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL  (if CG_DEBUG
;;;2008/09/03YM@DEL    (setq *error* nil)
;;;2008/09/03YM@DEL    (StartUndoErr)
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL  (if (ssget "X" '((-3 ("G_LSYM"))))
;;;2008/09/03YM@DEL    (setq SG_SERIES_CHG nil)
;;;2008/09/03YM@DEL    (setq SG_SERIES_CHG T)
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL  (setq #seri$ (CFGetXRecord "SERI"))
;;;2008/09/03YM@DEL  (if #seri$
;;;2008/09/03YM@DEL    (progn
;;;2008/09/03YM@DEL      (setq CG_DBNAME      (nth  0 #seri$)) ; 1.DB����        
;;;2008/09/03YM@DEL      (setq CG_SeriesCode  (nth  1 #seri$)) ; 2.SERIES�L��  
;;;2008/09/03YM@DEL      (setq CG_BrandCode   (nth  2 #seri$)) ; 3.�u�����h�L��  
;;;2008/09/03YM@DEL      (setq CG_DRSeriCode  (nth  3 #seri$)) ; 4.��SERIES�L��
;;;2008/09/03YM@DEL      (setq CG_DRColCode   (nth  4 #seri$)) ; 5.��COLOR�L��  
;;;2008/09/03YM@DEL      (setq CG_UpCabHeight (nth  5 #seri$)) ; 6.��t����      
;;;2008/09/03YM@DEL      (setq CG_CeilHeight  (nth  6 #seri$)) ; 7.�V�䍂��      
;;;2008/09/03YM@DEL      (setq CG_RoomW       (nth  7 #seri$)) ; 8.�Ԍ�          
;;;2008/09/03YM@DEL      (setq CG_RoomD       (nth  8 #seri$)) ; 9.���s          
;;;2008/09/03YM@DEL      (setq CG_GasType     (nth  9 #seri$)) ;10.�K�X��        
;;;2008/09/03YM@DEL      (setq CG_ElecType    (nth 10 #seri$)) ;11.�d�C��        
;;;2008/09/03YM@DEL      (setq CG_KikiColor   (nth 12 #seri$)) ;12.�@��F        
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL    (progn
;;;2008/09/03YM@DEL      (CFYesDialog "���i������͂��܂�")
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL;;;      (setq CG_SeriesCode  "PI") ; 00/10/02 YM DEL �e�����݂邽��
;;;2008/09/03YM@DEL      (setq CG_BrandCode   "N")
;;;2008/09/03YM@DEL      (setq CG_UpCabHeight 2350)
;;;2008/09/03YM@DEL      (setq CG_CeilHeight  2450)
;;;2008/09/03YM@DEL      (setq CG_RoomW       3600)
;;;2008/09/03YM@DEL      (setq CG_RoomD       3600)
;;;2008/09/03YM@DEL;      (setq CG_DRSeriCode  "41")
;;;2008/09/03YM@DEL;      (setq CG_DRColCode   "B")
;;;2008/09/03YM@DEL      (setq #seri$ T)
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;2008/09/03YM@DEL  ;// ���i�I���_�C�A���O�łn�j�������ꂽ
;;;2008/09/03YM@DEL  (defun SRSelectOKClick ( / #ret$ #Qry$ )
;;;2008/09/03YM@DEL    (setq #Qry$ (nth (atoi (get_tile "seri")) #SRQry$$) )
;;;2008/09/03YM@DEL;;;     (princ "\n----------------------------------------------")
;;;2008/09/03YM@DEL;;;     (princ "\n(SRSelectOKClick) #Qry$=")(princ #Qry$)
;;;2008/09/03YM@DEL;;;     (princ "\n----------------------------------------------")
;;;2008/09/03YM@DEL;;;   #Qry$=(PIA K N K PI PI 1999�H  NewPI SK_PIA 0.0 1.0 0.0)
;;;2008/09/03YM@DEL;;; ("PIA" "K" "N" "K" "PI" "PI 1999�H " "NewPI" "SK_PIA" 0.0 1.0 0.0)
;;;2008/09/03YM@DEL    ;// �e���͍��ڂ��O���[�o���ݒ�
;;;2008/09/03YM@DEL    (setq CG_CeilHeight  (atoi (get_tile "hei")))
;;;2008/09/03YM@DEL    (setq CG_UpCabHeight (atoi (get_tile "uphei")))
;;;2008/09/03YM@DEL    (setq CG_RoomW       (atoi (get_tile "ww")))
;;;2008/09/03YM@DEL    (setq CG_RoomD       (atoi (get_tile "dd")))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    (setq CG_SeriesCode (car #Qry$))
;;;2008/09/03YM@DEL    (setq CG_BrandCode  (nth 2 #Qry$))
;;;2008/09/03YM@DEL    (setq CG_DBNAME      (nth 7 #Qry$))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    (done_dialog)
;;;2008/09/03YM@DEL    T
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL  (setq #loop T)
;;;2008/09/03YM@DEL  (while #loop
;;;2008/09/03YM@DEL    ;// �߂�l�̏����ݒ�
;;;2008/09/03YM@DEL    (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
;;;2008/09/03YM@DEL    (if (not (new_dialog "SRSelectDlg" #dcl_id)) (exit))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    ;// ��ި���ޯ��
;;;2008/09/03YM@DEL    (set_tile "lab" "���i�I��")  ;�޲�۸�����
;;;2008/09/03YM@DEL    (set_tile "hei"   (itoa CG_CeilHeight))
;;;2008/09/03YM@DEL    (set_tile "uphei" (itoa CG_UpCabHeight))
;;;2008/09/03YM@DEL    (set_tile "ww"    (itoa CG_RoomW))
;;;2008/09/03YM@DEL    (set_tile "dd"    (itoa CG_RoomD))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL;;;DCL ������Ŏg�p�ł���R���g���[������
;;;2008/09/03YM@DEL;;;
;;;2008/09/03YM@DEL;;;�R���g���[������   �� ��
;;;2008/09/03YM@DEL;;;\"                 �N�H�[�e�[�V����(������̓���)
;;;2008/09/03YM@DEL;;;\\                 �~�L��
;;;2008/09/03YM@DEL;;;\n                 ���s
;;;2008/09/03YM@DEL;;;\t                 �����^�u
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    ;// ؽ��ޯ��
;;;2008/09/03YM@DEL    (start_list "seri" 3)
;;;2008/09/03YM@DEL    (setq #i 0)
;;;2008/09/03YM@DEL    (foreach #SRQry$ #SRQry$$
;;;2008/09/03YM@DEL      (add_list (strcat (nth 0 #SRQry$) "\t" "\t"
;;;2008/09/03YM@DEL                        (nth 2 #SRQry$) "\t"
;;;2008/09/03YM@DEL                        (nth 4 #SRQry$) "\t"
;;;2008/09/03YM@DEL                        (nth 5 #SRQry$)))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL      (if (and (= "PIA" (car #SRQry$))) ; YM2000.1.18
;;;2008/09/03YM@DEL        (setq #no #i)
;;;2008/09/03YM@DEL      )
;;;2008/09/03YM@DEL      (setq #i (1+ #i))
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    (end_list)
;;;2008/09/03YM@DEL    (if (/= #no nil)
;;;2008/09/03YM@DEL      (set_tile "seri" (itoa #no))
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL    (if (= SG_SERIES_CHG nil)
;;;2008/09/03YM@DEL      (progn
;;;2008/09/03YM@DEL        (mode_tile "seri" 1)
;;;2008/09/03YM@DEL        (set_tile "error" "���ɕ��ނ��z�u����Ă���̂�SERIES�͕ύX�ł��܂���")
;;;2008/09/03YM@DEL      )
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    ;// ��ق�ر���ݐݒ�
;;;2008/09/03YM@DEL    (action_tile "accept" "(setq #ret (SRSelectOKClick))")
;;;2008/09/03YM@DEL    (action_tile "cancel" "(setq #ret nil)(done_dialog)")
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    (start_dialog)
;;;2008/09/03YM@DEL    (unload_dialog #dcl_id)
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL    ;// OK�������ꂽ�ꍇ�͐}�ʂ̊g�����R�[�h�ɑI�������i�[
;;;2008/09/03YM@DEL    (if #ret ; #ret=T
;;;2008/09/03YM@DEL      (progn
;;;2008/09/03YM@DEL        (setq #ret$
;;;2008/09/03YM@DEL         (SRSelectDoorSeriesDlg "��SERIES�I��"
;;;2008/09/03YM@DEL           CG_DBNAME
;;;2008/09/03YM@DEL           CG_SeriesCode
;;;2008/09/03YM@DEL           CG_DRSeriCode
;;;2008/09/03YM@DEL           CG_DRColCode
;;;2008/09/03YM@DEL         )
;;;2008/09/03YM@DEL       )
;;;2008/09/03YM@DEL        (if #ret$
;;;2008/09/03YM@DEL          (progn
;;;2008/09/03YM@DEL            (setq CG_DRSeriCode (car #ret$))
;;;2008/09/03YM@DEL            (setq CG_DRColCode (cadr #ret$))
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL            ;// �Ԍ��̈�̍X�V
;;;2008/09/03YM@DEL            (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL            ;// �}�ʂ̊g�����R�[�h�ɏ��i������������
;;;2008/09/03YM@DEL            (CFSetXRecord "SERI"
;;;2008/09/03YM@DEL              (list
;;;2008/09/03YM@DEL                CG_DBNAME       ; 1.DB����        
;;;2008/09/03YM@DEL                CG_SeriesCode   ; 2.SERIES�L��  
;;;2008/09/03YM@DEL                CG_BrandCode    ; 3.�u�����h�L��  
;;;2008/09/03YM@DEL                CG_DRSeriCode   ; 4.��SERIES�L��
;;;2008/09/03YM@DEL                CG_DRColCode    ; 5.��COLOR�L��  
;;;2008/09/03YM@DEL                CG_UpCabHeight  ; 6.��t����      
;;;2008/09/03YM@DEL                CG_CeilHeight   ; 7.�V�䍂��      
;;;2008/09/03YM@DEL                CG_RoomW        ; 8.�Ԍ�          
;;;2008/09/03YM@DEL                CG_RoomD        ; 9.���s          
;;;2008/09/03YM@DEL                CG_GasType      ;10.�K�X��        
;;;2008/09/03YM@DEL                CG_ElecType     ;11.�d�C��        
;;;2008/09/03YM@DEL                CG_KikiColor    ;12.�@��F        
;;;2008/09/03YM@DEL              )
;;;2008/09/03YM@DEL            )
;;;2008/09/03YM@DEL            ;// �����ۑ�
;;;2008/09/03YM@DEL            (CFAutoSave)
;;;2008/09/03YM@DEL            (setq #loop nil)
;;;2008/09/03YM@DEL          )
;;;2008/09/03YM@DEL        )
;;;2008/09/03YM@DEL      )
;;;2008/09/03YM@DEL    ;else
;;;2008/09/03YM@DEL      (setq #loop nil)
;;;2008/09/03YM@DEL    )
;;;2008/09/03YM@DEL  )
;;;2008/09/03YM@DEL  (setq *error* nil)
;;;2008/09/03YM@DEL  (princ)
;;;2008/09/03YM@DEL
;;;2008/09/03YM@DEL)
;;;2008/09/03YM@DEL;C:SRSelect

;<HOM>*************************************************************************
; <�֐���>    : SRSetMaguti
; <�����T�v>  : �Ԍ��̈���쐬����
; <�߂�l>    : �Ȃ�
; <�쐬>      :
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SRSetMaguti (
    &RoomW
    &RoomD
    &Height
    /
    #ss
  )
  (if (setq #ss (ssget "X" '((-3 ("G_ROOM")))))
    (command "_erase" #ss "")
  )
  (setq &RoomD (* -1 &RoomD))
  (setvar "CECOLOR" "9")
  (MakeLWPolyLine
    (list
      (list 0 0 0)
      (list &RoomW 0 0)
      (list &RoomW &RoomD 0)
      (list 0 &RoomD 0)
    )
    1 0
  )
  (if (= nil (tblsearch "APPID" "G_ROOM")) (regapp "G_ROOM"))
  (CFSetXData (entlast) "G_ROOM" (list 1))
  (entmake
    (list
      '(0 . "POINT")
      '(100 . "AcDbEntity")
      '(100 . "AcDbPoint")
      (list 10 0.0 0.0 &Height)
    )
  )
  (setvar "CECOLOR" "BYLAYER")
  (CFSetXData (entlast) "G_ROOM" (list 2))

  (setvar "limmin" (list 0 &RoomD))
  (setvar "limmax" (list &RoomW 0))
  (command "zoom" "e")
;;;  (command "zoom" "0.9x") ; 06/05 YM
)
;SRSetMaguti

;<HOM>*************************************************************************
; <�֐���>    : SRSelectDoorSeriesDlg
; <�����T�v>  : ��SERIES�ACOLOR�̑I��
; <�߂�l>    : �Ȃ�
; <�쐬>      :
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun SRSelectDoorSeriesDlg (
  &Title        ;(STR)�_�C�A���O�^�C�g��
  &DBName       ;(STR)�Ώۃf�[�^�x�[�X��
  &SeriCode     ;(STR)SERIES�L��   �����D�� nil==>Xrecord 01/05/09 YM
  &DrSeriCode   ;(STR)��SERIES�L�� �����D�� nil�\ 01/05/09 YM
  &DrColCode    ;(STR)��COLOR�L��   �����D�� nil�\ 01/05/09 YM
  /
  #CG_SERIESCODE #DCL_ID #I #LST$ #NO #SERI$
   #MOJI_ICHI #MONGON
  )

  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION (dbconnect &DBName "" ""))
    )
    (progn
      (setq CG_DBSESSION (dbconnect &DBName "" ""))
    )
  )

  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertMsg "SERIES�ʂ̃f�[�^�x�[�X������܂���ł���")
      nil
    )
  ;else
    (progn
      ;// ���݂̔�SERIES�A��COLOR�̐ݒ�
      (setq #seri$ (CFGetXRecord "SERI"))
      (if #seri$
        (setq #CG_SeriesCode  (nth 1 #seri$)) ; 2.SERIES�L��
      )
      (setq SG_DRSERI$$
        (CFGetDBSQLRec CG_DBSESSION "���V���Y"
          (list
            (if &SeriCode
              (list "SERIES�L��" &SeriCode      'STR) ; �����̼ذ�ދL����D��
              (list "SERIES�L��" #CG_SeriesCode 'STR) ; �����̼ذ�ދL����D��
            );_if
          )
        )
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;// ���i�I���_�C�A���O�łn�j�������ꂽ
      (defun ##SRSelectDoorSeriesOK ( / #lst$ )
        (setq #lst$
          (list
            (nth 1 (nth (atoi (get_tile "drseri")) SG_DRSERI$$))
            (nth 2 (nth (atoi (get_tile "drcol"))  SG_DRCOL$$))
          )
        )
        (done_dialog)
        #lst$
      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (defun ##SelectDoorSeries (
          /
          #seri #Qry$ #Qry$$ #i #no #sQ #Q$
        )
        (setq #seri (nth 1 (nth (atoi (get_tile "drseri")) SG_DRSERI$$)))
        ;;; (�V���L��   ���V���L��   ���J���L��) �̃��X�g�擾
        (setq SG_DRCOL$$
          (CFGetDBSQLRec CG_DBSESSION "���V�Ǘ�"
          (list
            (list "���V���L��" #seri 'STR))
           )
        )

        ;;; SG_DRCOL$$�ɔ��J�����̂𑫂�
        (setq #Qry$$ nil) ; 02/04/10 YM ADD
        (foreach #Qry$ SG_DRCOL$$
          (setq #Q$
            (car (CFGetDBSQLRec CG_DBSESSION "��COLOR"
            (list
              (list "SERIES�L��" (nth 0 #Qry$) 'STR)
              (list "���J���L��"   (nth 2 #Qry$) 'STR))
            ))
          )
          ; 02/04/10 YM �װ�����C��  (listp nil)='T���A���L�͖��Ӗ��@#Q$=nil�̂Ƃ��ذ�ނ���
;;;02/04/10YM@MOD         (setq #sQ
;;;02/04/10YM@MOD           (if (listp #Q$)
;;;02/04/10YM@MOD             (nth 2 #Q$)
;;;02/04/10YM@MOD             ""
;;;02/04/10YM@MOD           );_if
;;;02/04/10YM@MOD         )

;;;02/04/10YM@MOD             (setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))

           ; 02/04/10 YM ADD-S
          (if #Q$
            (progn
              (setq #sQ (nth 2 #Q$))
              (setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))
            )
          );_if
          ; 02/04/10 YM ADD-E

        );foreach

        (setq SG_DRCOL$$ #Qry$$)

;;; �G���[�����ǉ� 00/02/20 MH ADD
;;; SG_DRCOL$$����ꂽ���ۂ��`�F�b�N���Ĕ�COLOR���X�gBOX�ւ̐i�s�𐧌䂷��B
;;; �Ƃ�Ă���Δ�COLOR���X�gBOX�ɑ���B�Ƃ�Ă��Ȃ���΁A�G���[�_�C�A���O�\��&���͕s��
        (if (not SG_DRCOL$$)
          (progn
            (mode_tile "drseri" 2)
            (start_list "drcol" 3)
            (add_list "")
            (end_list)
            (mode_tile "drcol" 1)
            (mode_tile "accept" 1)
            (set_tile "error" "��COLOR���l���ł��܂���ł����B")
          ); end of progn
          (progn
            (set_tile "lab" &Title)  ;�޲�۸�����
            (start_list "drcol" 3)
            (setq #i 0 #no 0)

            (foreach #Qry$ SG_DRCOL$$
              ; 01/07/23 HN MOD ��؂蕶����ύX
              ;@MOD@(add_list (strcat (nth 2 #Qry$) "\t" (nth 3 #Qry$)))

              ;2008/3/12 YM MOD "˷�"�̕���������Έȍ~�폜����
              (setq #mongon (nth 3 #Qry$))
              (setq #moji_ichi (vl-string-search  "˷�" #mongon))
              (if #moji_ichi
                (setq #mongon (substr #mongon 1 #moji_ichi))
              );_if
              
              (add_list (strcat (nth 2 #Qry$) " �F " #mongon))
;;;              (add_list (strcat (nth 2 #Qry$) " �F " (nth 3 #Qry$)))

              (if (= &DrColCode (nth 2 #Qry$)) ; �����g�p 01/05/09 YM
                (setq #no #i)
              )
              (setq #i (1+ #i))
            )
            (end_list)
            (set_tile "error" "")
            (set_tile "drcol" (itoa #no))
            (mode_tile "drcol" 0)
            (mode_tile "accept" 0)
          ); end of progn
        ); end of if
      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ;// �߂�l�̏����ݒ�
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
      (if (not (new_dialog "DoorSelectDlg" #dcl_id)) (exit))

      ;// popup_list
      (set_tile "lab" "��SERIES�I��")  ;�޲�۸�����
      (start_list "drseri" 3)

      (setq #i 0 #no 0)
      (foreach #Qry$ SG_DRSERI$$
        ; 01/07/04 HN MOD ��؂蕶����ύX
        ;@MOD@(add_list (strcat (nth 1 #Qry$) "\t" (nth 3 #Qry$)))
        (add_list (strcat (nth 1 #Qry$) " �F " (nth 3 #Qry$)))
        (if (= &DrSeriCode (nth 1 #Qry$)) ; �����g�p 01/05/09 YM
          (setq #no #i)
        )
        (setq #i (1+ #i))
      )
      (end_list)
      (set_tile "drseri" (itoa #no))
      (##SelectDoorSeries)

      ;// ��ق�ر���ݐݒ�
      (action_tile "accept" "(setq #lst$ (##SRSelectDoorSeriesOK))")
      (action_tile "drseri" "(##SelectDoorSeries)")
      (action_tile "cancel" "(setq #lst$ nil)(done_dialog)")

      (start_dialog)
      (unload_dialog #dcl_id)

      ;// OK�������ꂽ�ꍇ�͐}�ʂ̊g�����R�[�h�ɑI�������i�[
      #lst$
    )
  )
);SRSelectDoorSeriesDlg

;<HOM>*************************************************************************
; <�֐���>    : SRSelectDoorSeriesDlg_Handle
; <�����T�v>  : ��SERIES�ACOLOR�̑I��(���̑I�����ǉ�)
; <�߂�l>    : �Ȃ�
; <�쐬>      : 02/11/30 YM
; <���l>      : �~�J�h�r�w�Ή�
;*************************************************************************>MOH<
(defun SRSelectDoorSeriesDlg_Handle (
  &Title        ;(STR)�_�C�A���O�^�C�g��
  &DBName       ;(STR)�Ώۃf�[�^�x�[�X��
  &SeriCode     ;(STR)SERIES�L��   �����D�� nil==>Xrecord 01/05/09 YM
  &DrSeriCode   ;(STR)��SERIES�L�� �����D�� nil�\ 01/05/09 YM
  &DrColCode    ;(STR)��COLOR�L��   �����D�� nil�\ 01/05/09 YM
  &DrHandleCode ;(STR)���L�� 02/11/30 YM
  /
  #CG_SERIESCODE #DCL_ID #I #LST$ #NO #SERI$
  )

  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION (dbconnect &DBName "" ""))
    )
    (progn
      (setq CG_DBSESSION (dbconnect &DBName "" ""))
    )
  )

;-- 2011/11/29 A.Satoh Add - S
	(if (= CG_DBSESSION nil)
		(progn
;;;			(princ "\n������ �Z�b�V�����Ď擾 ������")
;;;      (princ (strcat "\n�������@asilisp.arx���ă��[�h����DB��CONNECT�@������"))

			; ARX�ă��[�h
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

      (setq CG_DBSESSION  (dbconnect &DBName  "" ""))
		)
	)
;;;  (princ "\n�������@CG_DBSESSION�@������ :")(princ CG_DBSESSION)
;-- 2011/11/29 A.Satoh Add - E
  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertMsg "SERIES�ʂ̃f�[�^�x�[�X������܂���ł���")
      nil
    )
  ;else
    (progn
      ;��ذ�ނ�ؽ�
      (setq SG_DRSERI$$
        (CFGetDBSQLRec CG_DBSESSION "���V���Y"
          (list
            (list "�p��F" "0"  'INT)
          )
        )
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;// ���i�I���_�C�A���O�łn�j�������ꂽ
      (defun ##SRSelectDoorSeriesOK ( / #lst$ )
        (setq #lst$
          (list
            (nth 0 (nth (atoi (get_tile "drseri")) SG_DRSERI$$))
            (nth 1 (nth (atoi (get_tile "drcol"))  SG_DRCOL$$ ))
            (nth 3 (nth (atoi (get_tile "handle")) SG_HANDLE$$))
          )
        )
        (done_dialog)
        #lst$
      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (defun ##SelectDoorSeries (
        /
        #seri #Qry$ #Qry$$ #i #no #sQ #Q$ #COL #COL$
        )
        (setq #seri (nth 0 (nth (atoi (get_tile "drseri")) SG_DRSERI$$)))
        ;;; (�V���L��   ���V���L��   ���J���L��) �̃��X�g�擾
        (setq SG_DRCOL$$
          (CFGetDBSQLRec CG_DBSESSION "���V�Ǘ�"
          (list
            (list "���V���L��" #seri 'STR))
           )
        )

        ;;; SG_DRCOL$$�ɔ��J�����̂𑫂�
        (setq #Qry$$ nil) ; 02/04/10 YM ADD
        (foreach #Qry$ SG_DRCOL$$
          (setq #Q$
            (car (CFGetDBSQLRec CG_DBSESSION "��COLOR"
            (list
              (list "���J���L��"   (nth 1 #Qry$) 'STR))
            ))
          )

          (if #Q$
            (progn
              (setq #sQ (nth 1 #Q$))
              (setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))
            )
          );_if

        );foreach

        (setq SG_DRCOL$$ #Qry$$)

;;; �G���[�����ǉ� 00/02/20 MH ADD
;;; SG_DRCOL$$����ꂽ���ۂ��`�F�b�N���Ĕ�COLOR���X�gBOX�ւ̐i�s�𐧌䂷��B
;;; �Ƃ�Ă���Δ�COLOR���X�gBOX�ɑ���B�Ƃ�Ă��Ȃ���΁A�G���[�_�C�A���O�\��&���͕s��
        (if (not SG_DRCOL$$)
          (progn
            (mode_tile "drseri" 2)
            (start_list "drcol" 3)
            (add_list "")
            (end_list)
            (mode_tile "drcol" 1)
            (mode_tile "accept" 1)
            (set_tile "error" "��COLOR���l���ł��܂���ł����B")
          ); end of progn
          (progn
            (set_tile "lab" &Title)  ;�޲�۸�����
            (start_list "drcol" 3)
            (setq #i 0 #no 0)

            (foreach #Qry$ SG_DRCOL$$
              ; 01/07/23 HN MOD ��؂蕶����ύX
              ;@MOD@(add_list (strcat (nth 2 #Qry$) "\t" (nth 3 #Qry$)))
							;2013/04/01 YM MOD-S
;;;              (add_list (strcat (nth 1 #Qry$) " �F " (nth 2 #Qry$)))
              (add_list (strcat (nth 2 #Qry$)))
							;2013/04/01 YM MOD-E
              (if (= &DrColCode (nth 1 #Qry$))
                (setq #no #i)
              )
              (setq #i (1+ #i))
            )
            (end_list)
            (set_tile "error" "")
            (set_tile "drcol" (itoa #no))
            (mode_tile "drcol" 0)
            (mode_tile "accept" 0)
          ); end of progn
        ); end of if

        (##SelectDoorHandle)

      );defun ##SelectDoorSeries
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (defun ##SelectDoorHandle ( ; ���I�����̕ύX 02/11/30 YM
        /
        #COL #COL$ #I #NO
        )

        ; ���I����---------------------------------------------------------------
        (setq #col$ (nth (atoi (get_tile "drcol")) SG_DRCOL$$))
        (setq #dr_seri (nth 0 #col$))
        (setq #col (nth 1 #col$))

        (setq SG_HANDLE$$
          (CFGetDBSQLRec CG_DBSESSION "����Ǘ�"
            (list
              (list "���V���L��"  #dr_seri  'STR)
              (list "���J���L��"  #col      'STR)
            )
          )
        )
        (start_list "handle" 3)
        (setq #i 0 #no 0)

        (foreach #Qry$ SG_HANDLE$$
          (add_list (strcat (nth 3 #Qry$) " �F " (nth 4 #Qry$)))
          (if (= &DrHandleCode (nth 3 #Qry$))
            (setq #no #i)
          )
          (setq #i (1+ #i))
        )
        (end_list)
        (set_tile "error" "")
        (set_tile "handle" (itoa #no))
        (mode_tile "handle" 0)
        (mode_tile "accept" 0)
      );defun ##SelectDoorHandle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ;// �߂�l�̏����ݒ�
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KSCMAIN.DCL")))
      (if (not (new_dialog "DoorSelectDlg_Handle" #dcl_id)) (exit))

      ;// popup_list
      (set_tile "lab" "��SERIES�I��")  ;�޲�۸�����
      (start_list "drseri" 3)

;2011/09/14 YM ADD-S
;;;<ERRMSG.INI>
;;;;���݂̼ذ��=WK_PSKB,���݂̔��ڰ��="R*"�̂Ƃ�ײ��߯����"X*"�ɸ�ڰ�ޕύX�ł��Ȃ�
;;;[DR_GRADE_PROHIBIT]
;;;WK_PSKB==RX
      ; �ύX�����̎擾
      (setq #sDR_GRADE_PROHIBIT (CFgetini "DR_GRADE_PROHIBIT" CG_DBNAME (strcat CG_SKPATH "ERRMSG.INI")))
      ;2011/09/14 YM ADD-E

      (setq #i 0 #no 0)
			(setq #dum$$ nil)
      (foreach #Qry$ SG_DRSERI$$

        ;2011/09/14 YM ADD-S if���ǉ�
        (setq #sDR_GRADE (strcat (substr &DrSeriCode 1 1) (substr (nth 0 #Qry$) 1 1)))
        (if (wcmatch #sDR_GRADE #sDR_GRADE_PROHIBIT)
          nil ;ؽĂɒǉ����Ȃ�
          ;else
          (progn
            (add_list (strcat (nth 0 #Qry$) " �F " (nth 1 #Qry$)))
						(setq #dum$$ (append #dum$$ (list #Qry$)))
          )
        );_if
        ;2011/09/14 YM ADD-E if���ǉ�

        (setq #i (1+ #i))
      );(foreach

			;2011/10/17 YM ADD �s��C��
      (setq #i 0 #no 0)
			(setq SG_DRSERI$$ #dum$$)
      (foreach #Qry$ SG_DRSERI$$
        (if (= &DrSeriCode (nth 0 #Qry$))
          (setq #no #i)
        );_if
        (setq #i (1+ #i))
			);(foreach

      (end_list)
      (set_tile "drseri" (itoa #no))
      (##SelectDoorSeries)

      ;// ��ق�ر���ݐݒ�
      (action_tile "accept" "(setq #lst$ (##SRSelectDoorSeriesOK))")
      (action_tile "drseri" "(##SelectDoorSeries)")
      (action_tile "drcol"  "(##SelectDoorHandle)") ; 02/11/30 YM ADD
      (action_tile "cancel" "(setq #lst$ nil)(done_dialog)")

      (start_dialog)
      (unload_dialog #dcl_id)

      ;// OK�������ꂽ�ꍇ�͐}�ʂ̊g�����R�[�h�ɑI�������i�[
      #lst$
    )
  )
);SRSelectDoorSeriesDlg_Handle

;<HOM>*************************************************************************
; <�֐���>    : C:SetRoomInfo
; <�����T�v>  : �����g�ݒ�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2011/06
; <���l>      : 
;*************************************************************************>MOH<
(defun C:SetRoomInfo (
  /
  #RoomInfo$ #seri$
  )

; (alert "�������@�H�����@������")

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:SetRoomInfo ////")
  (CFOutStateLog 1 1 " ")

  ;// �R�}���h�̏�����
  (StartUndoErr)
  (CFCmdDefBegin 0)
  (CFNoSnapReset)

  ; �����ݒ���̓��́i�_�C�A���O�\���j
  (setq #RoomInfo$ (InputRoomInfo))
  (if #RoomInfo$
    (progn
      ; �����ݒ���̔��f
      (setq CG_RoomW (nth 0 #RoomInfo$))        ; ��ʗ̈�w����
      (setq CG_RoomD (nth 1 #RoomInfo$))        ; ��ʗ̈�x����
      (setq CG_CeilHeight (nth 2 #RoomInfo$))   ; �V�䍂��
      (setq CG_UpCabHeight (nth 3 #RoomInfo$))  ; �݌�����
;-- 2011/09/21 A.Satoh Add - S
      (setq CG_GasType (nth 4 #RoomInfo$))  ; �K�X��
;-- 2011/09/21 A.Satoh Add - E

      ; �Ԍ��̈�̍ĕ`��
      (SRSetMaguti CG_RoomW CG_RoomD CG_CeilHeight)

      ; �}�ʂ̊g���f�[�^���X�V����
      (setq #seri$
        (list
          CG_DBNAME       ; DB����
          CG_SeriesCode   ; SERIES�L��
          CG_BrandCode    ; �u�����h�L��
          CG_DRSeriCode   ; ��SERIES�L��
          CG_DRColCode    ; ��COLOR�L��
          CG_HIKITE       ; �q�L�e�L��
          CG_UpCabHeight  ; ��t����
          CG_CeilHeight   ; �V�䍂��
          CG_RoomW        ; �Ԍ�
          CG_RoomD        ; ���s
          CG_GasType      ; �K�X��
          CG_ElecType     ; �d�C��
          CG_KikiColor    ; �@��F
          CG_KekomiCode   ; �P�R�~����
        )
      )
      (CFSetXRecord "SERI" #seri$)

      ; PlanInfo.cfg�̕ύX
      (ChangePlanInfo)
    )
  )

  (CFNoSnapFinish)
  (CFCmdDefFinish)
  (setq *error* nil)

  (princ)

);C:SetRoomInfo

;<HOM>*************************************************************************
; <�֐���>    : InputRoomInfo
; <�����T�v>  : �����ݒ���̓���
; <�߂�l>    : �����ݒ��񃊃X�g
;             :  (��ʗ̈�w���� ��ʗ̈�x���� �V�䍂�� �݌�����)
;             :   (3600 3600 2450 2350) or nil
; <�쐬>      :
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun InputRoomInfo (
  /
  #dcl_id #next #room_info$
;-- 2011/09/21 A.Satoh Add - S
  #err_flag #GAS$$ #GAS$ #idx #def
;-- 2011/09/21 A.Satoh Add - E
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;// �����񂪐��l�������ۂ����`�F�b�N����
    (defun ##IsNumeric(
      &str  ;���l�`�F�b�N�Ώە�����
      /
      #i #flg #str
      )

      (setq #i 1)
      (setq #flg T)
      (repeat (strlen &str)
        (if (= #flg T)
          (progn
            (setq #str (substr &str #i 1))
            (if (= nil (wcmatch #str "#"))
              (setq #flg nil)
            )
          )
        )
        (setq #i (1+ #i))
      )

      #flg
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;// �����ݒ�_�C�A���O�łn�j�������ꂽ
    (defun ##SetRoomInfo_CallBack(
      /
;;; #GAS$$�̓��[�J����`���Ȃ�
      #lst$ #dist_x #dist_y #ceil_h #hang_h #err_flg
;-- 2011/09/21 A.Satoh Add - S
      #gas_idx #idx #gas
;-- 2011/09/21 A.Satoh Add - E
      )

      (setq #err_flg nil)

      ; ��ʗ̈�w�����̓��̓`�F�b�N
      (setq #dist_x (get_tile "DIST_X"))
      (if (= #dist_x "")
        (progn
          (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
					(mode_tile "DIST_X" 2)
;-- 2011/12/17 A.Satoh Add - E
          (set_tile "error" "�u��ʗ̈�w�����v����͂��ĉ�����")
        )
;-- 2011/12/17 A.Satoh Mod - S
				(if (and (/= (type (read #dist_x)) 'INT) (/= (type (read #dist_x)) 'REAL))
;;;;;        (if (= nil (##IsNumeric #dist_x))
;-- 2011/12/17 A.Satoh Mod - E
          (progn
            (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
						(mode_tile "DIST_X" 2)
;-- 2011/12/17 A.Satoh Add - E
            (set_tile "error" "�u��ʗ̈�w�����v�͐��l�̂ݓ��͉\�ł�")
          )
;-- 2011/12/17 A.Satoh Mod - S
          (if (< (read #dist_x) 0)
;;;;;          (if (< (fix (atoi #dist_x)) 0)
;-- 2011/12/17 A.Satoh Mod - E
            (progn
              (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
		 					(mode_tile "DIST_X" 2)
;-- 2011/12/17 A.Satoh Add - E
							(set_tile "error" "�u��ʗ̈�w�����v���}�C�i�X�l�œ��͂���Ă��܂�")
            )
          )
        )
      )

      ; ��ʗ̈�x�����̓��̓`�F�b�N
      (if (= #err_flg nil)
        (progn
          (setq #dist_y (get_tile "DIST_Y"))
          (if (= #dist_y "")
            (progn
              (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
							(mode_tile "DIST_Y" 2)
;-- 2011/12/17 A.Satoh Add - E
              (set_tile "error" "�u��ʗ̈�x�����v����͂��ĉ�����")
            )
;-- 2011/12/17 A.Satoh Mod - S
						(if (and (/= (type (read #dist_y)) 'INT) (/= (type (read #dist_y)) 'REAL))
;;;;;            (if (= nil (##IsNumeric #dist_y))
;-- 2011/12/17 A.Satoh Mod - E
              (progn
                (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
								(mode_tile "DIST_Y" 2)
;-- 2011/12/17 A.Satoh Add - E
                (set_tile "error" "�u��ʗ̈�x�����v�͐��l�̂ݓ��͉\�ł�")
              )
;-- 2011/12/17 A.Satoh Mod - S
;;;;;              (if (< (fix (atoi #dist_y)) 0)
							(if (< (read #dist_y) 0)
;-- 2011/12/17 A.Satoh Mod - E
                (progn
                  (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
									(mode_tile "DIST_Y" 2)
;-- 2011/12/17 A.Satoh Add - E
                  (set_tile "error" "�u��ʗ̈�x�����v���}�C�i�X�l�œ��͂���Ă��܂�")
                )
              )
            )
          )
        )
      )

      ; �V�䍂���̓��̓`�F�b�N
      (if (= #err_flg nil)
        (progn
          (setq #ceil_h (get_tile "CEIL_H"))
          (if (= #ceil_h "")
            (progn
              (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
							(mode_tile "CEIL_H" 2)
;-- 2011/12/17 A.Satoh Add - E
              (set_tile "error" "�u�V�䍂���v����͂��ĉ�����")
            )
;-- 2011/12/17 A.Satoh Mod - S
						(if (and (/= (type (read #ceil_h)) 'INT) (/= (type (read #ceil_h)) 'REAL))
;;;;;            (if (= nil (##IsNumeric #ceil_h))
;-- 2011/12/17 A.Satoh Mod - E
              (progn
                (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
								(mode_tile "CEIL_H" 2)
;-- 2011/12/17 A.Satoh Add - E
                (set_tile "error" "�u�V�䍂���v�͐��l�̂ݓ��͉\�ł�")
              )
;-- 2011/12/17 A.Satoh Mod - S
;;;;;              (if (< (fix (atoi #ceil_h)) 0)
              (if (< (read #ceil_h) 0)
;-- 2011/12/17 A.Satoh Mod - E
                (progn
                  (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
		 							(mode_tile "CEIL_H" 2)
;-- 2011/12/17 A.Satoh Add - E
									(set_tile "error" "�u�V�䍂���v���}�C�i�X�l�œ��͂���Ă��܂�")
                )
              )
            )
          )
        )
      )

      ; �݌������̓��̓`�F�b�N
      (if (= #err_flg nil)
        (progn
          (setq #hang_h (get_tile "HANG_H"))
          (if (= #hang_h "")
            (progn
              (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
							(mode_tile "HANG_H" 2)
;-- 2011/12/17 A.Satoh Add - E
              (set_tile "error" "�u�݌������v����͂��ĉ�����")
            )
;-- 2011/12/17 A.Satoh Mod - S
						(if (and (/= (type (read #hang_h)) 'INT) (/= (type (read #hang_h)) 'REAL))
;;;;;            (if (= nil (##IsNumeric #hang_h))
              (progn
;-- 2011/12/17 A.Satoh Mod - E
                (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
								(mode_tile "HANG_H" 2)
;-- 2011/12/17 A.Satoh Add - E
                (set_tile "error" "�u�݌������v�͐��l�̂ݓ��͉\�ł�")
              )
;-- 2011/12/17 A.Satoh Mod - S
;;;;;              (if (< (fix (atoi #hang_h)) 0)
              (if (< (read #hang_h) 0)
;-- 2011/12/17 A.Satoh Mod - E
                (progn
                  (setq #err_flg T)
;-- 2011/12/17 A.Satoh Add - S
									(mode_tile "HANG_H" 2)
;-- 2011/12/17 A.Satoh Add - E
                  (set_tile "error" "�u�݌������v���}�C�i�X�l�œ��͂���Ă��܂�")
                )
;-- 2011/12/17 A.Satoh Add - S
								(if (> (fix (atoi #hang_h)) (fix (atoi #ceil_h)))
									(progn
										(setq #err_flg T)
										(mode_tile "HANG_H" 2)
	                  (set_tile "error" "�u�݌������v�́u�V�䍂���v�ȉ��œ��͂��ĉ�����")
									)
								)
;-- 2011/12/17 A.Satoh Add - E
              )
            )
          )
        )
      )

;-- 2011/09/21 A.Satoh Add - S
      (if (= #err_flag nil)
        (progn
          (setq #gas_idx (atoi (get_tile "GAS_TYPE")))
          (setq #idx 0)
          (repeat (length #GAS$$)
            (if (= #gas_idx #idx)
              (setq #gas (nth 0 (nth #idx #GAS$$)))
            )
            (setq #idx (1+ #idx))
          )
        )
      )
;-- 2011/09/21 A.Satoh Add - E

      (if (= #err_flg nil)
        (progn
          (setq #lst$
            (list
              (fix (atoi #dist_x))
              (fix (atoi #dist_y))
              (fix (atoi #ceil_h))
              (fix (atoi #hang_h))
;-- 2011/09/21 A.Satoh Add - S
              #gas
;-- 2011/09/21 A.Satoh Add - E
            )
          )
          (done_dialog 1)
        )
        (setq #lst$ nil)
      )

      #lst$
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-- 2011/09/21 A.Satoh Add - S
  (setq #err_flag nil)

  ; mdb���y�K�X��z���ꗗ���擾����
  (setq #GAS$$ (DBSqlAutoQuery CG_CDBSESSION "select * from �K�X��"))
  (if #GAS$$
    (progn
      (setq #GAS$$ (CFListSort #GAS$$ 1))
    )
    (progn
      (CFAlertMsg "�y�K�X��z��ں��ނ�����܂���B")
      (setq #room_info$ nil)
      (setq #err_flag T)
    )
  )

  (if (= #err_flag nil)
    (progn
;-- 2011/09/21 A.Satoh Add - E

  ; DCL���[�h
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "SetRoomInfo.dcl")))
;-- 2011/09/21 A.Satoh Add - S
  (if (not (new_dialog "SetRoomInfoDlg" #dcl_id)) (exit))

  ; �����l�ݒ�
  (set_tile "DIST_X" (itoa CG_RoomW))       ; ��ʗ̈�w����
  (set_tile "DIST_Y" (itoa CG_RoomD))       ; ��ʗ̈�x����
  (set_tile "CEIL_H" (itoa CG_CeilHeight))  ; �V�䍂��
  (set_tile "HANG_H" (itoa CG_UpCabHeight)) ; �݌�����
  (start_list "GAS_TYPE" 3)
  (foreach #GAS$ #GAS$$
    (add_list (nth 0 #GAS$))
  )
  (end_list)

  (setq #idx 0)
  (setq #def 0)
  (repeat (length #GAS$$)
    (if (= (nth 0 (nth #idx #GAS$$)) CG_GasType)
      (setq #def #idx)
    )
    (setq #idx (1+ #idx))
  )
  (set_tile "GAS_TYPE" (itoa #def))
;-- 2011/09/21 A.Satoh Add - E

  (setq #next 99)
  (while (and (/= 1 #next) (/= 0 #next))
;-- 2011/09/21 A.Satoh Del - S
;;;;;    (if (not (new_dialog "SetRoomInfoDlg" #dcl_id)) (exit))
;;;;;
;;;;;   ; �����l�ݒ�
;;;;;   (set_tile "DIST_X" (itoa CG_RoomW))       ; ��ʗ̈�w����
;;;;;   (set_tile "DIST_Y" (itoa CG_RoomD))       ; ��ʗ̈�x����
;;;;;   (set_tile "CEIL_H" (itoa CG_CeilHeight))  ; �V�䍂��
;;;;;   (set_tile "HANG_H" (itoa CG_UpCabHeight)) ; �݌�����
;-- 2011/09/21 A.Satoh Del - E

    ; �{�^����������
    (action_tile "accept" "(setq #room_info$ (##SetRoomInfo_CallBack))")
    (action_tile "cancel" "(setq #room_info$ nil)(done_dialog 0)")

    (setq #next (start_dialog))
  )

  (unload_dialog #dcl_id)
;-- 2011/09/21 A.Satoh Add - S
    )
  )
;-- 2011/09/21 A.Satoh Add - E

  #room_info$

) ;InputRoomInfo


;;;<HOM>***********************************************************************
;;; <�֐���>    : ChangePlanInfo
;;; <�����T�v>  : PlanInfo.cfg���X�V����(�����ݒ�p)
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 11/06/30 A.Satoh
;;; <���l>      :
;;;***********************************************************************>MOH<
(defun ChangePlanInfo (
  /
  #fp #PLANINFO$ #sFname #elm
  )

  ; ���݂̃v�������(PLANINFO.CFG)��ǂݍ���
  (setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))

  ; ���ڂ̍X�V
  (if (assoc "Width" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "Width" (itoa CG_RoomW))(assoc "Width" #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "Depth" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "Depth" (itoa CG_RoomD))(assoc "Depth" #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "CeilingHeight" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "CeilingHeight" (itoa CG_CeilHeight))(assoc "CeilingHeight" #PLANINFO$) #PLANINFO$))
  );_if
  (if (assoc "SetHeight" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "SetHeight" (itoa CG_UpCabHeight))(assoc "SetHeight" #PLANINFO$) #PLANINFO$))
  );_if
;-- 2011/09/21 A.Satoh Add - S
  (if (assoc "GasType" #PLANINFO$)
    (setq #PLANINFO$ (subst (list "GasType" CG_GasType)(assoc "GasType" #PLANINFO$) #PLANINFO$))
  );_if
;-- 2011/09/21 A.Satoh Add - E

  (setq #sFname (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
  (setq #fp  (open #sFname "w"))
  (if (/= nil #fp)
    (progn
      (foreach #elm #PLANINFO$
        (if (= ";" (substr (car #elm) 1 1))
          (princ (car #elm) #fp)
          ;else
          (progn
            (if (= (car #elm) "") ; if������ 03/07/22 YM ADD
              nil ; ��s(���������Ȃ�)
							;else
							(progn
								(if (= (cadr #elm) nil) ; if������ 2011/10/14 YM ADD
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
      (CFAlertMsg "PLANINFO.CFG�ւ̏������݂Ɏ��s���܂����B")
      (quit)
    )
  );_if

);ChangePlanInfo


;-- 2011/10/06 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : InputInitInfoDlg
; <�����T�v>  : �V���[�Y���������Ă��Ȃ���Ԃł�KPCAD�N������ɉ��L����ݒ肷��
;             :  �E���O���[�h
;             :  �E���F
;             :  �E����
;             :  �E�K�X��
;             :  �E�V�䍂��
;             :  �E��t����
;             :  �E�����gX,Y
; <�߂�l>    : �ݒ��񃊃X�g
;             :  (���O���[�h ���F ���� ��ʗ̈�w���� ��ʗ̈�x���� �V�䍂�� �݌����� �K�X��)
;             :   ("RF" "G" "J" 3600 3600 2450 2350 "13A") or nil
; <�쐬>      :
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
;;;(defun C:qqq (
;;;  /
;;;  #planInfo$
;;;  )
;;;
;;;  (setq #planInfo$ (InputInitInfoDlg))
;;;  (if #planInfo$
;;;    (progn
;;;      (setq CG_DRSeriCode  (nth 0 #planInfo$))
;;;      (setq CG_DRColCode   (nth 1 #planInfo$))
;;;      (setq CG_Hikite      (nth 2 #planInfo$))
;;;      (setq CG_RoomW       (nth 3 #planInfo$))
;;;      (setq CG_RoomD       (nth 4 #planInfo$))
;;;      (setq CG_CeilHeight  (nth 5 #planInfo$))
;;;      (setq CG_UpCabHeight (nth 6 #planInfo$))
;;;      (setq CG_GasType     (nth 7 #planInfo$))
;;;    )
;;;  )
;;;(princ "\nCG_DRSeriCode  = ") (princ CG_DRSeriCode)
;;;(princ "\nCG_DRColCode   = ") (princ CG_DRColCode)
;;;(princ "\nCG_Hikite      = ") (princ CG_Hikite)
;;;(princ "\nCG_RoomW       = ") (princ CG_RoomW)
;;;(princ "\nCG_RoomD       = ") (princ CG_RoomD)
;;;(princ "\nCG_CeilHeight  = ") (princ CG_CeilHeight)
;;;(princ "\nCG_UpCabHeight = ") (princ CG_UpCabHeight)
;;;(princ "\nCG_GasType     = ") (princ CG_GasType)
;;;
;;;)
;;;
(defun InputInitInfoDlg (
  /
  #err_flag #info$ #DRSERI$$ #DRCOL$$ #HANDLE$$ #GAS$$
  #dcl_id #i #no #Qry$ #GAS$ #next #sDR_GRADE_PROHIBIT #sDR_GRADE
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (defun ##SelDoorSeries (
      /
      ;;; #DRSERI$$ #DRCOL$$�̓��[�J����`���Ȃ�
      #seri #Qry$$ #Qry$ #Q$ #sQ #i #no
      )

      (setq #seri (nth 0 (nth (atoi (get_tile "drseri")) #DRSERI$$)))
      ;;; (�V���L��   ���V���L��   ���J���L��) �̃��X�g�擾
      (setq #DRCOL$$
        (CFGetDBSQLRec CG_DBSESSION "���V�Ǘ�"
          (list
            (list "���V���L��" #seri 'STR)
          )
        )
      )

      ;;; SG_DRCOL$$�ɔ��J�����̂𑫂�
      (setq #Qry$$ nil) ; 02/04/10 YM ADD
      (foreach #Qry$ #DRCOL$$
        (setq #Q$
          (car (CFGetDBSQLRec CG_DBSESSION "��COLOR"
            (list
              (list "���J���L��"   (nth 1 #Qry$) 'STR)
            )
          ))
        )

        (if #Q$
          (progn
            (setq #sQ (nth 1 #Q$))
            (setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))
          )
        )
      )

      (setq #DRCOL$$ #Qry$$)

      (if (not #DRCOL$$)
        (progn
          (mode_tile "drseri" 2)
          (start_list "drcol" 3)
          (add_list "")
          (end_list)
          (mode_tile "drcol" 1)
          (mode_tile "accept" 1)
          (set_tile "error" "��COLOR���l���ł��܂���ł����B")
        )
        (progn
          (start_list "drcol" 3)
          (setq #i 0 #no 0)

          (foreach #Qry$ #DRCOL$$
						;2013/04/01 YM MOD-S
;;;            (add_list (strcat (nth 1 #Qry$) " �F " (nth 2 #Qry$)))
            (add_list (strcat (nth 2 #Qry$)))
						;2013/04/01 YM MOD-E
            (if (= CG_DRColCode (nth 1 #Qry$))
              (setq #no #i)
            )
            (setq #i (1+ #i))
          )
          (end_list)
          (set_tile "error" "")
          (set_tile "drcol" (itoa #no))
          (mode_tile "drcol" 0)
          (mode_tile "accept" 0)
        )
      )

      (##SelDoorHandle)

    ) ; ##SelDoorSeries

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (defun ##SelDoorHandle ( ; ���I�����̕ύX 02/11/30 YM
      /
      ;;; #DRCOL$$ #HANDLE$$�̓��[�J����`���Ȃ�
      #col$ #dr_seri #col #i #no #Qry$
      )

      ; ���I����---------------------------------------------------------------
      (setq #col$ (nth (atoi (get_tile "drcol")) #DRCOL$$))
      (setq #dr_seri (nth 0 #col$))
      (setq #col (nth 1 #col$))

      (setq #HANDLE$$
        (CFGetDBSQLRec CG_DBSESSION "����Ǘ�"
          (list
            (list "���V���L��"  #dr_seri  'STR)
            (list "���J���L��"  #col      'STR)
          )
        )
      )
      (start_list "handle" 3)
      (setq #i 0 #no 0)

      (foreach #Qry$ #HANDLE$$
        (add_list (strcat (nth 3 #Qry$) " �F " (nth 4 #Qry$)))
        (if (= CG_Hikite (nth 3 #Qry$))
          (setq #no #i)
        )
        (setq #i (1+ #i))
      )
      (end_list)
      (set_tile "error" "")
      (set_tile "handle" (itoa #no))
      (mode_tile "handle" 0)
      (mode_tile "accept" 0)

   ); ##SelDoorHandle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;// �����񂪐��l�������ۂ����`�F�b�N����
    (defun ##IsNumeric(
      &str  ;���l�`�F�b�N�Ώە�����
      /
      #i #flg #str
      )

      (setq #i 1)
      (setq #flg T)
      (repeat (strlen &str)
        (if (= #flg T)
          (progn
            (setq #str (substr &str #i 1))
            (if (= nil (wcmatch #str "#"))
              (setq #flg nil)
            )
          )
        )
        (setq #i (1+ #i))
      )

      #flg
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;// �_�C�A���O��ɏ����l��ݒ肷��
    (defun ##ResetInitInfo(
      &sDR_GRADE_PROHIBIT ; ERRMSG.ini DR_GRADE_PROHIBIT���
      /
			#i #no #Qry$ #sDR_GRADE
			#GAS$ #idx #def
      )

      ; ���֘A
      (start_list "drseri" 3)
      (setq #i 0 #no 0)
      (foreach #Qry$ #DRSERI$$
;-- 2011/10/17 A.Satoh Mod - S
;;;;;        (setq #sDR_GRADE (strcat (substr CG_DRSeriCode 1 1) (substr (nth 0 #Qry$) 1 1)))
;;;;;        (if (wcmatch #sDR_GRADE &sDR_GRADE_PROHIBIT)
;;;;;          nil ;ؽĂɒǉ����Ȃ�
;;;;;          (progn
;;;;;            (add_list (strcat (nth 0 #Qry$) " �F " (nth 1 #Qry$)))
;;;;;          )
;;;;;        )
        (add_list (strcat (nth 0 #Qry$) " �F " (nth 1 #Qry$)))
;-- 2011/10/17 A.Satoh Mod - S

        (if (= CG_DRSeriCode (nth 0 #Qry$))
          (setq #no #i)
        )
        (setq #i (1+ #i))
      )
      (end_list)

      (set_tile "drseri" (itoa #no))
      (##SelDoorSeries)

      (set_tile "DIST_X" (itoa CG_RoomW))       ; ��ʗ̈�w����
      (set_tile "DIST_Y" (itoa CG_RoomD))       ; ��ʗ̈�x����
      (set_tile "CEIL_H" (itoa CG_CeilHeight))  ; �V�䍂��
      (set_tile "HANG_H" (itoa CG_UpCabHeight)) ; �݌�����

      ; �K�X�탊�X�g
      (start_list "GAS_TYPE" 3)
      (foreach #GAS$ #GAS$$
        (add_list (nth 0 #GAS$))
      )
      (end_list)

      (setq #idx 0)
      (setq #def 0)
      (repeat (length #GAS$$)
        (if (= (nth 0 (nth #idx #GAS$$)) CG_GasType)
          (setq #def #idx)
        )
        (setq #idx (1+ #idx))
      )
      (set_tile "GAS_TYPE" (itoa #def))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;// �����ݒ�_�C�A���O�łn�j�������ꂽ
    (defun ##SetInitInfo_CallBack(
      /
;;; #DRSERI$$ #DRCOL$$ #HANDLE$$ #GAS$$�̓��[�J����`���Ȃ�
      #err_flg #dist_x #dist_y #ceil_h #hang_h #gas_idx #idx
      #gas #lst$
      )

      (setq #err_flg nil)

      ; ��ʗ̈�w�����̓��̓`�F�b�N
      (setq #dist_x (get_tile "DIST_X"))
      (if (= #dist_x "")
        (progn
          (setq #err_flg T)
          (set_tile "error" "�u��ʗ̈�w�����v����͂��ĉ�����")
        )
        (if (= nil (##IsNumeric #dist_x))
          (progn
            (setq #err_flg T)
            (set_tile "error" "�u��ʗ̈�w�����v�͐��l�̂ݓ��͉\�ł�")
          )
          (if (< (fix (atoi #dist_x)) 0)
            (progn
              (setq #err_flg T)
              (set_tile "error" "�u��ʗ̈�w�����v���}�C�i�X�l�œ��͂���Ă��܂�")
            )
          )
        )
      )

      ; ��ʗ̈�x�����̓��̓`�F�b�N
      (if (= #err_flg nil)
        (progn
          (setq #dist_y (get_tile "DIST_Y"))
          (if (= #dist_y "")
            (progn
              (setq #err_flg T)
              (set_tile "error" "�u��ʗ̈�x�����v����͂��ĉ�����")
            )
            (if (= nil (##IsNumeric #dist_y))
              (progn
                (setq #err_flg T)
                (set_tile "error" "�u��ʗ̈�x�����v�͐��l�̂ݓ��͉\�ł�")
              )
              (if (< (fix (atoi #dist_y)) 0)
                (progn
                  (setq #err_flg T)
                  (set_tile "error" "�u��ʗ̈�x�����v���}�C�i�X�l�œ��͂���Ă��܂�")
                )
              )
            )
          )
        )
      )

      ; �V�䍂���̓��̓`�F�b�N
      (if (= #err_flg nil)
        (progn
          (setq #ceil_h (get_tile "CEIL_H"))
          (if (= #ceil_h "")
            (progn
              (setq #err_flg T)
              (set_tile "error" "�u�V�䍂���v����͂��ĉ�����")
            )
            (if (= nil (##IsNumeric #ceil_h))
              (progn
                (setq #err_flg T)
                (set_tile "error" "�u�V�䍂���v�͐��l�̂ݓ��͉\�ł�")
              )
              (if (< (fix (atoi #ceil_h)) 0)
                (progn
                  (setq #err_flg T)
                  (set_tile "error" "�u�V�䍂���v���}�C�i�X�l�œ��͂���Ă��܂�")
                )
              )
            )
          )
        )
      )

      ; �݌������̓��̓`�F�b�N
      (if (= #err_flg nil)
        (progn
          (setq #hang_h (get_tile "HANG_H"))
          (if (= #hang_h "")
            (progn
              (setq #err_flg T)
              (set_tile "error" "�u�݌������v����͂��ĉ�����")
            )
            (if (= nil (##IsNumeric #hang_h))
              (progn
                (setq #err_flg T)
                (set_tile "error" "�u�݌������v�͐��l�̂ݓ��͉\�ł�")
              )
              (if (< (fix (atoi #hang_h)) 0)
                (progn
                  (setq #err_flg T)
                  (set_tile "error" "�u�݌������v���}�C�i�X�l�œ��͂���Ă��܂�")
                )
              )
            )
          )
        )
      )

      (if (= #err_flg nil)
        (progn
          (setq #gas_idx (atoi (get_tile "GAS_TYPE")))
          (setq #idx 0)
          (repeat (length #GAS$$)
            (if (= #gas_idx #idx)
              (setq #gas (nth 0 (nth #idx #GAS$$)))
            )
            (setq #idx (1+ #idx))
          )
        )
      )

      (if (= #err_flg nil)
        (progn
          (setq #lst$
            (list
              (nth 0 (nth (atoi (get_tile "drseri")) #DRSERI$$))
              (nth 1 (nth (atoi (get_tile "drcol"))  #DRCOL$$ ))
              (nth 3 (nth (atoi (get_tile "handle")) #HANDLE$$))
              (fix (atoi #dist_x))
              (fix (atoi #dist_y))
              (fix (atoi #ceil_h))
              (fix (atoi #hang_h))
              #gas
            )
          )
          (done_dialog 1)
        )
        (setq #lst$ nil)
      )

      #lst$
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq #err_flag nil)

  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
    )
    (progn
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
    )
  )
;  (if (= CG_CDBSESSION nil)
;   (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
; )

  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertMsg "SERIES�ʂ̃f�[�^�x�[�X������܂���ł���")
      (setq #info$ nil)
      (setq #err_flag T)
    )
    (progn
      ;// ���݂̔�SERIES�A��COLOR�̐ݒ�
      ;��ذ�ނ�ؽ�
      (setq #DRSERI$$
        (CFGetDBSQLRec CG_DBSESSION "���V���Y"
          (list
            (list "�p��F" "0"  'INT)
          )
        )
      )
      (if (= #DRSERI$$ nil)
        (progn
          (CFAlertMsg "�y���V���Y�z��ں��ނ�����܂���B")
          (setq #info$ nil)
          (setq #err_flag T)
        )
      )
    )
  )

  (if (= #err_flag nil)
    (progn
      ; mdb���y�K�X��z���ꗗ���擾����
      (setq #GAS$$ (DBSqlAutoQuery CG_CDBSESSION "select * from �K�X��"))
      (if #GAS$$
        (progn
          (setq #GAS$$ (CFListSort #GAS$$ 1))
        )
        (progn
          (CFAlertMsg "�y�K�X��z��ں��ނ�����܂���B")
          (setq #info$ nil)
          (setq #err_flag T)
        )
      )
    )
  )

  (if (= #err_flag nil)
    (progn
      ; DCL���[�h
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "SetRoomInfo.dcl")))
      (if (not (new_dialog "InitRoomInfoDlg" #dcl_id)) (exit))

      ; �����l�ݒ�
      (setq #sDR_GRADE_PROHIBIT (CFgetini "DR_GRADE_PROHIBIT" CG_DBNAME (strcat CG_SKPATH "ERRMSG.INI")))

      ; �����l�̐ݒ�
      (setq CG_DRSeriCode        (CFgetini "INITIAL" "DoorSeriesCode" (strcat CG_SKPATH "ERRMSG.INI")))  ; ���O���[�h
      (setq CG_DRColCode         (CFgetini "INITIAL" "DoorColorCode"  (strcat CG_SKPATH "ERRMSG.INI")))  ; ���F
      (setq CG_Hikite            (CFgetini "INITIAL" "DoorHandle"     (strcat CG_SKPATH "ERRMSG.INI")))  ; ����
      (setq CG_RoomW       (atoi (CFgetini "INITIAL" "Width"          (strcat CG_SKPATH "ERRMSG.INI")))) ; �����g�w
      (setq CG_RoomD       (atoi (CFgetini "INITIAL" "Depth"          (strcat CG_SKPATH "ERRMSG.INI")))) ; �����g�x
      (setq CG_CeilHeight  (atoi (CFgetini "INITIAL" "CeilingHeight"  (strcat CG_SKPATH "ERRMSG.INI")))) ; �V�䍂��
      (setq CG_UpCabHeight (atoi (CFgetini "INITIAL" "SetHeight"      (strcat CG_SKPATH "ERRMSG.INI")))) ; ��t����
      (setq CG_GasType           (CFgetini "INITIAL" "GasType"        (strcat CG_SKPATH "ERRMSG.INI")))  ; �K�X��
;;;;(princ "\nCG_DRSeriCode  = ") (princ CG_DRSeriCode)
;;;;(princ "\nCG_DRColCode   = ") (princ CG_DRColCode)
;;;;(princ "\nCG_Hikite      = ") (princ CG_Hikite)
;;;;(princ "\nCG_RoomW       = ") (princ CG_RoomW)
;;;;(princ "\nCG_RoomD       = ") (princ CG_RoomD)
;;;;(princ "\nCG_CeilHeight  = ") (princ CG_CeilHeight)
;;;;(princ "\nCG_UpCabHeight = ") (princ CG_UpCabHeight)
;;;;(princ "\nCG_GasType     = ") (princ CG_GasType)

			(##ResetInitInfo #sDR_GRADE_PROHIBIT)

;;;;;      ; ���֘A
;;;;;      (start_list "drseri" 3)
;;;;;      (setq #i 0 #no 0)
;;;;;      (foreach #Qry$ #DRSERI$$
;;;;;        (setq #sDR_GRADE (strcat (substr CG_DRSeriCode 1 1) (substr (nth 0 #Qry$) 1 1)))
;;;;;        (if (wcmatch #sDR_GRADE #sDR_GRADE_PROHIBIT)
;;;;;          nil ;ؽĂɒǉ����Ȃ�
;;;;;          (progn
;;;;;            (add_list (strcat (nth 0 #Qry$) " �F " (nth 1 #Qry$)))
;;;;;          )
;;;;;        )
;;;;;
;;;;;        (if (= CG_DRSeriCode (nth 0 #Qry$))
;;;;;          (setq #no #i)
;;;;;        )
;;;;;        (setq #i (1+ #i))
;;;;;      )
;;;;;      (end_list)
;;;;;
;;;;;      (set_tile "drseri" (itoa #no))
;;;;;      (##SelDoorSeries)
;;;;;
;;;;;      (set_tile "DIST_X" (itoa CG_RoomW))       ; ��ʗ̈�w����
;;;;;      (set_tile "DIST_Y" (itoa CG_RoomD))       ; ��ʗ̈�x����
;;;;;      (set_tile "CEIL_H" (itoa CG_CeilHeight))  ; �V�䍂��
;;;;;      (set_tile "HANG_H" (itoa CG_UpCabHeight)) ; �݌�����
;;;;;
;;;;;      ; �K�X�탊�X�g
;;;;;      (start_list "GAS_TYPE" 3)
;;;;;      (foreach #GAS$ #GAS$$
;;;;;        (add_list (nth 0 #GAS$))
;;;;;      )
;;;;;      (end_list)
;;;;;
;;;;;      (setq #idx 0)
;;;;;      (setq #def 0)
;;;;;      (repeat (length #GAS$$)
;;;;;        (if (= (nth 0 (nth #idx #GAS$$)) CG_GasType)
;;;;;          (setq #def #idx)
;;;;;        )
;;;;;        (setq #idx (1+ #idx))
;;;;;      )
;;;;;      (set_tile "GAS_TYPE" (itoa #def))

      (setq #next 99)
      (while (and (/= 1 #next) (/= 0 #next))
        ; �{�^����������
        (action_tile "drseri" "(##SelDoorSeries)")
        (action_tile "drcol"  "(##SelDoorHandle)") ; 02/11/30 YM ADD
        (action_tile "accept" "(setq #info$ (##SetinitInfo_CallBack))")
;        (action_tile "cancel" "(setq #info$ nil)(done_dialog 0)")
        (action_tile "cancel" "(##ResetInitInfo #sDR_GRADE_PROHIBIT)")

        (setq #next (start_dialog))
      )

      (unload_dialog #dcl_id)
    )
  )

  #info$

) ;InputInitInfo
;-- 2011/10/06 A.Satoh Add - E

;-- 2011/10/11 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : CFOutInputCfg
; <�����T�v>  : Input.cfg�t�@�C���֓��͐ݒ������������
; <�߂�l>    : T  : ����I��
;             : nil: �ُ�I��
; <�쐬>      : 2011-10-11
; <���l>      : �{�֐��́AKPCAD�̊m��I������ђ��f�I�����ɌĂяo�����
;               �j���I�����͌Ăяo����Ȃ�
;*************************************************************************>MOH<
;;;;;(defun C:qqq (
;;;;;	/
;;;;;	)
;;;;;
;;;;;	(CFOutInputCfg T)
;;;;;)
;;;;;
(defun CFOutInputCfg (
	&fix_flg ; �m��I���t���O T:�m��I�� nil:���f�I��
  /
	#output$ #planinfo$$ #planinfo$ #plan$ #plan #ret
	#num #num_str #sk$ #spec$ #spec #expense$ #expense #listA$ #listD$
	#DoorGrade$$ #DoorGrade$ #Input$$ #Input$ #fid #wstr #index #write
	#output_presen$ #door$
#DoorColorCode #DoorHandle #DoorSeriesCode #err_flag #GasType #SeriesDB
#offset$ #allWhite ;-- 2012/03/05 A.Satoh Add CG�p�ǐݒ�(�I�t�Z�b�g����)�Ή�
#CG_Y ;2012/03/06 YM ADD
  )

  (setq #output$ nil)
	(setq #ret T)

;;;(princ "\n�����������@CFOutInputCfg 111�@����������")

  ; PlanInfo.cfg�Ǎ�
	(if (findfile (strcat CG_KENMEI_PATH "PLANINFO.CFG"))
		(progn
		  (setq #planinfo$$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))

;;;(princ "\n�����������@CFOutInputCfg 222�@����������")

      (foreach #planinfo$ #planinfo$$
 		    (cond
     		  ((= (nth 0 #planinfo$) "SeriesDB")
						(setq #SeriesDB (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN01" (nth 1 #planinfo$)))))
					)
					((= (nth 0 #planinfo$) "DoorSeriesCode")
						(setq #DoorSeriesCode (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN12" (nth 1 #planinfo$)))))
					)
					((= (nth 0 #planinfo$) "DoorColorCode")
						(setq #DoorColorCode (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN13" (nth 1 #planinfo$)))))
					)
					((= (nth 0 #planinfo$) "DoorHandle")
						(setq #DoorHandle (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN14" (nth 1 #planinfo$)))))
					)
					((= (nth 0 #planinfo$) "GasType")
						(setq #GasType (nth 1 #planinfo$))
;						(setq #plan$ (append #plan$ (list (list "PLAN24" (nth 1 #planinfo$)))))
					)
				)
			);foreach
;;;(princ "\n�����������@CFOutInputCfg 333�@����������")

		)
		(progn
			(setq #SeriesDB CG_SeriesDB)
;			(setq #plan$ (append #plan$ (list (list "PLAN01" CG_SeriesDB))))
			(setq #DoorSeriesCode CG_DRSeriCode)
;      (setq #plan$ (append #plan$ (list (list "PLAN12" CG_DRSeriCode))))
			(setq #DoorColorCode CG_DRColCode)
;      (setq #plan$ (append #plan$ (list (list "PLAN13" CG_DRColCode))))
			(setq #DoorHandle CG_HIKITE)
;      (setq #plan$ (append #plan$ (list (list "PLAN14" CG_HIKITE))))
			(setq #GasType CG_GasType)
;      (setq #plan$ (append #plan$ (list (list "PLAN24" CG_GasType))))
		)
	)

;;;(princ "\n�����������@CFOutInputCfg 444�@����������")

;;;(princ "\n DoorSeriesCode= " )(princ  #DoorSeriesCode)
;;;(princ "\n DoorColorCode = " )(princ  #DoorColorCode)
;;;(princ "\n DoorHandle    = " )(princ  #DoorHandle)
;;;(princ "\n #door$        = " )(princ  #door$)

;;;(princ "\n�����������@OutputPresenDlg�@����������")

	(if (= &fix_flg T)
		(progn
			(setq #door$ (list #DoorSeriesCode #DoorColorCode #DoorHandle))
			(setq	#output_presen$ (OutputPresenDlg #door$))
			(if (= #output_presen$ nil)
				(setq #ret nil)
				(progn

;;;(princ "\n�����������@CFOutInputCfg 555�@����������")

					(setq #DoorSeriesCode (nth 0 #output_presen$))
					(setq #DoorColorCode  (nth 1 #output_presen$))
					(setq #DoorHandle     (nth 2 #output_presen$))

;-- 2012/03/05 A.Satoh Add CG�p�ǐݒ�(�I�t�Z�b�g����)�Ή� - S

;;;					(setq #cg_y (nth 21 #output_presen$))
;;;					(setq #allWhite (nth 25 #output_presen$))

					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;					(setq #cg_y (nth 22 #output_presen$))
;					(setq #allWhite (nth 26 #output_presen$))
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					;2018/04/27 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #cg_y (nth 24 #output_presen$))
					(setq #allWhite (nth 28 #output_presen$))
					;2018/04/27 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;-- 2012/03/15 A.Satoh Mod �Ɩ��̋����Ή��i���ɖ߂��j - S
					;2012/03/06 YM MOD-S
					(if (= #cg_y "1")
;;;;;					(if (and (= #cg_y "1")(= #allWhite "0"));�w�i��(#allWhite="1")�̂Ƃ��ACG�ǵ̾�Ă͓��͉�ʂ͕s�v
					;2012/03/06 YM MOD-E
;-- 2012/03/15 A.Satoh Mod �Ɩ��̋����Ή��i���ɖ߂��j - E
						(progn
							; CG�p�ǐݒ菈��
;-- 2012/03/15 A.Satoh Mod �Ɩ��̋����Ή��i���ɖ߂��j - S
;;;;;							(setq #offset$ (SetCGWallDlg));#allWhite="1"�̂Ƃ�nil�ɂȂ�
							(setq #offset$ (SetCGWallDlg #allWhite))
;-- 2012/03/15 A.Satoh Mod �Ɩ��̋����Ή��i���ɖ߂��j - E
							(if (= #offset$ nil)
								(setq #ret nil)
							)
						)
;-- 2012/03/15 A.Satoh Del �Ɩ��̋����Ή��i���ɖ߂��j - S
;;;;;						;2012/03/06 YM MOD-S
;;;;;						(progn
;;;;;							(setq #offset$ (list "0" "0" "0" "0"))
;;;;;						)
;;;;;						;2012/03/06 YM MOD-E
;-- 2012/03/15 A.Satoh Del �Ɩ��̋����Ή��i���ɖ߂��j - E
					)
;-- 2012/03/05 A.Satoh Add CG�p�ǐݒ�(�I�t�Z�b�g����)�Ή� - E

;;;(princ "\n�����������@CFOutInputCfg 666�@����������")

				)
			);_if
		)
	)

;;;(princ "\n�����������@CFOutInputCfg 777�@����������")

	(if (= #ret T)
		(progn
			(setq #plan$ nil)
			(setq #plan$ (append #plan$ (list (list "PLAN01" #SeriesDB))))
		  (setq #plan$ (append #plan$ (list (list "PLAN12" #DoorSeriesCode))))
		  (setq #plan$ (append #plan$ (list (list "PLAN13" #DoorColorCode))))
		  (setq #plan$ (append #plan$ (list (list "PLAN14" #DoorHandle))))
		  (setq #plan$ (append #plan$ (list (list "PLAN24" #GasType))))

		  ; [SET_INFORMATION]�o�͏��̍쐬
			(setq #output$ (append #output$ (list "[SET_INFORMATION]")))
;;;(princ "\n�����������@111�@����������")
			(setq #err_flag nil)
			(setq #num 0)
			(foreach #plan #plan$
				(if (= #err_flag nil)
					(progn
						(setq #sk$ (CFGetSKData #plan))
						(if (= #sk$ nil)
							(setq #err_flag T)
							(progn
								(setq #num (1+ #num))
								(cond
									((< #num 10)
										(setq #num_str (strcat "00" (itoa #num)))
									)
									((and (> #num 9) (< #num 100))
										(setq #num_str (strcat "0" (itoa #num)))
									)
									(T
										(setq #num_str (itoa #num))
									)
								)
								(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) "," (nth 1 #sk$) "," (nth 2 #sk$) "," (nth 3 #sk$)))))
							)
						)
					)
				)
			)
;;;(princ "\n�����������@222�@����������")
			(if (= &fix_flg T)
				(progn
;;;(princ "\n�����������@333�@����������")
					; �L�b�`���d�l�̏����擾����
					(setq #plan$ nil)
					(setq #plan$ (append #plan$ (list (list "PLAN05" (nth  3 #output_presen$)))))	; �`��
					(setq #plan$ (append #plan$ (list (list "PLAN07" (nth  4 #output_presen$)))))	; ���s��
					(setq #plan$ (append #plan$ (list (list "PLAN04" (nth  5 #output_presen$)))))	; �L�b�`���Ԍ�
					(setq #plan$ (append #plan$ (list (list "PLAN31" (nth  6 #output_presen$)))))	; ���[�N�g�b�v����
					(setq #plan$ (append #plan$ (list (list "PLAN02" (nth  7 #output_presen$)))))	; �L���r�l�b�g�v����
					(setq #plan$ (append #plan$ (list (list "PLAN17" (nth  8 #output_presen$)))))	; �V���N
					(setq #plan$ (append #plan$ (list (list "PLAN16" (nth  9 #output_presen$)))))	; ���[�N�g�b�v�ގ�
					(setq #plan$ (append #plan$ (list (list "PLAN06" (nth 10 #output_presen$)))))	; �t���A�L���r�^�C�v

;;;(princ "\n�����������@444�@����������")
					;2016/04/15 YM ADD -S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #plan$ (append #plan$ (list (list "PLAN15" (nth 11 #output_presen$)))))	; �t���A�L���r�^�C�v
					;2016/04/15 YM ADD -E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;(princ "\n�����������@555�@����������")

					(setq #plan$ (append #plan$ (list (list "PLAN08" (nth 12 #output_presen$)))))	; �\�t�g�N���[�Y
					(setq #plan$ (append #plan$ (list (list "PLAN32" (nth 13 #output_presen$)))))	; �݌ˍ���
					(setq #plan$ (append #plan$ (list (list "PLAN19" (nth 14 #output_presen$)))))	; ����
					(setq #plan$ (append #plan$ (list (list "PLAN22" (nth 15 #output_presen$)))))	; �򐅊�
					(setq #plan$ (append #plan$ (list (list "PLAN20" (nth 16 #output_presen$)))))	; ���M�@��
					(setq #plan$ (append #plan$ (list (list "PLAN21" (nth 17 #output_presen$)))))	; �R�������I�[�u��
					(setq #plan$ (append #plan$ (list (list "PLAN42" (nth 18 #output_presen$)))))	; �H��
					(setq #plan$ (append #plan$ (list (list "PLAN23" (nth 19 #output_presen$)))))	; �����W�t�[�h
					(setq #plan$ (append #plan$ (list (list "PLAN44" (nth 20 #output_presen$)))))	; �K���X�p�[�e�B�V����
					(setq #plan$ (append #plan$ (list (list "PLAN47" (nth 21 #output_presen$)))))	; �L�b�`���p�l��

					;2018/04/27 YK ADD -S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;					(setq #plan$ (append #plan$ (list (list "PLAN11" (nth 22 #output_presen$)))))	; ���E����
;					(setq #plan$ (append #plan$ (list (list "PLAN48" (nth 23 #output_presen$)))))	; �V�䍂��
					;2018/04/27 YK ADD -E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;;;(princ "\n�����������@666�@����������")

					(setq #err_flag nil)
					(foreach #plan #plan$
						(if (= #err_flag nil)
							(progn
								(setq #sk$ (CFGetKichinTokusei #plan))
								(if (= #sk$ nil)
									(setq #err_flag T)
									(progn
										(setq #num (1+ #num))
										(cond
											((< #num 10)
												(setq #num_str (strcat "00" (itoa #num)))
											)
											((and (> #num 9) (< #num 100))
												(setq #num_str (strcat "0" (itoa #num)))
											)
											(T
												(setq #num_str (itoa #num))
											)
										)
										(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) "," (nth 1 #sk$) "," (nth 2 #sk$) "," (nth 3 #sk$)))))
									)
								)
							)
						)
					)

;;;(princ "\n�����������@777�@����������")

;-- 2012/01/18 A.Satoh Add CG�Ή� - S

					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;					(setq #sk$ (list (nth 22 #output_presen$) (nth 23 #output_presen$) (nth 24 #output_presen$)))
;					(setq #sk$ (list (nth 23 #output_presen$) (nth 24 #output_presen$) (nth 25 #output_presen$)))
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					;2018/04/27 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #sk$ (list (nth 25 #output_presen$) (nth 26 #output_presen$) (nth 27 #output_presen$)))
					;2018/04/27 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;;;(princ "\n�����������@888�@����������")

					(setq #num (1+ #num))
					(cond
						((< #num 10)
							(setq #num_str (strcat "00" (itoa #num)))
						)
						((and (> #num 9) (< #num 100))
							(setq #num_str (strcat "0" (itoa #num)))
						)
						(T
							(setq #num_str (itoa #num))
						)
					)
;-- 2012/03/05 A.Satoh Mod - S
;;;;;					(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) ",���J���[," (nth 1 #sk$) "," (nth 2 #sk$)))))
					(if (and (= #cg_y "1") (= #allWhite "1"))
							(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) ",," (nth 1 #sk$) "," (nth 2 #sk$)))))
							(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) ",���J���[," (nth 1 #sk$) "," (nth 2 #sk$)))))
					)
;-- 2012/03/05 A.Satoh Mod - E

					;2018/04/27 YK ADD -S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #num (1+ #num))
					(cond
						((< #num 10)
							(setq #num_str (strcat "00" (itoa #num)))
						)
						((and (> #num 9) (< #num 100))
							(setq #num_str (strcat "0" (itoa #num)))
						)
						(T
							(setq #num_str (itoa #num))
						)
					)
					(setq #sk$ (CFGetKichinTokusei (list "PLAN11" (nth 22 #output_presen$))))
					(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) "," (nth 1 #sk$) "," (nth 2 #sk$) "," (nth 3 #sk$)))))
					(setq #num (1+ #num))
					(cond
						((< #num 10)
							(setq #num_str (strcat "00" (itoa #num)))
						)
						((and (> #num 9) (< #num 100))
							(setq #num_str (strcat "0" (itoa #num)))
						)
						(T
							(setq #num_str (itoa #num))
						)
					)
					(setq #sk$ (CFGetKichinTokusei (list "PLAN48" (nth 23 #output_presen$))))
					(setq #output$ (append #output$ (list (strcat #num_str "=" (nth 0 #sk$) "," (nth 1 #sk$) "," (nth 2 #sk$) "," (nth 3 #sk$)))))
					;2018/04/27 YK ADD -E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					
;-- 2012/02/28 A.Satoh Del ([KPCAD_CG_RENKEI]�Z�N�V�����̏o�͉ӏ��ύX) - S
;;;;;				  ; [KPCAD_CG_RENKEI]�o�͏��̍쐬
;;;;;					(setq #output$ (append #output$ (list "[KPCAD_CG_RENKEI]")))
;;;;;					(setq #cg_y (nth 21 #output_presen$))
;;;;;					(if (= #cg_y "1")
;;;;;						(setq #output$ (append #output$ (list "CG=Y")))
;;;;;						(setq #output$ (append #output$ (list "CG=N")))
;;;;;					)
;-- 2012/02/28 A.Satoh Del ([KPCAD_CG_RENKEI]�Z�N�V�����̏o�͉ӏ��ύX) - E
;-- 2012/01/18 A.Satoh Add CG�Ή� - E


;;;(princ "\n�����������@999�@����������")

					; �z�u���ނ̏����擾����
					(setq #spec$ (CFGetSpecList))
					(if #spec$
						(progn
						  (setq #output$ (append #output$ (list "[DETAILS_INFORMATION]")))
							(foreach #spec #spec$
								(if #spec$
;-- 2011/11/25 A.Satoh Mod - S
;;;;;									(setq #output$
;;;;;										(append #output$
;;;;;											(list (strcat (nth 0 #spec) "," (nth 1 #spec) "," (nth 2 #spec) "," (itoa (nth 3 #spec)) ","
;;;;;																		(rtos (nth 4 #spec)) "," (rtos (nth 5 #spec)) "," (nth 6 #spec) "," (nth 7 #spec))
;;;;;											)
;;;;;										)
;;;;;									)
;;;;;									(setq #output$ (append #output$ (list ",,,,,,,")))
									(setq #output$
										(append #output$
											(list (strcat (nth 0 #spec) "," (nth 1 #spec) "," (nth 2 #spec) "," (nth 3 #spec) ","
																		(nth 4 #spec) "," (nth 5 #spec) "," (itoa (nth 6 #spec)) "," (rtos (nth 7 #spec)) ","
																		(rtos (nth 8 #spec)) "," (nth 9 #spec) "," (nth 10 #spec) "," (itoa (nth 11 #spec)))
											)
										)
									)
									(setq #output$ (append #output$ (list ",,,,,,,,,,,")))
;-- 2011/11/25 A.Satoh Mod - E
								)
							)
						)
						(progn
;-- 2011/11/25 A.Satoh Mod - S
;;;;;							(setq #output$ (append #output$ (list ",,,,,,,")))
							(setq #output$ (append #output$ (list ",,,,,,,,,,,")))
;-- 2011/11/25 A.Satoh Mod - E
						)
					);_if

;;;(princ "\n�����������@AAA�@����������")

					; buzai.cfg�̓Ǎ�
		    	(setq #expense$ (CFGetBuzaiExpense))
					(if (/= #expense$ nil)
						(progn
		      		(setq #listA$ nil #listD$ nil)
							(foreach #expense #expense$
								(cond
									((= (nth 0 #expense) "CONSTRUCT_A")
										(setq #listA$ (append #listA$ (list (nth 1 #expense))))
									)
									((= (nth 0 #expense) "FREIGHT_A")
										(setq #listA$ (append #listA$ (list (nth 1 #expense))))
									)
									((= (nth 0 #expense) "CONSTRUCT_D")
										(setq #listD$ (append #listD$ (list (nth 1 #expense))))
									)
									((= (nth 0 #expense) "FREIGHT_D")
										(setq #listD$ (append #listD$ (list (nth 1 #expense))))
									)
								)
							)

							; [KP_CONSTRUCT]�o�͏��̍쐬
							(setq #output$ (append #output$ (list "[KP_CONSTRUCT]")))
							(setq #output$ (append #output$ (list (strcat "A=" (nth 0 #listA$) "," (nth 1 #listA$)))))
							(setq #output$ (append #output$ (list (strcat "D=" (nth 0 #listD$) "," (nth 1 #listD$)))))
						)
					);_if

;;;(princ "\n�����������@BBB�@����������")


					; ���ʎQ�l���i�̎Z�o
					(setq #DoorGrade$$ (CFGetDoorGrade #spec$))
					(if (/= #DoorGrade$$ nil)
						(progn
				      (setq #output$ (append #output$ (list "[KP_ANOTHER_GRADE]")))
							(foreach #DoorGrade$ #DoorGrade$$
								(if #DoorGrade$
									(setq #output$
										(append #output$
											(list
												(strcat
													(nth 0 #DoorGrade$)
													(nth 1 #DoorGrade$) ","
													(nth 2 #DoorGrade$) ","
													(nth 3 #DoorGrade$) ","
													(nth 4 #DoorGrade$) ","
													(nth 5 #DoorGrade$) ","
													(nth 6 #DoorGrade$)
												)
											)
										)
									)
									(setq #output$ (append #output$ (list ",,,,,")))
								)
							)
						)
						(progn
							(setq #output$ (append #output$ (list "01=,,,,,")))
						)
					);_if

;;;(princ "\n�����������@CCC�@����������")

;-- 2012/02/28 A.Satoh Del ([KPCAD_CG_RENKEI]�Z�N�V�����̏o�͉ӏ��ύX) - S
				  ; [KPCAD_CG_RENKEI]�o�͏��̍쐬
					(setq #output$ (append #output$ (list "[KPCAD_CG_RENKEI]")))
;-- 2012/03/05 A.Satoh Mod CG�p�ǐݒ�(�I�t�Z�b�g����)�Ή� - S
;;;;;					(setq #cg_y (nth 21 #output_presen$))
;;;;;					(if (= #cg_y "1")
;;;;;						(setq #output$ (append #output$ (list "CG=Y")))
;;;;;						(setq #output$ (append #output$ (list "CG=N")))
;;;;;					)
					(if (= #cg_y "1")
						(progn
							(setq #output$ (append #output$ (list "CG=Y")))
							;2012/03/06 YM ADD-S
							(if (= #allWhite "0")
								(progn
							;2012/03/06 YM ADD-E
									(setq #output$ (append #output$ (list (strcat "U_OFFSET=" (nth 0 #offset$)))))
									(setq #output$ (append #output$ (list (strcat "D_OFFSET=" (nth 1 #offset$)))))
									(setq #output$ (append #output$ (list (strcat "L_OFFSET=" (nth 2 #offset$)))))
									(setq #output$ (append #output$ (list (strcat "R_OFFSET=" (nth 3 #offset$)))))
							;2012/03/06 YM ADD-S
								)
							);_if
							;2012/03/06 YM ADD-E
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
							(cond
								((= (nth 4 #offset$) "1")		; �Ɩ��̋����F����
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL1")))
								)
								((= (nth 4 #offset$) "2")		; �Ɩ��̋����F��⋭��
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL2")))
								)
								((= (nth 4 #offset$) "3")		; �Ɩ��̋����F����
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL3")))
								)
								((= (nth 4 #offset$) "4")		; �Ɩ��̋����F���ア
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL4")))
								)
								((= (nth 4 #offset$) "5")		; �Ɩ��̋����F�ア
									(setq #output$ (append #output$ (list "LIGHT_INTENSITY=LEVEL5")))
								)
							)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
						)
						(setq #output$ (append #output$ (list "CG=N")))
					);_if

;;;(princ "\n�����������@DDD�@����������")

;-- 2012/03/05 A.Satoh Mod CG�p�ǐݒ�(�I�t�Z�b�g����)�Ή� - E
;-- 2012/02/28 A.Satoh Del ([KPCAD_CG_RENKEI]�Z�N�V�����̏o�͉ӏ��ύX) - E
				)
			)

			; Input.cfg��Ǎ���
			(setq #Input$$ (ReadIniFile (strcat CG_SYSPATH "Input.cfg")))
			(if (/= #Input$$ nil)
				(progn
					; Input.cfg�̃o�b�N�A�b�v�����
					(if (findfile (strcat CG_SYSPATH "Input0.cfg"))
						(vl-file-delete (strcat CG_SYSPATH "Input0.cfg"))
					)
					(vl-file-rename (strcat CG_SYSPATH "Input.cfg") (strcat CG_SYSPATH "Input0.cfg"))

		      ; Input.cfg���������݃��[�h�ŊJ��
					(setq #fid (open (strcat CG_SYSPATH "Input.cfg") "W"))
					(if #fid
						(progn
							(setq #wstr "")
							(foreach #Input$ #Input$$
								(if (= (length #Input$) 2)
									;2016/04/15 YM MOD PLANNING_NO �Ō�쓮���N����
;;;									(if (and (> (strlen (nth 0 #Input$)) 5) (= (substr (nth 0 #Input$) 1 4) "PLAN"))
									(if (wcmatch (substr (nth 0 #Input$) 1 6) "PLAN??")
										(progn
											(setq #index (read (substr (nth 0 #Input$) 5)))
											(if (= 'INT (type #index))
												(setq #write nil)
												(setq #write T)
											)

											(if #write
												(setq #wstr (strcat (nth 0 #Input$) "=" (nth 1 #Input$)))
												(setq #wstr "")
											)
										)
										(setq #wstr (strcat (nth 0 #Input$) "=" (nth 1 #Input$)))
									)
									(if (= (nth 0 #Input$) "[SET_INFORMATION]")
										(setq #wstr "")
										(setq #wstr (nth 0 #Input$))
									)
								)

								(if (/= #wstr "")
									(princ (strcat #wstr "\n") #fid)
								)
							)

							(foreach #output #output$
								(princ (strcat #output "\n") #fid)
							)

							(close #fid)
						)
						(progn
							(CFAlertMsg "Input.cfg�̏o�͂Ɏ��s���܂����B")
							(setq #ret nil)
						)
					)
				)
				(progn
					(CFAlertMsg "Input.cfg�̓Ǎ��Ɏ��s���܂����B")
					(setq #ret nil)
				)
			);_if

;;;(princ "\n�����������@EEE�@����������")

		)
	)

;;;(princ "\n�����������@FFF�@����������")

  #ret

);CFOutInputCfg


;<HOM>*************************************************************************
; <�֐���>    : CFGetSKData
; <�����T�v>  : �uSK�����v�uSK�����l�v�e�[�u����Ǎ��AInput.cfg�o�͏����擾����
; <�߂�l>    : �o�͍��ڃ��X�g or nil
; <�쐬>      : 2011-10-11
; <���l>      : �o�͍��ڃ��X�g�t�H�[�}�b�g
;             :  (����ID ������ �����l �����l��)
;             :   exp. (PLAN01,�V���[�Y,SKB,�X�C�[�W�B�[)
;*************************************************************************>MOH<
(defun CFGetSKData (
  &plan$  ; INFORMATION��񃊃X�g (����ID �����l)
  /
	#err_flag #ret$ #SK_TOKU$ #toku_name #SK_TOKU_VALUE$ #toku_val_name
  )

  (setq #err_flag nil)
  (setq #ret$ nil)

  (setq #SK_TOKU$
    (CFGetDBSQLRec CG_DBSESSION "SK����"
      (list
        (list "����ID" (nth 0 &plan$)  'STR)
      )
    )
  )
  (if (= #SK_TOKU$ nil)
    (progn
      (CFAlertMsg "�ySK�����z��ں��ނ�����܂���B")
      (setq #err_flag T)
    )
  )
  (if (> (length #SK_TOKU$) 2)
    (progn
      (CFAlertMsg "�ySK�����z�̊Y��ں��ނ�2���ȏ㑶�݂��܂��B")
      (setq #err_flag T)
    )
  )
  (if (= #err_flag nil)
    (setq  #toku_name (nth 5 (car #SK_TOKU$)))
  )

  (if (= #err_flag nil)
    (progn
      (if (= (nth 0 &plan$) "PLAN01")
        (setq #SK_TOKU_VALUE$
          (CFGetDBSQLRec CG_DBSESSION "SK�����l"
            (list
              (list "����ID" (nth 0 &plan$) 'STR)
            )
          )
        )
        (setq #SK_TOKU_VALUE$
          (CFGetDBSQLRec CG_DBSESSION "SK�����l"
            (list
              (list "����ID" (nth 0 &plan$) 'STR)
              (list "�����l" (nth 1 &plan$) 'STR)
            )
          )
        )
      )

      (if (= #SK_TOKU_VALUE$ nil)
        (progn
          (CFAlertMsg "�ySK�����l�z��ں��ނ�����܂���B")
          (setq #err_flag T)
        )
      )
      (if (> (length #SK_TOKU_VALUE$) 2)
        (progn
          (CFAlertMsg "�ySK�����l�z�̊Y��ں��ނ�2���ȏ㑶�݂��܂��B")
          (setq #err_flag T)
        )
      )
    )
  )

  (if (= #err_flag nil)
    (progn
      (setq #toku_val_name (nth 3 (car #SK_TOKU_VALUE$)))

      (setq #ret$ (list (nth 0 &plan$) #toku_name (nth 1 &plan$) #toku_val_name))
    )
  )

  #ret$

);CFGetSKData


;<HOM>*************************************************************************
; <�֐���>    : CFGetKichinTokusei
; <�����T�v>  : �uSK�����v�uSK�����l�v�uPB�����l�v�e�[�u����Ǎ��AInput.cfg�o��
;             : �����擾����
; <�߂�l>    : �o�͍��ڃ��X�g or nil
; <�쐬>      : 2011-10-28
; <���l>      : �o�͍��ڃ��X�g�t�H�[�}�b�g
;             :  (����ID ������ �����l �����l��)
;             :   exp. (PLAN01,�V���[�Y,SKB,�X�C�[�W�B�[)
;*************************************************************************>MOH<
(defun CFGetKichinTokusei (
  &plan$  ; INFORMATION��񃊃X�g (����ID �����l)
  /
	#err_flag #ret$ #SK_TOKU$ #toku_name #PB_TOKU_VALUE$ #toku_val_name
  )

  (setq #err_flag nil)
  (setq #ret$ nil)

  (setq #SK_TOKU$
    (CFGetDBSQLRec CG_DBSESSION "SK����"
      (list
        (list "����ID" (nth 0 &plan$)  'STR)
      )
    )
  )
  (if (= #SK_TOKU$ nil)
    (progn
      (CFAlertMsg "�ySK�����z��ں��ނ�����܂���B")
      (setq #err_flag T)
    )
  )
  (if (> (length #SK_TOKU$) 2)
    (progn
      (CFAlertMsg "�ySK�����z�̊Y��ں��ނ�2���ȏ㑶�݂��܂��B")
      (setq #err_flag T)
    )
  )
  (if (= #err_flag nil)
		(progn
	    (setq  #toku_name (nth 5 (car #SK_TOKU$)))

			(setq #PB_TOKU_VALUE$
				(CFGetDBSQLRec CG_DBSESSION "PB�����l"
					(list
						(list "����ID" (nth 0 &plan$) 'STR)
						(list "�L��" (nth 1 &plan$) 'STR)
					)
				)
			)

      (if (= #PB_TOKU_VALUE$ nil)
        (progn
          (CFAlertMsg "�yPB�����l�z��ں��ނ�����܂���B")
          (setq #err_flag T)
        )
      )
      (if (> (length #PB_TOKU_VALUE$) 2)
        (progn
          (CFAlertMsg "�yPB�����l�z�̊Y��ں��ނ�2���ȏ㑶�݂��܂��B")
          (setq #err_flag T)
        )
      )
    )
  )

  (if (= #err_flag nil)
    (progn
      (setq #toku_val_name (nth 3 (car #PB_TOKU_VALUE$)))
			(if (= #toku_val_name nil)
				(setq #toku_val_name "")
			)

      (setq #ret$ (list (nth 0 &plan$) #toku_name (nth 1 &plan$) #toku_val_name))
    )
  )

  #ret$

);CFGetKichinTokusei


;;;<HOM>************************************************************************
;;; <�֐���>  : CFGetSpecList
;;; <�����T�v>: �z�u���ޏ����擾����
;;; <�߂�l>  : �z�u���ޏ�񃊃X�g
;;; <���l>    : ���L�O���[�o���ϐ���ݒ�
;;;               CG_DBNAME      : DB����
;;;               CG_SeriesCode  : SERIES�L��
;;;               CG_BrandCode   : �u�����h�L��
;;;************************************************************************>MOH<
(defun CFGetSpecList (
  /
	#spec$$ #CG_SpecList$$ #hin_old #LR_old #num_CHANGE$ #num #hin #LR
	#dum1$ #dum2$ #CG_SpecList$ #k #dum$$ #CG_SpecListA$$ #CG_SpecListD$$
	#a_cnt #d_cnt #bunrui #num_str #list$
  )

  ; �z�u���ގd�l�ڍ׏����擾
  (setq #spec$$ (ConfPartsAll_GetSpecInfo))

  ; �z�u���ގd�l�ڍ׏����擾
	(setq #CG_SpecList$$ (ConfPartsAll_GetSpecList #spec$$))

	(if #CG_SpecList$$
		(progn
		  (setq #hin_old nil)
		  (setq #LR_old  nil)
		  (setq #num_CHANGE$ nil)

		  ;����ւ��L������ �����i�Ԃ��A�����AR,L�̏��Ԃł����L,R�̏��Ԃɂ���
		  (foreach #CG_SpecList$ #CG_SpecList$$
    		(setq #num (nth  0 #CG_SpecList$));�ԍ�
;		    (setq #hin (nth  9 #CG_SpecList$))
		    (setq #hin (nth 11 #CG_SpecList$))
;    		(setq #LR  (nth 10 #CG_SpecList$))
    		(setq #LR  (nth 12 #CG_SpecList$))
		    (if (and (= #hin #hin_old) (= "R" #LR_old) (= "L" #LR))
    		  (setq #num_CHANGE$ (append #num_CHANGE$ (list (atoi #num))));1��O�Ɠ���ւ����K�v(����)
		    );_if
    		(setq #hin_old #hin)
		    (setq #LR_old   #LR)
		  );foreach

		  ;����ւ�����
		  (if #num_CHANGE$
    		(progn
		      (foreach #num_CHANGE #num_CHANGE$ ;#num_CHANGE��1�O�Ɠ���ւ���
    		    ;1�O
        		(setq #dum1$ (assoc (itoa (1- #num_CHANGE)) #CG_SpecList$$))

		        ;�ԍ�����׽
    		    (setq #dum1$ (CFModList #dum1$ (list (list 0 (itoa #num_CHANGE)))))

		        ;���̎�
    		    (setq #dum2$ (assoc (itoa #num_CHANGE) #CG_SpecList$$))

        		;�ԍ���ϲŽ
		        (setq #dum2$ (CFModList #dum2$ (list (list 0 (itoa (1- #num_CHANGE))))))

    		    ;1�O��#dum1$�ɓ���ւ���
        		(setq #CG_SpecList$$ (CFModList #CG_SpecList$$ (list (list (- #num_CHANGE 2) #dum1$))))

		        ;���̎���#dum2$�ɓ���ւ���
    		    (setq #CG_SpecList$$ (CFModList #CG_SpecList$$ (list (list (- #num_CHANGE 1) #dum2$))))
		      )

    		  ; �ԍ��Ń\�[�g�i�����ſ�Ă����"1","10","11","2"�ƂȂ��Ă��܂����琔���ſ�Ă��Ȃ�����ҁj
		      (setq #dum$$ nil)
    		  (foreach #CG_SpecList$ #CG_SpecList$$
        		(setq #k (atoi (nth 0 #CG_SpecList$)))
		        (setq #dum$$ (append #dum$$ (list (cons #k #CG_SpecList$))));�ԍ���擪�ɒǉ�
    		  )

		      ;�����̔ԍ��ſ��
    		  (setq #dum$$ (CFListSort #dum$$ 0))

		      (setq #CG_SpecList$$ nil);�ر
    		  (foreach #dum$ #dum$$
        		(setq #CG_SpecList$ (cdr #dum$))
		        (setq #CG_SpecList$$ (append #CG_SpecList$$ (list #CG_SpecList$)))
    		  )
		    )
		  )

		  ; �L�b�`���A���[�p�ɕ���
		  (setq #CG_SpecListA$$ nil)
		  (setq #CG_SpecListD$$ nil)
		  (setq #a_cnt 0)
		  (setq #d_cnt 0)

		  (foreach #CG_SpecList$ #CG_SpecList$$
    		(setq #bunrui (nth 8 #CG_SpecList$))
				(if (or (= (type (nth 6 #CG_SpecList$)) 'INT) (= (type (nth 6 #CG_SpecList$)) 'REAL))
					(setq #kosu (nth 6 #CG_SpecList$))
					(setq #kosu 0)
				)
				(if (or (= (type (nth 7 #CG_SpecList$)) 'INT) (= (type (nth 7 #CG_SpecList$)) 'REAL))
					(setq #tanka (nth 7 #CG_SpecList$))
					(setq #tanka 0)
				)
		    (if (= #bunrui "A")
    		  (progn
        		(setq #a_cnt (1+ #a_cnt))
		        (cond
    		      ((< #a_cnt 10)
        		    (setq #num_str (strcat "A00" (itoa #a_cnt) "=" (itoa #a_cnt)))
		          )
    		      ((and (> #a_cnt 9) (< #a_cnt 100))
        		    (setq #num_str (strcat "A0" (itoa #a_cnt) "=" (itoa #a_cnt)))
		          )
    		      (T
        		    (setq #num_str (strcat "A" (itoa #a_cnt) "=" (itoa #a_cnt)))
		          )
						)

		        ; �L�b�`���p��񃊃X�g�쐬
    		    (setq #list$
        		  (list
            		(list
		              #num_str
    		          (nth  1 #CG_SpecList$)	; �ŏI�i��
        		      (nth  5 #CG_SpecList$)	; �i��
;-- 2011/11/25 A.Satoh Add - S
        		      (nth  2 #CG_SpecList$)	; ��
        		      (nth  3 #CG_SpecList$)	; ����
        		      (nth  4 #CG_SpecList$)	; ���s
;-- 2011/11/25 A.Satoh Add - E
            		  #kosu										; ��
		              #tanka									; �P��
									(* #kosu #tanka)				; ���z
        		      (nth  9 #CG_SpecList$)	; �W��ID
;									""	; �����R�[�h�i���ݓ������Ή��A�����Ή����ɔ��f�j2011/10/12
									(nth 13 #CG_SpecList$)	; �����R�[�h
;-- 2011/11/25 A.Satoh Add - S
        		      (nth 14 #CG_SpecList$)	; �����t���O
;-- 2011/11/25 A.Satoh Add - E
		              (nth 10 #CG_SpecList$)	; �W�J�^�C�v
    		          (nth 11 #CG_SpecList$)	; CAD�i��
        		    )
		          )
    		    )
        		(setq #CG_SpecListA$$ (append #CG_SpecListA$$ #list$))
		      )
    		  (progn
        		(setq #d_cnt (1+ #d_cnt))
		        (cond
    		      ((< #d_cnt 10)
        		    (setq #num_str (strcat "D00" (itoa #d_cnt) "=" (itoa #d_cnt)))
		          )
    		      ((and (> #d_cnt 9) (< #d_cnt 100))
        		    (setq #num_str (strcat "D0" (itoa #d_cnt) "=" (itoa #d_cnt)))
		          )
    		      (T
        		    (setq #num_str (strcat "D" (itoa #d_cnt) "=" (itoa #d_cnt)))
		          )
						)

		        ; ���[�p��񃊃X�g�쐬
    		    (setq #list$
        		  (list
            		(list
		              #num_str
    		          (nth  1 #CG_SpecList$)	; �ŏI�i��
        		      (nth  5 #CG_SpecList$)	; �i��
;-- 2011/11/25 A.Satoh Add - S
        		      (nth  2 #CG_SpecList$)	; ��
        		      (nth  3 #CG_SpecList$)	; ����
        		      (nth  4 #CG_SpecList$)	; ���s
;-- 2011/11/25 A.Satoh Add - E
            		  #kosu										; ��
		              #tanka									; �P��
									(* #kosu #tanka)				; ���z
        		      (nth  9 #CG_SpecList$)	; �W��ID
;									""	; �����R�[�h�i���ݓ������Ή��A�����Ή����ɔ��f�j2011/10/12
									(nth 13 #CG_SpecList$)	; �����R�[�h
;-- 2011/11/25 A.Satoh Add - S
        		      (nth 14 #CG_SpecList$)	; �����t���O
;-- 2011/11/25 A.Satoh Add - E
		              (nth 10 #CG_SpecList$)	; �W�J�^�C�v
    		          (nth 11 #CG_SpecList$)	; CAD�i��
        		    )
		          )
    		    )
        		(setq #CG_SpecListD$$ (append #CG_SpecListD$$ #list$))
		      )
    		)
		  )

			(setq #ret$ (append #CG_SpecListA$$ #CG_SpecListD$$))
		)
		(progn
			(setq #ret$ nil)
		)
	)

	#ret$

) ;CFGetSpecList


;<HOM>*************************************************************************
; <�֐���>    : CFGetBuzaiExpense
; <�����T�v>  : buzai.cfg��[EXPENSE]���ڂ����X�g�ŕԂ�
; <�߂�l>    : Expense���ڃ��X�g or nil
; <�쐬>      : 2011-10-11
; <���l>      :
;*************************************************************************>MOH<
(defun CFGetBuzaiExpense (
  /
	#ret$ #fname #fp #syori #item$
#buf #flag
  )

  (setq #ret$ nil)

  ; buzai.cfg���J��
  (setq #fname (strcat CG_KENMEIDATA_PATH "buzai.cfg"))
  (setq #fp (open #fname "r"))
  (if (/= #fp nil)
    (progn
			; buzai.cfg�̓��e�����X�g�ɓZ�߂�
      (setq #syori nil)
      (setq #ret$ nil)
      (setq #buf T)
      (while #buf
        (setq #buf (read-line #fp))
        (if #buf
          (if (= #syori nil)
            (if (= #buf "[EXPENSE]")
              (setq #syori T)
            )
            (progn
              (setq #item$ (strparse #buf "=")) ;��������f�~���^�ŋ�؂�
              (setq #ret$ (append #ret$ (list #item$)))
            )
          )
        )
      )
      (close #fp)

			; �쐬�������X�g�̓��e���m�F�ɕs������ǉ�����
			;;; "CONSTRUCT_A"��񑶍݃`�F�b�N
			(setq #flag nil)
			(foreach #ret #ret$
				(if (= (nth 0 #ret) "CONSTRUCT_A")
					(setq #flag T)
				)
			)
			(if (= #flag nil)
				(setq #ret$ (append #ret$ (list (list "CONSTRUCT_A" "0"))))
			)

			;;; "FREIGHT_A"��񑶍݃`�F�b�N
			(setq #flag nil)
			(foreach #ret #ret$
				(if (= (nth 0 #ret) "FREIGHT_A")
					(setq #flag T)
				)
			)
			(if (= #flag nil)
				(setq #ret$ (append #ret$ (list (list "FREIGHT_A" "0"))))
			)

			;;; "CONSTRUCT_D"��񑶍݃`�F�b�N
			(setq #flag nil)
			(foreach #ret #ret$
				(if (= (nth 0 #ret) "CONSTRUCT_D")
					(setq #flag T)
				)
			)
			(if (= #flag nil)
				(setq #ret$ (append #ret$ (list (list "CONSTRUCT_D" "0"))))
			)

			;;; "FREIGHT_D"��񑶍݃`�F�b�N
			(setq #flag nil)
			(foreach #ret #ret$
				(if (= (nth 0 #ret) "FREIGHT_D")
					(setq #flag T)
				)
			)
			(if (= #flag nil)
				(setq #ret$ (append #ret$ (list (list "FREIGHT_D" "0"))))
			)
    )
		(progn
			(setq #ret$
				(list
					(list "CONSTRUCT_A" "0")
					(list "FREIGHT_A"   "0")
					(list "CONSTRUCT_D" "0")
					(list "FREIGHT_D"   "0")
				)
			)
		)
  )

  #ret$

);CFGetBuzaiExpense


;<HOM>*************************************************************************
; <�֐���>    : CFGetDoorGrade
; <�����T�v>  : ���ʎQ�l���i�̎Z�o
; <�߂�l>    : ���ʎQ�l���i��񃊃X�g or nil
; <�쐬>      : 2011-10-11
; <���l>      :
;*************************************************************************>MOH<
(defun CFGetDoorGrade (
	&spec$
  /
	#DoorGrade$$ #DoorGrade$ #no_cab$$ #no_cab$ #cab$$ #cab$ #spec$
	#no_cab_kingaku #cab_kingaku #flag
	#qry$ #num #num_str #DoorName #ret$ #err_flag
	#cab_hinban2 ; [���V���ʔ�Ή�����]�e�[�u���Œu����̕i�� 2011/12/22
	#sql
#rec$$ #rec$
  )

  (setq #ret$ nil)
	(setq #err_flag nil)

;-- 2012/03/09 A.Satoh Mod ���O���[�h�ʐώZ�C�� - S
;;;;;	(setq #DoorGrade$$
;;;;;		(list
;;;;;			(list "RS" "H"  "H")
;;;;;			(list "RP" "H"  "H")
;;;;;			(list "RM" "H"  "H")
;;;;;			(list "RJ" "H"  "H")
;;;;;			(list "RF" "H"  "J")
;;;;;			(list "UM" "PV" "L")
;;;;;			(list "UJ" "CG" "L")
;;;;;			(list "UF" "Y"  "G")
;;;;;			(list "XF" "Y"  "G")
;;;;;			(list "XC" "Y"  "G")
;;;;;		)
;;;;;	)
	(setq #DoorGrade$$ nil)
	(setq #rec$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from " "���V���ʐώZ")))
	(if #rec$$
		(foreach #rec$ #rec$$
			(if (= (nth 4 #rec$) "Y")  ; �Ώ�="Y"�ł���ꍇ�ɏ������s��
				(setq #DoorGrade$$
					(append #DoorGrade$$
						(list
							(list
								(nth 1 #rec$)    ; ���V���L��
								(nth 2 #rec$)    ; ���J���L��
								(nth 3 #rec$)    ; ����L��
							)
						)
					)
				)
			)
		)
	)
;-- 2012/03/09 A.Satoh Mod ���O���[�h�ʐώZ�C�� - E

	(setq #no_cab$$ nil)
	(setq #cab$$ nil)

	; ���ނ���ʎQ�l���i�Z�o�ΏۂƔ�Ώۂŕ�����
	; �W�J�^�C�v:(nth 12 #spec$) = 0 ��ΏۂƂ���
	(foreach #spec$ &spec$
;-- 2011/11/25 A.Satoh Mod - S
;;;;;		(if (= (nth 8 #spec$) 0)
		(if (= (nth 12 #spec$) 0)
;-- 2011/11/25 A.Satoh Mod - E
			(setq #cab$$ (append #cab$$ (list #spec$)))
			(setq #no_cab$$ (append #no_cab$$ (list #spec$)))
		)
	)

	; ���������ނ̋��z���v���Z�o����
	(setq #no_cab_kingaku 0)
  (foreach #no_cab$ #no_cab$$
;-- 2011/11/25 A.Satoh Mod - S
;;;;;		(setq #no_cab_kingaku (+ #no_cab_kingaku (nth 5 #no_cab$)))
		(setq #no_cab_kingaku (+ #no_cab_kingaku (nth 8 #no_cab$)))
;-- 2011/11/25 A.Satoh Mod - E
	)

	; �e���O���[�h�ʋ��z�����߂�
	(setq #num 1)
	(foreach #DoorGrade$ #DoorGrade$$
		(if (= #err_flag nil)
			(progn
				(setq #cab_kingaku 0)
				(setq #flag nil)

  			; ��SERIES����
				(setq #qry$ (CFGetDBSQLRec CG_DBSESSION "���V���Y" (list (list "���V���L��" (nth 0 #DoorGrade$) 'STR))))
				(if (= #qry$ nil)
					(progn
	  		  	(CFAlertMsg (strcat "�y���V���Y�z��ں��ނ�����܂��� ���V���L��:" (nth 0 #DoorGrade$)))
						(setq #err_flag T)
					)
					(setq #DoorName (nth 1 (nth 0 #qry$)))
				)

				(if (= #err_flag nil)
					(progn
						(foreach #cab$ #cab$$
							; �i�ԍŏI���̎擾
							(setq #qry$ (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
								(list
									;(list "�ŏI�i��"   (nth 1 #cab$)       'STR)
;-- 2011/11/25 A.Satoh Mod - S
;;;;;									(list "�i�Ԗ���"   (nth 9 #cab$)       'STR)
									(list "�i�Ԗ���"   (nth 13 #cab$)       'STR)
;-- 2011/11/25 A.Satoh Mod - E
									(list "���V���L��" (nth 0 #DoorGrade$) 'STR)
									(list "���J���L��" (nth 1 #DoorGrade$) 'STR)
									(list "����L��"   (nth 2 #DoorGrade$) 'STR)
								)
							))
							(if (= #qry$ nil)
								(progn
									(setq #qry$ (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
										(list
											;(list "�ŏI�i��"   (nth 1 #cab$)       'STR)
;-- 2011/11/25 A.Satoh Mod - S
;;;;;											(list "�i�Ԗ���"   (nth 9 #cab$)       'STR)
											(list "�i�Ԗ���"   (nth 13 #cab$)       'STR)
;-- 2011/11/25 A.Satoh Mod - E
											(list "���V���L��" (nth 0 #DoorGrade$) 'STR)
											(list "���J���L��" (nth 1 #DoorGrade$) 'STR)
										)
									))
;-- �� 2011/12/22 �R�c �ǉ� --------------------------------
; [�i�ԍŏI]�e�[�u���Ɍ�����Ȃ��ꍇ�́A
; [���V���ʔ�Ή�����]�e�[�u�����Q�Ƃ��ĕi�Ԃ�u����
; [�i�ԍŏI]�e�[�u������擾���Ȃ���
                  (if (= #qry$ nil)
                    (progn
                      ; [���V���ʔ�Ή�����]�e�[�u������u����̕i�Ԃ̎擾
;-- 2012/01/30 A.Satoh Mod - S
;;;;;                      (setq #sql (strcat "SELECT �i�Ԗ��� FROM ���V���ʔ�Ή����� "
;;;;;                          "WHERE �L���֎~�t���O='OK' AND ',' + ���V�� + ',' LIKE '%,"
;;;;;                          (nth 0 #DoorGrade$)
;;;;;                          ",%' AND �i�Ԓu��GP=(SELECT �i�Ԓu��GP FROM ���V���ʔ�Ή����� "
;;;;;                          "WHERE �L���֎~�t���O='OK' AND �i�Ԓu��GP IS NOT NULL AND �i�Ԗ���='"
;;;;;                          (nth 13 #cab$) "')" ; �u�i�Ԓu��GP�v�͋󕶎���s�̂���Null�Ŕ���
;;;;;                      ))
                      (setq #sql
                        (strcat "SELECT �i�Ԗ��� FROM ���V���ʔ�Ή����� "
                                "WHERE �L���֎~�t���O='OK' "
                                "AND ',' + ���V�� + ',' LIKE '%," (nth 0 #DoorGrade$) ",%' "
                                "AND ',' + ���J�� + ',' LIKE '%," (nth 1 #DoorGrade$) ",%' "
                                "AND �i�Ԓu��GP=(SELECT �i�Ԓu��GP FROM ���V���ʔ�Ή����� "
                                "WHERE �L���֎~�t���O='OK' AND �i�Ԓu��GP IS NOT NULL AND �i�Ԗ���='"
                                (nth 13 #cab$) "')" ; �u�i�Ԓu��GP�v�͋󕶎���s�̂���Null�Ŕ���
                        )
                      )
;-- 2012/01/30 A.Satoh Mod - E
                      (setq #qry$ (DBSqlAutoQuery CG_DBSESSION #sql))
                      (if (/= #qry$ nil)
                        (progn
                          (setq #cab_hinban2 (nth 0 (nth 0 #qry$)))

                          ; �i�ԍŏI���̎擾
                          (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
                            (list
                              (list "�i�Ԗ���"   #cab_hinban2        'STR)
                              (list "���V���L��" (nth 0 #DoorGrade$) 'STR)
                              (list "���J���L��" (nth 1 #DoorGrade$) 'STR)
                              (list "����L��"   (nth 2 #DoorGrade$) 'STR)
                            )
                          ))
                          (if (= #qry$ nil)
                            (progn
                              (setq #qry$ (CFGetDBSQLRec CG_DBSESSION "�i�ԍŏI"
                                (list
                                  (list "�i�Ԗ���"   #cab_hinban2        'STR)
                                  (list "���V���L��" (nth 0 #DoorGrade$) 'STR)
                                  (list "���J���L��" (nth 1 #DoorGrade$) 'STR)
                                )
                              ))
                            )
                          )
                        )
                      )
                    )
                  )
;-- �� 2011/12/22 �R�c �ǉ� --------------------------------
									(if (= #qry$ nil)
										(progn
;-- 2011/11/25 A.Satoh Mod - S
;;;;;											(setq #cab_kingaku (+ #cab_kingaku (nth 5 #cab$)))
											(setq #cab_kingaku (+ #cab_kingaku (nth 8 #cab$)))
;-- 2011/11/25 A.Satoh Mod - E
											(setq #flag T)
										)
;-- 2011/11/25 A.Satoh Mod - S
;;;;;										(setq #cab_kingaku (+ #cab_kingaku (* (nth 3 #cab$) (nth 8 (car #qry$)))))
										(setq #cab_kingaku (+ #cab_kingaku (* (nth 6 #cab$) (nth 8 (car #qry$)))))
;-- 2011/11/25 A.Satoh Mod - E
									)
								)
;-- 2011/11/25 A.Satoh Mod - S
;;;;;								(setq #cab_kingaku (+ #cab_kingaku (* (nth 3 #cab$) (nth 8 (car #qry$)))))
								(setq #cab_kingaku (+ #cab_kingaku (* (nth 6 #cab$) (nth 8 (car #qry$)))))
;-- 2011/11/25 A.Satoh Mod - E
							)
						)

						(if (< #num 10)
							(setq #num_str (strcat "0" (itoa #num) "="))
							(setq #num_str (strcat (itoa #num) "="))
						)

						(setq #ret$ (append #ret$ (list
							(list
								#num_str 
								(nth 0 #DoorGrade$)
								(nth 1 #DoorGrade$)
								(nth 2 #DoorGrade$)
								#DoorName
								(rtos (+ #no_cab_kingaku #cab_kingaku))
								(if (= #flag T)
									"1"
									"0"
								)
							)
						)))
						(setq #num (1+ #num))
					)
				)
			)
		)
	)

  #ret$

);CFGetDoorGrade
;-- 2011/10/11 A.Satoh Add - E

;-- 2011/10/27 A.Satoh Add - S
;<HOM>*************************************************************************
; <�֐���>    : OutputPresenDlg
; <�����T�v>  : �v���[���{�[�h�o�͐ݒ�_�C�A���O�������s��
; <�߂�l>    : �ݒ��񃊃X�g or nil
; <�쐬>      : 2011/10/27 A.Satoh
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun OutputPresenDlg (
	&door$	; ����񃊃X�g
  /
#PB_TOKUSEI$$ #info$ #err_flag #GBL_TOKUSEI$ #next #dcl_id
#DRSERI$$ #wt_ss #wt_en #xd_WRKT$ #type_f
#HANDLE$$ #Init$ #DRCOL$$
#CG_YUKAIRO$$ #CG_YUKAIRO$ #GBL_CGYukairoGoods$ #CG_YukairoCol$ ;-- 2012/01/18 A.Satoh Add CG�Ή�
#OLD_CG_Y #OLD_CG_N  ;-- 2012/01/25 A.Satoh Add CG�Ή�
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;//******************************************************
		;//
    ;// �}�ʏォ��"G_LSYM"�����}�`�𒊏o���A�w��̐��i�R�[�h
		;// �����i�Ԃ��擾����B
		;// �����擾�����ꍇ�́A�ŏ��̐}�`�݂̂�ΏۂƂ���
		;//
		;//******************************************************
		(defun ##GetHinban (
			&seikaku		; ���m�R�[�h
			/
			#hinban #ss #idx #flag #xd_LSYM$
			)
;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##GetHinban ����������")
			(setq #hinban nil)

			(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
			(if (/= #ss nil)
				(progn
					(setq #idx 0)
					(setq #flag nil)
					(setq #hinban nil)
					(repeat (sslength #ss)
						(if (= #flag nil)
							(progn
								(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
								(if (= (nth 9 #xd_LSYM$) &seikaku)
									(progn
										(setq #flag T)
										(setq #hinban (nth 5 #xd_LSYM$))
									)
								)
							)
						)
						(setq #idx (1+ #idx))
					)
				)
			)

			#hinban

		) ; ##GetHinban


		;//******************************************************
		;//
    ;// �}�ʏォ��"G_LSYM"�����}�`�𒊏o���A�w��̐��i�R�[�h
		;// �����i�Ԃ��u�����v�擾����B
		;//;2018/10/22 YM MOD
		;//******************************************************
		(defun ##GetHinban_HUKU (
			&seikaku		; ���m�R�[�h
			/
			#hinban #ss #idx #flag #xd_LSYM$ #hinban$
			)
;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##GetHinban ����������")
			(setq #hinban nil)

			(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
			(if (/= #ss nil)
				(progn
					(setq #idx 0)
;;;					(setq #flag nil)
					(setq #hinban$ nil)
					(repeat (sslength #ss)
						(if (= #flag nil)
							(progn
								(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
								(if (= (nth 9 #xd_LSYM$) &seikaku)
									(progn
;;;										(setq #flag T)
										(setq #hinban$ (append #hinban$ (list (nth 5 #xd_LSYM$))))
									)
								)
							)
						)
						(setq #idx (1+ #idx))
					)
				)
			)

			#hinban$

		) ; ##GetHinban_HUKU


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// �w��̓���ID�ƕi�Ԃ��Y������t���l���擾����
		;// �擾�ł��Ȃ��ꍇ�́A"NULL"������Ԃ�
		;// ������1�̂ݑΉ�
		;//
		;//******************************************************
		(defun ##GetGyakubukiValue (
			&id			; ����ID
			&jouken	; ����1
			/
			#value #QRY$
			)
;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##GetGyakubukiValue ����������")
			(setq #value nil)

			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB�t��"
					(list
						(list "����ID" &id     'STR)
						(list "����1"  &jouken 'STR)
					)
				)
			)

			(if (= #QRY$ nil)
				(setq #value "NULL")
				(setq #value (nth 5 (nth 0 #QRY$)))
			)

			#value

		) ; ##GetGyakubukiValue


		;//******************************************************
		;//
    ;// �w��̓���ID�ƕi��(����)���Y������t���l���擾����
		;// �擾�ł��Ȃ��ꍇ�́A"NULL"������Ԃ�
		;// ������1�̂ݑΉ�
		;//;2018/10/22 YM MOD
		;//******************************************************
		(defun ##GetGyakubukiValue_HUKU (
			&id			 ; ����ID
			&jouken$ ; ����1
			/
			#value #QRY$
			)
;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##GetGyakubukiValue ����������")
			(setq #value nil)

			(foreach jouken &jouken$
				
				(setq #QRY$
					(CFGetDBSQLRec CG_DBSESSION "PB�t��"
						(list
							(list "����ID" &id    'STR)
							(list "����1"  jouken 'STR)
						)
					)
				)

				(if (/= #QRY$ nil)
					(setq #value (nth 5 (nth 0 #QRY$)))
				);_if

;;;				(if (= #QRY$ nil)
;;;					(setq #value "NULL")
;;;					;else
;;;					(setq #value (nth 5 (nth 0 #QRY$)))
;;;				);_if

			);foreach


			(if (= #value nil)(setq #value "NULL")) ;_if
			
			#value

		) ; ##GetGyakubukiValue_HUKU



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// PB�t���ɂ��A�����l�擾
		;//
		;//******************************************************
		(defun ##GetInitData (
			&xd_WRKT$		; �V���(G_WRKT)
			/
			#ret$ #QRY$ #QRY #oku #oku$ #maguchi$
			#wt_height #value #flag #idx #ss #xd_LSYM$
			#wk_hinban #hinban #hinban2 #hinban$ #hinban2$
			#GLASS$$ #GLASS$ #spec$ #spec$$
			#LR$ #LR #wt_LR #TEN$ #TEN #wt_TEN #PLANINFO$ ;2018/04/27 YK ADD
			)
;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##GetInitData ����������")
			(setq #ret$ nil)

			;;;;; �`��
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB�t��"
					(list
						(list "����ID" "PLAN05" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(progn
					(setq #oku (atoi (nth 2 (car #QRY$))))

					(setq #hinban$ nil)
					(foreach #QRY #QRY$
						(if (/= (nth 3 #QRY) nil)
							(if (= (member (nth 3 #QRY) #hinban$) nil)
								(setq #hinban$ (append #hinban$ (list (nth 3 #QRY))))
							)
						)
					)

					; �}�ʂ���Q�[�g�J�E���^�[������
					(setq #flag nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) #hinban)
													(setq #flag T)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)

					(cond
						((= (nth 3 &xd_WRKT$) 0)		; I�^
							(if (< (nth 0 (nth 57 &xd_WRKT$)) #oku)
								(if (= #flag T)
									(setq #ret$ (append #ret$ (list "G00")))
									(setq #ret$ (append #ret$ (list "I00")))
								)
								(setq #ret$ (append #ret$ (list "IPA")))
							)
						)
						((= (nth 3 &xd_WRKT$) 1)		; L�^
							(if (and (< (nth 0 (nth 57 &xd_WRKT$)) #oku)
											 (< (nth 1 (nth 57 &xd_WRKT$)) #oku))
								(if (= #flag T)
									(setq #ret$ (append #ret$ (list "LG0")))
									(setq #ret$ (append #ret$ (list "L00")))
								)
								(setq #ret$ (append #ret$ (list "LG0")))
							)
						)
						((= (nth 3 &xd_WRKT$) 2)		; U�^
							(setq #ret$ (append #ret$ (list "U00")))
						)
						(T
							(setq #ret$ (append #ret$ (list "NULL")))
						)
					)
				)
			)

			;;;;; ���s��
			(setq #oku$ (nth 57 &xd_WRKT$))
			(cond
				((= (nth 3 &xd_WRKT$) 0)		; I�^
					(setq #QRY$
						(CFGetDBSQLRec CG_DBSESSION "���s"
							(list
								(list "���s" (rtos (nth 0 #oku$)) 'INT)
							)
						)
					)
					(if (= #QRY$ nil)
						(setq #ret$ (append #ret$ (list "NULL")))
						(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
					)
				)
				((= (nth 3 &xd_WRKT$) 1)		; L�^
					(if (equal (nth 0 #oku$) (nth 1 #oku$) 0.001) ;2018/08/06 YM MOD �덷�����e���Ȃ��ƒʂ�Ȃ�
						(progn
							(setq #QRY$
								(CFGetDBSQLRec CG_DBSESSION "���s"
									(list
										(list "���s" (rtos (nth 0 #oku$)) 'INT)
									)
								)
							)
							(if (= #QRY$ nil)
								(setq #ret$ (append #ret$ (list "NULL")))
								(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
							)
						)
						(setq #ret$ (append #ret$ (list "NULL")))
					)
				)
				((= (nth 3 &xd_WRKT$) 2)		; U�^
					(if (and (equal (nth 0 #oku$) (nth 1 #oku$) 0.001)  ;2018/08/06 YM MOD �덷�����e���Ȃ��ƒʂ�Ȃ�
									 (equal (nth 0 #oku$) (nth 2 #oku$) 0.001)) ;2018/08/06 YM MOD �덷�����e���Ȃ��ƒʂ�Ȃ�
						(progn
							(setq #QRY$
								(CFGetDBSQLRec CG_DBSESSION "���s"
									(list
										(list "���s" (rtos (nth 0 #oku$)) 'INT)
									)
								)
							)
							(if (= #QRY$ nil)
								(setq #ret$ (append #ret$ (list "NULL")))
								(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
							)
						)
						(setq #ret$ (append #ret$ (list "NULL")))
					)
				)
				(T
					(setq #ret$ (append #ret$ (list "NULL")))
				)
			)

			;;;;; �L�b�`���Ԍ�
			(setq #maguchi$ (nth 55 &xd_WRKT$))
			(cond
				((= (nth 3 &xd_WRKT$) 0)		; I�^
					(setq #QRY$
						(CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
							(list
								(list "�Ԍ�" (rtos (nth 0 #maguchi$)) 'INT)
							)
						)
					)
					(if (= #QRY$ nil)
						(setq #ret$ (append #ret$ (list "NULL")))
						(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
					)
				)
				((= (nth 3 &xd_WRKT$) 1)		; L�^
					(if (equal (nth 0 #oku$) (nth 1 #oku$) 0.001) ;2018/08/06 YM MOD �덷�����e���Ȃ��ƒʂ�Ȃ�
;;;					(if (= (nth 0 #oku$) (nth 1 #oku$))
						(progn
							(setq #QRY$
								(CFGetDBSQLRec CG_DBSESSION "�Ԍ�"
									(list
										(list "�Ԍ�" (rtos (nth 0 #maguchi$)) 'INT)
									)
								)
							)
							(if (= #QRY$ nil)
								(setq #ret$ (append #ret$ (list "NULL")))
								(setq #ret$ (append #ret$ (list (nth 1 (nth 0 #QRY$)))))
							)
						)
						(setq #ret$ (append #ret$ (list "NULL")))
					)
				)
				((= (nth 3 &xd_WRKT$) 2)		; U�^
					(setq #ret$ (append #ret$ (list "NULL")))
				)
				(T
					(setq #ret$ (append #ret$ (list "NULL")))
				)
			)

			;;;;; ���[�N�g�b�v����
			(setq #wt_height (fix (nth 8 &xd_WRKT$)))
			(setq #value (##GetGyakubukiValue "PLAN31" (itoa #wt_height)))
			(setq #ret$ (append #ret$ (list #value)))

			;;;;; �L���r�l�b�g�v����
			(if (= (nth 35 &xd_WRKT$) nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(setq #ret$ (append #ret$ (list (nth 35 &xd_WRKT$))))
			)

			;;;;; �V���N
			(setq #hinban (##GetHinban 410))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(progn
					(setq #QRY$
						(CFGetDBSQLRec CG_DBSESSION "WT�V���N"
							(list
								(list "�V���N�L��" #hinban 'STR)
							)
						)
					)
					(if (= #QRY$ nil)
						(setq #ret$ (append #ret$ (list "NULL")))
						(setq #ret$ (append #ret$ (list (nth 10 (nth 0 #QRY$)))))
					)
				)
			)

			;;;;; ���[�N�g�b�v�ގ�
			(setq #ret$ (append #ret$ (list (nth 2 &xd_WRKT$))))

			;;;;; �t���A�L���r�^�C�v
			(setq #ret$ (append #ret$ (list "NULL")))


			;2016/04/15 YM ADD ���ڒǉ�@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			;;; �V���N���L���r�l�b�g
			(setq #ret$ (append #ret$ (list "NULL")))
			;2016/04/15 YM ADD ���ڒǉ�@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


			;;;;; �\�t�g�N���[�Y
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB�t��"
					(list
						(list "����ID" "PLAN08" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(progn
					(setq #flag nil)
					(setq #value nil)
					(foreach #QRY #QRY$
						(if (= #flag nil)
							(if (/= (member (nth 0 &door$) (StrParse (nth 2 #QRY) ",")) nil)
								(progn
									(setq #flag T)
									(setq #value (nth 5 #QRY))
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #ret$ (append #ret$ (list "NULL")))
						(setq #ret$ (append #ret$ (list #value)))
					)
				)
			)

			;;;;; �݌ˍ���
			(setq #ret$ (append #ret$ (list "NULL")))

			;;;;; ����
;;;			(setq #hinban$ (##GetHinban 510));2018/10/22 YM MOD
			(setq #hinban$ (##GetHinban_HUKU 510));2018/10/22 YM MOD

			(if (= #hinban$ nil)
				(setq #ret$ (append #ret$ (list "N")))
				(progn
;;;					(setq #value (##GetGyakubukiValue "PLAN19" #hinban));2018/10/22 YM MOD
					(setq #value (##GetGyakubukiValue_HUKU "PLAN19" #hinban$));2018/10/22 YM MOD
					(if (= #value "NULL")
						(setq #value "N")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; �򐅊�
			(setq #ret$ (append #ret$ (list "N")))

			;;;;; ���M�@��
			(setq #hinban (##GetHinban 210))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "N")))
				(progn
					(setq #value (##GetGyakubukiValue "PLAN20" #hinban))
					(if (= #value "NULL")
						(setq #value "N")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; �R�������I�[�u��
			(setq #hinban (##GetHinban 113))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "NULL")))
				(progn
					(setq #flag nil)
					(setq #idx 1)
					(repeat (strlen #hinban)
						(if (= #flag nil)
							(if (= (substr #hinban #idx 1) "$")
								(setq #flag T)
							)
						)
						(setq #idx (1+ #idx))
					)

					(if (= #flag nil)
						(setq #value (##GetGyakubukiValue "PLAN21" #hinban))
						(setq #value "B")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; �H��
			(setq #hinban (##GetHinban 110))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "N")))
				(progn
					(setq #value (##GetGyakubukiValue "PLAN42" #hinban))
					(if (= #value "NULL")
						(setq #value "N")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; �����W�t�[�h
			(setq #hinban (##GetHinban 320))

			(if (= #hinban nil)
				(setq #ret$ (append #ret$ (list "N")))
				(progn
					(setq #value (##GetGyakubukiValue "PLAN23" #hinban))
					(if (= #value "NULL")
						(setq #value "N")
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; �K���X�p�[�e�B�V����
			(setq #GLASS$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �K���X�p�e�B�V����")))
			(if (= #GLASS$$ nil)
				(setq #value "NULL")
				(progn
					; �K���X�p�[�e�B�V�����i�ԃ��X�g���쐬
					(setq #hinban$ nil)
					(foreach #GLASS$ #GLASS$$
						(if (= (member (nth 5 #GLASS$) #hinban$) nil)
							(setq #hinban$ (append #hinban$ (list (nth 5 #GLASS$))))
						)
					)

					; �}�ʂ���K���X�p�[�e�B�V����������
					(setq #flag nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) #hinban)
													(progn
														(setq #flag T)
														(setq #hinban2 #hinban)
													)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value "NULL")
						(setq #value (##GetGyakubukiValue "PLAN44" #hinban2))
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)

			;;;;; �L�b�`���p�l��
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB�t��"
					(list
						(list "����ID" "PLAN47" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #value "N")
				(progn
					; �L�b�`���p�l���i�ԃ��X�g���쐬
					(setq #hinban$ nil)
					(foreach #QRY #QRY$
						(if (= (member (nth 2 #QRY) #hinban$) nil)
							(setq #hinban$ (append #hinban$ (list (list (nth 2 #QRY) (nth 5 #QRY)))))
						)
					)

					; �}�ʂ���L�b�`���p�l��������
					(setq #flag nil)
					(setq #hinban2 nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) (car #hinban))
													(progn
														(setq #wk_hinban #hinban)
														(setq #flag T)
													)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)
					(if (= #flag nil)
					  (if (findfile (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
					    (progn
								(setq #hinban2$ nil)
					      (setq #spec$$ (ReadCSVFile (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg")))
					      (if #spec$$
					        (foreach #spec$ #spec$$
					          (setq #hinban2$ (append #hinban2$ (list (nth 0 (StrParse (nth 0 #spec$) "=")))))
									)
								)
								(foreach #hinban #hinban$
									(if (= #flag nil)
										(foreach #hinban2 #hinban2$
											(if (= #flag nil)
												(if (= (car #hinban) #hinban2)
													(progn
														(setq #wk_hinban #hinban)
														(setq #flag T)
													)
												)
											)
										)
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value "N")
						(setq #value (nth 1 #wk_hinban))
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)


			;���E���� 2018/04/27 YK ADD-S
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB�t��"
					(list
						(list "����ID" "PLAN11" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #value "NULL")
				(progn
					(setq #LR nil)
					(foreach #QRY #QRY$
						(if (= (member (nth 2 #QRY) #LR$) nil)
							(setq #LR$ (append #LR$ (list (list (nth 2 #QRY) (nth 5 #QRY)))))
						)
					)

					(setq #flag nil)
					(setq #ss (ssget "X" '((-3 ("G_WRKT")))))
					(if (/= #ss nil)
						(foreach #LR #LR$
							(if (= #flag nil)
								(progn
									(if (= (nth 30 &xd_WRKT$) (car #LR))
										(progn
											(setq #wk_LR #LR)
											(setq #flag T)
										)
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value "NULL")
						(setq #value (nth 0 #wk_LR))
					)
					(setq #ret$ (append #ret$ (list #value)))
				)
			)
			;���E���� 2018/04/27 YK ADD-E



			;�V�䍂�� 2018/04/27 YK ADD-S
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB�t��"
					(list
						(list "����ID" "PLAN48" 'STR)
					)
				)
			)
			(setq #wk_TEN "NULL")

  		; ���݂̃v�������(PLANINFO.CFG)��ǂݍ���
  		(setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))

  		(if (assoc "CeilingHeight" #PLANINFO$)
    		(setq #value (nth 1 (assoc "CeilingHeight" #PLANINFO$)))
  		);_if

			(setq #flag nil)

			(foreach #QRY #QRY$
				(if (= #flag nil)
					(progn
						(if (= (nth 2 #QRY) #value)
							(progn
								(setq #wk_TEN #value)
								(setq #flag T)
							)
						)
					)
				)
			)
			(setq #ret$ (append #ret$ (list #wk_TEN)))
			;�V�䍂�� 2018/04/27 YK ADD-E

			#ret$

		) ; ##GetInitData

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// ���O���[�h�̑I���������s��
		;//
		;//******************************************************
		(defun ##SelDoorSeries (
			/
			;;; #DRSERI$$ #DRCOL$$�̓��[�J����`���Ȃ�
			#seri #Qry$$ #Qry$ #Q$ #sQ #i #no
			)

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##SelDoorSeries ����������")

			(setq #seri (nth 0 (nth (atoi (get_tile "drseri")) #DRSERI$$)))
			;;; (�V���L��   ���V���L��   ���J���L��) �̃��X�g�擾
			(setq #DRCOL$$
				(CFGetDBSQLRec CG_DBSESSION "���V�Ǘ�"
					(list
						(list "���V���L��" #seri 'STR)
					)
				)
			)

			;;; SG_DRCOL$$�ɔ��J�����̂𑫂�
			(setq #Qry$$ nil)
			(foreach #Qry$ #DRCOL$$
				(setq #Q$
					(car (CFGetDBSQLRec CG_DBSESSION "��COLOR"
						(list
							(list "���J���L��"   (nth 1 #Qry$) 'STR)
						)
					))
				)

				(if #Q$
					(progn
						(setq #sQ (nth 1 #Q$))
						(setq #Qry$$ (append #Qry$$ (list (append #Qry$ (list #sQ)))))
					)
				)
			)

			(setq #DRCOL$$ #Qry$$)

			(if (not #DRCOL$$)
				(progn
					(mode_tile "drseri" 2)
					(start_list "drcol" 3)
					(add_list "")
					(end_list)
					(mode_tile "drcol" 1)
					(mode_tile "accept" 1)
					(set_tile "error" "��COLOR���l���ł��܂���ł����B")
				)
				(progn
					(start_list "drcol" 3)
					(setq #i 0 #no 0)

					(foreach #Qry$ #DRCOL$$
						(add_list (nth 2 #Qry$))
						(if (= (nth 1 &door$) (nth 1 #Qry$))
							(setq #no #i)
						)
						(setq #i (1+ #i))
					)
					(end_list)
					(set_tile "error" "")
					(set_tile "drcol" (itoa #no))
					(mode_tile "drcol" 0)
					(mode_tile "accept" 0)
				)
			)

			(##SelDoorHandle)

		) ; ##SelDoorSeries

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// ���I�����̕ύX���s��
		;//
		;//******************************************************
		(defun ##SelDoorHandle (
			/
			;;; #DRCOL$$ #HANDLE$$�̓��[�J����`���Ȃ�
			#col$ #dr_seri #col #i #no #Qry$
			)

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##SelDoorHandle ����������")

			; ���I����------------------------------------------
			(setq #col$ (nth (atoi (get_tile "drcol")) #DRCOL$$))
			(setq #dr_seri (nth 0 #col$))
			(setq #col (nth 1 #col$))

			(setq #HANDLE$$
				(CFGetDBSQLRec CG_DBSESSION "����Ǘ�"
					(list
						(list "���V���L��"  #dr_seri  'STR)
						(list "���J���L��"  #col      'STR)
					)
				)
			)
			(start_list "handle" 3)
			(setq #i 0 #no 0)

			(foreach #Qry$ #HANDLE$$
				(add_list (strcat "(" (nth 3 #Qry$) ") " (nth 4 #Qry$)))
				(if (= (nth 2 &door$) (nth 3 #Qry$))
					(setq #no #i)
				)
				(setq #i (1+ #i))
			)
			(end_list)
			(set_tile "error" "")
			(set_tile "handle" (itoa #no))
			(mode_tile "handle" 0)
			(mode_tile "accept" 0)

		); ##SelDoorHandle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// CG���d�l�F���i���̑I�����������s��
		;// �@CG���d�l�F�F�����X�g�̐ݒ�A���X�g�̗L����
		;//
		;//******************************************************
		(defun ##SelCG_Goods (
			/
			;;; #CG_YUKAIRO$$ #CG_YukairoCol$�̓��[�J����`���Ȃ�
			#sel_no #goods_type #yukairo$ #flr_col$
			)

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##SelCG_Goods ����������")

			(setq #sel_no (atoi (get_tile "goods")))
			(setq #goods_type (nth 1 (nth #sel_no #GBL_CGYukairoGoods$)))

			(setq #CG_YukairoCol$ nil)
			(foreach #yukairo$ #CG_YUKAIRO$$
				(if (= #goods_type (nth 2 #yukairo$))
					(setq #CG_YukairoCol$
						(append #CG_YukairoCol$
							(list
								(list
									(nth 3 #yukairo$)
									(nth 4 #yukairo$)
									(nth 5 #yukairo$)
								)
							)
						)
					)
				)
			)

			(if #CG_YukairoCol$
				(progn
					(start_list "flr_col" 3)
					(foreach #flr_col$ #CG_YukairoCol$
						(add_list (nth 0 #flr_col$))
					)
					(end_list)

					(set_tile "flr_col" "0")
					(mode_tile "flr_col" 0)

					(mode_tile "accept" 0)
				)
				(progn
					(start_list "flr_col" 3)
					(add_list "")
					(end_list)
					(mode_tile "flr_col" 1)

					(mode_tile "accept" 1)
				)
			)

		) ; ##SelCG_Goods

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// �v���_�E�����X�g�̏����ݒ���s��
		;//
		;//******************************************************
    (defun ##GetDefIndex(
			&PLAN$$
			&value
			/
			#def #idx #flag
			)

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##GetDefIndex ����������")

			; �f�t�H���g�ݒ�
      (setq #idx 0)
			(setq #flag nil)
			(setq #def 0)
			(repeat (length &PLAN$$)
				(if (= #flag nil)
					(if (= (nth 2 (nth #idx &PLAN$$)) &value)
						(progn
							(setq #flag T)
							(setq #def #idx)
						)
					)
				)
    		(setq #idx (1+ #idx))
   		)

			#def

		)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// �v���_�E�����X�g�̏����ݒ���s��
		;//
		;//******************************************************
    (defun ##ResetInitInfo(
			&type_f	; �H��t���O�@T:�L�b�`�� nil:���[
			&Init$	; �����l���X�g
      /
			#i #no #Qry$ #def
			#plan05$$ #plan07$$ #plan04$$ #plan31$$ #plan02$$ #plan17$$
			#plan16$$ #plan06$$ #plan08$$ #plan32$$ #plan19$$ #plan22$$
			#plan20$$ #plan21$$ #plan42$$ #plan23$$ #plan44$$ #plan47$$
			#goods$ ;-- 2012/01/18 A.Satoh Add CG�Ή�
			#PLAN15$$ ;2016/04/15 YM ADD
			#plan11$$ ;2018/04/26 YK ADD
			#plan48$$ ;2018/04/26 YK ADD
      )

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##ResetInitInfo ����������")

      ; ���֘A
      (start_list "drseri" 3)
      (setq #i 0 #no 0)
      (foreach #Qry$ #DRSERI$$
        (add_list (nth 1 #Qry$))

        (if (= (nth 0 &door$) (nth 0 #Qry$))
          (setq #no #i)
        )
        (setq #i (1+ #i))
      )
      (end_list)

      (set_tile "drseri" (itoa #no))
      (##SelDoorSeries)

			(setq #plan05$$ (nth  0 #GBL_TOKUSEI$))	; �`��
			(setq #plan07$$ (nth  1 #GBL_TOKUSEI$))	; ���s��
			(setq #plan04$$ (nth  2 #GBL_TOKUSEI$))	; �L�b�`���Ԍ�
			(setq #plan31$$ (nth  3 #GBL_TOKUSEI$))	; ���[�N�g�b�v����
			(setq #plan02$$ (nth  4 #GBL_TOKUSEI$))	; �L���r�l�b�g�v����
			(setq #plan17$$ (nth  5 #GBL_TOKUSEI$))	; �V���N
			(setq #plan16$$ (nth  6 #GBL_TOKUSEI$))	; ���[�N�g�b�v�ގ�
			(setq #plan06$$ (nth  7 #GBL_TOKUSEI$))	; �t���A�L���r�^�C�v
			(setq #plan08$$ (nth  8 #GBL_TOKUSEI$))	; �\�t�g�N���[�Y
			(setq #plan32$$ (nth  9 #GBL_TOKUSEI$))	; �݌ˍ���
			(setq	#plan19$$ (nth 10 #GBL_TOKUSEI$))	; ����
			(setq #plan22$$ (nth 11 #GBL_TOKUSEI$))	; �򐅊�
			(setq #plan20$$ (nth 12 #GBL_TOKUSEI$))	; ���M�@��
			(setq #plan21$$ (nth 13 #GBL_TOKUSEI$))	; �R�������I�[�u��
			(setq #plan42$$ (nth 14 #GBL_TOKUSEI$))	; �H��
			(setq #plan23$$ (nth 15 #GBL_TOKUSEI$))	; �����W�t�[�h
			(setq #plan44$$ (nth 16 #GBL_TOKUSEI$))	; �K���X�p�[�e�B�V����
			(setq #plan47$$ (nth 17 #GBL_TOKUSEI$))	; �L�b�`���p�l��

			;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			(setq #plan15$$ (nth 18 #GBL_TOKUSEI$))	; �V���N���L���r�l�b�g
			;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

			;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			(setq #plan11$$ (nth 19 #GBL_TOKUSEI$))	; ���E����
			(setq #plan48$$ (nth 20 #GBL_TOKUSEI$))	; �V�䍂��
			;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


      ; �`��
      (start_list "type" 3)
      (foreach #plan05$ #plan05$$
        (add_list (nth 1 #plan05$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan05$$ (nth 0 &Init$)))
		      (set_tile "type" (itoa #def))
					(mode_tile "type" 0)
				)
				(progn
		      (set_tile "type" "0")
					(mode_tile "type" 1)
				)
			)

      ; ���s��
      (start_list "deep" 3)
      (foreach #plan07$ #plan07$$
        (add_list (nth 1 #plan07$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan07$$ (nth 1 &Init$)))
		      (set_tile "deep" (itoa #def))
					(mode_tile "deep" 0)
				)
				(progn
		      (set_tile "deep" "0")
					(mode_tile "deep" 1)
				)
			)

      ; �L�b�`���Ԍ�
      (start_list "maguchi" 3)
      (foreach #plan04$ #plan04$$
        (add_list (nth 1 #plan04$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan04$$ (nth 2 &Init$)))
		      (set_tile "maguchi" (itoa #def))
					(mode_tile "maguchi" 0)
				)
				(progn
		      (set_tile "maguchi" "0")
					(mode_tile "maguchi" 1)
				)
			)

      ; ���[�N�g�b�v����
      (start_list "wtheight" 3)
      (foreach #plan31$ #plan31$$
        (add_list (nth 1 #plan31$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan31$$ (nth 3 &Init$)))
		      (set_tile "wtheight" (itoa #def))
					(mode_tile "wtheight" 0)
				)
				(progn
		      (set_tile "wtheight" "0")
					(mode_tile "wtheight" 1)
				)
			)

      ; �L���r�l�b�g�v����
      (start_list "cab_plan" 3)
      (foreach #plan02$ #plan02$$
        (add_list (nth 1 #plan02$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan02$$ (nth 4 &Init$)))
		      (set_tile "cab_plan" (itoa #def))
					(mode_tile "cab_plan" 0)
				)
				(progn
		      (set_tile "cab_plan" "0")
					(mode_tile "cab_plan" 1)
				)
			)

      ; �V���N
      (start_list "sink" 3)
      (foreach #plan17$ #plan17$$
        (add_list (nth 1 #plan17$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan17$$ (nth 5 &Init$)))
		      (set_tile "sink" (itoa #def))
					(mode_tile "sink" 0)
				)
				(progn
		      (set_tile "sink" "0")
					(mode_tile "sink" 1)
				)
			)

      ; ���[�N�g�b�v�ގ�
      (start_list "wt_zai" 3)
      (foreach #plan16$ #plan16$$
        (add_list (nth 1 #plan16$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan16$$ (nth 6 &Init$)))
		      (set_tile "wt_zai" (itoa #def))
					(mode_tile "wt_zai" 0)
				)
				(progn
		      (set_tile "wt_zai" "0")
					(mode_tile "wt_zai" 1)
				)
			)

      ; �t���A�L���r�^�C�v
      (start_list "floor_cab" 3)
      (foreach #plan06$ #plan06$$
        (add_list (nth 1 #plan06$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan06$$ (nth 7 &Init$)))
		      (set_tile "floor_cab" (itoa #def))
					(mode_tile "floor_cab" 0)
				)
				(progn
		      (set_tile "floor_cab" "0")
					(mode_tile "floor_cab" 1)
				)
			)



;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      ; �V���N���L���r�l�b�g
      (start_list "sinkunder_cab" 3)
      (foreach #plan15$ #plan15$$
        (add_list (nth 1 #plan15$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan15$$ (nth 8 &Init$)))
		      (set_tile "sinkunder_cab" (itoa #def))
					(mode_tile "sinkunder_cab" 0)
				)
				(progn
		      (set_tile "sinkunder_cab" "0")
					(mode_tile "sinkunder_cab" 1)
				)
			)
;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



      ; �\�t�g�N���[�Y
      (start_list "soft_close" 3)
      (foreach #plan08$ #plan08$$
        (add_list (nth 1 #plan08$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan08$$ (nth 9 &Init$)))
		      (set_tile "soft_close" (itoa #def))
					(mode_tile "soft_close" 0)
				)
				(progn
		      (set_tile "soft_close" "0")
					(mode_tile "soft_close" 1)
				)
			)

      ; �݌ˍ���
      (start_list "wool_height" 3)
      (foreach #plan32$ #plan32$$
        (add_list (nth 1 #plan32$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan32$$ (nth 10 &Init$)))
		      (set_tile "wool_height" (itoa #def))
					(mode_tile "wool_height" 0)
				)
				(progn
		      (set_tile "wool_height" "0")
					(mode_tile "wool_height" 1)
				)
			)

      ; ����
      (start_list "water" 3)
      (foreach #plan19$ #plan19$$
        (add_list (nth 1 #plan19$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan19$$ (nth 11 &Init$)))
		      (set_tile "water" (itoa #def))
					(mode_tile "water" 0)
				)
				(progn
		      (set_tile "water" "0")
					(mode_tile "water" 1)
				)
			)

      ; �򐅊�
;-- 2011/10/29 �����_�ł́A�򐅊�͑I��t��
;|
      (start_list "josui" 3)
      (foreach #plan22$ #plan22$$
        (add_list (nth 1 #plan22$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan22$$ (nth 11 &Init$)))
		      (set_tile "josui" (itoa #def))
					(mode_tile "josui" 0)
				)
				(progn
		      (set_tile "josui" "0")
					(mode_tile "josui" 1)
				)
			)
|;
      (set_tile "josui" "0")
			(mode_tile "josui" 1)

      ; ���M�@��
      (start_list "conro" 3)
      (foreach #plan20$ #plan20$$
        (add_list (nth 1 #plan20$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan20$$ (nth 13 &Init$)))
		      (set_tile "conro" (itoa #def))
					(mode_tile "conro" 0)
				)
				(progn
		      (set_tile "conro" "0")
					(mode_tile "conro" 1)
				)
			)

      ; �R�������I�[�u��
      (start_list "oven" 3)
      (foreach #plan21$ #plan21$$
        (add_list (nth 1 #plan21$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan21$$ (nth 14 &Init$)))
		      (set_tile "oven" (itoa #def))
					(mode_tile "oven" 0)
				)
				(progn
		      (set_tile "oven" "0")
					(mode_tile "oven" 1)
				)
			)

      ; �H��
      (start_list "syokusen" 3)
      (foreach #plan42$ #plan42$$
        (add_list (nth 1 #plan42$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan42$$ (nth 15 &Init$)))
		      (set_tile "syokusen" (itoa #def))
					(mode_tile "syokusen" 0)
				)
				(progn
		      (set_tile "syokusen" "0")
					(mode_tile "syokusen" 1)
				)
			)

      ; �����W�t�[�h
      (start_list "rennji" 3)
      (foreach #plan23$ #plan23$$
        (add_list (nth 1 #plan23$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan23$$ (nth 16 &Init$)))
		      (set_tile "rennji" (itoa #def))
					(mode_tile "rennji" 0)
				)
				(progn
		      (set_tile "rennji" "0")
					(mode_tile "rennji" 1)
				)
			)

      ; �K���X�p�[�e�B�V����
      (start_list "glass" 3)
      (foreach #plan44$ #plan44$$
        (add_list (nth 1 #plan44$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan44$$ (nth 17 &Init$)))
		      (set_tile "glass" (itoa #def))
					(mode_tile "glass" 0)
				)
				(progn
		      (set_tile "glass" "0")
					(mode_tile "glass" 1)
				)
			)

      ; �L�b�`���p�l��
;      (start_list "panel" 3)
;      (foreach #plan47$ #plan47$$
;        (add_list (nth 1 #plan47$))
;      )
;      (end_list)
			(if (= &type_f T)
				(progn
		      (start_list "panel" 3)
    		  (foreach #plan47$ #plan47$$
        		(add_list (nth 1 #plan47$))
		      )
    		  (end_list)

					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan47$$ (nth 18 &Init$)))
		      (set_tile "panel" (itoa #def))
					(mode_tile "panel" 0)
				)
				(progn
		      (start_list "panel" 3)
       		(add_list "")
    		  (end_list)

		      (set_tile "panel" "0")
					(mode_tile "panel" 1)
				)
			)

			;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      ; ���E����
      (start_list "sayu_katte" 3)
      (foreach #plan11$ #plan11$$
        (add_list (nth 1 #plan11$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan11$$ (nth 19 &Init$)))
		      (set_tile "sayu_katte" (itoa #def))
					(mode_tile "sayu_katte" 0)
				)
				(progn
		      (set_tile "sayu_katte" "0")
					(mode_tile "sayu_katte" 1)
				)
			)

      ; �V�䍂��
      (start_list "tenjo_height" 3)
      (foreach #plan48$ #plan48$$
        (add_list (nth 1 #plan48$))
      )
      (end_list)
			(if (= &type_f T)
				(progn
					; �f�t�H���g�ݒ�
					(setq #def (##GetDefIndex #plan48$$ (nth 20 &Init$)))
		      (set_tile "tenjo_height" (itoa #def))
					(mode_tile "tenjo_height" 0)
				)
				(progn
		      (set_tile "tenjo_height" "0")
					(mode_tile "tenjo_height" 1)
				)
			)
			;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;-- 2012/01/18 A.Satoh Add CG�Ή� - S
			; ���i��
      (start_list "goods" 3)
;;;;;      (foreach #goods$ #GBL_CGYukairoGoods$
;;;;;        (add_list (nth 0 #goods$))
;;;;;      )
			(add_list "")
      (end_list)
			(set_tile "goods" "0")
;;;;;			(mode_tile "goods" 0)
			(mode_tile "goods" 1)

			(start_list "flr_col" 3)
			(add_list "")
			(end_list)
			(set_tile "flr_col" "0")
			(mode_tile "flr_col" 1)

;-- 2012/03/05 A.Satoh Add CG�w�i�F���Ή� - S
			(set_tile "all_white" "0")
			(mode_tile "all_white" 1)
;-- 2012/03/05 A.Satoh Add CG�w�i�F���Ή� - E

			(mode_tile "accept" 1)
;-- 2012/01/18 A.Satoh Add CG�Ή� - S

    ) ; ##ResetInitInfo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// �擾����PB�����l��񂩂�����l�ʏ�񃊃X�g���쐬����
		;//
		;//******************************************************
    (defun ##GetPBTokusei(
			&PB_TOKUSEI$$
      /
			#PB_TOKUSEI$ #ret$ #name
			#plan05$ #plan07$ #plan04$ #plan31$ #plan02$ #plan17$
			#plan16$ #plan06$ #plan08$ #plan19$ #plan22$ #plan20$
			#plan21$ #plan44$ #plan42$ #plan32$ #plan23$ #plan47$
			#plan15$ ;2016/04/15 YM ADD
			#plan11$ ;2018/04/26 YK ADD
			#plan48$ ;2018/04/26 YK ADD
      )

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##GetPBTokusei ����������")

			(setq #plan05$ nil #plan07$ nil #plan04$ nil #plan31$ nil #plan02$ nil #plan17$ nil)
			(setq #plan16$ nil #plan06$ nil #plan08$ nil #plan19$ nil #plan22$ nil #plan20$ nil)
			(setq #plan21$ nil #plan44$ nil #plan42$ nil #plan32$ nil #plan23$ nil #plan47$ nil)
			;2016/04/15 YM ADD-S
			(setq #plan15$ nil)
			;2016/04/15 YM ADD-E

			;2018/04/26 YK ADD-S
			(setq #plan11$ nil)
			(setq #plan48$ nil)
			;2018/04/26 YK ADD-E

;;;(princ "\n =============================")
;;;(princ "\n &PB_TOKUSEI$$=")
;;;(princ &PB_TOKUSEI$$)
;;;(princ "\n =============================")

			(foreach #PB_TOKUSEI$ &PB_TOKUSEI$$
				(if (= (nth 3 #PB_TOKUSEI$) nil)
					(setq #name "")
					(setq #name (nth 3 #PB_TOKUSEI$))
				)

				(cond
					((= (nth 1 #PB_TOKUSEI$) "PLAN05")	; �`��
						(setq #plan05$ (append #plan05$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN07")	; ���s��
						(setq #plan07$ (append #plan07$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN04")	; �L�b�`���Ԍ�
						(setq #plan04$ (append #plan04$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN31")	; ���[�N�g�b�v����
						(setq #plan31$ (append #plan31$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN02")	; �L���r�l�b�g�v����
						(setq #plan02$ (append #plan02$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN17")	; �V���N
						(setq #plan17$ (append #plan17$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN16")	; ���[�N�g�b�v�ގ�
						(setq #plan16$ (append #plan16$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN06")	; �t���A�L���r�^�C�v
						(setq #plan06$ (append #plan06$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN08")	; �\�t�g�N���[�Y
						(setq #plan08$ (append #plan08$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN32")	; �݌ˍ���
						(setq #plan32$ (append #plan32$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN19")	; ����
						(setq #plan19$ (append #plan19$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN22")	; �򐅊�
						(setq #plan22$ (append #plan22$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN20")	; ���M�@��
						(setq #plan20$ (append #plan20$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN21")	; �R�������I�[�u��
						(setq #plan21$ (append #plan21$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN42")	; �H��
						(setq #plan42$ (append #plan42$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN23")	; �����W�t�[�h
						(setq #plan23$ (append #plan23$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN44")	; �K���X�p�[�e�B�V����
						(setq #plan44$ (append #plan44$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN47")	; �L�b�`���p�l��
						(setq #plan47$ (append #plan47$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					((= (nth 1 #PB_TOKUSEI$) "PLAN15")	; �V���N���L���r�l�b�g
						(setq #plan15$ (append #plan15$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					((= (nth 1 #PB_TOKUSEI$) "PLAN11")	; ���E����
						(setq #plan11$ (append #plan11$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					((= (nth 1 #PB_TOKUSEI$) "PLAN48")	; �V�䍂��
						(setq #plan48$ (append #plan48$ (list (list (nth 1 #PB_TOKUSEI$) #name (nth 4 #PB_TOKUSEI$)))))
					)
					;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
				)
			)

			(setq #ret$
				(list
					#plan05$	; �`��
					#plan07$	; ���s��
					#plan04$	; �L�b�`���Ԍ�
					#plan31$	; ���[�N�g�b�v����
					#plan02$	; �L���r�l�b�g�v����
					#plan17$	; �V���N
					#plan16$	; ���[�N�g�b�v�ގ�
					#plan06$	; �t���A�L���r�^�C�v
					#plan08$	; �\�t�g�N���[�Y
					#plan32$	; �݌ˍ���
					#plan19$	; ����
					#plan22$	; �򐅊�
					#plan20$	; ���M�@��
					#plan21$	; �R�������I�[�u��
					#plan42$	; �H��
					#plan23$	; �����W�t�[�h
					#plan44$	; �K���X�p�[�e�B�V����
					#plan47$	; �L�b�`���p�l��
					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					#plan15$	; �V���N���L���r�l�b�g
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					#plan11$	; ���E����
					#plan48$	; �V�䍂��
					;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
				)
			)

      #ret$
    ) ; ##GetPBTokusei

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2012/01/25 A.Satoh Add - S
		;//******************************************************
		;//
    ;// CG�L���̃��W�I�{�^���I�����̏����i�����X�g�̊�����
		;// �񊈐������s��
		;//
		;//******************************************************
    (defun ##SetInitCG_List(
      /
			#cg_y #cg_n #goods$
      )

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##SetInitCG_List ����������")

			(setq #cg_y (get_tile "cg_y"))
			(setq #cg_n (get_tile "cg_n"))

			(if (or (/= #OLD_CG_Y #cg_y) (/= #OLD_CG_N #cg_n))
				(progn
					(setq #OLD_CG_Y #cg_y)
					(setq #OLD_CG_N #cg_n)

					(if (= #cg_y "1")
						(progn
							; ���i��
    				  (start_list "goods" 3)
		    		  (foreach #goods$ #GBL_CGYukairoGoods$
    		  		  (add_list (nth 0 #goods$))
		      		)
				      (end_list)
							(set_tile "goods" "0")
							(mode_tile "goods" 0)

							; ���F��
							(setq #CG_YukairoCol$ nil)

							(start_list "flr_col" 3)
							(add_list "")
							(end_list)
							(set_tile "flr_col" "0")
							(mode_tile "flr_col" 1)

;-- 2012/03/05 A.Satoh Add CG�w�i�F���Ή� - S
							(mode_tile "all_white" 0)
;-- 2012/03/05 A.Satoh Add CG�w�i�F���Ή� - E

							(mode_tile "accept" 1)
						)
						(progn
							(setq #CG_YukairoCol$ nil)

			    	  (start_list "goods" 3)
							(add_list "")
			  	    (end_list)
							(set_tile "goods" "0")
							(mode_tile "goods" 1)

							(start_list "flr_col" 3)
							(add_list "")
							(end_list)
							(set_tile "flr_col" "0")
							(mode_tile "flr_col" 1)

;-- 2012/03/05 A.Satoh Add CG�w�i�F���Ή� - S
							(set_tile "all_white" "0")
							(mode_tile "all_white" 1)
;-- 2012/03/05 A.Satoh Add CG�w�i�F���Ή� - E

							(mode_tile "accept" 0)
						)
					)
				)
			)

    ) ; ##SetInitCG_List
;-- 2012/01/25 A.Satoh Add - E

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-- 2012/03/05 A.Satoh Add - S
		;//******************************************************
		;//
    ;// �u�w�i�F���v�`�F�b�N�I�����̏����i�����X�g�̊�����
		;// �񊈐������s��
		;//
		;//******************************************************
    (defun ##SetAllWhite(
      /
			#goods$ #all_white
      )

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##SetAllWhite ����������")

			(setq #all_white (get_tile "all_white"))

			(if (= #all_white "1")
				(progn
					(setq #CG_YukairoCol$ nil)

	    	  (start_list "goods" 3)
					(add_list "")
	  	    (end_list)
					(set_tile "goods" "0")
					(mode_tile "goods" 1)

					(start_list "flr_col" 3)
					(add_list "")
					(end_list)
					(set_tile "flr_col" "0")
					(mode_tile "flr_col" 1)

					; �n�j�{�^��������
					(mode_tile "accept" 0)
				)
				(progn
					; ���i��
 				  (start_list "goods" 3)
    		  (foreach #goods$ #GBL_CGYukairoGoods$
 		  		  (add_list (nth 0 #goods$))
      		)
		      (end_list)
					(set_tile "goods" "0")
					(mode_tile "goods" 0)

					; ���F��
					(setq #CG_YukairoCol$ nil)

					(start_list "flr_col" 3)
					(add_list "")
					(end_list)
					(set_tile "flr_col" "0")
					(mode_tile "flr_col" 1)

					; �n�j�{�^���񊈐���
					(mode_tile "accept" 1)
				)
			)

    ) ; ##SetAllWhite
;-- 2012/03/05 A.Satoh Add - E

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;//******************************************************
		;//
    ;// �n�j�������ꂽ
		;//
		;//******************************************************
    (defun ##SetPresenInfo_CallBack(
      /
;;; #GBL_TOKUSEI$�̓��[�J����`���Ȃ�
			#ret$
			#plan05$$ #plan07$$ #plan04$$ #plan31$$ #plan02$$ #plan17$$
			#plan16$$ #plan06$$ #plan08$$ #plan32$$ #plan19$$ #plan22$$
			#plan20$$ #plan21$$ #plan42$$ #plan23$$ #plan44$$ #plan47$$
			#err_flag #cg_y #goods #flrcol #flr_col$
#file$ ;-- 2012/02/29 A.Satoh Add
#allWhite ;-- 2012/03/05 A.Satoh Add
 			#plan11$$ #plan48$$ ;-- 2018/04/26 YK Add
     )

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##SetPresenInfo_CallBack ����������")

;-- 2012/01/25 A.Satoh Add CG�Ή� - S
			(setq #err_flag nil)

			; CG�d�l�̓��͊m�F
			(setq #cg_y (get_tile "cg_y"))
			(setq #goods (get_tile "goods"))
;-- 2012/03/05 A.Satoh Mod - S
			(setq #allWhite (get_tile "all_white"))
;-- 2012/03/05 A.Satoh Mod - E

;-- 2012/03/05 A.Satoh Mod - S
;;;;;			(if (and (= #cg_y "1") (= (atoi (get_tile "goods")) 0))
			(if (and (= #cg_y "1") (= #allWhite "0") (= (atoi (get_tile "goods")) 0))
;-- 2012/03/05 A.Satoh Mod - E
				(progn
					(set_tile "error" "�����i�����I������Ă��܂���")
					(mode_tile "goods" 2)
					(setq #err_flag T)
				)
			)
;-- 2012/01/25 A.Satoh Add CG�Ή� - E

;-- 2012/02/29 A.Satoh Add - S
			(if (= #err_flag nil)
				(if (= #cg_y "1")
					(progn
						; �uCG����v�ł���ꍇ�A�p�[�X�}�ʂ̑��݃`�F�b�N���s��
						(setq #file$ (vl-directory-files (strcat CG_KENMEI_PATH "OUTPUT") "*����*.dwg"))
						(if (= #file$ nil)
							(progn
								;;; �uMB_ICONASTERISK�v�́uMB_ICONINFORMATION�v�Ɠ���
								;;; KPCAD�ł́uMB_ICONINFORMATION�v�̑���ɁuMB_ICONASTERISK�v���g�p����B
								(c:msgbox "CG����̏ꍇ�A�K��CG�p�̃p�[�X�}�ʂ��쐬����悤�ɂ��ĉ������B" "���" (logior MB_OK MB_ICONASTERISK))
								(setq #err_flag T)
							)
						)
					)
				)
			)
;-- 2012/02/29 A.Satoh Add - E

;;;(princ "\n�����������@2016/09/07 CHECK WRITE ##SetPresenInfo_CallBack #GBL_TOKUSEI$ ����������")
;;;(princ #GBL_TOKUSEI$)

			(if (= #err_flag nil)
				(progn
					(setq #plan05$$ (nth  0 #GBL_TOKUSEI$))	; �`��
;;;(princ "\n����������0")
					(setq #plan07$$ (nth  1 #GBL_TOKUSEI$))	; ���s��
;;;(princ "\n����������1")
					(setq #plan04$$ (nth  2 #GBL_TOKUSEI$))	; �L�b�`���Ԍ�
;;;(princ "\n����������2")
					(setq #plan31$$ (nth  3 #GBL_TOKUSEI$))	; ���[�N�g�b�v����
;;;(princ "\n����������3")
					(setq #plan02$$ (nth  4 #GBL_TOKUSEI$))	; �L���r�l�b�g�v����
;;;(princ "\n����������4")
					(setq #plan17$$ (nth  5 #GBL_TOKUSEI$))	; �V���N
;;;(princ "\n����������5")
					(setq #plan16$$ (nth  6 #GBL_TOKUSEI$))	; ���[�N�g�b�v�ގ�
;;;(princ "\n����������6")
					(setq #plan06$$ (nth  7 #GBL_TOKUSEI$))	; �t���A�L���r�^�C�v
;;;(princ "\n����������7")
					(setq #plan08$$ (nth  8 #GBL_TOKUSEI$))	; �\�t�g�N���[�Y
;;;(princ "\n����������8")
					(setq #plan32$$ (nth  9 #GBL_TOKUSEI$))	; �݌ˍ���
;;;(princ "\n����������9")
					(setq	#plan19$$ (nth 10 #GBL_TOKUSEI$))	; ����
;;;(princ "\n����������10")
					(setq #plan22$$ (nth 11 #GBL_TOKUSEI$))	; �򐅊�
;;;(princ "\n����������11")
					(setq #plan20$$ (nth 12 #GBL_TOKUSEI$))	; ���M�@��
;;;(princ "\n����������12")
					(setq #plan21$$ (nth 13 #GBL_TOKUSEI$))	; �R�������I�[�u��
;;;(princ "\n����������13")
					(setq #plan42$$ (nth 14 #GBL_TOKUSEI$))	; �H��
;;;(princ "\n����������14")
					(setq #plan23$$ (nth 15 #GBL_TOKUSEI$))	; �����W�t�[�h
;;;(princ "\n����������15")
					(setq #plan44$$ (nth 16 #GBL_TOKUSEI$))	; �K���X�p�[�e�B�V����
;;;(princ "\n����������16")
					(setq #plan47$$ (nth 17 #GBL_TOKUSEI$))	; �L�b�`���p�l��
;;;(princ "\n����������17")

					;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #plan15$$ (nth 18 #GBL_TOKUSEI$))	;�V���N���L���r�l�b�g
					;2016/04/15 YM ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;;(princ "\n����������18")

					;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					(setq #plan11$$ (nth 19 #GBL_TOKUSEI$))	;�V���N���L���r�l�b�g
					(setq #plan48$$ (nth 20 #GBL_TOKUSEI$))	;�V���N���L���r�l�b�g
					;2018/04/26 YK ADD-E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;-- 2012/01/18 A.Satoh Add CG�Ή� - S
					(setq #flrcol (atoi (get_tile "flr_col")))	; CG���d�l�F�F���I��ԍ�
;-- 2012/03/05 A.Satoh Mod - S
;					(if #CG_YukairoCol$
;						(setq #flr_col$ (nth #flrcol #CG_YukairoCol$))
;						(setq #flr_col$ (list "" "" "FLOOR_COLOR"))
;					)
					(if (= #cg_y "1")
						(if (= #allWhite "1")
							(setq #flr_col$ (list "" "KP_NO_FLOOR" "FLOOR_COLOR"))
							(setq #flr_col$ (nth #flrcol #CG_YukairoCol$))
						)
						(setq #flr_col$ (list "" "" "FLOOR_COLOR"))
					);_if

;-- 2012/03/05 A.Satoh Mod - E
;-- 2012/01/18 A.Satoh Add CG�Ή� - E

;;;(princ "\n���������� #DRSERI$$ = ")(princ #DRSERI$$)(princ "\n")
;;;(princ "\n���������� #DRCOL$$ = ")(princ #DRCOL$$)(princ "\n")
;;;(princ "\n���������� #HANDLE$$ = ")(princ #HANDLE$$)(princ "\n")
;;;(princ "\n���������� #plan05$$ = ")(princ #plan05$$)(princ "\n")
;;;(princ "\n���������� #plan04$$ = ")(princ #plan04$$)(princ "\n")
;;;(princ "\n���������� #plan31$$ = ")(princ #plan31$$)(princ "\n")
;;;(princ "\n���������� #plan02$$ = ")(princ #plan02$$)(princ "\n")
;;;(princ "\n���������� #plan17$$ = ")(princ #plan17$$)(princ "\n")
;;;(princ "\n���������� #plan16$$ = ")(princ #plan16$$)(princ "\n")
;;;(princ "\n���������� #plan06$$ = ")(princ #plan06$$)(princ "\n")
;;;(princ "\n���������� #plan15$$ = ")(princ #plan15$$)(princ "\n")
;;;
;;;(princ "\n���������� #plan08$$ = ")(princ #plan08$$)(princ "\n")
;;;(princ "\n���������� #plan32$$ = ")(princ #plan32$$)(princ "\n")
;;;(princ "\n���������� #plan19$$ = ")(princ #plan19$$)(princ "\n")
;;;(princ "\n���������� #plan22$$ = ")(princ #plan22$$)(princ "\n")
;;;(princ "\n���������� #plan20$$ = ")(princ #plan20$$)(princ "\n")
;;;(princ "\n���������� #plan21$$ = ")(princ #plan21$$)(princ "\n")
;;;(princ "\n���������� #plan42$$ = ")(princ #plan42$$)(princ "\n")
;;;(princ "\n���������� #plan23$$ = ")(princ #plan23$$)(princ "\n")
;;;(princ "\n���������� #plan44$$ = ")(princ #plan44$$)(princ "\n")
;;;(princ "\n���������� #plan47$$ = ")(princ #plan47$$)(princ "\n")
;;;(princ "\n���������� #cg_y = ")(princ #cg_y)(princ "\n")

					(setq #ret$
						(list
							(nth 0 (nth (atoi (get_tile "drseri"))      #DRSERI$$))	; ���O���[�h
							(nth 1 (nth (atoi (get_tile "drcol"))       #DRCOL$$ ))	; ���J���[
							(nth 3 (nth (atoi (get_tile "handle"))      #HANDLE$$))	; ����
							(nth 2 (nth (atoi (get_tile "type"))        #plan05$$))	; �`��
							(nth 2 (nth (atoi (get_tile "deep"))        #plan07$$))	; ���s��
							(nth 2 (nth (atoi (get_tile "maguchi"))     #plan04$$))	; �L�b�`���Ԍ�
							(nth 2 (nth (atoi (get_tile "wtheight"))    #plan31$$))	; ���[�N�g�b�v����
							(nth 2 (nth (atoi (get_tile "cab_plan"))    #plan02$$))	; �L���r�l�b�g�v����
							(nth 2 (nth (atoi (get_tile "sink"))        #plan17$$))	; �V���N
							(nth 2 (nth (atoi (get_tile "wt_zai"))      #plan16$$))	; ���[�N�g�b�v�ގ�
							(nth 2 (nth (atoi (get_tile "floor_cab"))   #plan06$$))	; �t���A�L���r�^�C�v
							;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@
							(nth 2 (nth (atoi (get_tile "sinkunder_cab")) #plan15$$))	; �V���N���L���r�l�b�g
							;2016/04/15 YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@
							(nth 2 (nth (atoi (get_tile "soft_close"))  #plan08$$))	; �\�t�g�N���[�Y
							(nth 2 (nth (atoi (get_tile "wool_height")) #plan32$$))	; �݌ˍ���
							(nth 2 (nth (atoi (get_tile "water"))       #plan19$$))	; ����
							(nth 2 (nth (atoi (get_tile "josui"))       #plan22$$))	; �򐅊�
							(nth 2 (nth (atoi (get_tile "conro"))       #plan20$$))	; ���M�@��
							(nth 2 (nth (atoi (get_tile "oven"))        #plan21$$))	; �R�������I�[�u��
							(nth 2 (nth (atoi (get_tile "syokusen"))    #plan42$$))	; �H��
							(nth 2 (nth (atoi (get_tile "rennji"))      #plan23$$))	; �����W�t�[�h
							(nth 2 (nth (atoi (get_tile "glass"))       #plan44$$))	; �K���X�p�[�e�B�V����
							(nth 2 (nth (atoi (get_tile "panel"))       #plan47$$))	; �L�b�`���p�l��
							;2018/04/26 YK ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@
							(nth 2 (nth (atoi (get_tile "sayu_katte"))   #plan11$$)) ; ���E����
							(nth 2 (nth (atoi (get_tile "tenjo_height")) #plan48$$)) ; �V�䍂��
							;2018/04/26 YK YM ADD-S @@@@@@@@@@@@@@@@@@@@@@@@@@@
;-- 2012/01/18 A.Satoh Add CG�Ή� - S
							#cg_y									; CG�L���iCG����̒l��ݒ� "1":CG���� "0":CG�Ȃ��j
							(nth 2 #flr_col$)			; InputCfg����
							(nth 1 #flr_col$)			; �F���L��
							(nth 0 #flr_col$)			; �F������
;-- 2012/01/18 A.Satoh Add CG�Ή� - E
;-- 2012/03/05 A.Satoh Add - S
							#allWhite
;-- 2012/03/05 A.Satoh Add - E
						)
					)

					(done_dialog 1)
				)
				(setq #ret$ nil)
			)

      #ret$
    ) ; ##SetPresenInfo_CallBack

		; 2017/06/15 KY ADD-S
		;//******************************************************
		;//
		;// ���i�R�[�h�Ɠ���ID�ɂ��APB�t�����ŏ����l�擾
		;//
		;//******************************************************
		(defun ##GetHinbanInitValue (
			&code		; (INT)���i�R�[�h(3��)
			&id			; (STR)����ID
			/
			#hinban
			#value
			)

			(setq #hinban (##GetHinban &code))

			(if (= #hinban nil)
				"N"
				;else
				(progn
					(setq #value (##GetGyakubukiValue &id #hinban))
					(if (= #value "NULL")
						(setq #value "N")
					)
					#value
				);progn
			);if
		);##GetHinbanInitValue

		;//******************************************************
		;//
		;// ���ڂ̏����l�擾(�t���[���L�b�`���p)
		;//
		;//******************************************************
		(defun ##GetInitData_FK$ (
			/
			#frames$$ #frame$ #counters$$ #counter$ #type #depth #width #height #sink #dimW #dimD
			#pt1 #pt2 #pt3 #pt4 #ang #bpc #pc #tmp1 #tmp2 #totalW #tmp #hinban
			#Init$ #qry$$
#value44 #value47 ;2017/11/02 YM ADD
#value11 #value48 ;2018/05/07 YK ADD
			)

			(setq #Init$ nil)
			(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
				(progn
					; �t���[�����̎擾
					(setq #frames$$ (GetFrameInfo$$ T T))
					(setq #counters$$ (nth 1 #frames$$))
					(setq #frames$$ (nth 0 #frames$$))

					; �`��̎擾 ---------------------------------------------
					(setq #type "NULL")
					(foreach #counter$ #counters$$
						(if (= #type "NULL")
							(progn
								(setq #hinban (nth 2 #counter$))
								(setq #tmp (vl-string-position (ascii "-") #hinban 6)) ; �i�Ԃ̍ŏ��̃n�C�t���̒���Ŕ��f
								(if #tmp
									(progn
										(setq #tmp (substr #hinban (1+ #tmp) 1))
										(cond
											((= #tmp "A") ; I�^
												(setq #type "I00")
											)
											((= #tmp "C") ; P�^
												(setq #type "IPA")
											)
											((= #tmp "K") ; ���[
												(setq #type "?")
											)
										);cond
									);progn
								);if
								(if (= #type "NULL")
									(progn
										(setq #tmp (fix (+ (nth 1 (nth 3 #counter$)) 0.1)))
										(cond
											((= #tmp 650) ; I�^
												(setq #type "I00")
											)
											((= #tmp 900) ; P�^
												(setq #type "IPA")
											)
											((= #tmp 450) ; ���[
												(setq #type "?")
											)
										);cond
									);progn
								);if
							);progn
						);if
					);foreach
					; --------------------------------------------------------

					; ���s���̎擾 -------------------------------------------
					(setq #depth "NULL")
					(foreach #counter$ #counters$$
						(if (= #depth "NULL")
							(progn
								(setq #tmp (fix (+ (nth 1 (nth 3 #counter$)) 0.1)))
								(setq #qry$$ (CFGetDBSQLRec CG_DBSESSION "���s" (list (list "���s" (itoa #tmp) 'INT))))
								(if #qry$$
									(setq #depth (nth 1 (nth 0 #qry$$)))
								);if
							);progn
						);if
					);foreach
					; --------------------------------------------------------

					; �L�b�`���Ԍ��̎擾 -------------------------------------
					(setq #ang nil)
					(setq #totalW 0.0)
					(setq #width nil)
					(foreach #counter$ #counters$$
						(setq #pt1 nil)
						(if (= #ang nil)
							(progn
								(setq #ang (nth 5 #counter$))
								(setq #pt1 (nth 1 #counter$))
								;(setq #pt1 (list (nth 0 #pt1) (nth 1 #pt1) 0.0))
								(setq #pt1 (list-put-nth 0.0 #pt1 2))
								(setq #bpt #pt1)
							);progn
							;else
							(if (equal #ang (nth 5 #counter$) 0.0001)
								(progn
									(setq #pt1 (nth 1 #counter$))
									;(setq #pt1 (list (nth 0 #pt1) (nth 1 #pt1) 0.0))
									(setq #pt1 (list-put-nth 0.0 #pt1 2))
									(setq #pt1 (mapcar '- #pt1 #bpt)) ; ��_����̑��΍��W
									(setq #pt1 (list (- (* (cos (- #ang)) (nth 0 #pt1)) (* (sin (- #ang)) (nth 1 #pt1)))
																	 (+ (* (sin (- #ang)) (nth 0 #pt1)) (* (cos (- #ang)) (nth 1 #pt1)))
																	 (nth 2 #pt1))) ; ��]
									(setq #pt1 (mapcar '+ #pt1 #bpt)) ; ��΍��W
								);progn
							);if
						);if
						(if #pt1
							(progn
								(setq #dimW (nth 0 (nth 3 #counter$)))
								(setq #dimD (nth 1 (nth 3 #counter$)))
								(setq #pt2 (list (+ (nth 0 #pt1) #dimW) (nth 1 #pt1) (nth 2 #pt1)))
								(setq #pt3 (list (nth 0 #pt2) (- (nth 1 #pt2) #dimD) (nth 2 #pt2)))
								(setq #pt4 (list (nth 0 #pt1) (- (nth 1 #pt1) #dimD) (nth 2 #pt1)))

								(setq #pc (mapcar '(lambda (#tmp1 #tmp2) (/ (+ #tmp1 #tmp2) 2.0)) #pt1 #pt3))
								(if (= #bpc nil)
									(progn
										(setq #bpc #pc)
										(setq #totalW #dimW)
									);progn
									;else
									(progn
										(setq #tmp (+ (- #totalW (- (nth 0 #bpc) (nth 0 #bpt))) (/ #dimW 2.0)))
										(if (equal (mapcar '- #pc #bpc) (list #tmp 0.0 0.0) 0.1)
											(setq #totalW (+ #totalW #dimW))
										);if
									);progn
								);if
							);progn
						);if
					);foreach
					(setq #tmp (fix (+ #totalW 0.1)))
					(if (> #tmp 0)
						(progn
							(setq #qry$$ (CFGetDBSQLRec CG_DBSESSION "�Ԍ�" (list (list "�Ԍ�" (itoa #tmp) 'INT))))
							(if #qry$$
								(setq #width (nth 1 (nth 0 #qry$$)))
							);if
						);progn
					);if
					(if (= nil #width)
						(setq #width "NULL")
					);if
					; --------------------------------------------------------

					; ���[�N�g�b�v�����̎擾 ---------------------------------
					(setq #height "NULL")
					(foreach #counter$ #counters$$
						(if (= #height "NULL")
							(progn
								(setq #tmp (+ (nth 2 (nth 1 #counter$)) (nth 2 (nth 3 #counter$))))
								(setq #height (strcat "H" (itoa (fix (+ #tmp 0.1)))))
							);progn
						);if
					);foreach
					; --------------------------------------------------------

					; �V���N�̎擾 -------------------------------------------
					(setq #sink "NULL")
					(foreach #counter$ #counters$$
						(if (= #sink "NULL")
							(progn
								(setq #hinban (nth 2 #counter$))
								(setq #tmp (vl-string-position (ascii "-") #hinban 6)) ; �i�Ԃ̍ŏ��̃n�C�t���̒��O�Ŕ��f
								(if #tmp
									(progn
										(setq #tmp (substr #hinban #tmp 1))
										(cond
											((= #tmp "S") ; �X�e�����X�X�N�G�A�}���`
												(setq #sink "S15_")
											)
											((= #tmp "P") ; P�V���N
												(setq #sink "P_")
											)
										);cond
									);progn
								);if
							);progn
						);if
					);foreach
					; --------------------------------------------------------


			;;;;; �K���X�p�[�e�B�V����
			(setq #GLASS$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from �K���X�p�e�B�V����")))
			(if (= #GLASS$$ nil)
				(setq #value "NULL")
				(progn
					; �K���X�p�[�e�B�V�����i�ԃ��X�g���쐬
					(setq #hinban$ nil)
					(foreach #GLASS$ #GLASS$$
						(if (= (member (nth 5 #GLASS$) #hinban$) nil)
							(setq #hinban$ (append #hinban$ (list (nth 5 #GLASS$))))
						)
					)

					; �}�ʂ���K���X�p�[�e�B�V����������
					(setq #flag nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) #hinban)
													(progn
														(setq #flag T)
														(setq #hinban2 #hinban)
													)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value44 "NULL")
						(setq #value44 (##GetGyakubukiValue "PLAN44" #hinban2)) ;2017/11/2 YM  �����߂�
					)
;;;					(setq #ret$ (append #ret$ (list #value)))
				)
			);_if

			;;;;; �L�b�`���p�l��
			(setq #QRY$
				(CFGetDBSQLRec CG_DBSESSION "PB�t��"
					(list
						(list "����ID" "PLAN47" 'STR)
					)
				)
			)
			(if (= #QRY$ nil)
				(setq #value "N")
				(progn
					; �L�b�`���p�l���i�ԃ��X�g���쐬
					(setq #hinban$ nil)
					(foreach #QRY #QRY$
						(if (= (member (nth 2 #QRY) #hinban$) nil)
							(setq #hinban$ (append #hinban$ (list (list (nth 2 #QRY) (nth 5 #QRY)))))
						)
					)

					; �}�ʂ���L�b�`���p�l��������
					(setq #flag nil)
					(setq #hinban2 nil)
					(setq #ss (ssget "X" '((-3 ("G_LSYM")))))
					(if (/= #ss nil)
						(foreach #hinban #hinban$
							(if (= #flag nil)
								(progn
									(setq #idx 0)
									(repeat (sslength #ss)
										(if (= #flag nil)
											(progn
												(setq #xd_LSYM$ (CFGetXData (ssname #ss #idx) "G_LSYM"))
												(if (= (nth 5 #xd_LSYM$) (car #hinban))
													(progn
														(setq #wk_hinban #hinban)
														(setq #flag T)
													)
												)
											)
										)
										(setq #idx (1+ #idx))
									)
								)
							)
						)
					)

					(if (= #flag nil)
						(setq #value47 "N")
						(setq #value47 (nth 1 #wk_hinban)) ;2017/11/2 YM  �����߂��H�H�H
					)

					;���E���� 2018/04/27 YK ADD-S
					(setq #value11 "NULL")
					;���E���� 2018/04/27 YK ADD-E

					;�V�䍂�� 2018/04/27 YK ADD-S
					(setq #QRY$
						(CFGetDBSQLRec CG_DBSESSION "PB�t��"
							(list
								(list "����ID" "PLAN48" 'STR)
							)
						)
					)
					(setq #value48 "NULL")

  				; ���݂̃v�������(PLANINFO.CFG)��ǂݍ���
  				(setq #PLANINFO$ (ReadIniFile (strcat CG_KENMEI_PATH "PLANINFO.CFG")))

		  		(if (assoc "CeilingHeight" #PLANINFO$)
    				(setq #value (nth 1 (assoc "CeilingHeight" #PLANINFO$)))
  				);_if


					(foreach #QRY #QRY$
						(if (= (nth 2 #QRY) #value)
							(progn
								(setq #value48 #value)
							)
						)
					)
					;�V�䍂�� 2018/04/27 YK ADD-E

					(if (= #flag nil)
					  (if (findfile (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg"))
					    (progn
								(setq #hinban2$ nil)
					      (setq #spec$$ (ReadCSVFile (strcat CG_KENMEIDATA_PATH "HOSOKU.cfg")))
					      (if #spec$$
					        (foreach #spec$ #spec$$
					          (setq #hinban2$ (append #hinban2$ (list (nth 0 (StrParse (nth 0 #spec$) "=")))))
									)
								)
								(foreach #hinban #hinban$
									(if (= #flag nil)
										(foreach #hinban2 #hinban2$
											(if (= #flag nil)
												(if (= (car #hinban) #hinban2)
													(progn
														(setq #wk_hinban #hinban)
														(setq #flag T)
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
			);_if


					(setq #Init$ (list
						; �`��
						#type
						; ���s��
						#depth
						; �L�b�`���Ԍ�
						#width
						; ���[�N�g�b�v����
						#height
						; �L���r�l�b�g�v����
						"NULL"
						; �V���N
						#sink
						; ���[�N�g�b�v�ގ�
						"NULL"
						; �t���A�L���r�^�C�v
						"NULL"
						; �V���N���L���r�l�b�g
						"NULL"
						; �\�t�g�N���[�Y
						"NULL"
						; �݌ˍ���
						"NULL"
						; ����
						(##GetHinbanInitValue 510 "PLAN19")
						; �򐅊�
						"N"
						; ���M�@��
						(##GetHinbanInitValue 210 "PLAN20")
						; �R�������I�[�u��
						"NULL"
						; �H��
						(##GetHinbanInitValue 110 "PLAN42")
						; �����W�t�[�h
						(##GetHinbanInitValue 320 "PLAN23")

						; �K���X�p�[�e�B�V����
						;2017/11/02 YM MOD-S
;;;						"NULL"
						#value44
						;2017/11/02 YM MOD-E

						;2017/11/02 YM MOD-S
						; �L�b�`���p�l��
;;;						"N"
						#value47
						;2017/11/02 YM MOD-E

						;2018/05/07 YK ADD-S
						#value11
						#value48
						;2018/05/07 YK ADD-E

					))
				);progn
			);if
			#Init$
		);##GetInitData_FK$
		; 2017/06/15 KY ADD-E

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;(princ "\n�����������@2016/09/07 CHECK WRITE�@000�@����������")

  (setq #err_flag nil)
;-- 2012/01/18 A.Satoh Add CG�Ή� - S
	(setq #CG_YukairoCol$ nil)
	(setq #CG_YUKAIRO$$ nil)
	(setq #OLD_CG_Y "0")
	(setq #OLD_CG_N "0")
;-- 2012/01/18 A.Satoh Add CG�Ή� - E

  (if (/= CG_DBSESSION nil)
    (progn
      (dbDisconnect CG_DBSESSION)
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
    )
    (progn
      (setq CG_DBSESSION (dbconnect CG_DBNAME "" ""))
    )
  )

;;;(princ "\n�����������@2016/09/07 CHECK WRITE�@111�@����������")

  (if (= CG_DBSESSION nil)
    (progn
      (CFAlertMsg "SERIES�ʂ̃f�[�^�x�[�X������܂���ł���")
      (setq #info$ nil)
      (setq #err_flag T)
    )
    (progn
      ;// ���݂̔�SERIES�A��COLOR�̐ݒ�
      ;��ذ�ނ�ؽ�
      (setq #DRSERI$$
        (CFGetDBSQLRec CG_DBSESSION "���V���Y"
          (list
            (list "�p��F" "0"  'INT)
          )
        )
      )
      (if (= #DRSERI$$ nil)
        (progn
          (CFAlertMsg "�y���V���Y�z��ں��ނ�����܂���B")
          (setq #info$ nil)
          (setq #err_flag T)
        )
      )
    )
  );_if

;;;(princ "\n�����������@2016/09/07 CHECK WRITE�@222�@����������")


	(if (= #err_flag nil)
		(progn
			; PB�����l���擾����
			(setq #PB_TOKUSEI$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from PB�����l")))
			(if (= #PB_TOKUSEI$$ nil)
				(progn
					(CFAlertMsg "�yPB�����l�z��ں��ނ�����܂���B")
					(setq #info$ nil)
					(setq #err_flag T)
				)
				(progn
					(setq #GBL_TOKUSEI$ (##GetPBTokusei #PB_TOKUSEI$$))
;;;(princ "\n�����������@2016/09/07 CHECK WRITE�@#GBL_TOKUSEI$�@����������")
;;;(princ #GBL_TOKUSEI$)
				)
			)
		)
	)

;;;(princ "\n�����������@2016/09/07 CHECK WRITE�@333�@����������")

;-- 2012/01/18 A.Satoh Add CG�Ή� - S
	(if (= #err_flag nil)
		(progn
			; CG���F�I�������擾����
			(setq #CG_YUKAIRO$$ (DBSqlAutoQuery CG_DBSESSION (strcat "select * from CG���F�I��")))
			(if (= #CG_YUKAIRO$$ nil)
				(progn
					(CFAlertMsg "�yCG���F�I���z��ں��ނ�����܂���B")
					(setq #info$ nil)
					(setq #err_flag T)
				)
				(progn
					; ���i���v���_�E���p���X�g���쐬����
					(setq #GBL_CGYukairoGoods$ (list (list "" "")))
					(foreach #CG_YUKAIRO$ #CG_YUKAIRO$$
						(if (= (member (list (nth 1 #CG_YUKAIRO$) (nth 2 #CG_YUKAIRO$)) #GBL_CGYukairoGoods$) nil)
							(setq #GBL_CGYukairoGoods$ (append #GBL_CGYukairoGoods$ (list (list (nth 1 #CG_YUKAIRO$) (nth 2 #CG_YUKAIRO$)))))
						)
					)
				)
			)
		)
	)

;;;(princ "\n�����������@2016/09/07 CHECK WRITE�@444�@����������")

;-- 2012/01/18 A.Satoh Add CG�Ή� - E

	(if (= #err_flag nil)
		(progn
			; �V�����擾
			(setq #wt_ss (ssget "X" '((-3 ("G_WRKT")))))
			(if (= #wt_ss nil)
				(progn
					(setq #wt_en nil)
					(setq #xd_WRKT$ nil)
					(setq #type_f nil)
					(setq #Init$ nil)
					; 2017/06/15 KY ADD-S
					; �t���[���L�b�`���Ή�
					(if (= BU_CODE_0012 "1") ; �t���[���L�b�`���̏ꍇ
						(progn
							(setq #type_f T)
							(setq #Init$ (##GetInitData_FK$))
						);progn
					);if
					; 2017/06/15 KY ADD-E
				)
				(progn
					(setq #wt_en (ssname #wt_ss 0))
					(setq #xd_WRKT$ (CFGetXData (ssname #wt_ss 0) "G_WRKT"))
					(setq #type_f T)

					; PB�t���ɂ��A�����l�擾
					(setq #Init$ (##GetInitData #xd_WRKT$))
				)
			)

      ; DCL���[�h
      (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
      (if (not (new_dialog "KPCAD_OutputPresenDlg" #dcl_id)) (exit))

      ; �����l�ݒ�
			(##ResetInitInfo #type_f #Init$)

      (setq #next 99)
      (while (and (/= 1 #next) (/= 0 #next))
        ; �{�^����������
        (action_tile "drseri" "(##SelDoorSeries)")
        (action_tile "drcol"  "(##SelDoorHandle)")
;-- 2012/01/18 A.Satoh Add CG�Ή� - S
        (action_tile "cg_y"   "(##SetInitCG_List)") ; CG����{�^���������̏����i�����i���A���F�����X�g�̊������j
        (action_tile "cg_n"   "(##SetInitCG_List)") ; CG�Ȃ��{�^���������̏����i�����i���A���F�����X�g�̔񊈐����j
        (action_tile "goods"  "(##SelCG_Goods)")    ; ���i�����X�g�I�����̏����i�F�����X�g�̐ݒ�j
;-- 2012/01/18 A.Satoh Add CG�Ή� - E
;-- 2012/03/05 A.Satoh Add CG�w�i�F���Ή� - S
        (action_tile "all_white" "(##SetAllWhite)") ; �w�i�F���`�F�b�N�̑I������
;-- 2012/03/05 A.Satoh Add CG�w�i�F���Ή� - E
        (action_tile "accept" "(setq #info$ (##SetPresenInfo_CallBack))")
        (action_tile "cancel" "(setq #info$ nil)(done_dialog 0)")

        (setq #next (start_dialog))
      )

      (unload_dialog #dcl_id)
    )
  );_if

;;;(princ "\n�����������@2016/09/07 CHECK WRITE�@555�@����������")


  #info$

) ;OutputPresenDlg
;-- 2011/10/27 A.Satoh Add - E


;-- 2012/02/07 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <�֐���>    : C:AutoDrawWall
;;; <�����T�v>  : �ǎ��������R�}���h
;;; <�߂�l>    :
;;; <�쐬>      : 2012/02/07 A.Satoh
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun C:AutoDrawWall (
  /
	#cmdecho #osmode #pickstyle #elevation #luprec #err_flag #size$
	#loop #wt_en #xd_WRKT$ #ret #ss_wt #wt_num 
  )

	;****************************************************
	; �G���[����
	;****************************************************
  (defun AutoDrawWallUndoErr( &msg )
    (command "_undo" "b")
    (CFCmdDefFinish)
    (setq *error* nil)
    (princ)
  )
	;****************************************************

  (CFOutStateLog 1 1 " ")
  (CFOutStateLog 1 1 "//// C:AutoDrawWall ////")
  (CFOutStateLog 1 1 " ")

  ;;;��������L�� PcSetKUTAI���ŕύX������
  ;;;RTOS�̓V�X�e���ϐ�LUPREC�ɂ���ď������𐧌��ł���B
  (setq #elevation (getvar "ELEVATION")) ; ���������ŕύX�����ׁA��������L������
  (setq #luprec (getvar "LUPREC"))
  (setvar "LUPREC" 2)

  (setq *error* AutoDrawWallUndoErr)
  (setq #elevation (getvar "ELEVATION")) ; ���������ŕύX�����ׁA��������L������
	(setq #cmdecho (getvar "CMDECHO"))
	(setq #osmode (getvar "OSMODE"))
	(setq #pickstyle (getvar "PICKSTYLE"))
  (setq #luprec (getvar "LUPREC"))
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)
  (setvar "PICKSTYLE" 0)
  (setvar "LUPREC" 2)
  (command "_undo" "M")
  (command "_undo" "a" "off")
	(CFCmdDefBegin 6)
	(setq #err_flag nil)

	; �V�̑��݃`�F�b�N
	(setq #ss_wt (ssget "X" '((-3 ("G_WRKT")))))
	(setq #wt_num (sslength #ss_wt))
	(cond
		((= #wt_num 0)	; �V�����݂��Ȃ�
			(CFAlertMsg "�ǂ������z�u�ł��܂���B")
			(setq #err_flag T)
		)
		((= #wt_num 1)	; �V���P�����Ȃ�
			(setq #wt_en (ssname #ss_wt 0))
		)
		(T
			; �V�w�菈��
			(setq #loop T)
			(while #loop
				(setq #wt_en (car (entsel "\n�Ǎ�}�Ώۂ̓V�}�`��I��: ")))
				(if #wt_en
					(progn
						(setq #xd_WRKT$ (CFGetXData #wt_en "G_WRKT"))
						(if (= #xd_WRKT$ nil)
							(CFAlertMsg "�V�}�`�ł͂���܂���B")
							(setq #loop nil)
						)
					)
				)
			)
		)
	)

	(if (= #err_flag nil)
		(progn
			; �ǎ��������T�C�Y�w��_�C�A���O����
			; �߂�l
			; �@�n�j������(�ǃp�^�[���ԍ� �ǂw�̕� �ǂw�ƓV�̌��� �ǂx�̕� �ǂx�ƓV�̌��� �ǂy�̕� �ǂy�ƓV�̌��� �ǂ̌��� �ǂ̍���)
			; �@�L�����Z��������nil
			;
			;     �ǃp�^�[���ԍ�
			;       1:�h�^,�k�^�E����p
			;       2:�h�^,�k�^������p
			;       3:�o�^�E����p
			;       4:�o�^������p
			;       5:�h�^�O����
			(setq #size$ (AutoDrawWall_SetWallSizeDlg))
			(if (= #size$ nil)
				(setq #err_flag T)
			)
		)
	)

	(if (= #err_flag nil)
		; �ǎ�����������
		(AutoDrawWall_MakeWall #wt_en #size$)
	)

	; �I������
	(CFCmdDefFinish)
	(setvar "CMDECHO" #cmdecho)
	(setvar "OSMODE" #osmode)
	(setvar "PICKSTYLE" #pickstyle)
	(setvar "ELEVATION" #elevation)
	(setvar "LUPREC" #luprec)
	(setq *error* nil)

  (princ)

) ;C:AutoDrawWall


;;;<HOM>*************************************************************************
;;; <�֐���>    : AutoDrawWall_SetWallSizeDlg
;;; <�����T�v>  : �ǎ��������T�C�Y�w��_�C�A���O����
;;; <�߂�l>    : (�ǃp�^�[���ԍ� �ǂw�̕� �ǂw�ƓV�̌��� �ǂx�̕� �ǂx�ƓV�̌��� �ǂy�̕� �ǂy�ƓV�̌��� �ǂ̌��� �ǂ̍���) or nil
;;;�@�@�@�@�@�@�@�@�@�ǃp�^�[���ԍ�
;;;�@�@�@�@�@�@�@�@�@�@1:�h�^,�k�^�E����p
;;;�@�@�@�@�@�@�@�@�@�@2:�h�^,�k�^������p
;;;�@�@�@�@�@�@�@�@�@�@3:�o�^�E����p
;;;�@�@�@�@�@�@�@�@�@�@4:�o�^������p
;;;						         5:�h�^�O����
;;; <�쐬>      : 2012/02/07 A.Satoh
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun AutoDrawWall_SetWallSizeDlg (
  /
	#size$ #dcl_id #x #y #next
	#CG_radio1_old #CG_radio2_old #CG_radio3_old #CG_radio4_old #CG_radio5_old
  )

	;***********************************************************************
	; �ǃp�^�[�����W�I�{�^���I������
	; �߂�l:�Ȃ�
	;***********************************************************************
	(defun ##SetWallSizeDlg_SelectRadio (
		&type		; �I���p�^�[���R�[�h
						; 1:�h�^,�k�^�E����p
						; 2:�h�^,�k�^������p
						; 3:�o�^�E����p
						; 4:�o�^������p
						; 5:�h�^�O����
		/
		#radioILR #radioILL #radioPR #radioPL #radioI3
		)

		; �ǃp�^�[���̐ݒ�l���擾
		(setq #radioILR (get_tile "radioILR"))	; �h�^,�k�^�E����p
		(setq #radioILL (get_tile "radioILL"))	; �h�^,�k�^������p
		(setq #radioPR  (get_tile "radioPR"))		; �o�^�E����p
		(setq #radioPL  (get_tile "radioPL"))		; �o�^������p
		(setq #radioI3  (get_tile "radioI3"))		; �h�^�O����

		(cond
			((= &type 1)	; �h�^,�k�^�E����p
				(if (/= #radioILR #CG_radio1_old)
					(progn
						(set_tile "radioILR" "1")
						(set_tile "radioILL" "0")
						(set_tile "radioPR" "0")
						(set_tile "radioPL" "0")
						(set_tile "radioI3" "0")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 0)
						(set_tile "edtWidthX_off" "0")
						(mode_tile "edtWidthX_off" 0)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 1)
						(set_tile  "edtWidthZ_off" "")
						(mode_tile "edtWidthZ_off" 1)
					)
				)
			)
			((= &type 2)	; �h�^,�k�^������p
				(if (/= #radioILL #CG_radio2_old)
					(progn
						(set_tile "radioILR" "0")
						(set_tile "radioILL" "1")
						(set_tile "radioPR" "0")
						(set_tile "radioPL" "0")
						(set_tile "radioI3" "0")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 0)
						(set_tile "edtWidthX_off" "0")
						(mode_tile "edtWidthX_off" 0)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 1)
						(set_tile  "edtWidthZ_off" "")
						(mode_tile "edtWidthZ_off" 1)
					)
				)
			)
			((= &type 3)	; �o�^�E����p
				(if (/= #radioPR #CG_radio3_old)
					(progn
						(set_tile "radioILR" "0")
						(set_tile "radioILL" "0")
						(set_tile "radioPR" "1")
						(set_tile "radioPL" "0")
						(set_tile "radioI3" "0")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 1)
						(set_tile "edtWidthX_off" "")
						(mode_tile "edtWidthX_off" 1)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 1)
						(set_tile  "edtWidthZ_off" "")
						(mode_tile "edtWidthZ_off" 1)
					)
				)
			)
			((= &type 4)	; �o�^������p
				(if (/= #radioPL #CG_radio4_old)
					(progn
						(set_tile "radioILR" "0")
						(set_tile "radioILL" "0")
						(set_tile "radioPR" "0")
						(set_tile "radioPL" "1")
						(set_tile "radioI3" "0")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 1)
						(set_tile "edtWidthX_off" "")
						(mode_tile "edtWidthX_off" 1)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 1)
						(set_tile  "edtWidthZ_off" "")
						(mode_tile "edtWidthZ_off" 1)
					)
				)
			)
			((= &type 5)	; �h�^�O����
				(if (/= #radioI3 #CG_radio5_old)
					(progn
						(set_tile "radioILR" "0")
						(set_tile "radioILL" "0")
						(set_tile "radioPR" "0")
						(set_tile "radioPL" "0")
						(set_tile "radioI3" "1")

						(setq #CG_radio1_old (get_tile "radioILR"))
						(setq #CG_radio2_old (get_tile "radioILL"))
						(setq #CG_radio3_old (get_tile "radioPR"))
						(setq #CG_radio4_old (get_tile "radioPL"))
						(setq #CG_radio5_old (get_tile "radioI3"))

						(set_tile "edtWidth_X" "")
						(mode_tile "edtWidth_X" 0)
						(set_tile "edtWidthX_off" "0")
						(mode_tile "edtWidthX_off" 0)
						(set_tile "edtWidth_Y" "")
						(mode_tile "edtWidth_Y" 0)
						(set_tile "edtWidthY_off" "0")
						(mode_tile "edtWidthY_off" 0)
						(set_tile  "edtWidth_Z" "")
						(mode_tile "edtWidth_Z" 0)
						(set_tile  "edtWidthZ_off" "0")
						(mode_tile "edtWidthZ_off" 0)
					)
				)
			)
		)

	) ; ##SetWallSizeDlg_SelectRadio
	;***********************************************************************

	;***********************************************************************
	; �n�j�{�^����������
	; �߂�l:�ǎ���������񃊃X�g
	;        (�ǃp�^�[���ԍ� �ǂw�̕� �ǂw�ƓV�̌��� �ǂx�̕� �ǂx�ƓV�̌��� �ǂy�̕� �ǂy�ƓV�̌��� �ǂ̌��� �ǂ̍���)
	;***********************************************************************
	(defun ##SetWallSizeDlg_CallBack (
		/
		#err_flag #ret$ #radioILR #radioILL #radioPR #radioPL #radioI3
		#widthX #widthX_off #widthY #widthY_off #widthZ #widthZ_off 
		#depth #height #ptnno
		)

    (setq #err_flag nil)
		(setq #ret$ nil)

		; �ǃp�^�[���̐ݒ�l���擾
		(setq #radioILR (get_tile "radioILR"))		; �h�^,�k�^�E����p
		(setq #radioILL (get_tile "radioILL"))		; �h�^,�k�^������p
		(setq #radioPR  (get_tile "radioPR"))			; �o�^�E����p
		(setq #radioPL  (get_tile "radioPL"))			; �o�^������p
		(setq #radioI3  (get_tile "radioI3"))			; �h�^�O����

		; �ǃT�C�Y�̓��͒l���擾
		(setq #widthX     (get_tile "edtWidth_X"))		; �ǂw�̕�
		(setq #widthX_off (get_tile "edtWidthX_off"))	; �ǂw�ƓV�̌���
		(setq #widthY     (get_tile "edtWidth_Y"))		; �ǂx�̕�
		(setq #widthY_off (get_tile "edtWidthY_off"))	; �ǂx�ƓV�̌���
		(setq #widthZ     (get_tile "edtWidth_Z"))		; �ǂy�̕�
		(setq #widthZ_off (get_tile "edtWidthZ_off"))	; �ǂy�ƓV�̌���
		(setq #depth      (get_tile "edtDepth"))			; �ǂ̌���
		(setq #height     (get_tile "edtHeight"))			; �ǂ̍���

		; �ǃp�^�[�����̓`�F�b�N
		(if (and (= #radioILR "0") (= #radioILL "0") (= #radioPR "0") (= #radioPL "0") (= #radioI3 "0"))
			(progn
				(set_tile "error" "�ǃp�^�[�������͂���Ă��܂���")
				(setq #err_flag T)
			)
		)

		(if (= #err_flag nil)
			(if (or (= #radioILR "1") (= #radioILL "1") (= #radioI3 "1"))
				; [�ǂw�̕�]�̓��̓`�F�b�N
				(if (or (= #widthX "") (= #widthX nil))
					(progn
						(set_tile "error" "[�Ǖ��w]�����͂���Ă��܂���")
						(mode_tile "edtWidth_X" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthX)) 'INT) (= (type (read #widthX)) 'REAL))
						(if (>= 0 (read #widthX))
							(progn
								(set_tile "error" "[�Ǖ��w]�ɂ�1�ȏ�̐��l����͂��ĉ�����")
								(mode_tile "edtWidth_X" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[�Ǖ��w]�ɂ͐��l����͂��ĉ�����")
							(mode_tile "edtWidth_X" 2)
							(setq #err_flag T)
						)
					)
				)
			)
			(progn
				; [�ǂw�̕�]�͖����ׁ͂̈A�O��ݒ肷��
				(setq #widthX "0")
			)
		)

		(if (= #err_flag nil)
			(if (or (= #radioILR "1") (= #radioILL "1") (= #radioI3 "1"))
				; [�ǂw�ƓV�̌���]�̓��̓`�F�b�N
				(if (or (= #widthX_off "") (= #widthX_off nil))
					(progn
						(set_tile "error" "[�ǂw�ƓV�̌���]�����͂���Ă��܂���")
						(mode_tile "edtWidthX_off" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthX_off)) 'INT) (= (type (read #widthX_off)) 'REAL))
						(if (> 0 (read #widthX_off))
							(progn
								(set_tile "error" "[�ǂw�ƓV�̌���]�ɂ�0�ȏ�̐��l����͂��ĉ�����")
								(mode_tile "edtWidthX_off" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[�ǂw�ƓV�̌���]�ɂ͐��l����͂��ĉ�����")
							(mode_tile "edtWidthX_off" 2)
							(setq #err_flag T)
						)
					)
				)
			)
			(progn
				; [�ǂw�ƓV�̌���]�͖����ׁ͂̈A�O��ݒ肷��
				(setq #widthX_off "0")
			)
		)

		(if (= #err_flag nil)
			; [�ǂx�̕�]�̓��̓`�F�b�N
			(if (or (= #widthY "") (= #widthY nil))
				(progn
					(set_tile "error" "[�Ǖ��x]�����͂���Ă��܂���")
					(mode_tile "edtWidth_Y" 2)
					(setq #err_flag T)
				)
				(if (or (= (type (read #widthY)) 'INT) (= (type (read #widthY)) 'REAL))
					(if (>= 0 (read #widthY))
						(progn
							(set_tile "error" "[�Ǖ��x]�ɂ�1�ȏ�̐��l����͂��ĉ�����")
							(mode_tile "edtWidth_Y" 2)
							(setq #err_flag T)
						)
					)
					(progn
						(set_tile "error" "[�Ǖ��x]�ɂ͐��l����͂��ĉ�����")
						(mode_tile "edtWidth_Y" 2)
						(setq #err_flag T)
					)
				)
			)
		)

		(if (= #err_flag nil)
			; [�ǂx�ƓV�̌���]�̓��̓`�F�b�N
			(if (= #err_flag nil)
				(if (or (= #widthY_off "") (= #widthY_off nil))
					(progn
						(set_tile "error" "[�ǂx�ƓV�̌���]�����͂���Ă��܂���")
						(mode_tile "edtWidthY_off" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthY_off)) 'INT) (= (type (read #widthY_off)) 'REAL))
						(if (> 0 (read #widthY_off))
							(progn
								(set_tile "error" "[�ǂx�ƓV�̌���]�ɂ�0�ȏ�̐��l����͂��ĉ�����")
								(mode_tile "edtWidthY_off" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[�ǂx�ƓV�̌���]�ɂ͐��l����͂��ĉ�����")
							(mode_tile "edtWidthY_off" 2)
							(setq #err_flag T)
						)
					)
				)
			)
		)

		(if (= #err_flag nil)
			(if (= #radioI3 "1")
				; [�ǂy�̕�]�̓��̓`�F�b�N
				(if (or (= #widthZ "") (= #widthZ nil))
					(progn
						(set_tile "error" "[�ǂy�̕�]�����͂���Ă��܂���")
						(mode_tile "edtWidth_Z" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthZ)) 'INT) (= (type (read #widthZ)) 'REAL))
						(if (>= 0 (read #widthZ))
							(progn
								(set_tile "error" "[�ǂy�̕�]�ɂ�1�ȏ�̐��l����͂��ĉ�����")
								(mode_tile "edtWidth_Z" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[�ǂy�̕�]�ɂ͐��l����͂��ĉ�����")
							(mode_tile "edtWidth_Z" 2)
							(setq #err_flag T)
						)
					)
				)
			)
			(progn
				; [�ǂy�̕�]�͖����ׁ͂̈A�O��ݒ肷��
				(setq #widthZ "0")
			)
		)

		(if (= #err_flag nil)
			(if (= #radioI3 "1")
				; [�ǂy�ƓV�̌���]�̓��̓`�F�b�N
				(if (or (= #widthZ_off "") (= #widthZ_off nil))
					(progn
						(set_tile "error" "[�ǂy�ƓV�̌���]�����͂���Ă��܂���")
						(mode_tile "edtWidthZ_off" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #widthZ_off)) 'INT) (= (type (read #widthZ_off)) 'REAL))
						(if (> 0 (read #widthZ_off))
							(progn
								(set_tile "error" "[�ǂy�ƓV�̌���]�ɂ�0�ȏ�̐��l����͂��ĉ�����")
								(mode_tile "edtWidthZ_off" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[�ǂy�ƓV�̌���]�ɂ͐��l����͂��ĉ�����")
							(mode_tile "edtWidthZ_off" 2)
							(setq #err_flag T)
						)
					)
				)
			)
			(progn
				; [�ǂy�ƓV�̌���]�͖����ׁ͂̈A�O��ݒ肷��
				(setq #widthZ_off "0")
			)
		)

		(if (= #err_flag nil)
			; [�ǂ̌���]�̓��̓`�F�b�N
			(if (or (= #depth "") (= #depth nil))
				(progn
					(set_tile "error" "[�ǂ̌���]�����͂���Ă��܂���")
					(mode_tile "edtDepth" 2)
					(setq #err_flag T)
				)
				(if (or (= (type (read #depth)) 'INT) (= (type (read #depth)) 'REAL))
					(if (>= 0 (read #depth))
						(progn
							(set_tile "error" "[�ǂ̌���]�ɂ�1�ȏ�̐��l����͂��ĉ�����")
							(mode_tile "edtDepth" 2)
							(setq #err_flag T)
						)
					)
					(progn
						(set_tile "error" "[�ǂ̌���]�ɂ͐��l����͂��ĉ�����")
						(mode_tile "edtDepth" 2)
						(setq #err_flag T)
					)
				)
			)
		)

		(if (= #err_flag nil)
			; [�ǂ̍���]�̓��̓`�F�b�N
			(if (or (= #height "") (= #height nil))
				(progn
					(set_tile "error" "[�ǂ̍���]�����͂���Ă��܂���")
					(mode_tile "edtHeight" 2)
					(setq #err_flag T)
				)
				(if (or (= (type (read #height)) 'INT) (= (type (read #height)) 'REAL))
					(if (>= 0 (read #height))
						(progn
							(set_tile "error" "[�ǂ̍���]�ɂ�1�ȏ�̐��l����͂��ĉ�����")
							(mode_tile "edtHeight" 2)
							(setq #err_flag T)
						)
					)
					(progn
						(set_tile "error" "[�ǂ̍���]�ɂ͐��l����͂��ĉ�����")
						(mode_tile "edtHeight" 2)
						(setq #err_flag T)
					)
				)
			)
		)

		; �ǃT�C�Y��񃊃X�g�̍쐬
		(if (= #err_flag nil)
			(progn
				; �ǃp�^�[���ԍ��̐ݒ�
				(cond
					((= #radioILR "1")
						(setq #ptnno 1)
					)
					((= #radioILL "1")
						(setq #ptnno 2)
					)
					((= #radioPR "1")
						(setq #ptnno 3)
					)
					((= #radioPL "1")
						(setq #ptnno 4)
					)
					((= #radioI3 "1")
						(setq #ptnno 5)
					)
				)
				; ��񃊃X�g�쐬
				(setq #ret$ (list #ptnno (atof #widthX) (atof #widthX_off) (atof #widthY) (atof #widthY_off) (atof #widthZ) (atof #widthZ_off) (atof #depth) (atof #height)))
				(done_dialog)
				#ret$
			)
		)

	) ; ##SetWallSizeDlg_CallBack
	;***********************************************************************

	(setq #size$ nil)

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
  (if (not (new_dialog "SetWallSizeDlg" #dcl_id)) (exit))

	; �_�C�A���O�����ݒ�
	(setq #CG_radio1_old  "0")												; �h�^,�k�^�E����p���W�I�{�^��
	(setq #CG_radio2_old  "0")												; �h�^,�k�^������p���W�I�{�^��
	(setq #CG_radio3_old  "0")												; �o�^�E����p���W�I�{�^��
	(setq #CG_radio4_old  "0")												; �o�^������p���W�I�{�^��
	(setq #CG_radio5_old  "0")												; �h�^�O���ǃ��W�I�{�^��
	(set_tile "edtWidth_X"    "")											; �ǂw�̕�
	(mode_tile "edtWidth_X" 1)
	(set_tile "edtWidthX_off" "")											; �ǂw�ƓV�̌���
	(mode_tile "edtWidthX_off" 1)
	(set_tile "edtWidth_Y"    "")											; �ǂx�̕�
	(mode_tile "edtWidth_Y" 1)
	(set_tile "edtWidthY_off" "")											; �ǂx�ƓV�̌���
	(mode_tile "edtWidthY_off" 1)
	(set_tile "edtWidth_Z"    "")											; �ǂy�̕�
	(mode_tile "edtWidth_Z" 1)
	(set_tile "edtWidthZ_off" "")											; �ǂy�ƓV�̌���
	(mode_tile "edtWidthZ_off" 1)
	(set_tile "edtDepth"      "150")									; �ǂ̌���
	(set_tile "edtHeight"     (itoa CG_CeilHeight))		; �ǂ̍���

	; �X���C�h�ݒ�
	;;; �h�^,�k�^�E����p
	(setq #x (dimx_tile "slide1")
				#y (dimy_tile "slide1")
	)
	(start_image "slide1")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall1"))
	(end_image)

	;;; �h�^,�k�^������p
	(setq #x (dimx_tile "slide2")
				#y (dimy_tile "slide2")
	)
	(start_image "slide2")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall2"))
	(end_image)

	;;; �o�^�E����p
	(setq #x (dimx_tile "slide3")
				#y (dimy_tile "slide3")
	)
	(start_image "slide3")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall3"))
	(end_image)

	;;; �o�^������p
	(setq #x (dimx_tile "slide4")
				#y (dimy_tile "slide4")
	)
	(start_image "slide4")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall4"))
	(end_image)

	;;; �h�^�O����
	(setq #x (dimx_tile "slide5")
				#y (dimy_tile "slide5")
	)
	(start_image "slide5")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\Wall5"))
	(end_image)

	(setq #next 99)
	(while (and (/= #next 1) (/= #next 0))
	  (action_tile "radioILR"   "(##SetWallSizeDlg_SelectRadio 1)")
	  (action_tile "radioILL"   "(##SetWallSizeDlg_SelectRadio 2)")
	  (action_tile "radioPR"    "(##SetWallSizeDlg_SelectRadio 3)")
	  (action_tile "radioPL"    "(##SetWallSizeDlg_SelectRadio 4)")
	  (action_tile "radioI3"    "(##SetWallSizeDlg_SelectRadio 5)")
	  (action_tile "accept"     "(setq #size$ (##SetWallSizeDlg_CallBack))")
  	(action_tile "cancel"     "(setq #size$ nil) (done_dialog)")

	  (setq #next (start_dialog))
	)
  (unload_dialog #dcl_id)

	#size$

) ;AutoDrawWall_SetWallSizeDlg


;;;<HOM>*************************************************************************
;;; <�֐���>    : AutoDrawWall_MakeWall
;;; <�����T�v>  : �ǎ�����������
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2012/02/07 A.Satoh
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun AutoDrawWall_MakeWall (
	&wt_en			; �V�}�`��
	&size$			; �ǎ��������T�C�Y���F�ǎ��������T�C�Y�w���ʂ���̓��͏��
							;  (�ǃp�^�[���ԍ� �ǂw�̕� �ǂw�ƓV�̌��� �ǂx�̕� �ǂx�ƓV�̌��� �ǂy�̕� �ǂy�ƓV�̌��� �ǂ̌��� �ǂ̍���)
							;�@�@�ǃp�^�[���ԍ�
							;�@�@�@1:�h�^,�k�^�E����p
							;�@�@�@2:�h�^,�k�^������p
							;�@�@�@3:�o�^�E����p
							;�@�@�@4:�o�^������p
							;      5:�h�^�O����
  /
	#xd_WRKT$ #keijo #oku #tei #wt_BaseP #pt$ #lr_flg
	#p1 #p2 #p3 #p4 #p5 #p6 #wt_type #ang1 #ang2 #ang3
	#Name$ #idx #idx2 #BaseP #off_x #off_y #offset
	#Name #ang #sql #qry$ #msg #Type #fname #wk_p #dist #rad
	#xd_SYM$ #Wxd #Dxd #Hxd #Bxd #Wset #Dset #Hset #Bset
	#ss #angle #To_p #eNEW #dIns #strFLG #eget #orgLYR$ #emod
  )

	; �V�}�`�̃x�[�X��_�����o��
	(setq #xd_WRKT$ (CFGetXData &wt_en "G_WRKT"))
	(setq #keijo    (nth  3 #xd_WRKT$))  ; �`��
	(setq #lr_flg   (nth 30 #xd_WRKT$))  ; ���E����t���O
	(setq #wt_BaseP (nth 32 #xd_WRKT$))  ; WT����_
	(setq #tei      (nth 38 #xd_WRKT$))  ; WT��ʐ}�`�����
	(setq #pt$ (GetLWPolyLinePt #tei)) ; �O�`�_��
	(setq #oku      (car (nth 57 #xd_WRKT$)))  ; ���s

	; �O�`�_��&pt$��#BASEP��擪�Ɏ��v����ɂ���
	(setq #pt$ (GetPtSeries #wt_BaseP #pt$))

	(if (= #keijo 1)
		(progn		; �k�^�V�ł���ꍇ
			(setq #p1 (nth 0 #pt$))
			(setq #p2 (nth 1 #pt$))
			(setq #p3 (nth 2 #pt$))
			(setq #p4 (nth 3 #pt$))
			(setq #p5 (nth 4 #pt$))
			(setq #p6 (nth 5 #pt$))
		)
		(progn		; �h�^�܂��͂o�^�ł���ꍇ
			(setq #p1 (nth 0 #pt$))
			(setq #p2 (nth 1 #pt$))
			(setq #p3 (nth 2 #pt$))
			(setq #p4 (nth 3 #pt$))
		)
	)

	; ��̐}�`�����擾
	(setq #wt_type (car &size$))	; �ǃp�^�[���ԍ��𔲂��o��
	(cond
		((= #wt_type 1)		; �h�^,�k�^�E����p
			; �z�u�p�x�����߂�
			(if (= #keijo 1)
				; �k�^�ł���
				(if (= #lr_flg "R")
					(progn		; �E����ł���
						(setq #ang1 (atof (angtos (angle #p1 #p6))))
						(setq #ang2 (atof (angtos (angle #p1 #p2))))
					)
					(progn		; ������܂��͕s���ł���
						(setq #ang1 (atof (angtos (angle #p1 #p6))))
						(setq #ang2 (atof (angtos (angle #p1 #p2))))
					)
				)
				; �h�^�ł���
				(progn
					(setq #ang1 (atof (angtos (angle #p1 #p4))))
					(setq #ang2 (atof (angtos (angle #p1 #p2))))
				)
			)

			(setq #Name$ (list (list "�Ԏd�؂h�^LD" #ang1) (list "�Ԏd�؂h�^RU" #ang2) nil))
		)
		((= #wt_type 2)		; �h�^,�k�^������p
			; �z�u�p�x�����߂�
			(if (= #keijo 1)
				; �k�^�ł���
				(if (= #lr_flg "L")
					(progn	; ������ł���
						(setq #ang1 (atof (angtos (angle #p1 #p2))))
						(setq #ang2 (atof (angtos (angle #p1 #p6))))
					)
					(progn	; �E����܂��͕s���ł���
						(setq #ang1 (atof (angtos (angle #p1 #p2))))
						(setq #ang2 (atof (angtos (angle #p1 #p6))))
					)
				)
				; �h�^�ł���
				(progn
					(setq #ang1 (atof (angtos (angle #p2 #p3))))
					(setq #ang2 (atof (angtos (angle #p2 #p1))))
				)
			)

			(setq #Name$ (list (list "�Ԏd�؂h�^RU" #ang1) (list "�Ԏd�؂h�^LD" #ang2) nil))
		)
		((= #wt_type 3)		; �o�^�E����p
			; �z�u�p�x�����߂�
			(setq #ang1 (atof (angtos (angle #p1 #p4))))

			(setq #Name$ (list (list "�Ԏd�؂h�^LD" #ang1) nil nil))
		)
		((= #wt_type 4)		; �o�^������p
			; �z�u�p�x�����߂�
			(setq #ang1 (atof (angtos (angle #p2 #p3))))

			(setq #Name$ (list (list "�Ԏd�؂h�^RU" #ang1) nil nil))
		)
		((= #wt_type 5)		; �h�^�O����
			; �z�u�p�x�����߂�
			(setq #ang1 (atof (angtos (angle #p1 #p4))))
			(setq #ang2 (atof (angtos (angle #p1 #p2))))
			(setq #ang3 (atof (angtos (angle #p2 #p3))))

			(setq #Name$ (list (list "�Ԏd�؂h�^LD" #ang1) (list "�Ԏd�؂h�^RU" #ang2) (list "�Ԏd�؂h�^RU" #ang3)))
		)
	)

	(setq #idx 0)
	(repeat (length #Name$)
		(if (/= (nth #idx #Name$) nil)
			(progn
				(cond
					((= #wt_type 1)		; �h�^,�k�^�E����p
						(if (= #idx 0)
							(progn
								; �z�u��_�����߂�
								(setq #BaseP #wt_BaseP)

								; �ǐ}�`�̈ړ���
								(setq #off_x (nth 4 &size$))
								(setq #off_y (nth 2 &size$))
							)
							(progn
								; �z�u��_�����߂�
								(setq #BaseP #wt_BaseP)

								; �ǐ}�`�̈ړ���
								(setq #off_x (+ (nth 4 &size$) (nth 7 &size$)))
								(setq #off_y (nth 2 &size$))
							)
						)
					)
					((= #wt_type 2)		; �h�^,�k�^������p
						(if (= #idx 0)
							(progn
								; �z�u��_�����߂�
								(if (= #keijo 1)
									(setq #BaseP #wt_BaseP)
									(setq #BaseP #p2)
								)

								; �ǐ}�`�̈ړ���
								(setq #off_x (nth 4 &size$))
								(setq #off_y (nth 2 &size$))
							)
							(progn
								; �z�u��_�����߂�
								(if (= #keijo 1)
									(setq #BaseP #wt_BaseP)
									(setq #BaseP #p2)
								)

								; �ǐ}�`�̈ړ���
								(setq #off_x (+ (nth 4 &size$) (nth 7 &size$)))
								(setq #off_y (nth 2 &size$))
							)
						)
					)
					((= #wt_type 3)		; �o�^�E����p
						; �z�u��_�����߂�
						(setq #BaseP #wt_BaseP)

						; �ǐ}�`�̈ړ���
						(setq #off_x (nth 4 &size$))
						(setq #off_y 0)
						(setq #offset (/ (- (nth 3 &size$) #oku) 2))
					)
					((= #wt_type 4)		; �o�^������p
						; �z�u��_�����߂�
						(setq #BaseP #p2)

						; �ǐ}�`�̈ړ���
						(setq #off_x (nth 4 &size$))
						(setq #off_y 0)
						(setq #offset (/ (- (nth 3 &size$) #oku) 2))
					)
					((= #wt_type 5)
						(cond
							((= #idx 0)
								; �z�u��_���X�V����
								(setq #BaseP #wt_BaseP)

								; �ǐ}�`�̈ړ���
								(setq #off_x (nth 4 &size$))
								(setq #off_y (nth 2 &size$))
							)
							((= #idx 1)
								(setq #BaseP #wt_BaseP)

								; �ǐ}�`�̈ړ���
								(setq #off_x (+ (nth 4 &size$) (nth 7 &size$)))
								(setq #off_y (nth 2 &size$))
							)
							((= #idx 2)
								; �z�u��_���X�V����
								(setq #BaseP #p2)

								; �ǐ}�`�̈ړ���
								(setq #off_x (nth 6 &size$))
								(setq #off_y (nth 2 &size$))
							)
						)
					)
				)

				(setq #Name (nth 0 (nth #idx #Name$)))
				(setq #ang  (nth 1 (nth #idx #Name$)))

				; ��̐}�`�����擾
				(setq #sql (strcat "select * from ��̐}�` where ��̖���='" #Name "'"))
				(setq #qry$ (car (DBSqlAutoQuery CG_CDBSession #sql)))
				(if (= #qry$ nil)
					(progn
						(setq #msg "  AutoDrawWall_SetKUTAI:�w��̐}�`�x��������܂���ł���")
						(CFOutStateLog 0 1 #msg)
						(CFOutStateLog 0 1 (strcat "        " #sql))
						(CFAlertMsg #msg)
						(exit)
					)
				)

				; �������
				(setq #Type  (fix (nth 2 #qry$)))

				; �}�`ID�擾
				(setq #fname (nth 15 #qry$))

			  ; ��}�p�̉�w�ݒu
				(MakeLayer "Z_00_00_00_01" 7 "CONTINUOUS")

				(Pc_CheckInsertDwg (strcat #fname ".dwg") CG_MSTDWGPATH)

				; �z�u�ʒu�𒲐�����
				(cond
					((= #idx 0)
						(cond
							((= #wt_type 1)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 2)
								(setq #wk_p (list #off_x #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(if (= #keijo 1)
									(setq #rad (+ (angle #p6 #p1) (angle '(0 0) #wk_p)))
									(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								)
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 3)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 4)
								(setq #wk_p (list #off_x #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 5)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
						)
					)
					((= #idx 1)
						(cond
							((= #wt_type 1)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 2)
								(setq #wk_p (list #off_x #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(if (= #keijo 1)
									(setq #rad (+ (angle #p6 #p1) (angle '(0 0) #wk_p)))
									(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								)
								(setq #BaseP (polar #BaseP #rad #dist))
							)
							((= #wt_type 5)
								(setq #wk_p (list (* #off_x -1) #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
						)
					)
					((= #idx 2)
						(if (= #wt_type 5)
							(progn
								(setq #wk_p (list #off_x #off_y))
								(setq #dist (distance '(0 0) #wk_p))
								(setq #rad (+ (angle #p1 #p2) (angle '(0 0) #wk_p)))
								(setq #BaseP (polar #BaseP #rad #dist))
							)
						)
					)
				)

				; ��̐}�`�̔z�u
				(command ".insert" (strcat CG_MSTDWGPATH #fname) #BaseP 1 1 #ang) 

				(command "_explode" (entlast))
				(setq #ss (ssget "P"))

				; �o�^�E���薔�͂o�^������ł���ꍇ
				(if (or (= #wt_type 3) (= #wt_type 4))
					(progn
						; ��̐}�`���ړ�����i�ǂ����s�ɑ΂��ċϓ��ɔz�u�j
						;;; �ړ��ʒu�����߂�
						(setq #angle (+ #ang 180))
						(if (>= #angle 360)
							(setq #angle (- #angle 360))
						)
						(setq #To_p (polar #BaseP (angtof (rtos #angle 2 2)) #offset))

						; ��̐}�`���ړ�
						(command "_.MOVE" #ss "" #BaseP #To_p)
					)
				)

				(SKMkGroup #ss)
				(command "_layer" "u" "N_*" "")
				(setq #eNEW (SearchGroupSym (ssname #ss 0)))
				(setq #dIns (cdr (assoc 10 (entget #eNEW))))

				; XData G_SYM ����K�v���擾
				(setq #xd_SYM$ (CFGetXData #eNEW "G_SYM"))
				(setq #Wxd (nth 3 #xd_SYM$))
				(setq #Dxd (nth 4 #xd_SYM$))
				(setq #Hxd (nth 5 #xd_SYM$))
				(setq #Bxd (nth 6 #xd_SYM$))

				; �ǃT�C�Y�̐ݒ�
				(cond
					((= #idx 0)
						(setq #Wset (nth 3 &size$))		; �Ǖ��x���g�p
					)
					((= #idx 1)
						(setq #Wset (nth 1 &size$))		; �Ǖ��w���g�p
					)
					((= #idx 2)
						(setq #Wset (nth 5 &size$))		; �Ǖ��y���g�p
					)
				)
				(setq #Dset (nth 7 &size$))
				(setq #Hset (nth 8 &size$))
				(setq #Bset #Bxd)

				(setvar "ELEVATION" #Bset)

				; XDATA�ݒ�
			  (if (= nil (tblsearch "APPID" "G_LSYM")) (regapp "G_LSYM"))

				(CFSetXData #eNew "G_LSYM"
					(list
						#fname                    ;  1:�{�̐}�`ID      :�w�i�Ԑ}�`�x.�}�`ID
						#dIns                     ;  2:�}���_          :�z�u��_
						(angtof (rtos #ang 2 2))  ;  3:��]�p�x        :�z�u��]�p�x
						CG_KCode                  ;  4:�H��L��        :CG_Kcode
						CG_SeriesCode             ;  5:SERIES�L��    :CG_SeriesCode
						#Name                     ;  6:�i�Ԗ���        :�w�i�Ԑ}�`�x.�i�Ԗ���
						"Z"                       ;  7:L/R�敪         :�w�i�Ԑ}�`�x.����L/R�敪
						""                        ;  8:���}�`ID        :
						""                        ;  9:���J���}�`ID    :
						999                       ; 10:���iCODE      :�w�i�Ԋ�{�x.���iCODE
						0                         ; 11:�����t���O      :�O�Œ�i�P�ƕ��ށj
						0                         ; 12:�z�u���ԍ�      :�z�u���ԍ�(1�`)
						0                         ; 13:�p�r�ԍ�        :�w�i�Ԑ}�`�x.�p�r�ԍ�
						#Hxd                      ; 14:���@�g          :�w�i�Ԑ}�`�x.���@�g
						0                         ; 15:�f�ʎw���̗L��  :�w�v���\���x.�f�ʗL�� 00/07/18 SN MOD
					)
				)

				(if (= nil (tblsearch "APPID" "G_KUTAI")) (regapp "G_KUTAI"))

				; ��̃^�C�v��ݒ肷��
				(CFSetXData #eNew "G_KUTAI" (list #Type))

			  ; �L�k�֘A����
				(CFCmdDefStart 0)
				(setq #strFLG nil)

				; �ύX�̂��������������L�k���Ă���
				(if (not (equal #Wxd #Wset 0.0001))
					(progn
						(setq #strFLG 'T)
						(SKY_Stretch_Parts #eNEW #Wset #Dxd #Hxd)
						; �c�L�k�ɂƂ��Ȃ��ʒu�ړ� (W�t���O= -1�̃A�C�e��)
						(if (= -1 (nth 8 #xd_SYM$))
							(PcMoveItem #eNEW #dIns)
						)
					)
				)

				(if (not (equal #Dxd #Dset 0.0001))
					(progn
						(setq #strFLG 'T)
						(SKY_Stretch_Parts #eNEW #Wset #Dset #Hxd)

						; �c�L�k�ɂƂ��Ȃ��ʒu�ړ� (D�t���O= -1�̃A�C�e��)
						(if (= -1 (nth 9 #xd_SYM$))
							(PcMoveItem #eNEW #dIns)
						)
					)
				)

				(if (not (equal #Hxd #Hset 0.0001))
					(progn
						(setq #strFLG 'T)
						(SKY_Stretch_Parts #eNEW #Wset #Dset #Hset)

						; �c�L�k�ɂƂ��Ȃ��ʒu�ړ� (H�t���O= -1�̃A�C�e��)
						(if (= -1 (nth 10 #xd_SYM$))
							(PcMoveItem #eNEW #dIns)
						)
					)
				)

				; �L�k�����������ꍇ�A�O���[�v����"G_PRIM"������3DSOLID�č\��
				(if (not #strFLG)
					(setq #eNEW (KcRemakePrimInGroup #eNEW))
				)

				(CFCmdDefEnd);�ů�ߊ֘A��߂�

				; XDATA�ݒ� G_SYM�͐L�k�����œ��e�ύX�����ׁA�L�k��Đݒ肷��B
				(CFSetXData #eNew "G_SYM"
					(list
						(nth  0 #xd_SYM$)		; �V���{������
						(nth  1 #xd_SYM$)		; �R�����g�P
						(nth  2 #xd_SYM$)		; �R�����g�Q
						(nth  3 #xd_SYM$)		; �V���{����l�v
						(nth  4 #xd_SYM$)		; �V���{����l�c
						(nth  5 #xd_SYM$)		; �V���{����l�g
						(nth  6 #xd_SYM$)		; �V���{����t������
						(nth  7 #xd_SYM$)		; ���͕��@
						(nth  8 #xd_SYM$)		; �v�����t���O
						(nth  9 #xd_SYM$)		; �c�����t���O
						(nth 10 #xd_SYM$)		; �g�����t���O
						; �L�k�t���O�v
			      (if (equal #Wxd #Wset 0.0001)
							(nth 11 #xd_SYM$)
							#Wset
						)
						; �L�k�t���O�c
						(if (equal #Dxd #Dset 0.0001)
							(nth 12 #xd_SYM$)
							#Dset
						)
						; �L�k�t���O�g
						(if (equal #Hxd #Hset 0.0001)
							(nth 13 #xd_SYM$)
							#Hset
						)
						(nth 14 #xd_SYM$)		; �u���[�N���C�����v
						(nth 15 #xd_SYM$)		; �u���[�N���C�����c
						(nth 16 #xd_SYM$)		; �u���[�N���C�����g
					)
				)

				; ��̂̉�w��Z_00_00_00_01����Z_KUTAI�ɕύX����(�L�k��Ƃ̌�ɍs������)
				(MakeLayer "Z_KUTAI" 7 "CONTINUOUS")
				(setq #idx2 0)
				(setq #ss (CFGetSameGroupSS #eNEW))
				(repeat (sslength #ss)
					(setq #eget (entget (ssname #ss #idx2)(list "*")))
					(setq #orgLYR$ (assoc 8 #eget))

					; ��wZ_00_00_00_01��̐}�`, �ڒn�}�` ��w M_* ���Ώ�
					(if (and #orgLYR$ (wcmatch (cdr #orgLYR$) "M_*,Z_00_00_00_01"))
						(progn
							(setq #emod (subst (cons 8 "Z_KUTAI") #orgLYR$  #eget))
							(setq #emod (subst (cons 62 256) (assoc 62 #emod) #emod))
							(entmod #emod)
						)
					)

					(setq #idx2 (1+ #idx2))
			  )
			)
		)

		(setq #idx (1+ #idx))
	)

) ; AutoDrawWall_MakeWall
;-- 2012/02/07 A.Satoh Add - E


;-- 2012/03/05 A.Satoh Add - S
;;;<HOM>*************************************************************************
;;; <�֐���>    : AutoDrawWall_SetWallSizeDlg
;;; <�����T�v>  : CG�p�ǐݒ��_�C�A���O����
;;; <�߂�l>    : (��I�t�Z�b�g�l ���I�t�Z�b�g�l ���I�t�Z�b�g�l �E�I�t�Z�b�g�l) or nil
;;; <�쐬>      : 2012/03/05 A.Satoh
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun SetCGWallDlg (
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
	&allWhite   ; �w�i�F���t���O  1:�w�i�F��  0:�w�i�F�F�ȊO
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
  /
	#offset$ #dcl_id #x #y #next
  )

	;***********************************************************************
	; �n�j�{�^����������
	; �߂�l:�ǃI�t�Z�b�g��񃊃X�g
	;        (��I�t�Z�b�g�l ���I�t�Z�b�g�l ���I�t�Z�b�g�l �E�I�t�Z�b�g�l �Ɩ��̋������x��)
	;***********************************************************************
	(defun ##SetCGWallDlg_CallBack (
		/
		#err_flag #ret$ #UpOffset #DnOffset #LfOffset #RtOffset
		#radioLv1 #radioLv2 #radioLv3 #radioLv4 #radioLv5 #radio  ;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή�

		)

    (setq #err_flag nil)
		(setq #ret$ nil)

		; �I�t�Z�b�g���͒l���擾
		(setq #UpOffset (get_tile "UpOffset"))		; ��I�t�Z�b�g�l
		(setq #DnOffset (get_tile "DnOffset"))		; ���I�t�Z�b�g�l
		(setq #LfOffset (get_tile "LfOffset"))		; ���I�t�Z�b�g�l
		(setq #RtOffset (get_tile "RtOffset"))		; �E�I�t�Z�b�g�l

		; ��I�t�Z�b�g�l���̓`�F�b�N
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
		(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
			(if (or (= #UpOffset "") (= #UpOffset nil))
				(progn
					(set_tile "error" "[��I�t�Z�b�g�l]�����͂���Ă��܂���")
					(mode_tile "UpOffset" 2)
					(setq #err_flag T)
				)
				(if (or (= (type (read #UpOffset)) 'INT) (= (type (read #UpOffset)) 'REAL))
					(if (> 0 (read #UpOffset))
						(progn
							(set_tile "error" "[��I�t�Z�b�g�l]�ɂ�0�ȏ�̐��l����͂��ĉ�����")
							(mode_tile "UpOffset" 2)
							(setq #err_flag T)
						)
					)
					(progn
						(set_tile "error" "[��I�t�Z�b�g�l]�ɂ͐��l����͂��ĉ�����")
						(mode_tile "UpOffset" 2)
						(setq #err_flag T)
					)
				)
			)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
		)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E

		(if (= #err_flag nil)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
			(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
				; ���I�t�Z�b�g�l���̓`�F�b�N
				(if (or (= #DnOffset "") (= #DnOffset nil))
					(progn
						(set_tile "error" "[���I�t�Z�b�g�l]�����͂���Ă��܂���")
						(mode_tile "DnOffset" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #DnOffset)) 'INT) (= (type (read #DnOffset)) 'REAL))
						(if (> 0 (read #DnOffset))
							(progn
								(set_tile "error" "[���I�t�Z�b�g�l]�ɂ�0�ȏ�̐��l����͂��ĉ�����")
								(mode_tile "DnOffset" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[���I�t�Z�b�g�l]�ɂ͐��l����͂��ĉ�����")
							(mode_tile "DnOffset" 2)
							(setq #err_flag T)
						)
					)
				)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
			)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
		)

		(if (= #err_flag nil)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
			(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
				; ���I�t�Z�b�g�l���̓`�F�b�N
				(if (or (= #LfOffset "") (= #LfOffset nil))
					(progn
						(set_tile "error" "[���I�t�Z�b�g�l]�����͂���Ă��܂���")
						(mode_tile "LfOffset" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #LfOffset)) 'INT) (= (type (read #LfOffset)) 'REAL))
						(if (> 0 (read #LfOffset))
							(progn
								(set_tile "error" "[���I�t�Z�b�g�l]�ɂ�0�ȏ�̐��l����͂��ĉ�����")
								(mode_tile "LfOffset" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[���I�t�Z�b�g�l]�ɂ͐��l����͂��ĉ�����")
							(mode_tile "LfOffset" 2)
							(setq #err_flag T)
						)
					)
				)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
			)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
		)

		(if (= #err_flag nil)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
			(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
				; �E�I�t�Z�b�g�l���̓`�F�b�N
				(if (or (= #RtOffset "") (= #RtOffset nil))
					(progn
						(set_tile "error" "[�E�I�t�Z�b�g�l]�����͂���Ă��܂���")
						(mode_tile "RtOffset" 2)
						(setq #err_flag T)
					)
					(if (or (= (type (read #RtOffset)) 'INT) (= (type (read #RtOffset)) 'REAL))
						(if (> 0 (read #RtOffset))
							(progn
								(set_tile "error" "[�E�I�t�Z�b�g�l]�ɂ�0�ȏ�̐��l����͂��ĉ�����")
								(mode_tile "RtOffset" 2)
								(setq #err_flag T)
							)
						)
						(progn
							(set_tile "error" "[�E�I�t�Z�b�g�l]�ɂ͐��l����͂��ĉ�����")
							(mode_tile "RtOffset" 2)
							(setq #err_flag T)
						)
					)
				)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
			)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
		)

;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
		(if (= #err_flag nil)
			(progn
				; �u�Ɩ��̋����v���W�I�{�^�����͒l���擾
				(setq #radioLv1 (get_tile "radioLv1"))		; ����
				(setq #radioLv2 (get_tile "radioLv2"))		; ��⋭��
				(setq #radioLv3 (get_tile "radioLv3"))		; ����
				(setq #radioLv4 (get_tile "radioLv4"))		; ���ア
				(setq #radioLv5 (get_tile "radioLv5"))		; �ア

				(cond
					((= #radioLv1 "1")		; ����
						(setq #radio "1")
					)
					((= #radioLv2 "1")		; ��⋭��
						(setq #radio "2")
					)
					((= #radioLv3 "1")		; ����
						(setq #radio "3")
					)
					((= #radioLv4 "1")		; ���ア
						(setq #radio "4")
					)
					((= #radioLv5 "1")		; �ア
						(setq #radio "5")
					)
					(T
						(set_tile "error" "[�Ɩ��̋���]���I������Ă��܂���")
						(mode_tile "radioLv1" 2)
						(setq #err_flag T)
					)
				)
			)
		)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E

		; �ǃI�t�Z�b�g��񃊃X�g�̍쐬
		(if (= #err_flag nil)
			(progn
				; ��񃊃X�g�쐬
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
				(if (= &allWhite "0")
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
					(setq #ret$ (list #UpOffset #DnOffset #LfOffset #RtOffset #radio))
					(setq #ret$ (list "0" "0" "0" "0" #radio))
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
				)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E
				(done_dialog)
				#ret$
			)
		)

	) ; ##SetWallSizeDlg_CallBack
	;***********************************************************************

	(setq #offset$ nil)

  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "Kscmain.dcl")))
  (if (not (new_dialog "SetCGWallDlg" #dcl_id)) (exit))

	; �_�C�A���O�����ݒ�
;-- 2012/03/19 A.Satoh Del �����l����̈˗� - S
;;;;;	(set_tile "UpOffset" "")			; ��I�t�Z�b�g�l
;;;;;	(set_tile "DnOffset" "")			; ���I�t�Z�b�g�l
;;;;;	(set_tile "LfOffset" "")			; ���I�t�Z�b�g�l
;;;;;	(set_tile "RtOffset" "")			; �E�I�t�Z�b�g�l
;-- 2012/03/19 A.Satoh Del �����l����̈˗� - E

;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - S
	(if (= &allWhite "1")
		(progn
;-- 2012/03/19 A.Satoh Add �����l����̈˗� - S
			(set_tile "UpOffset" "")			; ��I�t�Z�b�g�l
			(set_tile "DnOffset" "")			; ���I�t�Z�b�g�l
			(set_tile "LfOffset" "")			; ���I�t�Z�b�g�l
			(set_tile "RtOffset" "")			; �E�I�t�Z�b�g�l
;-- 2012/03/19 A.Satoh Add �����l����̈˗� - E
			(mode_tile "UpOffset" 1)			; ��I�t�Z�b�g�l
			(mode_tile "DnOffset" 1)			; ���I�t�Z�b�g�l
			(mode_tile "LfOffset" 1)			; ���I�t�Z�b�g�l
			(mode_tile "RtOffset" 1)			; �E�I�t�Z�b�g�l
		)
		(progn
;-- 2012/03/19 A.Satoh Add �����l����̈˗� - S
			(set_tile "UpOffset" "0")			; ��I�t�Z�b�g�l
			(set_tile "DnOffset" "0")			; ���I�t�Z�b�g�l
			(set_tile "LfOffset" "0")			; ���I�t�Z�b�g�l
			(set_tile "RtOffset" "0")			; �E�I�t�Z�b�g�l
;-- 2012/03/19 A.Satoh Add �����l����̈˗� - E
			(mode_tile "UpOffset" 0)			; ��I�t�Z�b�g�l
			(mode_tile "DnOffset" 0)			; ���I�t�Z�b�g�l
			(mode_tile "LfOffset" 0)			; ���I�t�Z�b�g�l
			(mode_tile "RtOffset" 0)			; �E�I�t�Z�b�g�l
		)
	)
;-- 2012/03/15 A.Satoh Add �Ɩ��̋����Ή� - E

;-- 2012/03/28 A.Satoh Mod �����l����̈˗� �Ɩ�������S�Ďg����悤�� - S
;;;;;;-- 2012/03/19 A.Satoh Add �����l����̈˗� - S
;;;;;	(mode_tile "radioLv4" 1)			; �Ɩ��̋����F���ア
;;;;;	(mode_tile "radioLv5" 1)			; �Ɩ��̋����F�ア
;;;;;;-- 2012/03/19 A.Satoh Add �����l����̈˗� - E
;-- 2012/03/28 A.Satoh Mod �����l����̈˗� �Ɩ�������S�Ďg����悤�� - E

	; �X���C�h�ݒ�
	(setq #x (dimx_tile "slide1")
				#y (dimy_tile "slide1")
	)
	(start_image "slide1")
	(fill_image 0 0 #x #y 0)
	(slide_image 0 0 #x #y (strcat CG_SYSPATH "SLD\\CG��"))
	(end_image)

	(setq #next 99)
	(while (and (/= #next 1) (/= #next 0))
	  (action_tile "accept" "(setq #offset$ (##SetCGWallDlg_CallBack))")
  	(action_tile "cancel" "(setq #offset$ nil) (done_dialog)")

	  (setq #next (start_dialog))
	)
  (unload_dialog #dcl_id)

	#offset$

) ;SetCGWallDlg
;-- 2012/03/05 A.Satoh Add - E


(princ)
