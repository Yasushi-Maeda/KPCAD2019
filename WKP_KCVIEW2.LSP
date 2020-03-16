(defun C:M1 ()  (Make1ViewPort)     (princ))
;;;;�R�ʃr���[�|�[�g�\���i�k�j
(defun C:M3L () (Make3ViewPort "L") (princ))
;;;;�R�ʃr���[�|�[�g�\���i�q�j
(defun C:M3R () (Make3ViewPort "R") (princ))
;;;;�S�ʃr���[�|�[�g�\��
(defun C:M4 ()  (Make4ViewPort)     (princ))

;;;<HOM>*************************************************************************
;;; <�֐���>    : NRMake1ViewPort
;;; <�����T�v>  : �K���ȂP�r���[�|�[�g���쐬����
;;; <�߂�l>    :
;;; <�쐬>      : 00/02/14 YM �S�ʏC�� 00/03/10 (setvar "GRIDMODE" 1)
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun Make1ViewPort (
    /
  )

  (setvar "TILEMODE" 1) ; ������� YM
  (setvar "tabmode" 0)
  (command "_vports" "SI") ; �ݸ���ޭ�
  (setvar "GRIDMODE" 1) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�  00/03/10 0 ==> 1

  ; 00/04/26 MH DEL ���O�̃J�����g�r���[�|�[�g�̂܂܂ɂ���
  ;(SKChgView "0,0,1") ; ���ʐ}�ɂ���

	;04/05/26 YM ADD
	(command "_REGEN")

  ;// UCS�A�C�R���̔�\��
  (command "_UCSICON" "A" "OF") ;UCS�A�C�R���̔�\��
)
;Make1ViewPort

;;;<HOM>*************************************************************************
;;; <�֐���>    : NRMake3ViewPort
;;; <�����T�v>  : �K����3�r���[�|�[�g���쐬����
;;; <�߂�l>    :
;;; <�쐬>      : 00/02/14 YM �S�ʏC��
;;; <���l>      :
;;;ID_SKVpointTop [_Button("���ʐ}", "ICON_16_VIETOP", "ICON_24_VIETOP")]^C^C^P(SKChgView "0,0,1") ^P
;;;ID_SKVpointBot [_Button("���ʐ}", "ICON_16_VIEBOT", "ICON_24_VIEBOT")]^C^C^P(SKChgView "0,0,-1") ^P
;;;ID_SKVpointLef [_Button("�����ʐ}", "ICON_16_VIELEF", "ICON_24_VIELEF")]^C^C^P(SKChgView "-1,0,0") ^P
;;;ID_SKVpointRig [_Button("�E���ʐ}", "ICON_16_VIERIG", "ICON_24_VIERIG")]^C^C^P(SKChgView "1,0,0") ^P
;;;ID_SKVpointFro [_Button("���ʐ}", "ICON_16_VIEFRO", "ICON_24_VIEFRO")]^C^C^P(SKChgView "0,-1,0") ^P
;;;ID_SKVpointBac [_Button("�w�ʐ}", "ICON_16_VIEBAC", "ICON_24_VIEBAC")]^C^C^P(SKChgView "0,1,0") ^P
;;;               [--]
;;;ID_SKVpointSW  [_Button("�쐼���p�}", "ICON_16_VIESWI", "ICON_24_VIESWI")]^C^C^P(SKChgView "-2,-2,1") ^P
;;;ID_SKVpointSE  [_Button("�쓌���p�}", "ICON_16_VIESEI", "ICON_24_VIESEI")]^C^C^P(SKChgView "2,-2,1") ^P
;;;ID_SKVpointNE  [_Button("�k�����p�}", "ICON_16_VIENEI", "ICON_24_VIENEI")]^C^C^P(SKChgView "1,1,1") ^P
;;;ID_SKVpointNW  [_Button("�k�����p�}", "ICON_16_VIENWI", "ICON_24_VIENWI")]^C^C^P(SKChgView "-1,1,1") ^P
;;;        |
;;;  ����  |
;;;________|  �쓌
;;;        |
;;;  ����  |
;;;        |
;;;
;;;|       |
;;;|       |  ����
;;;| �쓌  |________
;;;|       |
;;;|       |  ����
;;;|       |

;*************************************************************************>MOH<
(defun Make3ViewPort (
    &lr       ;(STR)�E������@"R" "L"
    /
    #os #vp #view$ #cv #cv2 #pt
  )

  (setq #vp (list "1,0,0" "0,-1,0" "0,0,1"  "2,-2,1")) ; �E����,����,����,�쓌���p�}

  (setvar "TILEMODE" 1) ; ������� YM
  (setvar "tabmode" 0)
  (command "_vports" "SI") ; �ݸ���ޭ�
  (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�

  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  (cond
    ((= &lr "L")    ;��������
      (command "_vports" "3" &lr)

      (foreach #view$ (vports)
        (setq #cv (car  #view$))
        (setq #pt (cadr #view$))
        (cond
          ((equal #pt (list 0.5 0.5) 0.01);�E��r���[ ����
           (setvar "cvport" #cv)
           (SKChgView (nth 1 #vp))
           (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
          )
          ((equal #pt (list 0.0 0.0) 0.01);���r���[ �쓌
           (setvar "cvport" #cv)
           (setq #cv2 #cv)
           (SKChgView (nth 3 #vp))
           (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
          )
          ((equal #pt (list 0.5 0.0) 0.01);�E���r���[ ����
           (setvar "cvport" #cv)
           (SKChgView (nth 2 #vp))
           (setvar "GRIDMODE" 1) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
          )
        );_(cond
      );_(foreach

    )
    ((= &lr "R")    ;�E������
      (command "_vports" "3" &lr)

      (foreach #view$ (vports)
        (setq #cv (car  #view$))
        (setq #pt (cadr #view$))
        (cond
          ((equal #pt (list 0.0 0.5) 0.01);����r���[ ����
           (setvar "cvport" #cv)
           (SKChgView (nth 1 #vp))
           (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
          )
          ((equal #pt (list 0.0 0.0) 0.01);�����r���[ ����
           (setvar "cvport" #cv)
           (SKChgView (nth 2 #vp))
           (setvar "GRIDMODE" 1) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
          )
          ((equal #pt (list 0.5 0.0) 0.01);�E�r���[ �쓌
           (setvar "cvport" #cv)
           (setq #cv2 #cv)
           (SKChgView (nth 3 #vp))
           (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
          )
        );_(cond
      );_(foreach

    )
  );_(cond

  (setvar "cvport" #cv2)
  (setvar "OSMODE" #os)

	;04/05/26 YM ADD
	(command "_REGEN")

  ;// UCS�A�C�R���̔�\��
  (command "_UCSICON" "A" "OF") ;UCS�A�C�R���̔�\��
)
;Make3ViewPort

;;;<HOM>*************************************************************************
;;; <�֐���>    : NRMake4ViewPort
;;; <�����T�v>  : �K���ȂS�r���[�|�[�g���쐬����
;;; <�߂�l>    :
;;; <�쐬>      : 00/02/14 YM �S�ʏC��
;;; <���l>      :
;;;        |
;;;  ����  | �E����
;;;________|________
;;;        |
;;;  ����  |  �쓌
;;;        |
;;;*************************************************************************>MOH<
(defun Make4ViewPort (
    /
    #os #vp #view$ #cv #cv2 #pt
  )

  (setq #vp (list "1,0,0" "0,-1,0" "0,0,1"  "2,-2,1")) ; �E����,����,����,�쓌

  (setvar "TILEMODE" 1) ; ������� YM
  (setvar "tabmode" 0)
  (command "_vports" "SI") ; �ݸ���ޭ�
  (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�

  (setq #os (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  ;// �ޭ��߰Ă��쐬���A���_��ݒ肷��
  (command "_vports" "4" ) ; 4����

  (foreach #view$ (vports)
    (setq #cv (car  #view$))
    (setq #pt (cadr #view$))
    (cond
      ((equal #pt (list 0.5 0.5) 0.01);�E��r���[ �E����
       (setvar "cvport" #cv)
       (SKChgView (nth 0 #vp))
       (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
      )
      ((equal #pt (list 0.0 0.5) 0.01);����r���[ ����
       (setvar "cvport" #cv)
       (SKChgView (nth 1 #vp))
       (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
      )
      ((equal #pt (list 0.0 0.0) 0.01);�����r���[ ����
       (setvar "cvport" #cv)
       (SKChgView (nth 2 #vp))
       (setvar "GRIDMODE" 1) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
      )
      ((equal #pt (list 0.5 0.0) 0.01);�E���r���[ �쓌
       (setvar "cvport" #cv)
       (setq #cv2 #cv)
       (SKChgView (nth 3 #vp))
       (setvar "GRIDMODE" 0) ;00/02/03 HN ADD �V�X�e���ϐ��ύX�����ǉ�
      )
    );_(cond
  );_(foreach

  (setvar "cvport" #cv2)
  (setvar "OSMODE" #os)

	;04/05/26 YM ADD
	(command "_REGEN")

  ;// UCS�A�C�R���̔�\��
  (command "_UCSICON" "A" "OF") ;UCS�A�C�R���̔�\��
)
;Make4ViewPort

;;;<HOM>*************************************************************************
;;; <�֐���>    : GetViewSize
;;; <�����T�v>  : ���݂̃r���[�̍ő�A�ŏ��̍��W�����߂�
;;; <�߂�l>    :
;;;        LIST : 1.�ŏ� x �l
;;;             : 2.�ő� x �l
;;;             : 3.�ŏ� y �l
;;;             : 4.�ő� y �l
;;; <�쐬>      : 99-12-20
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun GetViewSize (
    /
    #vctr #vsize #ssize #x #xmin #xmax #ymin #ymax
  )

  (setq #vctr  (getvar "VIEWCTR"))    ; ���݂̃r���[�|�[�g���̃r���[�̒��S���i�[���܂��BUCS ���W�ŕ\�� '(5.72083 4.00833 0.0)
  (setq #vsize (getvar "VIEWSIZE"))   ; ���݂̃r���[�|�[�g�̃r���[�̍������i�[���܂��B��}�P�ʂŕ\�� '8.74613
  (setq #ssize (getvar "SCREENSIZE")) ; ���݂̃r���[�|�[�g�̃T�C�Y (X ��������� Y ����)���s�N�Z�����Ŋi�[���܂��B'(1179.0 692.0)
  (setq #x (/ (* #vsize (car #ssize)) (cadr #ssize))) ; '(-1.72981 13.1715 -0.364733 8.3814)

  (setq #xmin (- (car  #vctr) (/ #x 2)))
  (setq #xmax (+ (car  #vctr) (/ #x 2)))
  (setq #ymin (- (cadr #vctr) (/ #vsize 2)))
  (setq #ymax (+ (cadr #vctr) (/ #vsize 2)))

  ;// �l���A��
  (list #xmin #xmax #ymin #ymax) ; '(-1.72981 13.1715 -0.364733 8.3814)
)
;GetViewSize

;;;<HOM>*************************************************************************
;;; <�֐���>    : SKAllFitVp
;;; <�����T�v>  : 3 or 4�r���[�̕\����S�čœK������
;;; <���l>      :
;;;*************************************************************************>MOH<
(defun SKAllFitVp (
    /
    #vid
    #os
  )

  (if (> 3 (length (vports)))
    (progn
      (command "_zoom" "e")
;;;      (command "_zoom" "0.9x") ; 06/05 YM
    )
  ;else
    (progn
      (setq #os (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (setq #vid (getvar "CVPORT"))
      (foreach #view$ (vports)
        (if (/= (car #view$) 1)
          (progn
            (setvar "CVPORT" (car #view$))
            (command "_zoom" "e")
;;;            (command "_zoom" "0.9x") ; 06/05 YM
          )
        )
      )
      (setvar "CVPORT" #vid) ; �ŏ����ޭ��ɖ߂�
      (setvar "OSMODE" #os)
    )
  )
  (princ)
)
;SKAllFitVp
(defun C:AllFitVp ()(SKAllFitVp));00/06/29 SN ADD

;<HOM>*************************************************************************
; <�֐���>    : MakeWorkView
; <�����T�v>  : ���[�N�r���[���쐬����
; <���l>      :
;*************************************************************************>MOH<
(defun MakeWorkView (
    /
    #viewEn
    #os #gr #sn
    #res$
    #xmax #ymax
    #wid
  )
  ;// �V�X�e���ϐ���ݒ�
  (setq #os (getvar "OSMODE"))
  (setq #gr (getvar "GRIDMODE"))
  (setq #sn (getvar "SNAPMODE"))
  (setvar "OSMODE"   0)
  (setvar "GRIDMODE" 0)
  (setvar "SNAPMODE" 0)
  (command "_.UCSICON" "A" "OF")  ;UCS�A�C�R����S�Ĕ�\��

  (if (= 0 (getvar "TILEMODE"))
    (progn
      ;// �r���[�̃T�C�Y���擾����
      (command "_.pspace")
      (setvar "SNAPMODE" 0)
      (setvar "OSMODE"   0)
      (setvar "GRIDMODE" 0)

      (setq #res$ (GetViewSize))
      (setq #xmax (nth 1 #res$))
      (setq #ymax (nth 3 #res$))
      (setq #xwid (/ (- #xmax (car #res$)) 10.))
      (setq #ywid (/ (- #ymax (nth 2 #res$)) 10.))

      (command "_.mview" (list #xmax #ymax) (list (- #xmax #xwid) (- #ymax #ywid)))
      (setq #viewEn (entlast))
      (command "_.mspace")
      (command "_.vpoint" "0,0,1")
      ;(setvar "OSMODE"   0)
      ;(setvar "GRIDMODE" 0)
      ;(setvar "SNAPMODE" 0)
    )
  )
  ;// �V�X�e���ϐ������ɖ߂�
  (setvar "OSMODE"   #os)
  (setvar "GRIDMODE" #gr)
  (setvar "SNAPMODE" #sn)

  #viewEn
)
;MakeWorkView

(princ)
