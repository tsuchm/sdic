;;; -*- Emacs-Lisp -*-
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: dictionary

;;; Commentary:

;; This file is a part of xdic. Please see xdic.el for more detail.

;; 1�ԤΥǡ����η�����
;;	���Ф��� TAB ���ʸ RET
;; �ȤʤäƤ��뼭������ץ����( look / grep )�����Ѥ��Ƹ�������
;; �饤�֥��

(require 'xdic)
(provide 'xdic-unix)
(put 'xdic-unix 'version "1.2")
(put 'xdic-unix 'init-dictionary 'xdic-unix-init-dictionary)
(put 'xdic-unix 'open-dictionary 'xdic-unix-open-dictionary)
(put 'xdic-unix 'close-dictionary 'xdic-unix-close-dictionary)
(put 'xdic-unix 'search-entry 'xdic-unix-search-entry)
(put 'xdic-unix 'get-content 'xdic-unix-get-content)



;;;----------------------------------------------------------------------
;;;		���/�ѿ������
;;;----------------------------------------------------------------------

(defvar xdic-unix-look-command nil "*Executable file name of look")

(defvar xdic-unix-look-case-option "-f" "*Command line option for look to ignore case")

(defvar xdic-unix-grep-command nil "*Executable file name of grep")

(defvar xdic-unix-grep-case-option "-i" "*Command line option for grep to ignore case")

(defconst xdic-unix-search-buffer-name "*xdic-unix*")



;;;----------------------------------------------------------------------
;;;		����
;;;----------------------------------------------------------------------

;; xdic-unix-*-command �ν���ͤ�����
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
	'((xdic-unix-look-command "look" "look.exe")
	  (xdic-unix-grep-command "egrep" "egrep.exe" "grep" "grep.exe")))


(defun xdic-unix-available-p () "\
Function to check availability of library.
�饤�֥������Ѳ�ǽ���򸡺�����ؿ�"
  (and xdic-unix-look-command xdic-unix-grep-command t))


(defun xdic-unix-init-dictionary (file-name &rest option-list)
  "Function to initialize dictionary"
  (let ((dic (xdic-make-dictionary-symbol)))
    (if (file-readable-p (setq file-name (expand-file-name file-name)))
	(progn
	  (mapcar '(lambda (c) (put dic (car c) (nth 1 c))) option-list)
	  (put dic 'file-name file-name)
	  (put dic 'identifier (concat "xdic-unix+" file-name))
	  (or (get dic 'title)
	      (put dic 'title (file-name-nondirectory file-name)))
	  (or (get dic 'look)
	      (put dic 'look xdic-unix-look-command))
	  (or (get dic 'look-case-option)
	      (put dic 'look-case-option xdic-unix-look-case-option))
	  (or (get dic 'grep)
	      (put dic 'grep xdic-unix-grep-command))
	  (or (get dic 'grep-case-option)
	      (put dic 'grep-case-option xdic-unix-grep-case-option))
	  (or (get dic 'coding-system)
	      (put dic 'coding-system xdic-default-coding-system))
	  dic)
      (error "Can't read dictionary: %s" (prin1-to-string file-name)))))


(defun xdic-unix-open-dictionary (dic)
  "Function to open dictionary"
  (and (or (xdic-buffer-live-p (get dic 'xdic-unix-search-buffer))
	   (put dic 'xdic-unix-search-buffer (generate-new-buffer xdic-unix-search-buffer-name)))
       dic))


(defun xdic-unix-close-dictionary (dic)
  "Function to close dictionary"
  (kill-buffer (get dic 'xdic-unix-search-buffer))
  (put dic 'xdic-unix-search-buffer nil))


(defun xdic-unix-search-entry (dic string &optional search-type) "\
Function to search word with look or grep, and write results to current buffer.
search-type ���ͤˤ�äƼ��Τ褦��ư����ѹ����롣
    nil    : �������׸���
    t      : �������׸���
    lambda : �������׸���
    0      : Ǥ�ո���
������̤Ȥ��Ƹ��Ĥ��ä����Ф���򥭡��Ȥ����������ʸ����Ƭ�� point ���ͤȤ���
Ϣ��������֤���
"
  (save-excursion
    (set-buffer (get dic 'xdic-unix-search-buffer))
    (save-restriction
      (if (get dic 'xdic-unix-erase-buffer)
	  (delete-region (point-min) (point-max))
	(goto-char (point-max))
	(narrow-to-region (point-max) (point-max)))
      (put dic 'xdic-unix-erase-buffer nil)
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
			       (format "^[^\t]*%s\t" string) (get dic 'file-name))
	  (xdic-call-process (get dic 'grep) nil t nil
			     (get dic 'coding-system)
			     (get dic 'grep-case-option)
			     (format "^[^\t]*%s\t" string) (get dic 'file-name))))
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
       ;; �桼��������Υ����ˤ�븡���ξ�� -> grep ��ȤäƸ���
       ((eq search-type 0)
	(xdic-call-process (get dic 'grep) nil t nil
			   (get dic 'coding-system)
			   string (get dic 'file-name)))
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


(defun xdic-unix-get-content (dic point)
  (save-excursion
    (set-buffer (get dic 'xdic-unix-search-buffer))
    (put dic 'xdic-unix-erase-buffer t)
    (if (<= point (point-max))
	(buffer-substring (goto-char point) (progn (end-of-line) (point)))
      (error "Can't find content. (ID=%d)" point))))
