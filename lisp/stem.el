;;; -*- Emacs-Lisp -*-
;;; $Id$


;;; ��ʸ��An algorithm for suffix stripping (M.F.Porter)�٤˵���
;;; ����Ƥ��륢�르�ꥺ��˴�Ť��ơ���ñ��θ��������������
;;; �Υ饤�֥��


;;;============================================================
;;;	stemming-rule �ξ����򵭽Ҥ���ؿ���
;;;============================================================

;;; �ѿ� str �򸡺�����ؿ� (�촴����ʬ���ѿ� stem ����������)
(defsubst stem:match (arg)
  (and
   (string-match arg str)
   (setq stem (substring str 0 (match-beginning 0)))))


;;; �ѿ� stem �˴ޤޤ�Ƥ��� VC �ο������ؿ�
(defsubst stem:m ()
  (save-match-data
    (let ((pos 0)(m 0))
      (while (string-match "\\(a\\|e\\|i\\|o\\|u\\|[^aeiou]y+\\)[aeiou]*" stem pos)
	(setq m (1+ m))
	(setq pos (match-end 0)))
      (if (= pos (length stem)) (1- m) m))))

(defsubst stem:m> (i)
  (< i (stem:m)))

(defsubst stem:m= (i)
  (= i (stem:m)))


;;; �ѿ� stem ���첻��ޤ�Ǥ��뤫��������ؿ�
(defsubst stem:*v* ()
  (save-match-data
    (if (string-match "\\(a\\|e\\|i\\|o\\|u\\|[^aeiou]y\\)" stem) t)))


;;; �ѿ� stem �� cvc �η��ǽ��äƤ��뤫��������ؿ�
(defsubst stem:*o ()
  (save-match-data
    (if (string-match "[^aeiou][aeiouy][^aeiouwxy]$" stem) t)))




;;;============================================================
;;;	stemming-rule �򵭽Ҥ����ؿ���
;;;============================================================

;;; ��1a�ʳ��� stemming rule
(defun stem:step1a (str)
  (let ((s)(stem))
    (if (setq s (cond
		 ((stem:match "sses$") "ss")
		 ((stem:match "ies$")  "i")
		 ((stem:match "ss$")   "ss")
		 ((stem:match "s$")    "")))
	(concat stem s)
      str)))


;;; ��1b�ʳ��� stemming rule
(defun stem:step1b (str)
  (let ((s)(stem))
    (cond
     ((and (stem:match "eed$") (stem:m> 0))
      (concat stem "ee"))
     ((or (and (not stem) (stem:match "ed$") (stem:*v*))
	  (and (stem:match "ing$") (stem:*v*)))
      (if (and (stem:m= 1) (stem:*o))
	  (concat stem "e")
	(setq str stem)
	(if (setq s (cond
		     ((stem:match "at$") "ate")
		     ((stem:match "bl$") "ble")
		     ((stem:match "iz$") "ize")
		     ((stem:match "\\([^lsz]\\)\\1$")
		      (substring str (match-beginning 1) (match-end 1)))))
	    (concat stem s)
	  str)))
     (t str))))


;;; ��1c�ʳ��� stemming rule
(defun stem:step1c (str)
  (let ((stem))
    (if (and (stem:match "y$")
	     (stem:*v*))
	(concat stem "i")
      str)))


;;; ��1�ʳ��� stemming rule
(defun stem:step1 (str)
  (stem:step1c
   (stem:step1b
    (stem:step1a str))))



;;; ��2�ʳ��� stemming rule
(defun stem:step2 (str)
  (let ((s)(stem))
    (if (and
	 (setq s (cond
		  ((stem:match "ational$") "ate")
		  ((stem:match "tional$")  "tion")
		  ((stem:match "enci$")    "ence")
		  ((stem:match "anci$")    "ance")
		  ((stem:match "izer$")    "ize")
		  ((stem:match "abli$")    "able")
		  ((stem:match "alli$")    "al")
		  ((stem:match "entli$")   "ent")
		  ((stem:match "eli$")     "e")
		  ((stem:match "ousli$")   "ous")
		  ((stem:match "ization$") "ize")
		  ((stem:match "ation$")   "ate")
		  ((stem:match "ator$")    "ate")
		  ((stem:match "alism$")   "al")
		  ((stem:match "iveness$") "ive")
		  ((stem:match "fulness$") "ful")
		  ((stem:match "ousness$") "ous")
		  ((stem:match "aliti$")   "al")
		  ((stem:match "iviti$")   "ive")
		  ((stem:match "biliti$")  "ble")))
	 (stem:m> 0))
	(concat stem s)
      str)))



;;; ��3�ʳ��� stemming rule
(defun stem:step3 (str)
  (let ((s)(stem))
    (if (and
	 (setq s (cond
		  ((stem:match "icate$") "ic")
		  ((stem:match "ative$") "")
		  ((stem:match "alize$") "al")
		  ((stem:match "iciti$") "ic")
		  ((stem:match "ical$")  "ic")
		  ((stem:match "ful$")   "")
		  ((stem:match "ness$")  "")))
	 (stem:m> 0))
	(concat stem s)
      str)))



;;; ��4�ʳ��� stemming rule
(defun stem:step4 (str)
  (let ((stem))
    (if (and (or
	      (stem:match "al$")
	      (stem:match "ance$")
	      (stem:match "ence$")
	      (stem:match "er$")
	      (stem:match "ic$")
	      (stem:match "able$")
	      (stem:match "ible$")
	      (stem:match "ant$")
	      (stem:match "ement$")
	      (stem:match "ment$")
	      (stem:match "ent$")
	      (and (string-match "[st]\\(ion\\)$" str)
		   (setq stem (substring str 0 (match-beginning 1))))
	      (stem:match "ou$")
	      (stem:match "ism$")
	      (stem:match "ate$")
	      (stem:match "iti$")
	      (stem:match "ous$")
	      (stem:match "ive$")
	      (stem:match "ize$"))
	     (stem:m> 1))
	stem str)))



