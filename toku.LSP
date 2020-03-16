(defun C:qqqq (
  /
	#EN #SYM #TOKU$
  )
  (setq #en (car (entsel)))
  (setq #sym (CFSearchGroupSym #en)) ; ëIëïîçﬁÇÃº›ŒﬁŸê}å`ñº #en
	(setq #TOKU$ (CFGetXData #sym "G_TOKU"))

	(CFSetXData #sym "G_TOKU"
    (CFModList #TOKU$
      (list (list 22 (list 0.0 0.0 53.0)))
    )
	)
	(princ)
);C:qqqq
