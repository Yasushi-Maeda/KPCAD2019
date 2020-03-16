;;;<HOM>************************************************************************
;;; <�֐���>  : C:KpPageSetup
;;; <�����T�v>: �y�[�W�ݒ�R�}���h
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 2001-04-08 HN ��w"0_HIDE"�̔�\��������ǉ�
;;; <����>    :
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:KpPageSetup
  (
  /
  #eLayer     ; ��w"0_HIDE"�̐}�`��
  #eLayer$    ; ��w"0_HIDE"�̒�`�f�[�^
  #iLayer     ; ��w�̕W���t���O�l(LAYER�̃O���[�v �R�[�h 70)
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
;;; <�֐���>  : C:KpPreview
;;; <�����T�v>: ����v���r���[�R�}���h
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 2001-04-08 HN ��w"0_HIDE"�̔�\��������ǉ�
;;; <����>    :
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:KpPreview
  (
  /
  #eLayer     ; ��w"0_HIDE"�̐}�`��
  #eLayer$    ; ��w"0_HIDE"�̒�`�f�[�^
  #iLayer     ; ��w�̕W���t���O�l(LAYER�̃O���[�v �R�[�h 70)
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
;;; <�֐���>  : C:KpPlot
;;; <�����T�v>: ����v���r���[�R�}���h
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 2001-04-08 HN ��w"0_HIDE"�̔�\��������ǉ�
;;; <����>    :
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:KpPlot
  (
  /
  #eLayer     ; ��w"0_HIDE"�̐}�`��
  #eLayer$    ; ��w"0_HIDE"�̒�`�f�[�^
  #iLayer     ; ��w�̕W���t���O�l(LAYER�̃O���[�v �R�[�h 70)
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
;;; <�֐���>  : C:PlainPlot
;;; <�����T�v>: �ȈՏo�̓R�}���h
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 1999-10-12
;;; <����>    : 2001-04-08 HN ��w"0_HIDE"�̔�\��������ǉ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun C:PlainPlot  (
  /
;;;   #ini$$
;;;   #device
;;;   #scale
;;;   #ctb
;;;   #paper
;;;   #edit
;;;   #offx #offy ; 01/04/16 KS ADD �I�t�Z�b�g�Ή�
;;;   #eLayer     ; ��w"0_HIDE"�̐}�`��
;;;   #eLayer$    ; ��w"0_HIDE"�̒�`�f�[�^
;;;   #iLayer     ; ��w�̕W���t���O�l(LAYER�̃O���[�v �R�[�h 70)
  )

	(setvar "pdmode" 0) ;2011/09/30 YM ADD

  ; 119 01/04/08 HN S-ADD ��w"0_HIDE"�̔�\��������ǉ�
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
  ; 119 01/04/08 HN E-ADD ��w"0_HIDE"�̔�\��������ǉ�

  (if (= nil (findfile (strcat CG_SYSPATH "SCPLOT.CFG")))
    (CFAlertErr "����ݒ�t�@�C�� <SCPLOT.CFG> ������܂���")
  );_if
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
	;03/07/22 YM ADD-S
  (setq #CENTER   (cadr (assoc "CENTER"  #ini$$)))  ;����̒��S
  (if (= nil #CENTER)
    (setq #CENTER "")
  )
	;03/07/22 YM ADD-E

  (setq #device   (cadr (assoc "DEVICE"  #ini$$)))  ;�o�̓f�o�C�X��
  (setq #edit     (cadr (assoc "EDIT"  #ini$$)))    ;�G�f�B�^��
; 01/04/16 KS S-ADD �I�t�Z�b�g�Ή�
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offx)
    (setq #offx "0.0")
  )
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offy)
    (setq #offy "0.0")
  )
; 01/04/16 KS E-ADD �I�t�Z�b�g�Ή�
;  (if (= CG_ACAD_VER "OEM")
;    (progn
;      (if (= nil (findfile (strcat CG_SYSPATH "PLOTTERS\\" #device)))
;        (CFAlertErr (strcat
;            "������ݒ�t�@�C�� <" #device "> ������܂���\n\n"
;            "Preferences �Ɠ��͂����L�̒ʂ�Ɋ��ݒ���s���ĉ�����\n\n"
;            "  1.[���]�^�u���N���b�N\n"
;            "  2.[�v���b�^��ǉ��܂��͊��ݒ�]���N���b�N\n"
;            "  3.�v���b�^��ǉ��E�B�U�[�h�����s\n"
;            "  4.�ݒ肷��V�X�e���v�����^��I��\n"
;            "  5.�v���b�^����[Syscad Plotter1]�Ɠ���\n"
;            "  1.SysCAD�t�H���_����[addplwiz.exe]�����s\n"
;            "  2.�ݒ肷��V�X�e���v�����^��I��\n"
;            "  3.�v���b�^����[Syscad Plotter1]�Ɠ���\n"
;            )
;        )
;      )
;    )
;  )
  ;01/03/06 KS S-MOD �p�[�X�Ή�
  ;(if (= 0 (getvar "TILEMODE"))
  ;  (CFAlertErr (strcat
  ;      "�ȈՏo�͂ł̓p�[�X�}�ʂ̈���̓T�|�[�g����Ă���܂���\n\n"
  ;      "������j���[��[�y�[�W�ݒ�]-[���]�ɂĂ����p������   "
  ;      )
  ;  )
  ;01/03/06 KS E-MOD �p�[�X�Ή�
  ;  (progn ; ELSE 00/07/11 SN MOD �ȉ��̏�����ELSE���̏����Ƃ���B
  ;    (setq #scale    (cadr (assoc "SCALE"   #ini$$)))  ;�k��
      (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;����X�^�C���t�@�C����

      ;// �ȈՈ���_�C�A���O

			; 01/09/07 YM MOD-S ����Ӱ�ނł͕\�����Ȃ�
			(if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
		;;;	(if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
	      (setq #ret$ CG_AUTOMODE_PRINT)
	      (setq #ret$ (SCPlainPlotDlg #device))
			);_if
			; 01/09/07 YM MOD-E ����Ӱ�ނł͕\�����Ȃ�

      (if (/= #ret$ nil)
        (progn
          (setq #paper (car #ret$))
          (setq #scale (cadr #ret$))
          ;00/06/20 SN S-MOD �p���T�C�Y�̒ǉ�
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
          ;00/06/20 SN S-MOD �k�ڂ̒ǉ�
          (cond
            ((= #scale "scale20")(setq #scale "1:20"))
            ((= #scale "scale30")(setq #scale "1:30"))
            ((= #scale "scale40")(setq #scale "1:40"))
; 01/04/16 KS S-ADD �I�t�Z�b�g�Ή�
            ((= #scale "scale1")(setq #scale "1:1"))
; 01/04/16 KS E-ADD �I�t�Z�b�g�Ή�
            (T (setq #scale "F"))
          );_cond

          ;00/06/20 SN E-MOD
          (if (= 0 (getvar "TILEMODE"))
            (progn
              ;(setq #area "ڲ���")
              (setq #area "E")
              (setq #lay  "ڲ���1")
            )
            (progn
; 02/03/18 KS S-MOD �k�ڎ������̓I�u�W�F�N�g�͈́A���͐}�ʔ͈͂ň��
							; 02/06/03 YM DEL-S
;;;              (if (= #scale "F")
;;;                (setq #area "E")
;;;                (setq #area "L")
;;;              )
							; 02/06/03 YM DEL-E

							; 02/06/03 YM MOD-S
              (if (= #scale "F")
								(progn ; �k�ڎ�����������̾��=0.0�Ƃ��� 02/06/03 YM ADD
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

					; 01/09/07 YM MOD-S ����Ӱ�ނł��޲�۸ޕ\�����Ȃ�
					(if (or (= CG_AUTOMODE 1)(= CG_AUTOMODE 2)(= CG_AUTOMODE 3)) ; 02/07/29 YM ADD 02/08/05 YM ADD
				;;;	(if (= CG_AUTOMODE 1) ; 02/07/29 YM ADD
						(setq #YesNo T)
						; 01/09/07 YM MOD-S �ϐ��i�[
	          (setq #YesNo
							(CFYesNoDialog
		            (strcat
		              "�o�̓f�o�C�X��: [" #device "]\n"
		              "�p���T�C�Y�@�@�@: [" #paper  "]\n"
		              "�k�ځ@�@�@�@�@�@�@: [" #scale  "]\n\n"
		              "����ň�����Ă���낵���ł����H"
		            )
		          )
						)
						; 01/09/07 YM MOD-E �ϐ��i�[
					);_if
					; 01/09/07 YM MOD-E ����Ӱ�ނł��޲�۸ޕ\�����Ȃ�

					(if #YesNo ; 01/09/07 YM MOD
            (progn
							; 01/09/07 YM MOD-S ����Ӱ�ނ�script�s��
							(cond
								((or (= CG_AUTOMODE 1)(= CG_AUTOMODE 3)) ; 02/07/29 YM MOD 02/08/05 YM ADD
									(if (= (getvar "TILEMODE") 0)
										(progn ; �߰�߰���
			                (command "_.-PLOT"
		                     "Y"           ;�ڍׂȈ�����ݒ�
		                     #lay
		                     #device       ;����f�o�C�X��
		                     #paper        ;�p���T�C�Y(�e���v���[�g)
		                     "M"           ;�p���P��
		                     "L"           ;�}�ʂ̕���
		                     "N"           ;�㉺�t���
		                     #area         ;����̈� �}�ʔ͈�
		                     #scale        ;�k��
		                     (strcat #offx "," #offy)   ;����I�t�Z�b�g
		                     "Y"           ;����X�^�C�����p�H
		                     #ctb          ;����X�^�C����
		                     "Y"           ;���̑������g�p�H
	                       "N"           ;����ړx���g�p���Đ��̑������ړx�ύX?
	                       "N"           ;�߰�߰��Ԃ��Ō�Ɉ��?
	                       "Y"           ;�B������
	                       "N"           ;�t�@�C�������o��
	                       "N"           ;�ύX��ۑ�
	                       "Y"           ;����𑱂���H
			                   "_.-LAYER"
			                   "ON"
			                   "O_HIDE"      ; 01/04/10 HN E-ADD ��w"0_HIDE"�̕\��������ǉ�
			                   ""
			                );_command "_.-PLOT"
										) ; �߰�߰���
; else
										(progn ; ���ً��
			                (command "_.-PLOT"
		                     "Y"           ;�ڍׂȈ�����ݒ�
		                     #lay
		                     #device       ;����f�o�C�X��
		                     #paper        ;�p���T�C�Y(�e���v���[�g)
		                     "M"           ;�p���P��
		                     "L"           ;�}�ʂ̕���
		                     "N"           ;�㉺�t���
		                     #area         ;����̈� �}�ʔ͈�
		                     #scale        ;�k��
		                     (strcat #offx "," #offy)   ;����I�t�Z�b�g
		                     "Y"           ;����X�^�C�����p�H
		                     #ctb          ;����X�^�C����
		                     "Y"           ;���̑������g�p�H
		                     "Y"           ;�B������
		                     "N"           ;�t�@�C�������o��
		                     "N"           ;�ύX��ۑ�
		                     "Y"           ;����𑱂���H
			                   "_.-LAYER"
			                   "ON"
			                   "O_HIDE"      ; 01/04/10 HN E-ADD ��w"0_HIDE"�̕\��������ǉ�
			                   ""
			                );_command "_.-PLOT"

										) ; ���ً��
									);_if
								)
									; �� AUTOMODE �����܂� ��
				;else
									; �� �ʏ�̂̏��� ��

	              ;// �������
	              ;(command "_.-PLOT"
								(T ; 02/07/29 YM MOD

								 ;03/07/22 YM ADD-S Scplot.cfg�ň���̒��S���I���\�ɂ���
								 (if (or (= "C" #CENTER)(= "c" #CENTER))
                 		(setq #CENTER "C")                      ;����I�t�Z�b�g
                 		(setq #CENTER (strcat #offx "," #offy)) ;����I�t�Z�b�g
								 );_if
								 ;03/07/22 YM ADD-E Scplot.cfg�ň���̒��S���I���\�ɂ���

		              (CFScriptCommand
		                ;01/03/06 KS S-MOD �p�[�X�Ή�
		                (append
		                  (list
		                       "_.-PLOT"
		                       "Y"           ;�ڍׂȈ�����ݒ�
		                       ;"Model"       ;���C�A�E�g
		                       #lay
		                       #device       ;����f�o�C�X��
		                       #paper        ;�p���T�C�Y(�e���v���[�g)
		                       "M"           ;�p���P��
		                       "L"           ;�}�ʂ̕���
		                       "N"           ;�㉺�t���
		                       #area         ;����̈� �}�ʔ͈�
		                       #scale        ;�k��
		                       ;"0.00,0.00"  ;����I�t�Z�b�g
		                       ; 01/04/16 KS S-ADD �I�t�Z�b�g�Ή�
		                       ;"C"           ;����I�t�Z�b�g
;;;		                       (strcat #offx "," #offy)   ;����I�t�Z�b�g
													#CENTER ; 03/07/22 YM ADD
		                       ; 01/04/16 KS E-ADD �I�t�Z�b�g�Ή�
		                       "Y"           ;����X�^�C�����p�H
		                       #ctb          ;����X�^�C����
		                       "Y"           ;���̑������g�p�H
		;                       "Y"           ;�B������
		;                       "N"           ;�t�@�C�������o��
		;                       "N"           ;�ύX��ۑ�
		;                       "Y"           ;����𑱂���H
		                  );_list
		                  (if (= (getvar "TILEMODE") 0)
		                    (list ; �߰�߰���
		                      "N"           ;����ړx���g�p���Đ��̑������ړx�ύX?
		                      "N"           ;�߰�߰��Ԃ��Ō�Ɉ��?
		                      "Y"           ;�B������
		                      "N"           ;�t�@�C�������o��
		                      "N"           ;�ύX��ۑ�
		                      "Y"           ;����𑱂���H
		                    )
		                    (list ; MODEL���
		                      "Y"           ;�B������
		                      "N"           ;�t�@�C�������o��
		                      "N"           ;�ύX��ۑ�
		                      "Y"           ;����𑱂���H
		                    )
		                  );_if

		                  ; 01/04/10 HN S-ADD ��w"0_HIDE"�̕\��������ǉ�
		                  (list
		                    "_.-LAYER"
		                    "ON"
		                    "O_HIDE"
		                    ""
		                  )
		                  ; 01/04/10 HN E-ADD ��w"0_HIDE"�̕\��������ǉ�

		                );_append
		                ;01/03/06 KS E-MOD �p�[�X�Ή�
		              );_CFScriptCommand
								)
							);_cond
							; 01/09/07 YM MOD-S ����Ӱ�ނ�script�s��

            )
          );_if
        )
      );_if

  ; 01/04/08 HN S-DEL
  ; �X�N���v�g�����̌㏈���͕s��
  ;DEL; 119 01/04/08 HN S-ADD ��w"0_HIDE"�̔�\��������ǉ�
  ;DEL(if #eLayer
  ;DEL  (progn
  ;DEL    (entmod #eLayer$)
  ;DEL    (command ".REGEN")
  ;DEL  )
  ;DEL)
  ; 119 01/04/08 HN E-ADD ��w"0_HIDE"�̔�\��������ǉ�
  ; 01/04/08 HN E-DEL

  (princ)
)
;C:PlainPlot

;;;<HOM>************************************************************************
;;; <�֐���>  : WebPDF_OUTPUT
;;; <�����T�v>: PDF�o�͂���
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 02/08/01 YM
;;; <���l>    : NAS WEB�őΉ� CG_AUTOMODE = 2 ���O��
;;;************************************************************************>MOH<
(defun WebPDF_OUTPUT  (
  /
    #limmin
    #limmax
#AREA #CTB #DEVICE #EDIT #ELAYER #ELAYER$ #ILAYER #INI$$ #LAY #OFFX #OFFY #PAPER #RET$ #SCALE ;04/04/14 YM ADD
;;;	#AREA #CTB #DEVICE #EDIT #ELAYER #ELAYER$ #ILAYER #INI$$ #LAY #OFFX #OFFY #PAPER #RET$ #SCALE
  )

;���p�[�X�}��
;;;�R�}���h: -plot
;;;�ڍׂȈ�����ݒ�? [�͂�(Y)/������(N)] <������>: y
;;;���C�A�E�g������� �܂��� [�ꗗ(?)] <ڲ���1>:
;;;�o�̓f�o�C�X������� �܂��� [�ꗗ(?)] <DWF ePlot.pc3>: ?
;;;�g�p�\�Ȉ���f�o�C�X�B
;;;  "RICOH imagio Neo C600 RPCS"
;;;  "Microsoft XPS Document Writer"
;;;  "EPSON LP-7000C"
;;;  "Default Windows System Printer.pc3"
;;;  "DWF6 ePlot.pc3"
;;;  "DWFx ePlot (XPS Compatible).pc3"
;;;  "DWG To PDF.pc3"��
;;;  "PublishToWeb JPG.pc3"
;;;  "PublishToWeb PNG.pc3"
;;;�o�̓f�o�C�X������� �܂��� [�ꗗ(?)] <DWF ePlot.pc3>: DWG To PDF.pc3�@��
;;;�p���T�C�Y����� �܂��� [�ꗗ(?)] <ISO A3 (420.00 x 297.00 �~��)>:
;;;�p���P�ʂ���� [�C���`(I)/�~�����[�g��(M)] <�~�����[�g��>: m
;;;�}�ʂ̕�������� [�c(P)/��(L)] <��>: 'VLIDE �}�ʂ̕�������� [�c(P)/��(L)] <��>: �}�ʂ̕�������� [�c(P)/��(L)] <��>: l
;;;�㉺���t�ɂ��Ĉ�����܂���? [�͂�(Y)/������(N)] <������>: n
;;;����̈����� [�\�����(D)/�I�u�W�F�N�g�͈�(E)/���C�A�E�g(L)/�r���[(V)/��(W)] <�I�u�W�F�N�g�͈�>:
;;;[�\�����(D)/�I�u�W�F�N�g�͈�(E)/���C�A�E�g(L)/�r���[(V)/��(W)] <�I�u�W�F�N�g�͈�>: e
;;;����ړx����� (��� �~�����[�g��=��}�P��) �܂��� [�t�B�b�g(F)] <1:1>:
;;;����I�t�Z�b�g(x,y)����� �܂��� [���S(C)] <���S>:
;;;����X�^�C�����g�p���Ĉ�����܂���? [�͂�(Y)/������(N)] <�͂�>: y
;;;����X�^�C�� �e�[�u��������� �܂��� [�ꗗ(?)] ( . = �Ȃ�) <Kpcad.ctb>:
;;;���̑������g�p���Ĉ�����܂���? [�͂�(Y)/������(N)] <�͂�>: 'VLIDE ���̑������g�p���Ĉ�����܂���? [�͂�(Y)/������(N)] : y
;;;����ړx���g�p���Đ��̑������ړx�ύX���܂���? [�͂�(Y)/������(N)] <������>:  n
;;;�y�[�p�[��Ԃ��ŏ��Ɉ�����܂���? [�͂�(Y)/������(N)] <������>: n
;;;�y�[�p�[��Ԃ̃I�u�W�F�N�g���B���������܂���? [�͂�(Y)/������(N)] <������>: y
;;;�t�@�C��������� <C:\Layout\BUKKEN\OUTPUT\A3-01-1-����_0_00-ڲ���1.pdf>:
;;;�y�[�W�ݒ�̕ύX��ۑ����܂��� [�͂�(Y)/������(N)]? <N> n
;;;����𑱂��܂��� [�͂�(Y)/������(N)] <Y>: y

  ; 119 01/04/08 HN S-ADD ��w"0_HIDE"�̔�\��������ǉ�
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
  ; 119 01/04/08 HN E-ADD ��w"0_HIDE"�̔�\��������ǉ�

  (if (= nil (findfile (strcat CG_SYSPATH "SCPLOT.CFG")))
    (CFAlertErr "����ݒ�t�@�C�� <SCPLOT.CFG> ������܂���")
  )
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE"  #ini$$)))  ;�o�̓f�o�C�X��
  (setq #edit     (cadr (assoc "EDIT"  #ini$$)))    ;�G�f�B�^��

  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offx)(setq #offx "0.0"))

  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offy)(setq #offy "0.0"))



	;�߰��}�p 2008/08/16 YM ADD
  (setq #Poffx     (cadr (assoc "POFFSETX" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #Poffx)(setq #Poffx "0.0"))

  (setq #Poffy     (cadr (assoc "POFFSETY" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #Poffy)(setq #Poffy "0.0"))


  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;����X�^�C���t�@�C����

  ;// �ȈՈ���_�C�A���O
  (setq #ret$ CG_AUTOMODE_PRINT)

  (setq #paper (car #ret$))
  (setq #scale (cadr #ret$))
  ;00/06/20 SN S-MOD �p���T�C�Y�̒ǉ�
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
    (progn ;�߰�߰���
          (setq #area "E");�I�u�W�F�N�g�͈�(E)
;;;      (setq #area "L");�}�ʔ͈�(L) 2008/08/16 \\circa�łȂ���8/16�ɗ�����̂�L==>E�ɂ���
      (setq #lay  "ڲ���1")
    )
    (progn ;���ً��

      (setq #area "E");�I�u�W�F�N�g�͈�(E) 2008/08/16 L==>E
;;;      (setq #area "L");�}�ʔ͈�(L)

;;;      (if (= #scale "F")
;;;				(progn
;;;          (setq #area "E");�I�u�W�F�N�g�͈�(E)
;;;;;;          (setq #area "L");�}�ʔ͈�(L)
;;;			    (setq #offx "0.0")
;;;					(setq #offy "0.0")
;;;				)
;;;      );_if

      (setq #lay  "���f��")
    )
  );_if

	; PLOT����ގ��s(PDF�o�͗p)
	(if (= (getvar "TILEMODE") 0)
		(progn ; �߰�߰��� PDF���޽�į�߂ɏo�� �w�߰��}�x
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
         "Y"           ;�ڍׂȈ�����ݒ�
         #lay
         #device       ;����f�o�C�X��
         #paper        ;�p���T�C�Y(�e���v���[�g)
         "M"           ;�p���P��
         "L"           ;�}�ʂ̕���
         "N"           ;�㉺�t���
         #area         ;����̈� �}�ʔ͈�
         #scale        ;�k��
         (strcat #Poffx "," #Poffy)   ;����I�t�Z�b�g
         "Y"           ;����X�^�C�����p�H
         #ctb          ;����X�^�C����
         "Y"           ;���̑������g�p�H
         "N"           ;����ړx���g�p���Đ��̑������ړx�ύX?
         "N"           ;�߰�߰��Ԃ��Ō�Ɉ��?
         "Y"           ;�B������
         CG_PDF_FILENAME  ;���t�@�C��������� <C:\Layout\BUKKEN\OUTPUT\A3-01-1-����_0_00-ڲ���1.pdf>:
         "N"           ;�y�[�W�ݒ�̕ύX��ۑ����܂���
         "Y"           ;����𑱂��܂���
      );_command "_.-PLOT"

		) ; �߰�߰���

; else
		(progn ; ���ً�� PDF���޽�į�߂ɏo��
      (command "_.-PLOT"
         "Y"           ;�ڍׂȈ�����ݒ�
         #lay
         #device       ;����f�o�C�X��
         #paper        ;�p���T�C�Y(�e���v���[�g)
         "M"           ;�p���P��
         "L"           ;�}�ʂ̕���
         "N"           ;�㉺�t���
         #area         ;����̈� �}�ʔ͈�
         #scale        ;�k��
         (strcat #offx "," #offy)   ;����I�t�Z�b�g
         "Y"           ;����X�^�C�����p�H
         #ctb          ;����X�^�C����
         "Y"           ;���̑������g�p�H
         "H"           ;�B������
         CG_PDF_FILENAME  ;���t�@�C��������� <C:\Layout\BUKKEN\OUTPUT\A3-01-1-����_0_00-ڲ���1.pdf>:
         "N"           ;�ύX��ۑ�
         "Y"           ;����𑱂���H
      );_command "_.-PLOT"

		) ; ���ً��
	);_if
  (princ)
);WebPDF_OUTPUT

;;;<HOM>************************************************************************
;;; <�֐���>  : WebTIFF_OUTPUT
;;; <�����T�v>: TIFF�o�͂���
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 02/08/02 YM
;;; <���l>    : NAS WEB�őΉ� �߰��}��\�����Ă��邱�Ƃ��O��
;;;************************************************************************>MOH<
(defun WebTIFF_OUTPUT  (
  /
	#AREA #CTB #DEVICE #INI$$ #LAY #OFFX #OFFY #PAPER #SCALE
  )
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE2"  #ini$$))) ;�o�̓f�o�C�X��
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offx)(setq #offx "0.0"))
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offy)(setq #offy "0.0"))

	; 03/02/25 YM MOD-S WEB�ł����y���̑����𑾂�
  (setq #ctb      (cadr (assoc "CTB2"    #ini$$)))  ;����X�^�C���t�@�C����
	(if (= nil #ctb)(setq #ctb (cadr (assoc "CTB" #ini$$))))
	; 03/02/25 YM MOD-E WEB�ł����y���̑����𑾂�
;;;  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;����X�^�C���t�@�C����

  (setq #paper    (cadr (assoc "SIZE"    #ini$$)))  ;�s�N�Z��
	(setq #scale "F")
  (setq #area  "E") ; ��޼ު�Ĕ͈� 03/02/19 YM MOD
;;;  (setq #area  "D") ; �}�ʔ͈� 03/02/19 YM MOD

  (if (= 0 (getvar "TILEMODE")) ; 03/02/22 YM ADD
		(progn
		  (setq #lay  "ڲ���1") ; 03/02/22 YM ADD
		)
		(progn
			(setq #lay  "Model")
		)
	);_if

  ;;S-ADD by K.S 2002/08/05
	(setvar "DISPSILH" 1)                     ;�V���G�b�gON

	; �ް�,���������ς� 03/02/22 YM DEL-S
;;;03/02/22YM@DEL	(command "_.ZOOM" "E")
;;;03/02/22YM@DEL;;;  (command "_.VPOINT" "R" "" 8)
;;;03/02/22YM@DEL
;;;03/02/22YM@DEL	(if (= CG_LRCode "R") ; 03/02/19 YM ADD
;;;03/02/22YM@DEL		(progn ; �E����̂Ƃ�
;;;03/02/22YM@DEL		  (command "_.VPOINT" "R" "300" 7)
;;;03/02/22YM@DEL		)
;;;03/02/22YM@DEL		(progn ; ������̂Ƃ�
;;;03/02/22YM@DEL		  (command "_.VPOINT" "R" "240" 7)
;;;03/02/22YM@DEL		)
;;;03/02/22YM@DEL	);_if
;;;03/02/22YM@DEL
;;;03/02/22YM@DEL	(command "_.DVIEW" "ALL" "" "D" 7500 "X") ;�p�[�X�}�ɐ؂�ւ�
  ;;E-ADD by K.S 2002/08/05
	
	; PLOT����ގ��s(TIFF�o�͗p)
  (command "_.-PLOT"
     "Y"           ;�ڍׂȈ�����ݒ�
     #lay          ;ڲ��Ė������ <ڲ���1>:
     #device       ;�o�̓f�o�C�X������� <Independent JPEG Group JFIF (JPEG ���k).pc3>:
     #paper        ;�p�����ނ���� <Super VGA (600.00 x 800.00 �߸��)>:
     "L"           ;�}�ʂ̕�������� [�c(P)/��(L)] <��>:
     "N"           ;�㉺���t�ɂ��Ĉ�����܂���? [�͂�(Y)/������(N)] <No>:
     #area         ;����̈����� [�\�����(D)/��޼ު�Ĕ͈�(E)/ڲ���(L)/�ޭ�(V)/��(W)] <��޼ު�Ĕ͈�>:
     #scale        ;����ړx����� (��� �߸��=��}�P��) �܂��� [̨��(F)] <1:1>:
     (strcat #offx "," #offy)   ;����̾��(x,y)����� �܂��� [���S(C)] <Center>: 0,0
     "Y"           ;������ق��g�p���Ĉ�����܂���? [�͂�(Y)/������(N)] <Yes>:
     #ctb          ;������� ð��ٖ������ �܂��� [�ꗗ(?)] ( . = �Ȃ�) <Kpcad.ctb>:
     "Y"           ;���̑������g�p���Ĉ�����܂���? [�͂�(Y)/������(N)] <Yes>:
     "N"           ;����ړx���g�p���Đ��̑������ړx�ύX? [�͂�(Y)/������(N)] <No>:
     "N"           ;�߰�߰��Ԃ��Ō�Ɉ��? [�͂�(Y)/������(N)] <No>:
     "Y"           ;�B�����������܂���? [�͂�(Y)/������(N)] <No>: y
;;;		(strcat CG_PDFOUTPUTPATH CG_BukkenNo "_DRW1.Tif")
		(strcat CG_PDFOUTPUTPATH CG_BukkenNo "_DRW1")
     "N"           ;ڲ��Ă̕ύX��ۑ����܂��� [�͂�(Y)/������(N)]? <N>
     "Y"           ;����𑱂��܂��� [�͂�(Y)/������(N)] <Y>:
  );_command "_.-PLOT"

  (princ)
);WebTIFF_OUTPUT


;;;<HOM>************************************************************************
;;; <�֐���>  : WebJPG_OUTPUT
;;; <�����T�v>: JPG�o�͂���
;;; <�߂�l>  : �Ȃ�
;;; <�쐬>    : 04/09/13 YM
;;; <���l>    : NAS �����ݸ޼�Ď���JPG�o��
;;;************************************************************************>MOH<
(defun WebJPG_OUTPUT  (
  /
	#AREA #CTB #DEVICE #INI$$ #LAY #OFFX #OFFY #OUTPUT #PAPER #SCALE
  )
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE2"  #ini$$))) ;�o�̓f�o�C�X��
  (setq #offx     (cadr (assoc "OFFSETX" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offx)(setq #offx "0.0"))
  (setq #offy     (cadr (assoc "OFFSETY" #ini$$)))  ;�����I�t�Z�b�g
  (if (= nil #offy)(setq #offy "0.0"))

	; 03/02/25 YM MOD-S WEB�ł����y���̑����𑾂�
  (setq #ctb      (cadr (assoc "CTB2"    #ini$$)))  ;����X�^�C���t�@�C����
	(if (= nil #ctb)(setq #ctb (cadr (assoc "CTB" #ini$$))))
	; 03/02/25 YM MOD-E WEB�ł����y���̑����𑾂�
;;;  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;����X�^�C���t�@�C����

  (setq #paper    (cadr (assoc "SIZE"    #ini$$)))  ;�s�N�Z��
	(setq #scale "F")
  (setq #area  "E") ; ��޼ު�Ĕ͈� 03/02/19 YM MOD
;;;  (setq #area  "D") ; �}�ʔ͈� 03/02/19 YM MOD

  (if (= 0 (getvar "TILEMODE")) ; 03/02/22 YM ADD
		(progn
		  (setq #lay  "ڲ���1") ; 03/02/22 YM ADD
		)
		(progn
			(setq #lay  "Model")
		)
	);_if

  ;;S-ADD by K.S 2002/08/05
	(setvar "DISPSILH" 1)                     ;�V���G�b�gON

	(setq #output (strcat CG_KENMEI_PATH "BLOCK" "\\PERS.jpg"))
	(if (findfile #output)(vl-file-delete #output))

	(if #output
		(progn
			; PLOT����ގ��s(TIFF�o�͗p)
		  (command "_.-PLOT"
		     "Y"           ;�ڍׂȈ�����ݒ�
		     #lay          ;ڲ��Ė������ <ڲ���1>:
		     #device       ;�o�̓f�o�C�X������� <Independent JPEG Group JFIF (JPEG ���k).pc3>:
		     #paper        ;�p�����ނ���� <Super VGA (600.00 x 800.00 �߸��)>:
		     "L"           ;�}�ʂ̕�������� [�c(P)/��(L)] <��>:
		     "N"           ;�㉺���t�ɂ��Ĉ�����܂���? [�͂�(Y)/������(N)] <No>:
		     #area         ;����̈����� [�\�����(D)/��޼ު�Ĕ͈�(E)/ڲ���(L)/�ޭ�(V)/��(W)] <��޼ު�Ĕ͈�>:
		     #scale        ;����ړx����� (��� �߸��=��}�P��) �܂��� [̨��(F)] <1:1>:
		     (strcat #offx "," #offy)   ;����̾��(x,y)����� �܂��� [���S(C)] <Center>: 0,0
		     "Y"           ;������ق��g�p���Ĉ�����܂���? [�͂�(Y)/������(N)] <Yes>:
		     #ctb          ;������� ð��ٖ������ �܂��� [�ꗗ(?)] ( . = �Ȃ�) <Kpcad.ctb>:
		     "Y"           ;���̑������g�p���Ĉ�����܂���? [�͂�(Y)/������(N)] <Yes>:
		     "N"           ;����ړx���g�p���Đ��̑������ړx�ύX? [�͂�(Y)/������(N)] <No>:
		     "N"           ;�߰�߰��Ԃ��Ō�Ɉ��? [�͂�(Y)/������(N)] <No>:
		     "Y"           ;�B�����������܂���? [�͂�(Y)/������(N)] <No>: y
				#output
		     "N"           ;ڲ��Ă̕ύX��ۑ����܂��� [�͂�(Y)/������(N)]? <N>
		     "Y"           ;����𑱂��܂��� [�͂�(Y)/������(N)] <Y>:
		  );_command "_.-PLOT"
		)
	);_if

  (princ)
);WebJPG_OUTPUT


;<HOM>*************************************************************************
; <�֐���>    : SCPlainPlotDlg
; <�����T�v>  : �ȈՏo�̓R�}���h�_�C�A���O
; <�߂�l>    :
; <�쐬>      : 1999-10-12
; <���l>      :
;*************************************************************************>MOH<
(defun SCPlainPlotDlg (
    &device          ;(STR)�o�̓f�o�C�X��
    /
    #dcl_id
  )
  (defun PlainPlotDlgOK ()
    (list
      (get_tile "paper")
      (get_tile "scale")
    )
  )
  ;// �p���T�C�Y�̔���
  (setq #lm (getvar "LIMMAX"))

  (setq #dcl_id (eval (load_dialog (strcat CG_DCLPATH "KCPLOT.dcl"))))
  (new_dialog "SCPlotDlg" #dcl_id)

  ;00/06/20 SN S-MOD �p���T�C�Y�E�k�ڂ̏����l��������
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
  (set_tile "dev" (strcat "�o�̓f�o�C�X: " &device))
  (action_tile "accept" "(setq #ret$ (PlainPlotDlgOK)) (done_dialog)")
  (action_tile "cancel" "(setq #ret$ nil) (done_dialog)")
  (action_tile "setting" "(PlainPlotDlgSet)")
  (start_dialog)
  (unload_dialog #dcl_id)

  #ret$
)

;00/07/05 SN ADD ������ݒ����݉������̏���
; #ini$$, #device, #edit, #scale, #ctb
; ��C:PlainPlot�̕ϐ�
(defun PlainPlotDlgSet()
  ;(setq #ret (startapp (strcat &edit CG_SYSPATH "SCPLOT.CFG" ) ""))
  ;(if (not #ret )
  ;  (CFAlertErr (strcat CG_SYSPATH "SCPLOT.CFG" "���J���܂���"))
  ;)
  (c:arxStartApp (strcat #edit " " CG_SYSPATH "SCPLOT.CFG") 1)
  (setq #ini$$ (ReadIniFile (strcat CG_SYSPATH "SCPLOT.CFG")))
  (setq #device   (cadr (assoc "DEVICE"  #ini$$)))  ;�o�̓f�o�C�X��
  (setq #edit     (cadr (assoc "EDIT"  #ini$$)))    ;�G�f�B�^��
  (setq #scale    (cadr (assoc "SCALE"   #ini$$)))  ;�k��
  (setq #ctb      (cadr (assoc "CTB"     #ini$$)))  ;����X�^�C���t�@�C����
  (set_tile "dev" (strcat "�o�̓f�o�C�X: " #device))
)

(princ)