;;; ��5�ʳ��� stemming rule
(defun stem:step5 (str)
  (let ((stem))
    (if (or
	 (and (stem:match "e$")
	      (or (stem:m> 1)
		  (and (stem:m= 1)
		       (not (stem:*o)))))
	 (and (stem:match "ll$")
	      (setq stem (concat stem "l"))
	      (stem:m> 1)))
	stem str)))




;;; �����ޤ�������ؿ�

;;;============================================================
;;;	�����ؿ�
;;;============================================================

;;; Porter �Υ��르�ꥺ��˴�Ť�����������������ؿ�
(defun stem:stripping-inflection (str) "\
Porter �Υ��르�ꥺ��˴�Ť�����������������ؿ�
-tion �� -ize �ʤɤθ����������
Ϳ����줿��θ��θ�Ȥ��Ʋ�ǽ���Τ����Υꥹ�Ȥ��֤�"
  (let ((w str)(l (list str)))
    (mapcar
     '(lambda (func)
	(setq str (funcall func str))
	(or (string= str (car l))
	    (setq l (cons str l))))
     '(stem:step1 stem:step2 stem:step3 stem:step4 stem:step5))
    (setq w (stem:string-and (car l) w))
    (if (string= w (car l)) l (cons w l))))



;;; Porter �Υ��르�ꥺ���Ŭ�Ѥ���ؿ�
(defun stem:stripping-suffix (word)
  (save-match-data
    (stem:step5
     (stem:step4
      (stem:step3
       (stem:step2
	(stem:step1 word)))))))



(defun stem:string-and (w1 w2) "\
2�Ĥ�ʸ����ΰ��פ��Ƥ�����ʬ���֤��ؿ�"
  (let ((i))
    (if (> (length w1) (length w2))	; w1 ������Ĺ�����
	(setq i  w1			; w1 �� w2 ��򴹤���
	      w1 w2
	      w2 i))
    (setq i (length w1))
    (while (not (string= w1 (substring w2 0 i)))
      (setq i (1- i))
      (setq w1 (substring w1 0 i)))
    w1))



(defun stem:word-at-point () "\
����������֤α�ñ��� stemming �����֤��ؿ�"
  (let ((str))
    (setq str (save-excursion
		(if (not (looking-at "\\<"))
		    (forward-word -1))
		(if (looking-at "[A-Za-z]+")
		    (downcase (match-string 0)))))
    (stem:string-and (stem:stripping-suffix str) str)))




;;; �ȼ��Υҥ塼�ꥹ�ƥ��å����ˤ�ä�
;;; ư��/���ƻ�ε�§Ū���ѷ���̾���ʣ�������������ؿ�
(defun stem:stripping-conjugation (str) "\
ư��/���ƻ�ε�§Ū���ѷ���̾���ʣ�����γ��Ѹ�����������ؿ�
Ϳ����줿��θ����Ȥ��Ʋ�ǽ���Τ����Υꥹ�Ȥ��֤�
�ޥå�����ҥ塼�ꥹ�ƥ��å������ʤ��ä���硢nil ���֤�"
  (let ((l)(stem))
    (save-match-data
      (if (setq l (cond
		   ;; ��ӵ�/�Ǿ��
		   ((stem:match "\\([^aeiou]\\)\\1e\\(r\\|st\\)$")
		    (list (substring str (match-beginning 1) (match-end 1))
			  (substring str (match-beginning 0) (match-beginning 2))))
		   ((stem:match "\\([^aeiou]\\)ie\\(r\\|st\\)$")
		    (setq c (substring str (match-beginning 1) (match-end 1)))
		    (list c (concat c "y") (concat c "ie")))
		   ((stem:match "e\\(r\\|st\\)$") '("" "e"))
		   ;; 3ñ��/ʣ����
		   ((stem:match "ches$") '("ch" "che"))
		   ((stem:match "shes$") '("sh" "che"))
		   ((stem:match "ses$") '("s" "se"))
		   ((stem:match "xes$") '("x" "xe"))
		   ((stem:match "zes$") '("z" "ze"))
		   ((stem:match "ves$") '("f" "fe"))
		   ((stem:match "\\([^aeiou]\\)oes$")
		    (setq c (substring str -4 -3))
		    (list c (concat c "o") (concat c "oe")))
		   ((stem:match "\\([^aeiou]\\)ies$")
		    (setq c (substring str -4 -3))
		    (list c (concat c "y") (concat c "ie")))
		   ((stem:match "es$") '("" "e"))
		   ((stem:match "s$") '(""))
		   ;; ����/���ʬ��
		   ((stem:match "\\([^aeiou]\\)ied$")
		    (setq c (substring str -4 -3))
		    (list c (concat c "y") (concat c "ie")))
		   ((stem:match "\\([^aeiou]\\)\\1ed$")
		    (list (substring str -4 -3)
			  (substring str -4 -1)))
		   ((stem:match "cked$") '("c" "cke"))
		   ((stem:match "ed$") '("" "e"))
		   ;; ����ʬ��
		   ((stem:match "\\([^aeiou]\\)\\1ing$")
		    (list (substring str -5 -4)))
		   ((stem:match "ing$") '("" "e"))
		   ))
	  (append (mapcar '(lambda (s) (concat stem s)) l)
		  (list str)))
      )))
