;;;<HOM>************************************************************************
;;; <�֐���>  : LOADLOAD
;;; <�����T�v>: load.lsp�@���֐�������
;;; <�߂�l>  : 2008/07/03 YM ADD
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun LOADLOAD (
  /
  )
	(princ (strcat "\n�������@LOADLOAD�@�r�s�`�q�s�@������"))

;06/06/14 AO ���i�ŁAOEM�ł̗�����FAS�����[�h����
;06/06/14 AO DEL (if (= "ACAD" CG_PROGRAM)
;06/06/14 AO DEL   (setq CG_LOAD_EXT ".LSP")
;06/06/14 AO DEL   ;else
;06/06/14 AO DEL   (setq CG_LOAD_EXT ".FAS")
;06/06/14 AO DEL )

;06/06/14 AO ADD ���[�h����t�@�C�������g���q���폜 �� fas�����[�h
(setq CG_LOAD_EXT "")
;06/06/14 AO MOD �ȍ~ CG_LOAD_EXT(�g���q)�͋󕶎��ƂȂ�,FAS�����[�h����

;@@@(princ "\nload.fas ��۰�ޒ�...\n")
(load (strcat CG_LISPPATH "WKP_KCCMN"        CG_LOAD_EXT))  ;���ʃt�@�C��
;�v��������
(load (strcat CG_LISPPATH "WKP_KCSRCPLN"     CG_LOAD_EXT))
;���[�N�g�b�v�֘A
(load (strcat CG_LISPPATH "WKP_KCWKTOPZ"     CG_LOAD_EXT))
(load (strcat CG_LISPPATH "WKP_KCWKTOPZ2"    CG_LOAD_EXT))  ;���[�N�g�b�v�i�Ԋm��
(load (strcat CG_LISPPATH "WKP_KCWTGP"       CG_LOAD_EXT))  ;���[�N�g�b�v���ʐ}�쐬 new
(load (strcat CG_LISPPATH "WKP_KCLOSNK"      CG_LOAD_EXT))  ;�V���N�֘A
(load (strcat CG_LISPPATH "WKP_KCSIDE"       CG_LOAD_EXT))  ;�T�C�h�p�l���֘A
(load (strcat CG_LISPPATH "WKP_KCDOOR"       CG_LOAD_EXT))  ;���ʊ֘A
(load (strcat CG_LISPPATH "WKP_KCSELECT"     CG_LOAD_EXT))  ;���i�I��
(load (strcat CG_LISPPATH "WKP_KCBALOON"     CG_LOAD_EXT))  ;�d�l�\�ԍ��֘A
(load (strcat CG_LISPPATH "WKP_KCMRR"        CG_LOAD_EXT))  ;�~���[���]
(load (strcat CG_LISPPATH "WKP_KCSTRCH"      CG_LOAD_EXT))  ;�L�k�֘A
(load (strcat CG_LISPPATH "WKP_KCMKFLR"      CG_LOAD_EXT))  ;�V��t�B���[�֘A
(load (strcat CG_LISPPATH "WKP_KCCHECK"      CG_LOAD_EXT))  ;�z�u�`�F�b�N�֘A
(load (strcat CG_LISPPATH "WKP_KCKUTAI"      CG_LOAD_EXT))  ;��̊֘A 00/12/04 SN ADD
;�ݔ��z�u�E�ҏW�֘A
(load (strcat CG_LISPPATH "WKP_KCPARTS"      CG_LOAD_EXT))  ;�ݔ��z�u�֘A
(load (strcat CG_LISPPATH "WKP_KCCNFPTS"     CG_LOAD_EXT))  ;�ݔ��z�u�֘A
(load (strcat CG_LISPPATH "WKP_KCDELPTS"     CG_LOAD_EXT))  ;�ݔ��z�u�֘A
(load (strcat CG_LISPPATH "WKP_KCSUBPTS"     CG_LOAD_EXT))  ;�⑫����
(load (strcat CG_LISPPATH "WKP_KCEDPTS"      CG_LOAD_EXT))  ;�ݔ��ҏW
(load (strcat CG_LISPPATH "WKP_KCEDCMN"      CG_LOAD_EXT))  ;�ݔ��ҏW����
;����֘A
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
;�o�X�֘A
(load (strcat CG_LISPPATH "WKP_KBSRCPLN"     CG_LOAD_EXT))  ;�o�X�v��������
(load (strcat CG_LISPPATH "WKP_KBTABLE"      CG_LOAD_EXT))  ;�d�l�\�֘A
(load (strcat CG_LISPPATH "WKP_KBDINSID"     CG_LOAD_EXT))  ;
(load (strcat CG_LISPPATH "WKP_KBDDRAIN"     CG_LOAD_EXT))  ;
(load (strcat CG_LISPPATH "WKP_KBDIM"        CG_LOAD_EXT))  ;
(load (strcat CG_LISPPATH "WKP_KBCMN"        CG_LOAD_EXT))  ;�o�X����
;���̑�
(load (strcat CG_LISPPATH "WKP_KCVIEW2"      CG_LOAD_EXT))  ;�r���[�|�[�g����֘A MOD 00/02/14 YM
;���[�J�[�Ǝ� 01/10/09 YM ADD
(load (strcat CG_LISPPATH "WKP_KCEXTEND"     CG_LOAD_EXT))
;���ݕs�g�p
;@DEL@(load (strcat CG_LISPPATH "KCMAIN.fas"))     ;���C��  01/08/09 HN DEL
;@DEL@(load (strcat CG_LISPPATH "KCPANEL.fas"))    ;�C���e���A�p�l���֘A  01/08/17 HN DEL
;@DEL@(load (strcat CG_LISPPATH "KCEXP.fas"))      ;�L�k����  01/08/17 YM DEL
;@DEL@(load (strcat CG_LISPPATH "KCHanger.fas"))   ;�n���K�[�֘A    00/03/12 HM ADD  01/08/19 HN DEL
;@DEL@(load (strcat CG_LISPPATH "KCRange.fas"))    ;�����W�t�[�h�֘A    00/05/21 HM ADD
;@DEL@(load (strcat CG_LISPPATH "KCFDisp.fas"))    ;00/05/03 HN ADD 03/09/29 YM DEL

	(princ (strcat "\n�������@LOADLOAD�@�d�m�c�@������"))

);LOADLOAD

(princ)