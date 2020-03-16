;;;(defun PcIsExistPOnLine 
;;;(defun PcSetOpt$G_OPT
;;;(defun PcDelOpt$G_OPT
;;;(defun PcGetEn$CrossArea
;;;(defun PcChkHeightCrossing
;;;(defun PcChkZdirCross
;;;(defun PcChkItemNext
;;;(defun PcChkItemNextInList
;;;(defun PcChk4POver
;;;(defun PcJudgeCrossing
;;;(defun PcInsertItem&SetXData
;;;(defun PcChgH_GSYM
;;;(defun PcPolar
;;;(defun PcGetItem4P$
;;;(defun PcGetNextSimilarItem$

;<HOM>*************************************************************************
; <�֐���>    : PcIsExistPOnLine
; <�����T�v>  : ��{�̐���ɏd�Ȃ�_�����邩�ǂ����`�F�b�N
; <�߂�l>    : �󂯎�������X�g���ɐ���̓_���݂���� T �Ȃ���� nil
; <�쐬>      : 2000-03-29   MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcIsExistPOnLine (
  &LINE$      ; ��_���琬������X�g
  &P$         ; �`�F�b�N�Ώۂ̓_���X�g
  /
  #Pnt$ #FLG #a1 #a2
  )
  (setq #FLG nil)
  (while (and (not #FLG) (setq #Pnt$ (car &P$)))
    (setq #a1 (angle #Pnt$ (car &LINE$)))
    (setq #a2 (angle #Pnt$ (cadr &LINE$)))
    (setq #FLG
      (cond
        ((equal 0 (distance #Pnt$ (car &LINE$)) 0.1) 'T)
        ((equal 0 (distance #Pnt$ (cadr &LINE$)) 0.1) 'T)
        ((equal #a1 (+ #a2 pi) 0.0001) 'T)
        ((equal #a1 (- #a2 pi) 0.0001) 'T)
        (t nil)
      )
    ); end of setq
    (setq &P$ (cdr &P$))
  ); end of while
  #FLG
); PcIsExistPOnLine

;<HOM>*************************************************************************
; <�֐���>    : PcSetOpt$G_OPT
; <�����T�v>  : �n���ꂽ���X�g�̓��e��"G_OPT"�ɒǉ��A�܂��͐V�K�ݒu����
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2000-03-30   MH
; <���l>      : ���X�g�̌`���� ((�i��  ��) (�i��  ��) (�i��  ��)�c)�Ȃ̂ɒ���
;*************************************************************************>MOH<
(defun PcSetOpt$G_OPT (
   &eEN       ; �ݒ�Ώۂ̐}�`��
   &OPT$      ; �ǉ�(�V�K?)�I�v�V�������e���X�g
    /
   #GOP$      ; �����̃I�v�V�������X�g;
   #iHIN #OP$ #OPFLG
  )
  (if (setq #GOP$ (CFGetXData &eEN "G_OPT"))
    ;; ���łɃI�v�V�������L
    (progn
    ;;; �l�����ꂽ���݂�"G_OPT"���e#GOP$��ό`������
      (setq #iHIN (+ (car #GOP$) (length &OPT$))) ; ���̌��l+�ǉ����X�g����
      (setq #GOP$ (cdr #GOP$))
      (setq #GOP$ (cons #iHIN #GOP$)) ; ���̌��l��������
      (setq #GOP$ (append #GOP$ (apply 'append &OPT$))) ; ����̃f�[�^�t��
      (if (CFSetXData &eEN "G_OPT" #GOP$) ;�ό`���������X�g��"G_OPT"�ݒ�
        (setq #OPFLG 'T)
      )
    )
    ;; �I�v�V������񖳂� = �V�K�ݒu
    (progn
      (if (= (tblsearch "APPID" "G_OPT") nil) (regapp "G_OPT"))
      (setq #OP$ (cons (length &OPT$) (apply 'append &OPT$)))
      (if (CFSetXData &eEN "G_OPT" #OP$)
        (setq #OPFLG 'T)
      )
    )
  )
  #OPFLG
);PcSetOpt$G_OPT

;<HOM>*************************************************************************
; <�֐���>    : PcDelOpt$G_OPT
; <�����T�v>  : G_OPT����w��̕i�Ԃ̍��ڂ𔲂�
; <�߂�l>    : �Ȃ�
; <�쐬>      : 2000-07-14   MH
; <���l>      : ��������i�Ԃ́A���X�g�̌`�œn��
;*************************************************************************>MOH<
(defun PcDelOpt$G_OPT (
  &eEN       ; �ݒ�Ώۂ̐}�`��
  &OPT$      ; �폜�I�v�V�����i�ԃ��X�g
  /
  #GOP$ #i #newOP$
  )
  ;; ���łɃI�v�V�������L�Ȃ�Ύ��s
  (if (setq #GOP$ (CFGetXData &eEN "G_OPT"))
    (progn
      (setq #GOP$ (cdr #GOP$))
      (setq #i 0)
      (while (car #GOP$)
        (if (member (car #GOP$) &OPT$)
          ; �폜�Ώ�OPT������
          (repeat 2 (setq #GOP$ (cdr #GOP$))); repeat
          ; �폜�Ώۂł͂Ȃ�����
          (progn
            (setq #i (1+ #i))
            (repeat 2
              (setq #newOP$ (append #newOP$ (list (car #GOP$))))
              (setq #GOP$ (cdr #GOP$))
            ); repeat
          ); progn
        ); if
      ); while
      ; �I�v�V�������X�g���`
      (setq #GOP$ (if (< 0 #i) (cons #i #newOP$) nil))
      ; ���`��̃��X�g���A�C�e���ɐݒu
      (CFSetXData &eEN "G_OPT" #GOP$)
    ); progn
  ); if
); PcDelOpt$G_OPT

;<HOM>*************************************************************************
; <�֐���>    : PcGetEn$CrossArea
; <�����T�v>  : �����Ɋ֌W�Ȃ�����A�C�e���̎w��͈͂ɏd���ʒu����A�C�e�������o
; <�߂�l>    : �}�`���̃��X�g �Ȃ�= nil
; <�쐬>      : 00/03/29 MH
; <���l>      : �w��͈͂ɐڂ���ʒu�̐}�`���擾���邩�ǂ����t���O�Ŕ��f
;*************************************************************************>MOH<
(defun PcGetEn$CrossArea (
  &eONE       ; �`�F�b�N���ɂȂ�}�`��
  &iL &iR &iF &iB ; �͈͂��w�肷�鍶�E�O��̐L�k�l(0�Ō��}�`�͈͂Ɠ��l)
  &flgNX      ; ���̃t���O�� 'T �Ȃ�A�w��͈͂ɐڂ���ʒu�̐}�`���擾
  /
  #xd$ #w #d #h #ang #dSQR$
  #ss #ilen #i #i2
  #eEN #p5 #p6 #p7 #p8
  #pFLG #dCHK$ #RES$
  )
  ;;; �͈͂ɐڂ���}�`���擾���Ȃ��̂Ȃ�A�͈͑S�̂�1mm�k������B
  (if (not &flgNX) (progn
    (setq &iL (1- &iL))
    (setq &iR (1- &iR))
    (setq &iF (1- &iF))
    (setq &iB (1- &iB))))
  (setq #dSQR$ (PcGetItem4P$ &eONE &iL &iR &iF &iB))
  ; �}�ʒ��̑S�A�C�e���擾
  (setq #ss (ssget "X" '((-3 ("G_LSYM")))))
  ; ��r���̐}�`�͎�菜��
  (ssdel &eONE #ss)
  (if (not #ss) (setq #ilen 0) (setq #ilen (sslength #ss)))

  ;�`�F�b�N�p���X�g(setq #OR$ nil #CH$ nil)
  ; ����`�Ɗe�}�`�̕ӂ�����邩�A�_�͔͈͓��ɓ��邩�A���`�F�b�N
  (setq #i 0)
  (repeat #ilen
    (setq #eEN (ssname #ss #i))
    ;;; �`�F�b�N����A�C�e���̋�`�̈�S�_�����߂�
    (setq #xd$ (CFGetXData #eEN "G_SYM"))
    (setq #w (nth 3 #xd$))
    (setq #d (nth 4 #xd$))
    (setq #h (nth 5 #xd$))
    (setq #ang (nth 2 (CFGetXData #eEN "G_LSYM")))
    (setq #p5 (cdr (assoc 10 (entget #eEN))))
    ; �������Ⴄ�P�[�X���ΏۂȂ̂ŁAZ�l���ŏ��ɔ���
    (setq #p5 (list (read (rtos (car #p5) 2 10)) (read (rtos (cadr #p5) 2 10))))
    (setq #p6 (Pcpolar #p5 #ang #w))
    (setq #p7 (Pcpolar #p6 (- #ang (dtr 90)) #d))
    (setq #p8 (Pcpolar #p5 (- #ang (dtr 90)) #d))
    (setq #dCHK$ (list #p5 #p6 #p7 #p8))

    (setq #pFLG nil)
    (setq #i2 0)
    (setq #pFLG (PcJudgeCrossing #dSQR$ #dCHK$))

    (if #pFLG (setq #RES$ (cons #eEN #RES$)))
    (setq #i (1+ #i))
  ); end of repeat
  ; ���ʂ�Ԃ� nil �� ���X�g
  (setq #RES$ #RES$)
); PcGetEn$CrossArea

;<HOM>*************************************************************************
; <�֐���>    : PcChkHeightCrossing
; <�����T�v>  : ��̐}�`�̍��������̊��m�F
; <�߂�l>    : �{�̓��m�d��=-1 ���e�l���ŏd��=1 �ڂ��Ă���=0  �d�Ȃ�Ȃ�=nil
; <�쐬>      : 00/04/23 MH
; <���l>      : ���e�͈͂��l���ɂ����
;*************************************************************************>MOH<
(defun PcChkHeightCrossing (
  &eUNDER     ; ���̐}�`
  &eTOP       ; ��̐}�`
  &fSPACE     ; ���e�����2�̐}�`�Ԃ̊J��
  /
  #dORG #Z0 #Z1 #Z2
  #XD$ #TEA
  )
  ;;;���̐}�`�̍ŏ�ʂł�Z�l #Z0
  (setq #xd$ (CFGetXData &eUNDER "G_SYM"))
  (setq #dORG (cdr (assoc 10 (entget &eUNDER))))
  (setq #Z0 (caddr #dORG))
  (if (= 1 (nth 10 #xd$)) (setq #Z0 (+ #Z0 (nth 5 #xd$))))
  ;;; ���e�l������
  (if (numberp &fSPACE) (setq #Z1 (+ #Z0 &fSPACE)))

  ;;; ��̐}�`�̍ŉ��ʂł�Z�l #Z2
  (setq #xd$ (CFGetXData &eTOP "G_SYM"))
  (setq #dORG (cdr (assoc 10 (entget &eTOP))))
  (setq #Z2 (caddr #dORG))
  (if (= -1 (nth 10 #xd$)) (setq #Z2 (- #Z2 (nth 5 #xd$))))

  ;;; �����`�F�b�N ���ʂ�Ԃ�
  (setq #tea (list #Z0 #Z1 #Z2))
  (cond
    ((= #Z1 #Z2) 0)
    ((and (> #Z0 #Z2) (> #Z1 #Z2)) -1)
    ((> #Z1 #Z2) 1)
    (t nil)
  ); cond
);PcChkHeightCrossing

;<HOM>*************************************************************************
; <�֐���>    : PcChkZdirCross
; <�����T�v>  : ��̃A�C�e���̍��������̊��m�F
; <�߂�l>    : �d��=1 �ڂ��Ă���=0  �d�Ȃ�Ȃ�=nil
; <�쐬>      : 00/05/11 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcChkZdirCross (
  &eONE       ; �}�`�P
  &eTWO       ; �}�`�Q
  /
  #xd$ #d #Z1 #Z2 #Z3 #Z4
  )
  (setq #xd$ (CFGetXData &eONE "G_SYM"))
  (setq #d (cdr (assoc 10 (entget &eONE))))
  (setq #Z1 (caddr #d))
  (if (= 1 (nth 10 #xd$))
    (setq #Z2 (+ #Z1 (nth 5 #xd$)))
    (setq #Z2 (- #Z1 (nth 5 #xd$)))
  );if
  (setq #xd$ (CFGetXData &eTWO "G_SYM"))
  (setq #d (cdr (assoc 10 (entget &eTWO))))
  (setq #Z3 (caddr #d))
  (if (= 1 (nth 10 #xd$))
    (setq #Z4 (+ #Z3 (nth 5 #xd$)))
    (setq #Z4 (- #Z3 (nth 5 #xd$)))
  );if
  ;;; �����`�F�b�N ���ʂ�Ԃ�
  (cond
    ((equal (max #Z1 #Z2) (min #Z3 #Z4) 0.1) 0)
    ((equal (min #Z1 #Z2) (max #Z3 #Z4) 0.1) 0)
    ((and (<= #Z1 (max #Z3 #Z4)) (>= #Z1 (min #Z3 #Z4))) 1)
    ((and (<= #Z2 (max #Z3 #Z4)) (>= #Z2 (min #Z3 #Z4))) 1)
    (t nil)
  ); cond
); PcChkZdirCross

;<HOM>*************************************************************************
; <�֐���>    : PcChkItemNext
; <�����T�v>  : �A�C�e���̑O�㍶�E�ɗאڂ���A�C�e�������݂��邩�`�F�b�N
; <�߂�l>    : �}�`���̃��X�g �Ȃ�= nil
; <�쐬>      : 00/05/11 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcChkItemNext (
  &eONE       ; �`�F�b�N���ɂȂ�}�`��
  &L &R &F &B ; �`�F�b�N�ӂ��w�肷��t���O�i1 �� 0 ���́j
  /
  #iL #iR #iF #iB #NX$ #NX2$ #RES$
  )
  ; �͈͂��w�肷�鍶�E�O��̐L�k�l(0�Ō��}�`�͈͂Ɠ��l)���o��
  (setq #iL (if (= 1 &L) 0 -1))
  (setq #iR (if (= 1 &R) 0 -1))
  (setq #iF (if (= 1 &F) 0 -1))
  (setq #iB (if (= 1 &B) 0 -1))
  (setq #NX$ (PcGetEn$CrossArea &eONE #iL #iR #iF #iB 'T))
  ; �Z�o���ꂽ�}�`�̂S�_���t���O�P�Ŏw�肳�ꂽ�ӂ��o���ʒu�ɂ��邩�`�F�b�N
  (while (car #NX$)
    (if (PcChk4POver &eONE (car #NX$) &L &R &F &B)
      (setq #NX2$ (cons (car #NX$) #NX2$))
    );if
    (setq #NX$ (cdr #NX$))
  ); while
  ; �c�����̈ʒu�֌W���`�F�b�N
  (setq #RES$ nil)
  (while (car #NX2$)
    (if (= 1 (PcChkZdirCross &eONE (car #NX2$)))
      (setq #RES$ (cons (car #NX2$) #RES$))
    );if
    (setq #NX2$ (cdr #NX2$))
  ); while

  #RES$
); PcChkItemNext

;<HOM>*************************************************************************
; <�֐���>    : PcChkItemNextInList
; <�����T�v>  : �}�`�����X�g���ɃA�C�e���̑O�㍶�E�ɗאڂ���A�C�e�������݂��邩�H
; <�߂�l>    : �}�`���̃��X�g �Ȃ�= nil
; <�쐬>      : 00/09/14 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcChkItemNextInList (
  &eONE       ; �`�F�b�N���ɂȂ�}�`��
  &L &R &F &B ; �`�F�b�N�ӂ��w�肷��t���O�i1 �� 0 ���́j
  &eCHK$      ; �`�F�b�N�Ώۂ̐}�`�����X�g
  /
  #iL #iR #iF #iB #NX$ #NX2$ #RES$
  )
  ; �͈͂��w�肷�鍶�E�O��̐L�k�l(0�Ō��}�`�͈͂Ɠ��l)���o��
  (setq #iL (if (= 1 &L) 0 -1))
  (setq #iR (if (= 1 &R) 0 -1))
  (setq #iF (if (= 1 &F) 0 -1))
  (setq #iB (if (= 1 &B) 0 -1))
  (setq #NX$ (PcGetEn$CrossItemArea &eONE #iL #iR #iF #iB 'T &eCHK$))
  ; �Z�o���ꂽ�}�`�̂S�_���t���O�P�Ŏw�肳�ꂽ�ӂ��o���ʒu�ɂ��邩�`�F�b�N
  (while (car #NX$)
    (if (PcChk4POver &eONE (car #NX$) &L &R &F &B)
      (setq #NX2$ (cons (car #NX$) #NX2$))
    );if
    (setq #NX$ (cdr #NX$))
  ); while
  ; �c�����̈ʒu�֌W���`�F�b�N
  (setq #RES$ nil)
  (while (car #NX2$)
    (if (= 1 (PcChkZdirCross &eONE (car #NX2$)))
      (setq #RES$ (cons (car #NX2$) #RES$))
    );if
    (setq #NX2$ (cdr #NX2$))
  ); while

  #RES$
); PcChkItemNextInList

;<HOM>*************************************************************************
; <�֐���>    : PcChk4POver
; <�����T�v>  : �`�F�b�N���A�C�e���̎w��ӂ��O�ɓ_�����邩�H
; <�߂�l>    : �_��������= T   �Ȃ�= nil
; <�쐬>      : 00/05/15 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcChk4POver (
  &eONE       ; �`�F�b�N���ɂȂ�}�`��
  &eCHK
  &iL &iR &iF &iB ; �`�F�b�N������ӂ̎w�� 1 �� 0
  /
  #4P$ #xd$ #w #d #h #ang #p5 #p6 #p7 #p8 #RESflg
  ##JudgeOver
  )
  (defun ##JudgeOver (&JP1 &JP2 &ANG &4P$ / #CHKP #IntP #RES)
    (while (and (not #RES) (setq #CHKP (car &4P$)) )
      (setq #IntP (inters &JP1 &JP2 #CHKP (Pcpolar #CHKP &ANG 100) nil))
      (if (and
            (equal &ANG (angle #IntP #CHKP) 0.001)
            (not (and (equal (car #IntP) (car #CHKP) 0.001)
                      (equal (cadr #IntP) (cadr #CHKP) 0.001)))
          ); and
        (setq #RES 'T)(setq #RES nil)
      ); if
      (setq &4P$ (cdr &4P$))
    ); while
    #RES
  ); JudgeOver

  ; �`�F�b�N������4�_���o��
  (setq #4P$ (PcGetItem4P$ &eCHK 0 0 0 0))
  ;;; �`�F�b�N���A�C�e���̋�`�̈�S�_�����߂�
  (setq #xd$ (CFGetXData &eONE "G_SYM"))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #h (nth 5 #xd$))
  (setq #ang (nth 2 (CFGetXData &eONE "G_LSYM")))
  (setq #p5 (cdr (assoc 10 (entget &eONE))))
  ; �������Ⴄ�P�[�X���ΏۂȂ̂ŁAZ�l���ŏ��ɔ���
  (setq #p5 (list (read (rtos (car #p5) 2 10)) (read (rtos (cadr #p5) 2 10))))
  (setq #p6 (Pcpolar #p5 #ang #w))
  (setq #p7 (Pcpolar #p6 (- #ang (dtr 90)) #d))
  (setq #p8 (Pcpolar #p5 (- #ang (dtr 90)) #d))
  (setq #RESflg nil)
  ; ���Ӄ`�F�b�N
  (if (= 1 &iL)
    (setq #RESflg (##JudgeOver #p5 #p8 (angle #p6 #p5) #4P$)))
  ; �E�Ӄ`�F�b�N
  (if (and (not #RESflg) (= 1 &iR))
    (setq #RESflg (##JudgeOver #p6 #p7 (angle #p5 #p6) #4P$)))
  ; ��Ӄ`�F�b�N
  (if (and (not #RESflg) (= 1 &iB))
    (setq #RESflg (##JudgeOver #p5 #p6 (angle #p8 #p5) #4P$)))
  ; �O�Ӄ`�F�b�N
  (if (and (not #RESflg) (= 1 &iF))
    (setq #RESflg (##JudgeOver #p8 #p7 (angle #p5 #p8) #4P$)))
  #RESflg
); PcChk4POver

;<HOM>*************************************************************************
; <�֐���>    : PcJudgeCrossing
; <�����T�v>  : �Q�̃|�����C�����m�Ō���镔�������邩�ǂ������f������
; <�߂�l>    : ����� T  �ڐG�Ȃ� nil
; <�쐬>      : 00/03/30 MH 01/02/06 MOD
; <���l>      :
;*************************************************************************>MOH<
(defun PcJudgeCrossing (
  &dA$        ; ��̂̓_���X�gA
  &dB$        ; ��̂̓_���X�gB
  /
  ##getLINE$ #ALINE$ #BLINE$ #i #FLG  #CHKL$ #DA$ #DB$ 

  )
  (defun ##getLINE$ (&dP$ / #i #temp$)
    (setq #temp$ (list (list (last &dP$) (car &dP$))))
    (setq #i 0)
    (repeat (1- (length &dP$))
      (setq #temp$ (append #temp$ (list (list (nth #i &dP$) (nth (1+ #i) &dP$)))))
      (setq #i (1+ #i))
    ) 
    #temp$
  )
  ; �`�F�b�N�p�ɐ����X�g�쐬
  (if (< 1 (length &dA$)) (setq #ALINE$ (##getLINE$ &dA$)))
  (if (< 1 (length &dB$)) (setq #BLINE$ (##getLINE$ &dB$)))
  (setq #FLG nil)
  (while (and (not #FLG) (car #ALINE$))
    (setq #i 0)
    (while (and (not #FLG) (setq #CHKL$ (nth #i #BLINE$)))
      (if (inters (car (car #ALINE$)) (cadr (car #ALINE$)) (car #CHKL$) (cadr #CHKL$) T)
        (setq #FLG 'T)
      )
      (setq #i (1+ #i))
    ); while
    (setq #ALINE$ (cdr #ALINE$))
  ); while
  #FLG
); PcJudgeCrossing

;<HOM>*************************************************************************
; <�֐���>    : PcInsertItem&SetXData
; <�����T�v>  : �y�i�Ԑ}�`�z�����ɃA�C�e���ݒu
; <�߂�l>    : �ݒu�����}�`���B���s������nil
; <�쐬>      : 00-04-03   MH
; <���l>      : ���݂܂ł̓X�g���b�`�����s�v�Ȃ̂ŐL�k�ɑΉ����ĂȂ��B
;*************************************************************************>MOH<
(defun PcInsertItem&SetXData (
  &Z_QLY$      ; �i�Ԑ}�`�N�G��
  &dPNT        ; �}����_
  &fANG        ; �}���p�x
  /
  #K_QLY$ #FIG$ #eUNIT #ss #ang #pt
  #SHIN
  )
  (setq #sHIN (car &Z_QLY$))
  ;;; �i�Ԗ��̂���"�i�Ԋ�{"�N�G���l��
  (setq #K_QLY$ (PcGetPartQLY$  "�i�Ԋ�{" #sHIN nil nil))

  ;;; "�i�Ԑ}�`"��"�i�Ԋ�{"����SELPARTS.CFG �̓��e���X�g�Ɠ��������쐬����
  (setq #FIG$ (PcMakeFig$ByQLY &Z_QLY$ #K_QLY$ 0 0))
  (setq #eUNIT (PcSetItem "SET" nil #FIG$ &dPNT &fANG nil nil))
  #eUNIT
) ; PcInsertItem&SetXData

;<HOM>*************************************************************************
; <�֐���>    : PcChgH_GSYM
; <�����T�v>  : �g���f�[�^���̃V���{����t��������ύX����
; <�߂�l>    : �ݒu�����}�`���B���s������nil
; <�쐬>      : 2000-04-05   MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcChgH_GSYM(
  &eEN        ; �}�`��
  &dPNT       ; �}����_
  /
  #xd$
  )
  (setq #xd$ (CFGetXData &eEN "G_SYM"))
  (CFSetXData &eEN "G_SYM"
    (list
      (nth 0 #xd$)    ;�V���{������
      (nth 1 #xd$)    ;�R�����g�P
      (nth 2 #xd$)    ;�R�����g�Q
      (nth 3 #xd$)    ;�V���{����l�v
      (nth 4 #xd$)    ;�V���{����l�c
      (nth 5 #xd$)    ;�V���{����l�g
      (read (rtos (caddr &dPNT) 2 1))    ;�V���{����t������
      (nth 7 #xd$)    ;���͕��@
      (nth 8 #xd$)    ;�v�����t���O
      (nth 9 #xd$)    ;�c�����t���O
      (nth 10 #xd$)   ;�g�����t���O
      (nth 11 #xd$)   ;�L�k�t���O�v
      (nth 12 #xd$)   ;�L�k�t���O�c
      (nth 13 #xd$)   ;�L�k�t���O�g
      (nth 14 #xd$)   ;�u���[�N���C�����v
      (nth 15 #xd$)   ;�u���[�N���C�����c
      (nth 16 #xd$)   ;�u���[�N���C�����g
    )
  )
); PcChgH_GSYM

;<HOM>*************************************************************************
; <�֐���>    : PcPolar
; <�����T�v>  : Polar �̊�_��X��Y�[���̓_���g���ƌ��ʂ��������ɑΉ������֐�
; <�߂�l>    : ���ʂ̓_���W
; <�쐬>      : 00/03/30 MH
; <���l>      : Polar�̑�p�B�쓮�͓���
;*************************************************************************>MOH<
(defun PcPolar (
  &dPNT$      ; �_���X�g
  &fANG       ; �p�x(���W�A��)
  &fDIST      ; �ړ�����
  /
  ##PcMinusOne
  #dTENP$ #dRES$  ; ���ʂ̓_���W
  )
  (defun ##PcMinusOne (&fX &fY &fZ &plusX &plusY / #fX #fY)
    (setq #fX (+ (read (rtos &fX 2 10)) &plusX))
    (setq #fY (+ (read (rtos &fY 2 10)) &plusY))
    (if &fZ
      (list #fX #fY &fZ)
      (list #fX #fY)
    )
  ); ##PcMinusOne

  ; ���ꂼ��A0�̏ꏊ�ɉ���1�𑫂��āA���ʂ��o�Ă���1 ����
  (cond
    ; X�l,Y�l= 0
    ((and (= 0 (car &dPNT$)) (= 0 (cadr &dPNT$)))
      (setq #dTENP$ (list (+ 1.0 (car &dPNT$)) (+ 1.0 (cadr &dPNT$))))
      (if (numberp (caddr &dPNT$))
        (setq #dTENP$ (append #dTENP$ (list (caddr &dPNT$))))
      );if
      (setq #dTENP$ (polar #dTENP$ &fANG &fDIST))
      (setq #dRES$ (##PcMinusOne (car #dTENP$) (cadr #dTENP$) (caddr #dTENP$) -1.0 -1.0))
    )
    ; X�l= 0
    ((= 0 (car &dPNT$))
      (setq #dTENP$ (list (1+ (car &dPNT$)) (cadr &dPNT$)))
      (if (numberp (caddr &dPNT$))
        (setq #dTENP$ (append #dTENP$ (list (caddr &dPNT$))))
      );if
      (setq #dTENP$ (polar #dTENP$ &fANG &fDIST))
      (setq #dRES$ (##PcMinusOne (car #dTENP$) (cadr #dTENP$) (caddr #dTENP$) -1.0 0))
    )
    ; Y�l= 0
    ((= 0 (cadr &dPNT$))
      (setq #dTENP$ (list (car &dPNT$) (1+ (cadr &dPNT$))))
      (if (numberp (caddr &dPNT$))
        (setq #dTENP$ (append #dTENP$ (list (caddr &dPNT$))))
      );if
      (setq #dTENP$ (polar #dTENP$ &fANG &fDIST))
      (setq #dRES$ (##PcMinusOne (car #dTENP$) (cadr #dTENP$) (caddr #dTENP$) 0 -1.0))
    )
    ; X�l��Y�l����0
    (t (setq #dRES$ (polar &dPNT$ &fANG &fDIST))
    )
  ); end of cond
  #dRES$
); PcPolar

;<HOM>*************************************************************************
; <�֐���>    : PcGetItem4P$
; <�����T�v>  : �Ώېݔ��̋�`�̈�S�_�����߂�i�Q�����_�ɕϊ��j
; <�߂�l>    : �S�_�̃��X�g
; <�쐬>      : 2000-04-27 MH
; <���l>      :
;*************************************************************************>MOH<
(defun PcGetItem4P$ (
    &eONE     ;(ENAME)�Ώېݔ�
    &iL &iR &iF &iB ; �͈͂��w�肷�鍶�E�O��̐L�k�l(0�Ō��}�`�͈͂Ɠ��l)
    /
    #xd$ #ang #w #d #p1 #p2 #p3 #p4
  )
  (setq #xd$ (CFGetXData &eONE "G_SYM"))
  (setq #w (nth 3 #xd$))
  (setq #d (nth 4 #xd$))
  (setq #ang (nth 2 (CFGetXData &eONE "G_LSYM")))

  (setq #p1 (cdr (assoc 10 (entget &eONE))))
  (setq #p2 (Pcpolar #p1 #ang #w))
  (setq #p3 (Pcpolar #p2 (- #ang (dtr 90)) #d))
  (setq #p4 (Pcpolar #p1 (- #ang (dtr 90)) #d))

  (setq #p1 (list (car #p1) (cadr #p1)))
  (setq #p2 (list (car #p2) (cadr #p2)))
  (setq #p3 (list (car #p3) (cadr #p3)))
  (setq #p4 (list (car #p4) (cadr #p4)))
  ;;; �E���O��̐L�k�l�ŁA��`�̈�S�_���ړ�
  ; �O��
  (setq #p1 (Pcpolar #p1 (+ #ang (dtr 90)) &iB))
  (setq #p2 (Pcpolar #p2 (+ #ang (dtr 90)) &iB))
  (setq #p3 (Pcpolar #p3 (- #ang (dtr 90)) &iF))
  (setq #p4 (Pcpolar #p4 (- #ang (dtr 90)) &iF))
  ; ���E
  (setq #p1 (Pcpolar #p1 (+ #ang (dtr 180)) &iL))
  (setq #p2 (Pcpolar #p2 #ang               &iR))
  (setq #p3 (Pcpolar #p3 #ang               &iR))
  (setq #p4 (Pcpolar #p4 (+ #ang (dtr 180)) &iL))

  ; ���ʃ��X�g��Ԃ�
  (list #p1 #p2 #p3 #p4)
);PcGetItem4P

;<HOM>*************************************************************************
; <�֐���>    : PcGetNextSimilarItem$
; <�����T�v>  : �w��̕����ł�������̗אڐ}�`���r�؂��܂Ŏ��X�Ƀ��X�g�ɒǉ�
; <�߂�l>    : LIST
; <�쐬>      : 00-09-19 MH
; <���l>      :
;*************************************************************************>MOH<;
(defun PcGetNextSimilarItem$ (
  &chkFLG     ; �������w������t���O
  &sLR        ; �אڂ��擾���������
  &eCH        ; ��ƂȂ�ŏ��̃A�C�e��
  &eNX$       ; ���Ɏ擾���݂̗אڃA�C�e�����X�g
  &eNTCHK$    ; �`�F�b�N�Ώۂ̐}�`�����X�g
  /
  #eCH #exCH #eNX$ #eNEXT$ #FLG
  )
  (setq #eCH &eCH)
  (setq #eNX$ &eNX$)
  (while #eCH
    (setq #eNEXT$
      (cond
        ((= "L" &sLR) (PcChkItemNextInList #eCH 1 0 0 0 &eNTCHK$)) ; ��
        ((= "R" &sLR) (PcChkItemNextInList #eCH 0 1 0 0 &eNTCHK$)) ; �E
        (t nil)
      ); cond
    ); �w������אڐ}�`�擾
    ; �אڂ̒��Ɋm�F�Ώۂ̏����Ɉ�v����}�`������Ύ擾�B���̃`�F�b�N���Ƃ���
    (setq #exCH #eCH)
    (setq #eCH nil)
    (setq #FLG nil)
    (while (and (not #FLG) (setq #eNCHK$ (car #eNEXT$)))
      (setq #FLG
        (cond
          ((= "B" &chkFLG) (PcChkBuiltIn #eNCHK$))
          ((= "C" &chkFLG)
            (setq #sHIN (nth 5 (CFGetXData #eNCHK$ "G_LSYM")))
            (wcmatch #sHIN "T-###PS*,T-###PFD*")
          )
          ((= "SameAng" &chkFLG)
            (equal (read (angtos (nth 2 (CFGetXData #eNCHK$ "G_LSYM")) 0 3))
                   (read (angtos (nth 2 (CFGetXData #exCH "G_LSYM")) 0 3)) 0.01)
          )
          (t nil)
        ); cond
      ); setq
      (if #FLG (progn
          (setq #eCH #eNCHK$)
          (setq #eNX$ (cons #eNCHK$ #eNX$))
      )); if progn
      (setq #eNEXT$ (cdr #eNEXT$))
    ); while
  ); while
  #eNX$
); PcGetNextSimilarItem$

(princ)