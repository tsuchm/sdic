;;; -*- Emacs-Lisp -*-
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: dictionary

;;; Commentary:

;; This file is a part of xdic. Please see xdic.el for more detail.

;; COMPAT �����μ�������ץ����( look / grep )�����Ѥ��Ƹ�������
;; �饤�֥��Ǥ���COMPAT �����ξܺ٤ˤĤ��Ƥ� dictionary-format.txt 
;; �򻲾Ȥ��Ʋ�������


;;; Install:

;; (1) look ����ʸ��/��ʸ���ΰ㤤��̵�뤷������������� grep ( fgrep 
;;     �ޤ��� GNU grep )��ɬ�פǤ����ޤ�������ɽ�����������Ѥ������ 
;;     egrep ��ɬ�פǤ����ѥ����̤äƤ��뤫��ǧ���Ʋ�������
;;
;; (2) �����Ŭ�ڤʷ������Ѵ����ơ�Ŭ���ʾ��( ��: /usr/dict/ )����¸
;;     ���Ʋ������������Ѵ��ѥ�����ץȤȤ��ưʲ��� Perl ������ץȤ�
;;     ���ѤǤ��ޤ���
;;
;;         gene.perl    - GENE95 ����
;;         jgene.perl   - GENE95 ���񤫤��±Ѽ������������
;;         eijirou.perl - �Ѽ�Ϻ
;;
;;     --compat ���ץ�������ꤹ��ɬ�פ�����ޤ���
;;
;; (3) �Ȥ���褦�ˤ���������������� xdic-eiwa-dictionary-list �ޤ�
;;     �� xdic-waei-dictionary-list ���ɲä��Ʋ�������
;;
;;         (setq xdic-eiwa-dictionary-list
;;               (cons '(xdic-compat "/usr/dict/gene.dic") xdic-eiwa-dictionary-list))
;;
;;     �����������ϼ��Τ褦�ʹ����ˤʤäƤ��ޤ���
;;
;;         (xdic-compat �ե�����̾ (���ץ����A ��A) (���ץ����B ��B) ...)
;;
;;     ���̤ʻ��꤬���פʾ��ˤϡ����ץ����Ͼ�ά�Ǥ��ޤ���
;;
;;         (xdic-compat �ե�����̾)


;;; Options:

;; xdic-compat.el ���Ф��ƻ���Ǥ��륪�ץ����ϼ����̤�Ǥ���
;;
;; coding-system
;;     ����δ��������ɤ���ꤷ�ޤ�����ά�������ϡ�
;;     xdic-default-coding-system ���ͤ�Ȥ��ޤ���
;;
;; title
;;     ����Υ����ȥ����ꤷ�ޤ�����ά�������ϡ�����ե������ 
;;     basename �򥿥��ȥ�Ȥ��ޤ���
;;
;; look
;;     �������׸���/�������׸����λ������Ѥ��볰�����ޥ�ɤ�̾�������
;;     ���ޤ�����ά�������� xdic-compat-look-command ���ͤ�Ȥ��ޤ���
;;
;; look-case-option
;;     look ���ץ����ˤ�äƻ��ꤵ�줿�������ޥ�ɤ��Ф��ơ�����ʸ��
;;     /��ʸ������̤��ʤ��Ǹ�������褦�˻ؼ����뤿��Υ��ޥ�ɥ饤��
;;     ��������ꤷ�ޤ�����ά�������� xdic-compat-look-case-option ��
;;     �ͤ�Ȥ��ޤ���
;;
;; grep
;;     �������׸���/��ʸ�����λ������Ѥ��볰�����ޥ�ɤ�̾������ꤷ��
;;     ������ά�������� xdic-compat-grep-command ���ͤ�Ȥ��ޤ���
;;
;; grep-case-option
;;     grep ���ץ����ˤ�äƻ��ꤵ�줿�������ޥ�ɤ��Ф��ơ�����ʸ��
;;     /��ʸ������̤��ʤ��Ǹ�������褦�˻ؼ����뤿��Υ��ޥ�ɥ饤��
;;     ��������ꤷ�ޤ�����ά�������� xdic-compat-grep-case-option ��
;;     �ͤ�Ȥ��ޤ���
;;
;; egrep
;;     ����ɽ�������λ������Ѥ��볰�����ޥ�ɤ�̾������ꤷ�ޤ�����ά
;;     �������� xdic-compat-egrep-command ���ͤ�Ȥ��ޤ���
;;
;; egrep-case-option
;;     egrep ���ץ����ˤ�äƻ��ꤵ�줿�������ޥ�ɤ��Ф��ơ�����ʸ
;;     ��/��ʸ������̤��ʤ��Ǹ�������褦�˻ؼ����뤿��Υ��ޥ�ɥ饤
;;     ���������ꤷ�ޤ�����ά�������� 
;;     xdic-compat-egrep-case-option ���ͤ�Ȥ��ޤ���


;;; Note:

;; xdic-compat-look-command / xdic-compat-grep-command /
;; xdic-compat-egrep-command ���ͤϼ�ưŪ�����ꤵ��ޤ����㤨�С�
;; xdic-compat-grep-command �ξ�硢fgrep / fgrep.exe / grep /
;; grep.exe ��4��Υ��ޥ�ɤ򸡺����ơ����Ĥ��ä����ޥ�ɤ�Ȥ��ޤ���
;;
;; xdic-compat.el �� xdic-gene.el ��Ʊ����ǽ���󶡤��Ƥ���饤�֥���
;; ����xdic-compat.el �ϳ������ޥ�ɤ�ƤӽФ��Ƥ���Τ��Ф��ơ�
;; xdic-gene.el �� Emacs �ε�ǽ�Τߤ����Ѥ��Ƥ��ޤ����������������Х�
;; �ե����ɤ߹���Ǥ��鸡����Ԥʤ��Τǡ����̤Υ��꤬ɬ�פˤʤ�ޤ���
;;
;; Default ������Ǥϡ�ɬ�פʳ������ޥ�ɤ����Ĥ��ä����� 
;; xdic-compat.el �򡢸��Ĥ���ʤ��ä����ˤ� xdic-gene.el ��Ȥ��褦
;; �ˤʤäƤ��ޤ���


;;; �饤�֥���������
(require 'xdic)
(provide 'xdic-compat)
(put 'xdic-compat 'version "1.2")
(put 'xdic-compat 'init-dictionary 'xdic-compat-init-dictionary)
(put 'xdic-compat 'open-dictionary 'xdic-compat-open-dictionary)
(put 'xdic-compat 'close-dictionary 'xdic-compat-close-dictionary)
(put 'xdic-compat 'search-entry 'xdic-compat-search-entry)
(put 'xdic-compat 'get-content 'xdic-compat-get-content)


;;;----------------------------------------------------------------------
;;;		���/�ѿ������
;;;----------------------------------------------------------------------

(defvar xdic-compat-look-command nil "*Executable file name of look")

(defvar xdic-compat-look-case-option "-f" "*Command line option for look to ignore case")

(defvar xdic-compat-grep-command nil "*Executable file name of grep")

(defvar xdic-compat-grep-case-option "-i" "*Command line option for grep to ignore case")

(defvar xdic-compat-egrep-command nil "*Executable file name of egrep")

(defvar xdic-compat-egrep-case-option "-i" "*Command line option for egrep to ignore case")

(defconst xdic-compat-search-buffer-name " *xdic-compat*")



;;;----------------------------------------------------------------------
;;;		����
;;;----------------------------------------------------------------------

;; xdic-compat-*-command �ν���ͤ�����
(mapcar '(lambda (list)
	   (or (symbol-value (car list))
	       (set (car list)
		    (catch 'which
		      (mapcar '(lambda (file)
				 (mapcar '(lambda (path)
					    (if (file-executable-p (expand-file-name file path))
						(throw 'which (expand-file-name file path))))
					 exec-path))
			      (cdr list))
		      nil))))
	'((xdic-compat-look-command "look" "look.exe")
	  (xdic-compat-grep-command "fgrep" "fgrep.exe" "grep" "grep.exe")
	  (xdic-compat-egrep-command "egrep" "egrep.exe" "grep" "grep.exe")))


(defun xdic-compat-available-p () "\
Function to check availability of library.
�饤�֥������Ѳ�ǽ���򸡺�����ؿ�"
  (and (stringp xdic-compat-look-command) (stringp xdic-compat-grep-command)))


(defun xdic-compat-init-dictionary (file-name &rest option-list)
  "Function to initialize dictionary"
  (let ((dic (xdic-make-dictionary-symbol)))
    (if (file-readable-p (setq file-name (expand-file-name file-name)))
	(progn
	  (mapcar '(lambda (c) (put dic (car c) (nth 1 c))) option-list)
	  (put dic 'file-name file-name)
	  (put dic 'identifier (concat "xdic-compat+" file-name))
	  (or (get dic 'title)
	      (put dic 'title (file-name-nondirectory file-name)))
	  (or (get dic 'look)
	      (put dic 'look xdic-compat-look-command))
	  (or (get dic 'look-case-option)
	      (put dic 'look-case-option xdic-compat-look-case-option))
	  (or (get dic 'grep)
	      (put dic 'grep xdic-compat-grep-command))
	  (or (get dic 'grep-case-option)
	      (put dic 'grep-case-option xdic-compat-grep-case-option))
	  (or (get dic 'egrep)
	      (put dic 'egrep xdic-compat-egrep-command))
	  (or (get dic 'egrep-case-option)
	      (put dic 'egrep-case-option xdic-compat-egrep-case-option))
	  (or (get dic 'coding-system)
	      (put dic 'coding-system xdic-default-coding-system))
	  (and (stringp (get dic 'look))
	       (stringp (get dic 'grep))
	       dic))
      (error "Can't read dictionary: %s" (prin1-to-string file-name)))))


(defun xdic-compat-open-dictionary (dic)
  "Function to open dictionary"
  (and (or (xdic-buffer-live-p (get dic 'xdic-compat-search-buffer))
	   (put dic 'xdic-compat-search-buffer (generate-new-buffer xdic-compat-search-buffer-name)))
       dic))


(defun xdic-compat-close-dictionary (dic)
  "Function to close dictionary"
  (kill-buffer (get dic 'xdic-compat-search-buffer))
  (put dic 'xdic-compat-search-buffer nil))


(defun xdic-compat-search-entry (dic string &optional search-type) "\
Function to search word with look or grep, and write results to current buffer.
search-type ���ͤˤ�äƼ��Τ褦��ư����ѹ����롣
    nil    : �������׸���
    t      : �������׸���
    lambda : �������׸���
    0      : ��ʸ����
    regexp : ����ɽ������
������̤Ȥ��Ƹ��Ĥ��ä����Ф���򥭡��Ȥ����������ʸ����Ƭ�� point ���ͤȤ���
Ϣ��������֤���"
  (save-excursion
    (set-buffer (get dic 'xdic-compat-search-buffer))
    (save-restriction
      (if (get dic 'xdic-compat-erase-buffer)
	  (delete-region (point-min) (point-max))
	(goto-char (point-max))
	(narrow-to-region (point-max) (point-max)))
      (put dic 'xdic-compat-erase-buffer nil)
      (cond
       ;; �������׸����ξ�� -> look ��ȤäƸ���
       ((eq search-type nil)
	(if (string-match "\\Ca" string)
	    (xdic-call-process (get dic 'look) nil t nil
			       (get dic 'coding-system)
			       string (get dic 'file-name))
	  (xdic-call-process (get dic 'look) nil t nil
			     (get dic 'coding-system)
			     (get dic 'look-case-option) string (get dic 'file-name))))
       ;; �������׸����ξ�� -> grep ��ȤäƸ���
       ((eq search-type t)
	(if (string-match "\\Ca" string)
	    (xdic-call-process (get dic 'grep) nil t nil
			       (get dic 'coding-system)
			       (concat string "\t") (get dic 'file-name))
	  (xdic-call-process (get dic 'grep) nil t nil
			     (get dic 'coding-system)
			     (get dic 'grep-case-option)
			     (concat string "\t") (get dic 'file-name))))
       ;; �������׸����ξ�� -> look ��ȤäƸ��� / ;ʬ�ʥǡ�����õ�
       ((eq search-type 'lambda)
	(if (string-match "\\Ca" string)
	    (xdic-call-process (get dic 'look) nil t nil
			       (get dic 'coding-system)
			       string (get dic 'file-name))
	  (xdic-call-process (get dic 'look) nil t nil
			     (get dic 'coding-system)
			     (get dic 'look-case-option)
			     string (get dic 'file-name)))
	(goto-char (point-min))
	(while (if (looking-at (format "%s\t" (regexp-quote string)))
		   (= 0 (forward-line 1))
		 (delete-region (point) (point-max)))))
       ;; ��ʸ�����ξ�� -> grep ��ȤäƸ���
       ((eq search-type 0)
	(if (string-match "\\Ca" string)
	    (xdic-call-process (get dic 'grep) nil t nil
			       (get dic 'coding-system)
			       string (get dic 'file-name))
	  (xdic-call-process (get dic 'grep) nil t nil
			     (get dic 'coding-system)
			     (get dic 'grep-case-option)
			     string (get dic 'file-name))))
       ;; ����ɽ�������ξ�� -> egrep ��ȤäƸ���
       ((eq search-type 'regexp)
	(or (stringp (get dic 'egrep))
	    (error "%s" "Command to search regular expression pattern is not specified"))
	(if (string-match "\\Ca" string)
	    (xdic-call-process (get dic 'egrep) nil t nil
			       (get dic 'coding-system)
			       string (get dic 'file-name))
	  (xdic-call-process (get dic 'egrep) nil t nil
			     (get dic 'coding-system)
			     (get dic 'egrep-case-option)
			     string (get dic 'file-name))))
       ;; ����ʳ��θ�����������ꤵ�줿���
       (t (error "Not supported search type is specified. \(%s\)"
		 (prin1-to-string search-type))))
      ;; �Ƹ�����̤� ID ����Ϳ����
      (goto-char (point-min))
      (let (ret)
	(while (if (looking-at "\\([^\t]+\\)\t")
		   (progn
		     (setq ret (cons (cons (xdic-match-string 1) (match-end 0)) ret))
		     (= 0 (forward-line 1)))))
	(reverse ret)))))


(defun xdic-compat-get-content (dic point)
  (save-excursion
    (set-buffer (get dic 'xdic-compat-search-buffer))
    (put dic 'xdic-compat-erase-buffer t)
    (if (<= point (point-max))
	(buffer-substring (goto-char point) (progn (end-of-line) (point)))
      (error "Can't find content. (ID=%d)" point))))
