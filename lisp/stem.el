;;; stem.el ---- routines for stemming
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: stemming

;;; Commentary:

;; ��ʸ��An algorithm for suffix stripping (M.F.Porter)�٤˵��Ҥ����
;; ���륢�르�ꥺ��˴�Ť��ơ���ñ��θ��������������Υ饤�֥�ꡣ
;; ���ѵڤӺ����ۤκݤϡ�GNU ���̸��ѵ������Ŭ���ʥС������ˤ�������
;; �Ʋ�������

;; �켡���۸�
;;    http://www-nagao.kuee.kyoto-u.ac.jp/member/tsuchiya/elisp/xdic.html


;; -*- Emacs-Lisp -*-

(provide 'stem)

(defvar stem:minimum-word-length 4 "Porter �Υ��르�ꥺ�बŬ�ѤǤ���Ǿ���Ĺ")


;;;============================================================
;;;	������ؿ�
;;;============================================================

;; ư��®�٤���夵���뤿��ˡ��ؿ������ǳ����ѿ��򤤤��äƤ���
;; �ؿ������ꡢͽ�����ʤ������Ѥ�ȯ�������ǽ�����⤤�����äơ�
;; ������ؿ���ľ�ܸƤӽФ����Ȥ��򤱤뤳�ȡ�

;;------------------------------------------------------------
;;	stemming-rule �ξ����򵭽Ҥ���ؿ���
;;------------------------------------------------------------

(defsubst stem:match (arg) "\
�ѿ� str �򸡺�����������ؿ� (�촴����ʬ���ѿ� stem ����������)"
  (and
   (string-match arg str)
   (setq stem (substring str 0 (match-beginning 0)))))

(defsubst stem:m () "\
�ѿ� stem �˴ޤޤ�Ƥ��� VC �ο������������ؿ�"
  (save-match-data
    (let ((pos 0)(m 0))
      (while (string-match "\\(a\\|e\\|i\\|o\\|u\\|[^aeiou]y+\\)[aeiou]*" stem pos)
	(setq m (1+ m))
	(setq pos (match-end 0)))
      (if (= pos (length stem)) (1- m) m))))

(defsubst stem:m> (i) "\
�ѿ� stem �˴ޤޤ�Ƥ��� VC �ο��ξ��򵭽Ҥ���������ؿ�"
  (< i (stem:m)))

(defsubst stem:m= (i) "\
�ѿ� stem �˴ޤޤ�Ƥ��� VC �ο��ξ��򵭽Ҥ���������ؿ�"
  (= i (stem:m)))

(defsubst stem:*v* () "\
�ѿ� stem ���첻��ޤ�Ǥ��뤫��������ؿ�"
  (save-match-data
    (if (string-match "\\(a\\|e\\|i\\|o\\|u\\|[^aeiou]y\\)" stem) t)))

(defsubst stem:*o () "\
�ѿ� stem �� cvc �η��ǽ��äƤ��뤫��������ؿ�"
  (save-match-data
    (if (string-match "[^aeiou][aeiouy][^aeiouwxy]$" stem) t)))



;;------------------------------------------------------------
;;	stemming-rule �򵭽Ҥ����ؿ���
;;------------------------------------------------------------

(defun stem:step1a (str) "��1a�ʳ��� stemming rule (������ؿ�)"
  (let ((s)(stem))
    (if (setq s (cond
		 ((stem:match "sses$") "ss")
		 ((stem:match "ies$")  "i")
		 ((stem:match "ss$")   "ss")
		 ((stem:match "s$")    "")))
	(concat stem s)
      str)))


(defun stem:step1b (str) "��1b�ʳ��� stemming rule (������ؿ�)"
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


(defun stem:step1c (str) "��1c�ʳ��� stemming rule (������ؿ�)"
  (let ((stem))
    (if (and (stem:match "y$")
	     (stem:*v*))
	(concat stem "i")
      str)))


(defun stem:step1 (str) "��1�ʳ��� stemming rule (������ؿ�)"
  (stem:step1c
   (stem:step1b
    (stem:step1a str))))


(defun stem:step2 (str) "��2�ʳ��� stemming rule (������ؿ�)"
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


(defun stem:step3 (str) "��3�ʳ��� stemming rule (������ؿ�)"
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


(defun stem:step4 (str) "��4�ʳ��� stemming rule (������ؿ�)"
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


(defun stem:step5 (str) "��5�ʳ��� stemming rule (������ؿ�)"
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


(defun stem:extra (str) "\
ư��/���ƻ�ε�§Ū���ѷ���̾���ʣ�����γ��Ѹ����������������ؿ�
Ϳ����줿��θ����Ȥ��Ʋ�ǽ���Τ����Υꥹ�Ȥ��֤�"
  (let ((l)(stem))
    (setq l (cond
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
	    (list str))
    ))




;;;============================================================
;;;	�����ؿ�
;;;============================================================

(defun stem:stripping-suffix (str) "\
���Ѹ�����������ؿ�
Ϳ����줿��θ��θ�Ȥ��Ʋ�ǽ���Τ����Υꥹ�Ȥ��֤�"
  (save-match-data
    (let (l w)
      (setq l (sort
	       (append
		;; ��ʸ����ʸ�����Ѵ�
		(list (prog1 str (setq str (downcase str))))
		;; �ȼ��Υҥ塼�ꥹ�ƥ��å�����Ŭ��
		(stem:extra str)
		(if (> (length str) stem:minimum-word-length)
		    ;; ñ��Ĺ�������������С�Porter �Υ��르�ꥺ���Ŭ��
		    (mapcar
		     '(lambda (func)
			(setq str (funcall func str)))
		     '(stem:step1 stem:step2 stem:step3 stem:step4 stem:step5))))
	       'string<))
      ;; ��Ĺ������ʬ������
      (let* ((w1 (car l))
	     (w2 (car (reverse l)))
	     (i (min (length w1) (length w2))))
	(while (not (string= (substring w1 0 i)
			     (substring w2 0 i)))
	  (setq i (1- i)))
	(setq l (cons (substring w1 0 i) l)))
      ;; ��ʣ���Ƥ������Ǥ������
      (mapcar '(lambda (c) (or (string= c (car w)) (setq w (cons c w)))) l)
      ;; ʸ�����Ĺ������¤٤�����
      (sort (reverse w)
	    '(lambda (a b) (< (length a) (length b))))
      )))


;;; ��ؿ�����̾
(defalias 'stemming 'stem:stripping-suffix)


;;; Porter �Υ��르�ꥺ���Ŭ�Ѥ���ؿ�
(defun stem:stripping-inflection (word) "\
Porter �Υ��르�ꥺ��˴�Ť�����������������ؿ�"
  (save-match-data
    (stem:step5
     (stem:step4
      (stem:step3
       (stem:step2
	(stem:step1 word)))))))
