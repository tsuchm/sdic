;;; -*- Emacs-Lisp -*-
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: dictionary

;;; Commentary:

;; This file is a part of xdic. Please see xdic.el for more detail.

;; 1�ԤΥǡ����η�����
;;	���Ф��� TAB ���ʸ RET
;; �ȤʤäƤ��뼭������ץ�������餺�˸�������饤�֥��

(require 'xdic)
(provide 'xdic-gene)
(put 'xdic-gene 'version "1.2")
(put 'xdic-gene 'init-dictionary 'xdic-gene-init-dictionary)
(put 'xdic-gene 'open-dictionary 'xdic-gene-open-dictionary)
(put 'xdic-gene 'close-dictionary 'xdic-gene-close-dictionary)
(put 'xdic-gene 'search-entry 'xdic-gene-search-entry)
(put 'xdic-gene 'get-content 'xdic-gene-get-content)



;;;----------------------------------------------------------------------
;;;		���/�ѿ������
;;;----------------------------------------------------------------------

(defvar xdic-gene-extract-option "-dc" "\
*Option for archiver.
���̼����Ÿ�����뤿��˻Ȥ����ץ����")

(defconst xdic-gene-search-buffer-name "*xdic-gene*")



;;;----------------------------------------------------------------------
;;;		����
;;;----------------------------------------------------------------------

(defun xdic-gene-init-dictionary (file-name &rest option-list)
  "Function to initialize dictionary"
  (let ((dic (xdic-make-dictionary-symbol)))
    (if (file-readable-p (setq file-name (expand-file-name file-name)))
	(progn
	  (mapcar '(lambda (c) (put dic (car c) (nth 1 c))) option-list)
	  (put dic 'file-name file-name)
	  (put dic 'identifier (concat "xdic-gene+" file-name))
	  (or (get dic 'title)
	      (put dic 'title (file-name-nondirectory file-name)))
	  (if (get dic 'extract)
	      (or (get dic 'extract-option)
		  (put dic 'extract-option xdic-gene-extract-option)))
	  (or (get dic 'coding-system)
	      (put dic 'coding-system xdic-default-coding-system))
	  dic)
      (error "Can't read dictionary: %s" (prin1-to-string file-name)))))


(defun xdic-gene-open-dictionary (dic)
  "Function to open dictionary"
  (if (or (xdic-buffer-live-p (get dic 'xdic-gene-search-buffer))
	  (save-excursion
	    (set-buffer (put dic 'xdic-gene-search-buffer (generate-new-buffer xdic-gene-search-buffer-name)))
	    (prog1 (if (get dic 'extract)
		       (= 0 (xdic-call-process (get dic 'extract) nil t nil
					       (get dic 'coding-system)
					       (get dic 'extract-option)
					       (get dic 'file-name)))
		     (condition-case err
			 (xdic-insert-file-contents (get dic 'file-name) nil nil nil nil (get dic 'coding-system))
		       (error nil)))
	      (setq buffer-read-only t)
	      (set-buffer-modified-p nil))))
      dic))


(defun xdic-gene-close-dictionary (dic)
  "Function to close dictionary"
  (kill-buffer (get dic 'xdic-gene-search-buffer))
  (put dic 'xdic-gene-search-buffer nil))


(defun xdic-gene-search-entry (dic string &optional search-type) "\
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
    (set-buffer (get dic 'xdic-gene-search-buffer))
    (goto-char (point-min))
    (setq string (cond
		  ;; �������׸����ξ��
		  ((eq search-type nil) (concat "^" (regexp-quote string)))
		  ;; �������׸����ξ��
		  ((eq search-type t) (format "^\\([^\t]*%s\\)\t" (regexp-quote string)))
		  ;; �������׸����ξ��
		  ((eq search-type 'lambda) (format "^%s\t" (regexp-quote string)))
		  ;; �桼��������Υ����ˤ�븡���ξ��
		  ((eq search-type 0) string)
		  ;; ����ʳ��θ�����������ꤵ�줿���
		  (t (error "Not supported search type is specified. \(%s\)"
			    (prin1-to-string search-type)))))
    (let (ret (case-fold-search t))
      (while (re-search-forward string nil t)
	(save-excursion
	  (setq ret (cons (cons (buffer-substring (progn (beginning-of-line) (point))
						  (progn (skip-chars-forward "^\t") (point)))
				(1+ (point)))
			  ret))))
      (reverse ret))))


(defun xdic-gene-get-content (dic point)
  (save-excursion
    (set-buffer (get dic 'xdic-gene-search-buffer))
    (if (<= point (point-max))
	(buffer-substring (goto-char point) (progn (end-of-line) (point)))
      (error "Can't find content. (ID=%d)" point))))
