;;; -*- Emacs-Lisp -*-
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: dictionary

;;; Commentary:

;; This file is a part of xdic. Please see xdic.el for more detail.

;; 1�ԤΥǡ����η�����
;;	���Ф��� TAB ���ʸ RET
;; �ȤʤäƤ��뼭������ץ�������餺�˸�������饤�֥��



;;;----------------------------------------------------------------------
;;;		����
;;;----------------------------------------------------------------------

(defun xdic-gene-open-dictionary (dic)
  "Function to open dictionary"
  (if (bufferp (get dic 'search-buffer))
      (kill-buffer (get dic 'search-buffer)))
  (save-excursion
    (set-buffer (put dic 'search-buffer (generate-new-buffer "*xdic-gene*")))
    (insert-file-contents (get dic 'file-name))
    (setq buffer-read-only t)
    (set-buffer-modified-p nil)
    t))


(defun xdic-gene-close-dictionary (dic)
  "Function to close dictionary"
  (kill-buffer (get dic 'search-buffer))
  (put dic 'search-buffer nil))


(defun xdic-gene-search-entry (dic string &optional search-type) "\
Function to search word with look or grep, and write results to current buffer.
search-type ���ͤˤ�äƼ��Τ褦��ư����ѹ����롣
    nil    : �������׸���
    t      : �������׸���
    lambda : �������׸���
������̤Ȥ��Ƹ��Ĥ��ä����Ф���򥭡��Ȥ����������ʸ����Ƭ�� point ���ͤȤ���
Ϣ��������֤���
"
  (save-excursion
    (set-buffer (get dic 'search-buffer))
    (goto-char (point-min))
    (setq string (cond
		  ;; �������׸����ξ��
		  ((eq search-type nil)
		   (format "^\\(%s[^\t]*\\)\t" (regexp-quote string)))
		  ;; �������׸����ξ��
		  ((eq search-type t)
		   (format "^\\([^\t]*%s\\)\t" (regexp-quote string)))
		  ;; �������׸����ξ��
		  ((eq search-type 'lambda)
		   (format "^\\(%s\\)\t" (regexp-quote string)))
		  ;; ����ʳ��θ�����������ꤵ�줿���
		  (t (error "Not supported search type is specified. \(%s\)"
			    (prin1-to-string search-type)))))
    (let (ret)
      (while (re-search-forward string nil t)
	(setq ret (cons (cons (match-string 1) (match-end 0)) ret)))
      (reverse ret))))


(defun xdic-gene-get-content (dic point)
  (save-excursion
    (set-buffer (get dic 'search-buffer))
    (if (<= point (point-max))
	(buffer-substring (goto-char point) (progn (end-of-line) (point)))
      (error "Can't find content. (ID=%d)" point))))




;;;----------------------------------------------------------------------
;;;		�������
;;;----------------------------------------------------------------------

(provide 'xdic-gene)
(put 'xdic-gene 'version "1.1")
(put 'xdic-gene 'open-dictionary 'xdic-gene-open-dictionary)
(put 'xdic-gene 'close-dictionary 'xdic-gene-close-dictionary)
(put 'xdic-gene 'search-entry 'xdic-gene-search-entry)
(put 'xdic-gene 'get-content 'xdic-gene-get-content)
