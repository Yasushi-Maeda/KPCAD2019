;<HOM>*************************************************************************
; <�֐���>    : CFGetXData
; <�����T�v>  : �}�`�̊g���f�[�^���擾����
; <�߂�l>    :
;        LIST : �g���f�[�^�̓��e�̃��X�g
; <���l>      :
;               Ex.(GetXData #en "KIKI")  -> (20 "SMK" "0")
;                  (GetXData #en "WIRE") -> (8 20 19 "ZYO")
;                  (GetXData #en "*")    -> (20 "SMK" "0")
;*************************************************************************>MOH<
(defun CFGetXData (
    &en     ;(ENT) �}�`��
    &apn    ;(STR) �A�v���P�[�V������
    /
    #elm #xd$ #ret #lst$ #i
#ename ;-- 2012/02/27 A.Satoh Add
  )
  (setq #xd$ (cdr (cadr (assoc -3 (entget &en (list &apn))))))
;;; ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;; �g���f�[�^:(-3 ("G_LSYM" (1000 . "0020901") ( ) ...( ) ))

;;; (princ "\n#xd$=")(princ #xd$)
;;; #xd$=((1000 . JBT1-015DL) (1000 . ) (1000 . ) (1040 . 150.0)
;;;       (1040 . 605.0) (1040 . 825.0) (1040 . 0.0) (1070 . 3)
;;;       (1070 . 1) (1070 . 1) (1070 . 1) (1070 . 0)
;;;       (1070 . 0) (1070 . 0) (1070 . 0) (1070 . 0) (1070 . 0))
;;; ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  (if #xd$
    (progn
      (setq #i 0)
      (while (< #i (length #xd$))
        (setq #elm (nth #i #xd$))
        (if (= (car #elm) 1005)
;-- 2012/02/27 A.Satoh Mod - S
;;;;;          (setq #elm (cons 1005 (handent (cdr #elm))))
					(progn
						(setq #ename (handent (cdr #elm)))
						(if (= #ename nil)
							(setq #elm (cons 1000 (cdr #elm)))
							(setq #elm (cons 1005 #ename))
						)
					)
;-- 2012/02/27 A.Satoh Mod - E
        )
        (if (= (cdr #elm) "{")
          (progn
            (setq #i (1+ #i))
            (setq #elm (nth #i #xd$))
            (setq #lst$ nil)
            (while (/= (cdr #elm) "}")
              (if (= (car #elm) 1005)
;-- 2012/02/27 A.Satoh Mod - S
;;;;;                (setq #elm (cons 1005 (handent (cdr #elm))))
								(progn
									(setq #ename (handent (cdr #elm)))
									(if (= #ename nil)
										(setq #elm (cons 1000 (cdr #elm)))
										(setq #elm (cons 1005 #ename))
									)
								)
;-- 2012/02/27 A.Satoh Mod - E
              )
              (setq #lst$ (append #lst$ (list (cdr #elm))))
              (setq #i (1+ #i))
              (setq #elm (nth #i #xd$))
            )
            (setq #ret (append #ret (list #lst$)))
          )
        ;else
          (progn
            (setq #ret (append #ret (list (cdr #elm))))
          )
        )
        (setq #i (1+ #i))
      )
    )
  )
  #ret
)
;CFGetXData

;<HOM>*************************************************************************
; <�֐���>    : CFSetXData
; <�����T�v>  : �}�`�Ɋg���f�[�^��t������
; <�߂�l>    :
;       ENAME : �g���f�[�^�t����̴�èè��
; <�쐬>      : 98-03-25 ��{����
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun CFSetXData (
    &en     ;(ENT)  �}�`��
    &apn    ;(STR)  ���ع���ݖ�
    &lst$   ;(LIST) �g���ް��t�����e��ؽ�  (10 "MOJI" 3.456)��
    /
    #eg     ;�}�`���
    #xdata$ ;�g���ް�
    #typ    ;���������
    #elm    ;�g���ް��v�f
    #elm$   ;
  )
  (setq #xdata$ (list &apn))
  (setq #eg (entget &en))
  (foreach #elm &lst$ ; �g���ް��t�����e��ؽĂ̊e�v�f
    (setq #typ (type #elm))
    (cond
      ((= #typ 'INT)  ;����
        (setq #elm$ (cons 1070 #elm))
      )
      ((= #typ 'REAL) ;����
        (setq #elm$ (cons 1040 #elm))
      )
      ((= #typ 'STR)  ;������
        (setq #elm$ (cons 1000 #elm))
      )
      ((= #typ 'LIST) ;ؽ�
        (setq #elm$ (cons 1010 #elm))
      )
      ((= #typ 'ENAME) ;�}�`�����
        (setq #elm$ (cons 1005 (cdr (assoc 5 (entget #elm)))))
      )
    );_(cond
    (setq #xdata$ (append #xdata$ (list #elm$)))
  )

  ;// �}�`�X�V
  (entmod (append #eg (list (list -3 #xdata$)))) ; �}�`���Ɋg���f�[�^��t��

  ;// �}�`����Ԃ�
  &en ; �����Ɠ���
)
;CFSetXData

;<HOM>************************************************************************
; <�֐���>    : CFModList
; <�����T�v>  : ؽĒ��̎w��v�f��ύX����
; <�߂�l>    :
;        LIST : �ύX���ؽ�
; <�쐬>      : 98-03-25 ��{����
; <���l>      : �Ȃ�
;************************************************************************>MOH<
(defun CFModList (
    &lst$       ;�ύX�v�f
    &lst$$      ;�Ώ�ؽ�
    /
    #i #j
    ;@@@#no #dat$ #NO$ ;00/01/30 HN MOD �d���ϐ��錾���C��
    #no #dat$
    #lst$ #no$
  )
  (setq #no$  (mapcar 'car &lst$$))
  (setq #dat$ (mapcar 'cadr &lst$$))
  (setq #i 0)
  (setq #j 0)
  (foreach #lst &lst$
    (if (member #i #no$)
      (progn
        (setq #lst$ (cons (nth #j #dat$) #lst$))
        (setq #j (1+ #j))
      )
      (setq #lst$ (cons #lst #lst$))
    )
    (setq #i (1+ #i))
  )
  (reverse #lst$)
)
;CFModList

;<HOM>*************************************************************************
; <�֐���>    : CFSetXRecord
; <�����T�v>  : �}�ʂɊg��ں��ނ�t������
; <�߂�l>    : �Ȃ�
; <�쐬>      : 98-03-25 ��{����
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun CFSetXRecord (
    &symbol   ;(STR) �I�u�W�F�N�g�̃L�[��
    &lst$     ;(LIST)�ݒ肷��f�[�^
    /
    #elm #elm$ #elm2 #xname
    #xrec$
    #typ
    #xlist$
  )
  (setq #xlist$ (dictsearch (namedobjdict) &symbol))
  (if (/= #xlist$ nil)
    (entdel (cdr (car #xlist$)))
  )
  ;// Xrecord �̃f�[�^ ���X�g���쐬���܂�
  (setq #xrec$ '((0 . "XRECORD")(100 . "AcDbXrecord")))
  (foreach #elm &lst$
    (setq #typ (type #elm))
    (cond
      ((= #typ 'INT)  ;����
        (setq #elm$ (cons 62 #elm))
      )
      ((= #typ 'REAL) ;����
        (setq #elm$ (cons 40 #elm))
      )
      ((= #typ 'STR)  ;������
        (setq #elm$ (cons 1 #elm))
      )
      ((= #typ 'LIST) ;ؽ�
        ;// �Ή��ł��Ȃ�
        (princ)
      )
      ((= #typ 'ENAME) ;�}�`��
        ;// �Ή��ł��Ȃ�
        (princ)
      )
    )
    (setq #xrec$ (append #xrec$ (list #elm$)))
  )
  ;// entmakex ���g���āA�I�[�i�[�̂Ȃ� Xrecord ���쐬���܂�
  (setq #xname (entmakex #xrec$))
  ;// �V���� Xrecord ���A���O�̕t�����I�u�W�F�N�g �f�B�N�V���i����
  ;// �ǉ����܂�
  (dictadd (namedobjdict) &symbol #xname)
)
;CFSetXRecord

;<HOM>*************************************************************************
; <�֐���>    : CFGetXRecord
; <�����T�v>  : �}�ʂ̊g��ں��ނ��擾����
; <�߂�l>    :
;        LIST : �g��ں��ނ̓��e��ؽ�
; <�쐬>      : 98-03-25 ��{����
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun CFGetXRecord (
  &symbol
  /
  #xlist$
  #elm
  #ret
  #i
  #loop
  )
  ; ���O�̕t�����I�u�W�F�N�g �f�B�N�V���i���� Xrecord ���������܂�
  (setq #xlist$ (dictsearch (namedobjdict) &symbol))
  (if (/= #xlist$ nil)
    (progn
      (setq #i 0)
      (setq #loop T)
      (while #loop
        (setq #elm (nth #i #xlist$))
        (if (= (car #elm) 100)
          (setq #loop nil)
        )
        (setq #i (1+ #i))
      )
      (while (/= nil (setq #elm (nth #i #xlist$)))
        (setq #ret (append #ret (list (cdr #elm))))
        (setq #i (1+ #i))
      )
      #ret
    )
  )
  ; 00/01/20 HN S-ADD 2000�p�ɕύX #ret �� (cdr #ret)
  (if (= "14" (substr (getvar "acadver") 1 2))
      #ret
      (cdr #ret)
  )
  ; 00/01/20 HN E-ADD 2000�p�ɕύX #ret �� (cdr #ret)
)
;CFGetXRecord

;<HOM>************************************************************************
; <�֐���>    : CFDelListItem
; <�����T�v>  : ���X�g���̎w��v�f���폜����
; <�߂�l>    :
;      ���X�g : �폜��̃��X�g
;
; <���l>      : �n�߂ɂ݂������v�f�̂ݍ폜
;               DelListItem �� Common.lsp
;************************************************************************>MOH<
(setq CFDelListItem DelListItem)

;<HOM>***********************************************************************
; <�֐���>   : CFAreaInPt
; <�@�\�T�v> : ���ړ_�ɑ΂��鑽�p�`�̓��O������s���B
; <�߂�l>   :
;        INT : -1:OUTSIDE 0:ON_LINE 1:INSIDE
; <���l>     : �Ȃ�
;***********************************************************************>MOH<*/
(defun CFAreaInPt (
    &pt      ; lNX : ���ړ_�w���W
            ; lNY : ���ړ_�x���W
    &plst$  ; ���p�`���_���X�g
    /
    #x1 #y1 #x2 #y2 #aa #bb #cc #dd #i #cnt #dx #dy #eps #ret #cc
  )
  ;// ������
  (setq #cnt 0)
  (setq #eps 0.000001)
  ;// ���ړ_�����������������̌�_���J�E���g����
  (setq #x2 (car (car &plst$)))
  (setq #y2 (cadr(car &plst$)))
  (setq #i 1)
  (setq #ret nil)
  (while (and (< #i (length &plst$))(= nil #ret))
    (setq #x1 #x2
      #y1 #y2
      #x2 (car (nth #i &plst$))
      #y2 (cadr(nth #i &plst$))
    )
    ;// ���E���̏ꍇ
    (if (equal &pt (list #x1 #y1 ) #eps)
      (setq #ret 0)
    )
    (if (and (= nil #ret)(/= &pt (list #x1 #y1 )))
      (progn
        (setq #aa (- #y1 #y2)
          #bb (- #x2 #x1)
          #cc (- (* #aa #x1 -1)(* #bb #y1))
          #dd (+ (* #aa #aa) (* #bb #bb))
          #dx (/ (- (* #bb #bb (car &pt))
                (* #aa #bb (cadr &pt))
                (* #aa #cc  ))
                #dd
              )
        #dy (/ (+ (* #aa #bb (car &pt) -1)
                (* #aa #aa (cadr &pt))
                (* #bb #cc -1))
                #dd
              )
        )
        (if (and (or (<= (*(- #dx #x1)(- #dx #x2) 0.)) (== #bb 0. ))
                 (or (<= (*(- #dy #y1)(- #dy #y2) 0.)) (== #aa 0. ))
                 (< (+ (*(- #dx (car &pt))(- #dx (car &pt)))
                       (*(- #dy (cadr &pt))(- #dy (cadr &pt)))
                   )
                   #eps
                 )
            )
            (setq #ret 0)
        )
      )
    )
    (if
      (and
        (or(and(<= #y1 (cadr &pt))(<(cadr &pt) #y2))
           (and(<= #y2 (cadr &pt))(<(cadr &pt) #y1))
        )
        (= nil #ret)
      )
      (if (> (/ (*(- #x2 #x1) (-(cadr &pt) #y1)) (- #y2 #y1))
             (- (car &pt) #x1)
          )
        (setq #cnt(1+ #cnt))
      )
    )
    (setq #i (1+ #i))
  )
  (if(= nil #ret)
    (setq #ret (1-(* 2(rem #cnt 2))))
  )
  #ret
)
;CFAreaInPt

;;<HOM>*************************************************************************
;; <�֐���>    : CFGetSameGroupSS
;; <�����T�v>  : ��������ް��èè����o��
;; <�߂�l>    :
;;        LIST : ���ް��èè�I���
;; <�쐬>      : 98-03-25 ��{����
;; <���l>      : �Ȃ�
;;*************************************************************************>MOH<
;(defun CFGetSameGroupSS (
;    &en
;    /
;    #eg$
;    #lst
;    #ss
;  )
;  (setq #ss (ssadd))
;  (setq #eg$ (entget (cdr (assoc 330 (entget &en)))))  ;// �e�}�ʏ����擾
;  (foreach #lst #eg$  ;// ��ٰ�����ް�}�`�̎擾
;    (if (= 340 (car #lst))
;      (setq #ss (ssadd (cdr #lst) #ss))
;    )
;  )
;  #ss
;)
;;CFGetSameGroupSS

;<HOM>*************************************************************************
; <�֐���>    : CFGetSameGroupSS
; <�����T�v>  : �����ٰ�߂����ް��èè����o��
; <�߂�l>    : �I���Z�b�g
;        LIST : ���ް��èè��ؽ� (ENAME ENAME ...)
; <�쐬>      : 98-03-25 ��{����
; <�C��>      : 98-07-29 �X�{������
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun CFGetSameGroupSS (
    &en      ; (ENAME)    �V���{���}�`��
    /
    #ss #en$ #eg$ #eg #gen #geg$ #en
  )

  (setq #ss (ssadd)) ; �V�K
  (setq #en$ nil)
  (setq #eg$ (entget &en)) ; �����}�`����èè� �ް�

  (foreach #eg #eg$
    (if (= 330 (car #eg))
      (progn
        (setq #gen  (cdr #eg))                ; 330 �}�`��
        (setq #geg$ (entget #gen))            ; 330 ��èè� �ް�

;;;       (princ "\n (length #geg$) = ")(princ (length #geg$))  ; @YM@ 00/01/27

        (foreach #geg #geg$
          (if (= 340 (car #geg))
            (progn
;;;             (setq #ss (ssadd (cdr #geg) #ss)) ; 340 �}�`��
              (ssadd (cdr #geg) #ss)  ; @YM@ 00/01/27
            );_progn
            ;(setq #en$ (cons (cdr #geg) #en$))
          )
        );_foreach
      )
    );_if
  )
  #ss
)
;CFGetSameGroupSS

;<HOM>*************************************************************************
; <�֐���>    : CFDrawRectOrRegionTransUcs
; <�����T�v>  : ���߂ɂ��A��`�܂��͗̈�����ײ݂���}������
; <�߂�l>    :
;        LIST : �쐬�����_��
; <�쐬>      : 97-05-07 ��{����
; <���l>      :
;*************************************************************************>MOH<
(defun CFDrawRectOrRegionTransUcs (
    &type   ;(INT)1:��`���� 2:�̈����
    /
    #p1 #p2 #pt$
    #en$
  )
  ;// ��`���̈�����ײ݂���}������
  (if (= &type 1)
    ;// ��`�̈�
    (progn
      (setq #p1 (getpoint "\n�n�߂̓_: "))
      (setq #p2 (getcorner #p1 "\n���̓_: "))
      (if (< (cadr #p1) (cadr #p2))
        (setq #pt$
          (list
            ;;#p1
            (list (car #p1) (cadr #p1) 0.0)
            (list (car #p2) (cadr #p1) 0.0)
            ;;#p2
            (list (car #p2) (cadr #p2) 0.0)
            (list (car #p1) (cadr #p2) 0.0)
          )
        )
      ;else
        (setq #pt$
          (list
            ;;#p1
            (list (car #p1) (cadr #p1) 0.0)
            (list (car #p1) (cadr #p2) 0.0)
            ;;#p2
            (list (car #p2) (cadr #p2) 0.0)
            (list (car #p2) (cadr #p1) 0.0)
          )
        )
      )
      (MakeCmLwPolyLine #pt$ "C")
    )
  ;else
    ;// �̈�
    (progn
      (setq #pt$ (CFGetDrawPlinePt 1))
      (MakeCmLwPolyLine #pt$ "C")
    )
  )
  #pt$
)
;CFDrawRectOrRegionTransUcs

;<HOM>*************************************************************************
; <�֐���>    : CFGetDrawPlinePt
; <�����T�v>  : �A�����������}�������̒[�_�̃��X�g���擾����
; <�߂�l>    :
;        LIST : �쐬�����_��
; <�쐬>      : 97-05-07 ��{����
; <���l>      :
;*************************************************************************>MOH<
(defun CFGetDrawPlinePt (
    &mode         ;(INT) �����L���Ƃ��邩(���b�Z�[�W�̂�)
                  ;      0:����
                  ;      1:�L��
    /
    #en$ #loop #msg #p1 #p2 #pt$ #os
  )
  (setq #loop T)
  (setq #msg "\n�n�߂̓_: ")
  (setq #p1 (getpoint "\n�n�߂̓_: "))
  (setq #p1 (list (car #p1) (cadr #p1)))
  (setq #pt$ (list #p1))
  (while (= T #loop)
    (initget "U C")
    (if (/= nil #p1)
      (if (= &mode 1)
        (setq #p2 (getpoint #p1 "\n���̓_/U=�߂�/C=����: "))
        (setq #p2 (getpoint #p1 "\n���̓_/U=�߂� : "))
      )
    )
    (cond
      ((or (= "C" #p2) (= nil #p2))
        (setq #loop nil)
      )
      ((= "U" #p2)
        (setq #p1 (trans (cdr (assoc 10 (entget (car #en$)))) 0 1))
        (entdel (car #en$))
        (setq #en$ (cdr #en$))
        (setq #pt$ (cdr #pt$))
      )
      (T
        (setq #p2 (list (car #p2) (cadr #p2)))
        (setq #pt$ (cons #p2 #pt$))
        (setq #os (getvar "OSMODE"))
        (setvar "OSMODE" 0)
        (command "_line" #p1 #p2 "")
        (setvar "OSMODE" #os)
        (setq #p1 #p2)
        (setq #en$ (cons (entlast) #en$))
      )
    )
  )
  (mapcar 'entdel #en$)
  (setq #pt$ (reverse #pt$))
)
;CFGetDrawPlinePt

;<HOM>*************************************************************************
; <�֐���>    : CFGetGroupEnt
; <�����T�v>  : �����ٰ�߂����ް��èè����o��
; <�߂�l>    :
;        LIST : ���ް��èè��ؽ� (ENAME ENAME ...)
; <�쐬>      : 98-03-25 ��{����
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun CFGetGroupEnt (
    &en       ;(ENAME)�C�ӂ̃O���[�v���̐}�`
    /
    #en #eg$ #lst #en$ #geg$ #gen
  )
  (setq #en$ nil)
  (setq #eg$ (entget &en))
  (foreach #eg #eg$
    (if (= 330 (car #eg))
      (progn
        (setq #gen  (cdr #eg))
        (setq #geg$ (entget #gen))
        (foreach #geg #geg$
          (if (= 340 (car #geg))
            (if (assoc 8 (entget (cdr #geg))) ; 00/02/17 HN ADD ��w����nil�`�F�b�N��ǉ�
              (setq #en$ (cons (cdr #geg) #en$))
            )
          )
        )
      )
    )
  )
  #en$
)
;CFGetGroupEnt

;<HOM>*************************************************************************
; <�֐���>    : CFublock
; <�����T�v>  : ���O�̂Ȃ������}�`�̍쐬
; <�߂�l>    :
; <�쐬>      : 98-04-28
; <���l>      :
;*************************************************************************>MOH<
(defun CFublock (
    &pt       ;(LIST)   �u���b�N��_
    &ss       ;(PICKSET)�u���b�N������}�`�I���Z�b�g
    /
    #i #eg #name
  )
  (entmake (list '(0 . "BLOCK")'(2 . "*Uxx")'(70 . 1)(cons 10 &pt)))
  (setq #i 0)
  (repeat (sslength &ss)
    (setq #eg (entget (ssname &ss #i)))
    (entmake  (cdr #eg))
    (setq #i  (1+ #i))
  )
  (setq #name (entmake '((0 . "ENDBLK"))))
  (setq #i 0)
  (repeat (sslength &ss)
    (entdel (ssname &ss #i))
    (setq #i (1+ #i))
  )
  (entmake (list '(0 . "INSERT")(cons 2 #name)(cons 10 &pt)))
)
;CFublock

;<HOM>*************************************************************************
; <�֐���>    : CFListSort
; <�����T�v>  : ���X�g�̃��X�g���w��v�f�ԍ��Ń\�[�g����
; <�߂�l>    : �\�[�g���ꂽ���X�g�̃��X�g
; <�쐬>      : 1998-08-13
; <���l>      :
;*************************************************************************>MOH<
(defun CFListSort (
    &llist$$   ;���X�g�̃��X�g
    &key       ;�\�[�g���郊�X�g�̗v�f�ԍ� 0 �`
    /
    #number_items       #partition_size
    #number_partitions  #first_index
    #last_index         #unsorted
    #count              #ptr_lst
    #sorted_list        #i         #j
    #t1                 #t2
  )

  (if (and &llist$$ &key)
    (progn
      (setq #number_items (length &llist$$)
            #partition_size #number_items
            #ptr_lst nil                  ;pointer list
            #count 0
            #unsorted T                   ;assume list #is not sorted
      )

      (while (< #count #number_items)
        (setq #ptr_lst (append #ptr_lst (list #count)) ;built pointer list
              #count (1+ #count)
        )
      ) ;while

    ;------------------------------------------------------------------

      (while #unsorted

        (setq #partition_size (fix (/ (1+ #partition_size) 2))
              #number_partitions (fix (/ #number_items #partition_size))
        )

        (if (= #partition_size 1)
          (setq #unsorted nil)       ;assume list #is sorted
        )

        (if (/= (rem #number_items #partition_size) 0)
          (setq #number_partitions (1+ #number_partitions))
        )
        (setq #first_index 0
              #i 1
        )
        (while (< #i #number_partitions)
          (setq #last_index (+ #first_index #partition_size))

          (if (> #last_index (- #number_items #partition_size))
            (setq #last_index (- #number_items #partition_size))
          )

          ;loop thru and test (j) to (j+offset) in pointer list

          (setq #j #first_index)
          (while (< #j #last_index)
            (if (> (nth &key (nth (nth #j #ptr_lst) &llist$$))
                   (nth &key (nth
                      (nth (+ #j #partition_size) #ptr_lst) &llist$$)
                   )
                )

              ; then swap items in pointer list
              (setq #t1 (nth #j #ptr_lst)
                    #t2 (nth (+ #j #partition_size) #ptr_lst)
                    #ptr_lst (subst #t2 -1
                              (subst #t1 #t2
                                (subst -1 #t1 #ptr_lst)
                              )
                            )
                    #unsorted T
              ) ;setq
            ) ;if

            (setq #j (1+ #j))

          ) ;while #j

          (setq #first_index (+ #first_index #partition_size)
                #i (1+ #i)
          )

        ) ;while #i


      ) ;while #unsorted

    ;------------------------------------------------------------------
      ;Build new list using sorted pointers

      (setq #count 0 #sorted_list nil)
      (while (< #count #number_items)
        (setq #sorted_list
                (append #sorted_list        ;build updated list
                  (list
                    (nth
                      (nth #count #ptr_lst)  ;pointer
                      &llist$$
                    )
                  )
                )
              #count (1+ #count)
        ) ;setq
      ) ;while

      #sorted_list                          ;return sorted list
    ) ;progn

    ;else
    nil
  ) ;if
)
;CFListSort

;<HOM>*************************************************************************
; <�֐���>    : CFMargeSort
; <�����T�v>  : ���X�g�̃}�[�W�\�[�g���s��
; <�߂�l>    : �\�[�g���ꂽ���X�g
; <�쐬>      : 97-02-17
; <�쐬��>    : ���� ��
; <���l>      : �Ȃ�
;*************************************************************************>MOH<
(defun CFMargeSort (
    &L1$  ;(LIST)�\�[�g���s�����X�g
    /
    #flg #i1 #itmp #L2$ #Ltmp$
  )
  (if (and(= 'LIST(type &L1$))(/= 0 (length &L1$)))
    (progn
      (setq #i1 1)                                  ;#i1     &L1$$����
      (setq #Ltmp$ '())                             ;#Ltmp$  �ꎞ��r�pؽ�
      (setq #L2$   '())                             ;#Ltmp$  �ꎞ��r�p����
      (setq #Ltmp$ (cons (nth 0 &L1$) #Ltmp$))      ;#L2$    ����ؽ�(�Ԓl)
      (setq #L2$   #Ltmp$)                          ;#flg    �}���O nil   �}���� T
      (while (< #i1 (length   &L1$))
        (setq #Ltmp$ (reverse #L2$))
        (setq #L2$ '())
        (setq #itmp   0)
        (setq #flg nil)
        (while (< #itmp (length #Ltmp$))
          (cond
            ((> (nth #i1 &L1$)(nth #itmp #Ltmp$))                     ;��r�l��菬
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
            )
            ((and (= #flg nil)(<= (nth #i1 &L1$)(nth #itmp #Ltmp$)))  ;��r�l����
              (setq #L2$ (cons (nth #i1    &L1$  ) #L2$))
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
              (setq #flg T)
            )
            (T                                                        ;�����
              (setq #L2$ (cons (nth #itmp #Ltmp$) #L2$))
            )
          )
          (setq #itmp (1+ #itmp))
        )
        (if (= #flg nil)                                              ;��r�l���ő�
          (setq #L2$ (cons (nth #i1    &L1$  ) #L2$))
        )
        (setq #i1 (1+ #i1))
      )
      (reverse #L2$)
    )
  )
)
;CFMargeSort

;<HOM>*************************************************************************
; <�֐���>    : CFAlertErr
; <�����T�v>  : �x���_�C�A���O�\����A�G���[�I��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CFAlertErr (
    &msg        ;(STR)���b�Z�[�W���e
  )
  (c:msgbox &msg "�x��" (logior MB_OK MB_ICONEXCLAMATION))
;;;  (*error*)
)
;CFAlertErr

;<HOM>*************************************************************************
; <�֐���>    : CFAlertMsg
; <�����T�v>  : �x���_�C�A���O�\��
; <�߂�l>    : �Ȃ�
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CFAlertMsg (
    &msg        ;(STR)���b�Z�[�W���e
  )
  (c:msgbox &msg "�x��" (logior MB_OK MB_ICONEXCLAMATION))
)
;CFAlertMsg

;<HOM>*************************************************************************
; <�֐���>    : CFYesNoDialog
; <�����T�v>  : �m�F�_�C�A���O�\��(Yes,Cancel)
; <�߂�l>    :
;           T : �͂�
;         nil : ������
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CFYesNoDialog (
    &msg        ;(STR)���b�Z�[�W���e
  )
  (if (= IDYES (c:msgbox &msg "�m�F" (logior MB_YESNO MB_ICONQUESTION)))
    T
    nil
  )
)
;CFYesNoDialog

;<HOM>*************************************************************************
; <�֐���>    : CfYesNoJpDlg
; <�����T�v>  : �m�F�_�C�A���O(�͂�,������)
; <�߂�l>    : T:(�͂�)  nil:(������)
; <�쐬>      : 00/08/04 MH
; <���l>      :
;*************************************************************************>MOH<
(defun CfYesNoJpDlg (
  &sMSG       ;(������) �m�F���b�Z�[�W
  &sDFO       ;(������) "Yes" "No" �ǂ�����f�t�H���g�ɁH
  /
  #dcl_id #ret
  )
  ;// �߂�l�̏����ݒ�
  (setq #dcl_id (load_dialog (strcat CG_DCLPATH "KCMAIN.DCL")))
  (if (not (new_dialog
    (if (= "YES" (strcase &sDFO)) "YesDefo_No_Dlg" "Yes_NoDefo_Dlg") #dcl_id)) (exit))
  (set_tile "msg" &sMSG)
  (action_tile "accept" "(setq #ret T)  (done_dialog)")
  (action_tile "cancel" "(setq #ret nil)(done_dialog)")
  (start_dialog)
  (unload_dialog #dcl_id)
  #ret
); CfYesNoJpDlg

;<HOM>*************************************************************************
; <�֐���>    : CFAlertYesNoDialog
; <�����T�v>  : �x���_�C�A���O�\��(Yes,Cancel)
; <�߂�l>    :
;           T : �͂�
;         nil : ������
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CFAlertYesNoDialog (
    &msg        ;(STR)���b�Z�[�W���e
  )
  (if (= IDYES (c:msgbox &msg "�x��" (logior MB_YESNO MB_ICONASTERISK)))
    T
    nil
  )
)
;CFAlertYesNoDialog

;<HOM>*************************************************************************
; <�֐���>    : CFYesNoCancelDialog
; <�����T�v>  : �m�F�_�C�A���O�\��(Yes,No,Cancel)
; <�߂�l>    :
;    ID_YES   : �͂�
;    ID_CANCEL: �L�����Z��
;    ID_NO    : ������
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CFYesNoCancelDialog (
    &msg        ;(STR)���b�Z�[�W���e
    /
    #ret
  )
  (c:msgbox &msg "�m�F" (logior MB_YESNOCANCEL MB_ICONQUESTION))
)
;CFYesNoCancelDialog

;<HOM>*************************************************************************
; <�֐���>    : CFYesDialog
; <�����T�v>  : �m�F�_�C�A���O�\��(Yes)
; <�߂�l>    :
;    ID_YES   : �͂�
; <�쐬>      : 1999-10-05
; <���l>      :
;*************************************************************************>MOH<
(defun CFYesDialog (
    &msg        ;(STR)���b�Z�[�W���e
  )
  (c:msgbox &msg "�m�F" (logior MB_OK MB_ICONASTERISK))
)
;CFYesDialog

;<HOM>************************************************************************
; <�֐���>    : CFModListItem
; <�����T�v>  : ؽĒ��̎w��v�f��ύX����
; <�߂�l>    :
;        LIST : �ύX���ؽ�
; <�쐬>      : 98-03-25 ��{����
; <���l>      : �Ȃ�
;************************************************************************>MOH<
(defun CFModListItem (
    &mem      ;(???) �ύX�v�f
    &n        ;(INT) �ύX�v�f�ԍ�
    &list$    ;(LIST)�Ώ�ؽ�
    /
  )
  (cond
    ((equal &n 1)
      (cons &mem (cdr &list$))
    )
    (T
      (cons (car &list$) (CFModListItem &mem (1- &n) (cdr &list$)))
    )
  )
)
;CFModListItem

;<HOM>************************************************************************
; <�֐���>    : CFarea_rl
; <�����T�v>  : �_�̃x�N�g���ɑ΂��鍶�E�̔���
; <�߂�l>    :
;         INT : 1:�� -1:�E 0:��������
;
; <�쐬>      : 97-03-18 ������
; <���l>      : pp �� sp -> ep �̍��E�ǂ���ɂ��邩���肷��
;
;                                           pp( 1)
;
;                 sp =============> ep      pp( 0)
;
;                                           pp(-1)
;************************************************************************>MOH<
(defun CFArea_rl (
    &sp     ;(LIST)�x�N�g���̈�_��
    &ep     ;(LIST)�x�N�g���̓�_��
    &pp     ;(LIST)���肷��_
    /
    #RL
  )
  (setq #RL(- (* (-(car &ep)(car &sp))(-(cadr &pp)(cadr &sp)))
              (* (-(car &pp)(car &sp))(-(cadr &ep)(cadr &sp)))
           )
  )
  (cond ((> #RL 0) 1)       ;��
        ((< #RL 0)-1)       ;�ǂ���ł��Ȃ�
        (T        0)        ;�E
  )
)
;CFarea_rl

;<HOM>*************************************************************************
; <�֐���>    : CFGetDropPt
;
; <�����T�v>  : �w��_����w������ɑ΂��Ă̐��_��Ԃ�
;
; <�߂�l>    : ������_���W (px py 0) : ����
;               nil                    : ���܂�Ȃ�
;
; <���l>      :
;                                       �^
;                                     �^
;                     ���܂������W����
;                                 �^  �_
;                               �^      �_
;                                         �_
;                                           �_    &pt$
;                                             + ���w����W
;*************************************************************************>MOH<
(defun CFGetDropPt (
    &pt    ;(LIST)���W
    &pt$   ;(LIST)�n�I�_���W���X�g
    /
    #eg #pls #ple #ans #ang #ptv
  )
  ;// �w������G���e�B�e�B����n�I�_�����o��
  (setq #pls (nth 0 &pt$))
  (setq #ple (nth 1 &pt$))

  ;// �n�_�𒆐S�Ƃ����I�_�̊p�x�����߂�
  (setq #ang  (angle #pls #ple))

  ;// �w��_����w������ɐ����Ȓ���10�̉��z�������쐬
  (setq #ptv  (polar &pt (+ #ang(/ PI 2.)) 10))

  ;// �w������Ɖ��z�����̉��z��_�����߂�
  (setq #ans (inters #pls #ple &pt #ptv nil))

  ;// ���_��Ԃ�
  #ans
)
;CFGetDropPt

;<HOM>*************************************************************************
; <�֐���>    : CFCnvElistToSS
; <�����T�v>  : �}�`���X�g��I���Z�b�g�ɕϊ�����
; <�߂�l>    :
;     PICKSET : �I���Z�b�g
; <���l>      :
;*************************************************************************>MOH<
(defun CFCnvElistToSS (
    &en$             ;(LIST)�}�`���X�g
    /
    #ss
    #en
  )
  (setq #ss (ssadd))
  (foreach #en &en$
    (ssadd #en #ss)
  )
  #ss
)
;CFCnvElistToSS

;;;<HOM>***********************************************************************
;;; <�֐���>    : CfDwgOpenByScript
;;; <�����T�v>  : �}�ʃt�@�C�����I�[�v������B
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000/02/03 ���� ���L
;;; <���l>      : �I�[�v���p�̃X�N���v�g-�t�@�C�����쐬���āA�Ăяo���܂��B
;;;               (command ".OPEN") �̕����ł́AAcad.lsp�������Ǎ��݂��Ȃ��ׁB
;;;***********************************************************************>MOH<
(defun CfDwgOpenByScript (
  &sFileOpen    ; �I�[�v��-�t�@�C����
  /
  #sFileScr     ; �X�N���v�g-�t�@�C����
  #pFileScr     ; �X�N���v�g-�t�@�C���̃t�@�C��-�|�C���^
  )

  (if (/= nil (findfile &sFileOpen))
    (progn
      ;00/08/29 HN MOD �p�X�w��ǉ�
      ;@@@(setq #sFileScr "Open.scr")
      (setq #sFileScr (strcat CG_SYSPATH "Open.scr"))

      (setq #pFileScr (open #sFileScr "w"))
      (if (/= nil #pFileScr)
        (progn
          (write-line "_.OPEN" #pFileScr)
          (if (/= 0 (getvar "DBMOD"))
            (write-line "Y" #pFileScr)
          )
          (write-line &sFileOpen #pFileScr)
          (close #pFileScr)
        )
      )
    )
    (progn
      (princ (strcat "\ņ�� " &sFileOpen " �����݂��܂���B"))
    )
  )

  (command "._SCRIPT" #sFileScr)

  (princ)
) ; CfDwgOpenByScript

;;;<HOM>***********************************************************************
;;; <�֐���>    : CfDwgNewByScript
;;; <�����T�v>  : �V�K�}�ʃt�@�C�����I�[�v������B
;;; <�߂�l>    : �Ȃ�
;;; <�쐬>      : 2000/02/03 ���� ���L
;;; <���l>      : �I�[�v���p�̃X�N���v�g-�t�@�C�����쐬���āA�Ăяo���܂��B
;;;               (command ".OPEN") �̕����ł́AAcad.lsp�������Ǎ��݂��Ȃ��ׁB
;;;***********************************************************************>MOH<
(defun CfDwgNewByScript (
  &sFileTemp    ; �e���v���[�g-�t�@�C����
  /
  #sFileScr     ; �X�N���v�g-�t�@�C����
  #pFileScr     ; �X�N���v�g-�t�@�C���̃t�@�C��-�|�C���^
  )

  ;00/08/29 HN MOD �p�X�w��ǉ�
  ;@@@(setq #sFileScr "New.scr")
  (setq #sFileScr (strcat CG_SYSPATH "New.scr"))

  (setq #pFileScr (open #sFileScr "w"))
  (if (/= nil #pFileScr)

    (progn
      (write-line "_.NEW" #pFileScr)
      (if (/= 0 (getvar "DBMOD"))
        (write-line "Y" #pFileScr)
      )
      (write-line &sFileTemp #pFileScr)
      (close #pFileScr)
    )
  )

  (command "._SCRIPT" #sFileScr)

  (princ)
) ; CfDwgNewByScript

;<HOM>*************************************************************************
; <�֐���>    : CFRefreshHatchEnt
; <�����T�v>  : �n�b�`���O�}�`���X�V����
; <�߂�l>    : �Ȃ�
; <���l>      : �n�b�`���O�}�`�� (entmake) �֐��ō쐬�����ꍇ�A
;               �X�P�[�������݂̃X�P�[���ɔ��f����Ȃ����߁A
;               (command "-hatchedit")�ɂ�葮���̍čX�V���Ȃ�
;               ��΂Ȃ�Ȃ����ߖ{�֐����쐬����
;  00/02/07 1/31����R�s�[
;*************************************************************************>MOH<
(defun CFRefreshHatchEnt (;  00/02/07 1/31����R�s�[
  /
  #flg
  #ss
  #i
  #eHat
  #sPat
  )
  ;�y�[�p�[��Ԃ̂Ƃ��A��x���f����ԂɈړ����A�n�b�`���O���X�V����B
  (if (= 0 (getvar "TILEMODE"))
    (progn
      (setq #flg T)
      (command "_.mspace")
    )
  )
  (setq #ss (ssget "X" '((0 . "HATCH"))))
  (if (/= nil #ss)
    (progn
      (setq #i 0)
      (repeat (sslength #ss)
        (setq #eHat (ssname #ss #i))
        (setq #sPat (cdr (assoc 2 (entget #eHat))))
        (if (= "SOLID" #sPat)
          (command "_.-hatchedit" #eHat "P" "")
          (command "_.-hatchedit" #eHat "P" "" "" "")
        )
        (setq #i (1+ #i))
      )
    )
  )
  (if (/= nil #flg)
    (command "_.pspace")
  )
)

;00/08/24 SN S-MOD
; ȽĂ��ꂽ�e�֐��ź�ق���O���ϐ����㏑�������̂ő���ł͕��A�ł��Ȃ��B
; ����āA�L������O���ϐ���list�ɂ�������o���@�ɂ�����q�ɑΉ�����B
; CFNoSnapReset�ͺ���ވ�A����̐擪�ź�ق���B
; CFNoSnapFinish�ͺ���ވ�A����̍Ō�ź�ق���B
;   ����q�̂��܂�����Ȃ����A
;   �����I�Ɉ�ԍŏ��ɓ��ꂽ�ް������O���ϐ���ؾ�Ă���B
;

(defun CFNoSnapStart ();  00/02/07 1/31����R�s�[
  ;ؽĂ̐擪�ɍŏI�̼��ѕϐ���ǉ�
  (setq CG_OSMODE   (cons (getvar "OSMODE")   CG_OSMODE))

	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(setq CG_3DOSMODE  (cons (getvar "3DOSMODE" ) CG_3DOSMODE ));2011/06/30 YM ADD
  		(setq CG_UCSDETECT (cons (getvar "UCSDETECT") CG_UCSDETECT))
		)
	);_if
  (setq CG_SNAPMODE (cons (getvar "SNAPMODE") CG_SNAPMODE))

  (setvar "OSMODE"   0)


	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(setvar "3DOSMODE"  1) ;2011/06/30 YM ADD
			(setvar "UCSDETECT" 0) ;�_�C�i�~�b�N UCS ���A�N�e�B�u�ɂ��Ȃ� 2011/10/11 YM ADD
		)
	);_if
  (setvar "SNAPMODE" 0)
);defun



(defun CFNoSnapEnd ();  00/02/07 1/31����R�s�[
  ;ؽĂ̐擪���缽�ѕϐ���ݒ�
  (if (car CG_OSMODE)   (setvar "OSMODE"   (car CG_OSMODE)))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(if (car CG_3DOSMODE)  (setvar "3DOSMODE"  (car CG_3DOSMODE )));2011/06/30 YM ADD
  		(if (car CG_UCSDETECT) (setvar "UCSDETECT" (car CG_UCSDETECT)))
		)
	);_if
  (if (car CG_SNAPMODE) (setvar "SNAPMODE" (car CG_SNAPMODE)))

  ;ؽčč쐬
  (setq CG_OSMODE   (cdr CG_OSMODE))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
	  	(setq CG_3DOSMODE  (cdr CG_3DOSMODE ));2011/06/30 YM ADD
	  	(setq CG_UCSDETECT (cdr CG_UCSDETECT))
		)
	);_if
  (setq CG_SNAPMODE (cdr CG_SNAPMODE))
)
(defun CFNoSnapReset()
  (setq CG_OSMODE   '())
  (setq CG_3DOSMODE   '());2011/06/30 YM ADD
  (setq CG_SNAPMODE '())
)
(defun CFNoSnapFinish()
  ;ؽĂ̍Ōォ�缽�ѕϐ���ݒ�
  (if (last CG_OSMODE)   (setvar "OSMODE"   (last CG_OSMODE)))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(if (last CG_3DOSMODE)  (setvar "3DOSMODE"  (last CG_3DOSMODE )));2011/06/30 YM ADD
  		(if (last CG_UCSDETECT) (setvar "UCSDETECT" (last CG_UCSDETECT)))
		)
	);_if
  (if (last CG_SNAPMODE) (setvar "SNAPMODE" (last CG_SNAPMODE)))
  (CFNoSnapReset)
)
;(defun CFNoSnapStart ();  00/02/07 1/31����R�s�[
;  (setq CG_OSMODE   (getvar "OSMODE"))
;  (setq CG_SNAPMODE (getvar "SNAPMODE"))
;  (setvar "OSMODE"   0)
;  (setvar "SNAPMODE" 0)
;)
;(defun CFNoSnapEnd ();  00/02/07 1/31����R�s�[
;  (setvar "OSMODE"   CG_OSMODE)
;  (setvar "SNAPMODE" CG_SNAPMODE)
;)
;00/08/24 SN E-MOD
;<HOM>*************************************************************************
; <�֐���>    : CFCmdDefStart
; <�����T�v>  : �R�}���h���s����
;               �X�i�b�v�E�O���b�h�E�������[�h�E�n�X�i�b�v
;               ���f�t�H���g�ݒ肷��B
; <����>      : &mode �ޯĉ��Z ���ꂼ��̘a�Őݒ肷��B
;               0:�S��OFF
;               1:�X�i�b�v���[�h�@�n�m
;               2:�O���b�h���[�h�@�n�m
;               4:�������[�h�@�@�@�n�m
;               8:�n�X�i�b�v���[�h�n�m
;               ��)�z�u�����              &mode=7  ON ON ON OFF
;                  ����ȯĂ�I���������� &mode=6 OFF ON ON OFF
; <�߂�l>    : �Ȃ�
; <�쐬>      : 00/09/07 SN
; <���l>      :
;*************************************************************************>MOH<
;�J�n
(defun CFCmdDefStart ( &mode )
  ;ؽĂ̐擪�ɍŏI�̼��ѕϐ���ǉ�
  (setq CG_DEFSNAPMODE  (cons (getvar "SNAPMODE" ) CG_DEFSNAPMODE ))
  (setq CG_DEFGRIDMODE  (cons (getvar "GRIDMODE" ) CG_DEFGRIDMODE ))
  (setq CG_DEFORTHOMODE (cons (getvar "ORTHOMODE") CG_DEFORTHOMODE))
  (setq CG_DEFOSMODE    (cons (getvar "OSMODE"   ) CG_DEFOSMODE   ))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
	  	(setq CG_DEF3DOSMODE   (cons (getvar "3DOSMODE" )  CG_DEF3DOSMODE  ));2011/06/30 YM ADD
	  	(setq CG_DEFUCSDETECT  (cons (getvar "UCSDETECT" ) CG_DEFUCSDETECT ))
		)
	);_if

  (if &mode (progn
    ;���ꂼ��̃r�b�g�ɂ��n�m�^�n�e�e��؂�ւ���
    (if (= (rem &mode 2) 1);�ů��Ӱ��
      (setvar "SNAPMODE"  1)
      (setvar "SNAPMODE"  0)
    )
    (if (= (rem (lsh &mode -1) 2) 1);��د��Ӱ��
      (setvar "GRIDMODE"  1)
      (setvar "GRIDMODE"  0)
    )
    (if (= (rem (lsh &mode -2) 2) 1);����Ӱ��
      (setvar "ORTHOMODE" 1)
      (setvar "ORTHOMODE" 0)
    )
    (if (= (rem (lsh &mode -3) 2) 1);O�ů��Ӱ��
			(progn
	      ;�ݒu�l��ێ�����OFF�̏ꍇ�͐ݒ肷��B
	      (if (> (car CG_DEFOSMODE) 16383) (setvar "OSMODE" (- (car CG_DEFOSMODE) 16384)))
			)
			;else
			(progn
				(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
					(progn
						;2011/06/30 YM ADD-S�yOSNAP OFF�z3DOSNAP�����łɈꏏ��OFF�ɂ���
						(setvar "3DOSMODE"  1) ;���ׂĂ� 3D �I�u�W�F�N�g �X�i�b�v�𖳌��ɂ���
						(setvar "UCSDETECT" 0) ;�_�C�i�~�b�N UCS ���A�N�e�B�u�ɂ��Ȃ� 2011/10/11 YM ADD
					)
				);_if
	      ;�ݒu�l��ێ�����OFF�ɂ���(osnap)
	      (if (< (car CG_DEFOSMODE) 16384) (setvar "OSMODE" (+ (car CG_DEFOSMODE) 16384)))
			)
    )
  ));End if-progn
)
;�I��
(defun CFCmdDefEnd ()
  ;ؽĂ̐擪���缽�ѕϐ���ݒ�
  (if (car CG_DEFSNAPMODE ) (setvar "SNAPMODE"  (car CG_DEFSNAPMODE )))
  (if (car CG_DEFGRIDMODE ) (setvar "GRIDMODE"  (car CG_DEFGRIDMODE )))
  (if (car CG_DEFORTHOMODE) (setvar "ORTHOMODE" (car CG_DEFORTHOMODE)))
  (if (car CG_DEFOSMODE   ) (setvar "OSMODE"    (car CG_DEFOSMODE   )))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(if (car CG_DEF3DOSMODE )  (setvar "3DOSMODE"   (car CG_DEF3DOSMODE  )));2011/06/30 YM ADD
  		(if (car CG_DEFUCSDETECT ) (setvar "UCSDETECT"  (car CG_DEFUCSDETECT )))
		)
	);_if
  ;ؽčč쐬
  (setq CG_DEFSNAPMODE  (cdr CG_DEFSNAPMODE ))
  (setq CG_DEFGRIDMODE  (cdr CG_DEFGRIDMODE ))
  (setq CG_DEFORTHOMODE (cdr CG_DEFORTHOMODE))
  (setq CG_DEFOSMODE    (cdr CG_DEFOSMODE   ))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
  		(setq CG_DEF3DOSMODE   (cdr CG_DEF3DOSMODE  ));2011/06/30 YM ADD
  		(setq CG_DEFUCSDETECT  (cdr CG_DEFUCSDETECT ))
		)
	);_if
)
;�O���ϐ�������
(defun CFCmdDefReset()
  (setq CG_DEFSNAPMODE  '())
  (setq CG_DEFGRIDMODE  '())
  (setq CG_DEFORTHOMODE '())
  (setq CG_DEFOSMODE    '())
  (setq CG_DEF3DOSMODE  '());2011/06/30 YM ADD
  (setq CG_DEFUCSDETECT '())
)
;��������J�n
(defun CFCmdDefBegin( &mode )
  (CFCmdDefReset)
  (CFCmdDefStart &mode)
)
;�����I��&������
(defun CFCmdDefFinish()
  ;ؽĂ̍Ōォ�缽�ѕϐ���ݒ�
  (if (last CG_DEFSNAPMODE ) (setvar "SNAPMODE"  (last CG_DEFSNAPMODE )))
  (if (last CG_DEFGRIDMODE ) (setvar "GRIDMODE"  (last CG_DEFGRIDMODE )))
  (if (last CG_DEFORTHOMODE) (setvar "ORTHOMODE" (last CG_DEFORTHOMODE)))
  (if (last CG_DEFOSMODE   ) (setvar "OSMODE"    (last CG_DEFOSMODE   )))
	(if (or (= "19" CG_ACADVER)(= "18" CG_ACADVER))
		(progn
	  	(if (last CG_DEF3DOSMODE  ) (setvar "3DOSMODE"   (last CG_DEF3DOSMODE )));2011/06/30 YM ADD
	  	(if (last CG_DEFUCSDETECT ) (setvar "UCSDETECT"  (last CG_DEFUCSDETECT )))
		)
	);_if
  (CFNoSnapReset)
)


;<HOM>*************************************************************************
; <�֐���>    : CFgetini
; <�����T�v>  : ini �t�@�C���̓��e��ǂݍ���
; <�߂�l>    :
;         STR : �ǂݍ��񂾍��ڕ���
;             ; �ǂݍ��߂Ȃ������ꍇ nil
; <���l>      :
;*************************************************************************>MOH<
(defun CFgetini (
   &sSection	; [�Z�N�V����]
   &sEntry	; �G���g���[=
   &sFilename	; \\�t�@�C���� (�t���p�X�Ŏw��)
   /
   #pRet	; �t�@�C�����ʎq
   #sLine	; ���ݓǂݍ��ݍs
   #sSection	; ���݃Z�N�V����
   #sEntry	; ���݃G���g��
   #sEntStr	;
   #sTmp	;
   #iColumn	;
   #sRet	;
#END_FLG
   )
;///////////////////////////////////////////////////////////////////////
  	;; �R�����g���Ȃ���������ɂ���
	;; �Ȃ������ʈӖ��̂Ȃ��s�ɂȂ�ꍇ�� nil ��Ԃ�
  	(defun Comment_Omit (
			&sLine
			/
			 #iIDX	;
			)
	    ; �R�����g�s
        ; XXX �����͂���ł������H�H
      (setq #iIDX (vl-string-position (ascii ";") &sLine))
      (if (/= #iIDX nil)
				(progn
				  (setq &sLine (substr &sLine 1 #iIDX)) 
				 )
      );_if

	      ; �Ӗ��̂���s�ɂ� = �� [ ] ���܂܂��͂�
      (if (or (vl-string-position  (ascii "=") &sLine)
      	 (and (vl-string-position  (ascii "[") &sLine)
	            (vl-string-position  (ascii "]") &sLine)))
				  &sLine
				  nil
      );_if
	);Comment_Omit
;///////////////////////////////////////////////////////////////////////
  	; �t�@�C�����I�[�v��
	(setq #END_FLG T) ; �擾������I��� 01/02/06 YM ADD

	(setq #pRet (open &sFilename "r"))
	(if (/= #pRet nil)
	  (progn
      (setq #sLine (read-line #pRet))
      ; 1�s���ǂݍ���
	    (while (and #END_FLG (/= #sLine nil))
	      ; �R�����g�s���Ȃ�
	      (setq #sLine (Comment_Omit #sLine))
	      ; �L���ȍs�������ꍇ
	      (if (/= #sLine nil)
					(progn 
          ; ���ݍs�̃Z�N�V���������擾����
					  (setq #sTmp (vl-string-right-trim " \t\n" (vl-string-left-trim "[" #sLine)))
	          (if (/= #sTmp #sLine)
            	(setq #sSection (substr #sLine 2 (- (strlen #sTmp) 1)))
	          );_if
	      
	          ; ���ݍs�̃Z�N�V�������Ǝw�肵���Z�N�V���������������ꍇ
		  			; �G���g������������
					  (if (= &sSection #sSection)
					    (progn 
                (setq #sLine (read-line #pRet))
					      (while (and #END_FLG (/= #sLine nil))
									; �R�����g�s���Ȃ�
					        (setq #sLine (Comment_Omit #sLine))
									; �L���ȍs�������ꍇ
									(if (/= #sLine nil)
				          ; �G���g�����擾����
				          ; XXX �G���g���͍ŏ��̃J��������n�܂�A�X�y�[�X,=���܂܂Ȃ��A�Ƃ��Ă悢���H
									  (progn 
									    (setq #sEntry (car (strparse #sLine "=")))
							  	    (setq #sEntStr (cadr (strparse #sLine "=")))
									    ; �擾�����L���ȃG���g���Ǝw�肵���G���g�����r����
									    (if  (and (/= #sEntry nil) (= #sEntry &sEntry))
					              (progn
								 	        (setq #sRet #sEntStr)
													(setq #END_FLG nil) ; �擾������I��� 01/02/06 YM ADD
													;;; \\n ��\n�ɒu������
													(while (vl-string-search "\\n" #sRet) ; "\\n"�����邩?
														(setq #sRet (vl-string-subst "\n" "\\n" #sRet)) ; �ŏ���1�u��
													)
					              )
		                  );_if
									  )
	        				) ; (if (/= #sLine nil)
									(setq #sLine (read-line #pRet))
		      			) ; (while (/= #sLine nil)
			   	    ) ; progn
					  ) ; if (= &sSection #sSection)
					)
	      );_if
	      (setq #sLine (read-line #pRet))
	    ); while (/= #sLine nil)

;2014/12/04 Y.Ikeda ADD �t�@�C���N���[�Y
      (close #pRet)

		)
		(progn
		; �t�@�C���I�[�v���G���[  
	  	(print (strcat "�t�@�C�����Ȃ�:" &sFilename))
      nil
		)
	);_if

	(if (= nil #sRet)
		(CFAlertMsg (strcat "���b�Z�[�W [" &sSection "] " &sEntry " �Ԃ��Q�Ƃł��܂���B"
												"\nErrmsg.ini �̃o�[�W���������m�F���������B"))
	);_if
	#sRet
);CFgetini

;;;<HOM>************************************************************************
;;; <�֐���>  : CFDispYashiLayer
;;; <�����T�v>: ���w��\������
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun CFDispYashiLayer (
  )
  ;// �Ȃ���Ζ�̉�w���쐬����
  (MakeLayer CG_YASHI_LAYER       CG_YASHI_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_LAYER  CG_YASHI_COL "CONTINUOUS")

  ;// �Ȃ���Ζ�̈�̉�w���쐬����
  (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")

  (command "_.LAYER" "ON" "N_YASHI*" "")

)
;CFDispYashiLayer

;;;<HOM>************************************************************************
;;; <�֐���>  : CFHideYashiLayer
;;; <�����T�v>: ���w���\���ɂ���
;;; <�߂�l>  : �Ȃ�
;;; <���l>    : �Ȃ�
;;;************************************************************************>MOH<
(defun CFHideYashiLayer (
  )
  ;// �Ȃ���Ζ�̉�w���쐬����
  (MakeLayer CG_YASHI_LAYER       CG_YASHI_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_LAYER  CG_YASHI_COL "CONTINUOUS")

  ;// �Ȃ���Ζ�̈�̉�w���쐬����
  (MakeLayer CG_YASHI_AREA_LAYER           CG_YASHI_AREA_COL "CONTINUOUS")
  (MakeLayer CG_YASHI_PERS_HIDE_AREA_LAYER CG_YASHI_AREA_COL "CONTINUOUS")

  (command "_.LAYER" "OF" "N_YASHI*" "")
)
;CFHideYashiLayer

(princ)

