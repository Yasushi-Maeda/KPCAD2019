;<HOM>*************************************************************************
; <�֐���>    : SearchPlanSB
; <�����T�v>  : �o�X�v��������
; <�߂�l>    :
; <�쐬>      : 1999-06-14
; <���l>      :
;*************************************************************************>MOH<
(defun C:SBSearchPlan ()
  (defun TempErr (msg)
    (CFAlertMsg "�v���������Ɏ��s���܂����B")
    (command "_undo" "b")
    (setq *error* nil)
    (princ)
  )
  (if CG_DEBUG
    (setq *error* nil)
    (progn
      (StartUndoErr)
      (setq *error* TempErr)
    )
  )
  ;// �V�X�e���o�X�v����������ʂ̕\��
  (C:SearchPlanSBFORM)

  ;//-----------------------------------------------------------
  ;// �v���������_�C�A���O�ɂďo�͂��ꂽ�����擾����
    (if (ReadIniFile (strcat CG_SYSPATH "SRCPLN.CFG"))
      (SB_SearchPlanNewDWG)
  )
  (setq *error* nil)
  (princ)
)

;<HOM>*************************************************************************
; <�֐���>    : SB_SearchPlanNewDWG
; <�����T�v>  : �v���������p�̐V�K�}�ʂ��J��
; <�߂�l>    : �Ȃ�
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun SB_SearchPlanNewDWG (
    /
    #family$$
  )
  ;// �����ۑ�
  (CFAutoSave)
  (command "_point" "0,0")
  ;// �t�@�~���[�R�[�h��ݒ肷��
  (setq #family$$ (ReadIniFile (strcat CG_SYSPATH "SRCPLN.CFG")))
  (SBG_SetFamilyCode #family$$)

  ;(setq CG_OPENMODE 3)    ;�o�X
  (C:SB_LayoutPlan)
  ;(command "_new" ".")
  ;// �V�K�}�ʃI�[�v����AAcad.lsp ����v��������(C:SB_LayoutPlan)���s��
)


;<HOM>*************************************************************************
; <�֐���>    : SBSetFamilyCode
; <�����T�v>  : ���͏����O���[�o���t�@�~���[�i��
; <�߂�l>    :
; <�쐬>      : 1998-11-12
; <���l>      :
;*************************************************************************>MOH<
(defun SBG_SetFamilyCode (
    &family$$    ;(LIST)�v����������ʂ̓��͏��
    /
    #f
    #sql #qry #series #dseries #color #lst$ #key #fcfg$ #fcfg$$ #tmp$$
  )
  (setq CG_INCNO "00")
  (setq CG_SBOUTPATH (strcat CG_KENMEI_PATH "OUTPUT\\"))
  (setq CG_OUTPUTTYPE "DWG")

  ;//----------------------------------------------------------------
  ;// �e��O���[�o���ϐ��Ɋi�[
  (setq CG_FamilyCode (cadr (assoc "FamilyCode"   &family$$)))  ;�t�@�~���[�i��
  (setq CG_WOffset    (atoi (cadr (assoc "SERIBW" &family$$)))) ;���j�b�g�I�t�Z�b�g��W

  (setq CG_GROVALZNO  "111")              ;�o�͐}�ʎ�ޏ��
  (setq CG_KoujiKind  "1�K�V�X�e���o�X")

  ;// SRCPLN.CFG�̏��
  (setq CG_DBName       (cadr (assoc "SERIDB" &family$$)))         ;�f�[�^�x�[�X���� "sb_sua"
  (setq CG_Hinmoku      "SB")                                      ;�i��             "SB"
  (setq CG_BaseOffset   (atof (cadr (assoc "SERIBW" &family$$))))  ;����@          77
  (setq CG_WPanelThk    (atof (cadr (assoc "SERIWW" &family$$))))  ;���ٌ���          33
  (setq CG_DOffset      (atof (cadr (assoc "SERIBD" &family$$))))  ;D����@         70.5
  (setq CG_DPanelThk    (atof (cadr (assoc "SERIWD" &family$$))))  ;D���ٌ���         39.5
  (setq CG_SeriesCode   (cadr (assoc "SERIES"       &family$$)))   ;SERIES�R�[�h
  (setq CG_SeriesFolder (cadr (assoc "SERIFOLDER"   &family$$)))   ;SERIES���̃t�H���_�[
  (setq CG_SeriesName   (cadr (assoc "SERINAME"     &family$$)))   ;SERIES����

  (setq CG_Kouhou (cadr (assoc (strcat CG_SeriesCode "B32")  &family$$)))  ;���z�H�@
  (setq CG_CeilHeight 2179)                      ;�V�䍂��

  (CFOutLog 1 nil "")
  (CFOutLog 1 nil (strcat "  +�t�@�~���[�i��:" CG_FamilyCode))
  (CFOutLog 1 nil "")
  (CFOutLog 1 nil (strcat "  +�H�@: "          CG_Kouhou))
  (CFOutLog 1 nil (strcat "  +�Ưĵ̾�ė�W: "  (itoa CG_WOffset)))
  (CFOutLog 1 nil (strcat "  +�H�����: "      CG_KoujiKind))
  (CFOutLog 1 nil (strcat "  +�����ԍ�: "      CG_BukkenNo))
  (CFOutLog 1 nil (strcat "  +��������: "      CG_BukkenName))

  ;//-----------------------------------------------------------
  ;// ���ʃf�[�^�x�[�X�ւ̐ڑ�
  (if (= CG_CDBSESSION nil)
    (setq CG_CDBSESSION (dbconnect CG_CDBNAME "" ""))
  )
  ;// SERIES�ʃf�[�^�x�[�X�̐ڑ�
  (if (/= CG_DBSESSION nil)
    (dbDisconnect CG_DBSESSION)
  )
  (setq CG_DBSESSION (DBConnect CG_DBNAME "" ""))
  (if (= CG_DBSESSION nil)
    (CFAlertErr "ODBC���������ݒ肳��Ă��邩�m�F���ĉ�����")
  )

  (CFOutLog 1 nil (strcat "  +DB����:    "  CG_DBName))
  (CFOutLog 1 nil (strcat "  +�i��:      "  CG_Hinmoku))
  (CFOutLog 1 nil (strcat "  +�ذ�޺���: "  CG_SeriesCode))
  (CFOutLog 1 nil (strcat "  +�ذ��̫���: " CG_SeriesFolder))

  ;// SERIES�ʃt�H���_�[�̃`�F�b�N
  (if (not (dos_subdir (strcat CG_SBDATAPATH CG_SeriesFolder)))
    (CFAlertErr "SBSetFamilyCode:SERIES���̃t�H���_�[�����݂��܂���")
  )

  ;//----------------------------------------------------------------
  ;// SB�����e�[�u�������擾����
  ;    LAYOUT              123456789012345678901234567890123456789
  ;    �t�@�~���[�i�ԗ�    SUA-GF1216NN/N#ACA+JBGNNNNNBABNBANN
  ;
  ;      -> (("SUAB01" "SUA"�@"SERIES") ("SUAB02" "G" "�O���[�h") ....)
  (setq CG_FamilyInfo$$ (SBG_GetTokusei CG_FamilyCode)) ;SB���������擾����

  ;-------------------------------------------------------------
  ;                    0        1         2         3
  ;LAYOUT              123456789012345678901234567890123456789
  ;�t�@�~���[�i�ԗ�    SUA-GF1216NN/N#ACA+JBGNNNNNBABNBANN

  ;// �T�C�Y�R�[�h�A�h�A�R�[�h�A���f�����A�p�b�P�[�W�����O���[�o���ϐ��Ɋi�[
  (setq CG_BrandCode  "NR")                                                  ;�u�����h�R�[�h�i���g�p�j
  (setq CG_SizeCode   (cadr  (assoc (strcat CG_SeriesCode "B04") CG_FamilyInfo$$))) ;�T�C�Y�R�[�h
  (setq CG_DoorCode   (cadr  (assoc (strcat CG_SeriesCode "B11") CG_FamilyInfo$$))) ;�h�A�R�[�h
  (setq CG_DoorLR     (caddr (assoc (strcat CG_SeriesCode "B11") CG_FamilyInfo$$))) ;�h�A���E�R�[�h
  (setq CG_ModelName (strcat
    (cadr (assoc (strcat CG_SeriesCode "B01") CG_FamilyInfo$$)) "-"
    (cadr (assoc (strcat CG_SeriesCode "B03") CG_FamilyInfo$$)) " "
    (cadr (assoc (strcat CG_SeriesCode "B04") CG_FamilyInfo$$)) " "
    (cadr (assoc (strcat CG_SeriesCode "B11") CG_FamilyInfo$$))
  ))


  (setq CG_PackName (substr CG_FamilyCode 5))    ;�p�b�P�[�W����


  (CFOutLog 1 nil (strcat "  +�߯���ޖ���: "  CG_PackName))

  ;//--------------------------------------------------
  ;// ���ʃf�[�^�x�[�X�̐ڑ�����
  (if (/= CG_DBSESSION nil)
    (progn
      (DBDisConnect CG_DBSESSION)
      (setq CG_DBSESSION nil)
    )
  )
)
;SBG_SetFamilyCode

;<HOM>*************************************************************************
; <�֐���>    : SBG_GetTokusei
; <�����T�v>  : �����c�a���擾����
; <�߂�l>    :
;        LIST : (����ID �ϊ��l �⑫�l �@�\��)�̃��X�g
;               (("SUAB01" "SUA" "" "SERIES") ("SUAB02" "G" "" "�O���[�h") ....)
; <�쐬>      : 1998-06-16
; <���l>      :
;*************************************************************************>MOH<
(defun SBG_GetTokusei (
    &family    ;(STR)�t�@�~���[�i�ԕ�����
    /
    #sql #qry$ #qry$$ #key #str1 #str2 #tmp$ #kinou #id #family$$ #str
  )

  ;// ���݂̃o�[�W������SB�����e�[�u�����擾
  (setq #key CG_SeriesCode)
  (setq #sql (strcat "select \"����ID\",\"�@�\��\",\"�����ʒu\",\"�T�C�Y\" from SB���� where ����ID like '" #key "B__'"))
  (setq #qry$$ (DBSqlAutoQuery CG_DBSession #sql))
  (if (= #qry$$ nil)
    (progn
      (CFOutStateLog 0 1 "  SKGetTokusei:�wSB�����x��������܂���ł���")
      (CFOutStateLog 0 1 (strcat "        " #sql))
    )
  )

  ;// ����ID�ƒl��ؽĂɕϊ����� (("SUAB01" "???") ....)
  (foreach #qry$ #qry$$
    (setq #id    (car #qry$))        ;����ID
    (setq #kinou (cadr #qry$))       ;�@�\��
    (if (or (= (nth 2 #qry$) nil) (= (nth 2 #qry$) 0))
      (setq #str "")
      (progn
        (setq #str1 "")
        (setq #str2 "")
        ;// SB�����l�e�[�u���ɂ��A�l��ϊ�����
        (setq #str1 (substr &family (fix (nth 2 #qry$)) (fix (nth 3 #qry$))))
        (setq #qry$
          (car
            (CFGetDBSQLRec CG_DBSESSION "SB�����l"
              (list
                (list "����ID" #id 'STR)
                (list "�����l" #str1 'STR)
              )
            )
          )
        )
        (if (= #qry$ nil)
          (progn
            (CFOutStateLog 0 1 (strcat "        " #sql))
          )
          (progn
            (setq #str1 (ai_strtrim (nth 4 #qry$)))
            (setq #str2 (ai_strtrim (nth 5 #qry$)))
          )
        )
      )
    )
    (if (= (substr #id 5 2) "32")   ;��̕��H�@��Input.CFG�̌��z�H�@�Ƃ���
      (setq #family$$ (append #family$$ (list (list #id CG_Kouhou #str2 (ai_strtrim #kinou)))))
      (setq #family$$ (append #family$$ (list (list #id #str1 #str2 (ai_strtrim #kinou)))))
    )
  )
  #family$$
)
;SBG_GetTokusei

;<HOM>*************************************************************************
; <�֐���>    : SBG_GetSeriesTable
; <�����T�v>  : ���݂�SERIES�����擾����
; <�߂�l>    :
;        LIST : �V���ǃe�[�u���̌������R�[�h
; <�쐬>      : 1999-02-16
; <���l>      :
;*************************************************************************>MOH<
(defun SBG_GetSeriesTable (
  &key
  /
  #sql #qry$
  )
  ;(setq #sql (strcat "select * from �V���Ǘ� where �i�ԕ���='" &key "'"))
  (setq #qry$
    (car
      (CFGetDBSQLRec CG_CDBSESSION "SB�V���Y"
        (list
          (list "SERIES" &key 'STR)
        )
      )
    )
  )
  (if (= #qry$ nil)
    (progn
      (CFOutStateLog 0 1 "  CFGetSeriesTable:�w�V���Ǘ��x��������܂���ł���")
      (CFOutStateLog 0 1 (strcat "        " #sql))
    )
  )
  #qry$
)

;<HOM>*************************************************************************
; <�֐���>    : C:SB_LayoutPlan
; <�����T�v>  : �V�X�e���o�X�̃v������������
; <�߂�l>    : �Ȃ�
; <�쐬>      :
; <���l>      :
;*************************************************************************>MOH<
(defun C:SB_LayoutPlan ()

  (if (= "1" (substr CG_GROVALZNO 1 1))
    (progn
      (princ "\n���ϐ}�쐬")
      (setq CG_Zno "01")
      (SBDrawInsideBefore)
      (setq CG_GROVALZNO (strcat "0" (substr CG_GROVALZNO 2)))
    )
  )
  (if (= "1" (substr CG_GROVALZNO 2 1))
    (progn
      (princ "\n���r���ݔ��}�쐬")
      (setq CG_Zno "02")
      (SBDrawDrainageBefore)
      (setq CG_GROVALZNO (strcat (substr CG_GROVALZNO 1 1) "0" (substr CG_GROVALZNO 3)))
    )
  )
  (if (= "1" (substr CG_GROVALZNO 3 1))
    (progn
      (princ "\n�d�l�}�쐬")
      (setq CG_Zno "03")
      (SBDrawTableBefore)
      (setq CG_GROVALZNO (strcat (substr CG_GROVALZNO 1 2) "0"))
    )
  )
  (if (= CG_GROVALZNO "000")
    (progn
      (princ "\n�V�X�e���o�X���C�A�E�g�̏I��")
      (setq CG_OpenMode nil)
    )
  )
)
(princ)
