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



;;;----------------------------------------------------------------------
;;;		���/�ѿ������
;;;----------------------------------------------------------------------

(defvar xdic-unix-coding-system (if (>= emacs-major-version 20) 'euc-japan *euc-japan*)
  "*Coding system of dictionary")

(defvar xdic-unix-look-command "look" "*Executable file name of look")

(defvar xdic-unix-look-option "-f" "*Command line option for look")

(defvar xdic-unix-grep-command "egrep" "*Executable file name of grep")

(defvar xdic-unix-grep-option "-i" "*Command line option for grep")




;;;----------------------------------------------------------------------
;;;		�����
;;;----------------------------------------------------------------------

;;; ���������ɤ�����
(if (>= emacs-major-version 20)
    (setq process-coding-system-alist
	  (append (list (cons (format ".*%s" xdic-unix-look-command) xdic-unix-coding-system)
			(cons (format ".*%s" xdic-unix-grep-command) xdic-unix-coding-system))
		  (if (boundp 'process-coding-system-alist) process-coding-system-alist)))
  (define-program-coding-system nil (format ".*%s" xdic-unix-look-command) xdic-unix-coding-system)
  (define-program-coding-system nil (format ".*%s" xdic-unix-grep-command) xdic-unix-coding-system))


  

;;;----------------------------------------------------------------------
;;;		����
;;;----------------------------------------------------------------------

(defun xdic-unix-open-dictionary (dic)
  "Function to open dictionary"
  (if (bufferp (get dic 'search-buffer))
      (kill-buffer (get dic 'search-buffer)))
  (put dic 'search-buffer (generate-new-buffer "*xdic-unix*")))


(defun xdic-unix-close-dictionary (dic)
  "Function to close dictionary"
  (kill-buffer (get dic 'search-buffer))
  (put dic 'search-buffer nil))


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
    (set-buffer (get dic 'search-buffer))
    (erase-buffer)
    (cond
     ;; �������׸����ξ�� -> look ��ȤäƸ���
     ((eq search-type nil)
      (call-process xdic-unix-look-command nil t nil xdic-unix-look-option
		    string (get dic 'file-name)))
     ;; �������׸����ξ�� -> grep ��ȤäƸ���
     ((eq search-type t)
      (call-process xdic-unix-grep-command nil t nil xdic-unix-grep-option
		    (format "^[^\t]*%s\t" string) (get dic 'file-name)))
     ;; �������׸����ξ�� -> look ��ȤäƸ��� / ;ʬ�ʥǡ�����õ�
     ((eq search-type 'lambda)
      (call-process xdic-unix-look-command nil t nil xdic-unix-look-option
		    string (get dic 'file-name))
      (goto-char (point-min))
      (while (if (looking-at (format "%s\t" (regexp-quote string)))
		 (= 0 (forward-line 1))
	       (delete-region (point) (point-max)))))
     ;; �桼��������Υ����ˤ�븡���ξ�� -> grep ��ȤäƸ���
     ((eq search-type 0)
      (call-process xdic-unix-grep-command nil t nil xdic-unix-grep-option
		    string (get dic 'file-name)))
     ;; ����ʳ��θ�����������ꤵ�줿���
     (t (error "Not supported search type is specified. \(%s\)"
	       (prin1-to-string search-type))))
    ;; �Ƹ�����̤� ID ����Ϳ����
    (goto-char (point-min))
    (let (ret)
      (while (if (looking-at "\\([^\t]+\\)\t")
		 (progn
		   (setq ret (cons (cons (match-string 1) (match-end 0)) ret))
		   (= 0 (forward-line 1)))))
      (reverse ret))))


(defun xdic-unix-get-content (dic point)
  (save-excursion
    (set-buffer (get dic 'search-buffer))
    (if (<= point (point-max))
	(buffer-substring (goto-char point) (progn (end-of-line) (point)))
      (error "Can't find content. (ID=%d)" point))))




;;;----------------------------------------------------------------------
;;;		�������
;;;----------------------------------------------------------------------

(provide 'xdic-unix)
(put 'xdic-unix 'version "1.1")
(put 'xdic-unix 'open-dictionary 'xdic-unix-open-dictionary)
(put 'xdic-unix 'close-dictionary 'xdic-unix-close-dictionary)
(put 'xdic-unix 'search-entry 'xdic-unix-search-entry)
(put 'xdic-unix 'get-content 'xdic-unix-get-content)
