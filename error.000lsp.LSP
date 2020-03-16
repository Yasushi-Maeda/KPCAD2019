
(defun *error* (msg)
  (princ "@@@ error: ")
  (princ msg)
 (princ)
)

;;;(defun my_err(s)
;;;  (prompt "\nERROR: mycmd failed or was cancelled")
;;;  (setvar "clayer" old_clayer)
;;;  (command-s "._undo" "_e")
;;;  (setq *error* mv_oer)
;;;)

(defun c:mycmd ()

  (setq old_clayer (getvar "clayer"));���݉�w���i�[

;;;  (setq old_err *error* ;�G���[�֐�����U���̖��O�ɂ���
;;;        *error* my_err
;;;        old_clayer (getvar "clayer")
;;;  )

  (setq insPt (getpoint "\nSpecify text insertion: "))

  (if (/= insPt nil)
    (progn

			;��w��ύX����
		  (setvar "clayer" "0");2020/02/14 ADD

      (command-s "._undo" "_be")
      (command-s "._-layer" "_m" "Text" "_C" "3" "" "")
      (command-s "._-text" insPt000 "" "0" "Sample Text")
      (command-s "._undo" "_e")

;;;      (command "._undo" "_be")
;;;      (command "._-layer" "_m" "Text" "_C" "3" "" "")
;;;      (command "._-text" insPt000 "" "0" "Sample Text")
;;;      (command "._undo" "_e")

;;;      (command-s "._undo" "_be")
;;;      (command-s "._-layer" "_m" "Text" "_C" "3" "" "")
;;;      (command-s "._-text" insPt "" "0" "Sample Text")
;;;      (command-s "._undo" "_e")

    )
  )

  (setvar "clayer" old_clayer)
  (setq *error* mv_oer)
 (princ)
)

;command�@�֐����g���āA�ϐ���insPt000�ɂ����ꍇ

;;;�R�}���h:
;;;Specify text insertion: ���̂悤�ȃR�}���h  "MYCMD" �͂���܂���B�w���v��\������ɂ� F1 �L�[�������Ă��������B
;;;���̂悤�ȃR�}���h  "0" �͂���܂���B�w���v��\������ɂ� F1 �L�[�������Ă��������B
;;;���̂悤�ȃR�}���h  "SAMPLE TEXT" �͂���܂���B�w���v��\������ɂ� F1 �L�[�������Ă��������B
;;;���G���[�֐�(defun my_err(s)�ɔ�΂��ɍŌ�܂Œʂ遄

;command-S�@�֐����g�����ꍇ
;;;���G���[�������シ���ɃG���[�֐�(defun my_err(s)�ɔ�ԁ�

;�G���[�֐��������w�肵�Ȃ��ƁA�ʏ��
;*error*�@�ɔ�� msg = �G���[: �s���� (command-s) �̎��s�B

;;;�R�}���h:
;;;�R�}���h:
;;;MYCMD
;;;
;;;Specify text insertion: �A�v���P�[�V���� �G���[: �R�}���h���͂ő������^�C�v�������ł��B
;;; �G���[: �s���� (command-s) �̎��s�B





;; *pop-error-mode* �֐��̎g�p��
 
(defun my_err (err_msg)
    (if (/= err_msg "Function cancelled")
      (prompt (strcat "\nError: " err_msg))
    )
    (command "._undo" "_e")
    (command "._U")
    (setq *error* olderr)
  (princ)
)
 
(defun myUtil (key / )
    (setq olderr *error*
          *error* my_err)
    (*push-error-using-command*)         ;; �J�X�^�� �G���[ �n���h���[�̃R�}���h-s �̑���� command �֐��̎g�p
    (command "._undo" "_group")          ;; ���̃T���v���ł͎��s����܂��񂪁A�G���[ �n���h���[��ݒ肷�邽�߂̗ǂ��t���[�����[�N�B
    (/ 1 0)                              ;; �R�[�h��ݒ肷��Ƃ��ɁA�J�X�^�� �G���[ handlerRemove ���g���K�[����s�K�؂Ȓl�����֐����Ăяo��
 
    ;;; �����ɉ����̏��������s�B
 
    (command "._undo" "_e")
    (setq *error* olderr)                ; �Â� *error* �n���h���[�𕜌�
    (*pop-error-mode*)                   ; *pop-error-mode* ���g�p
)