;;; -*- Emacs-Lisp -*-
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: dictionary

;;; Commentary:

;; This file is a part of xdic. Please see xdic.el for more detail.

;; 1�ԤΥǡ����η�����
;;
;;	���Ф��� TAB ���ʸ RET
;;
;; �ȤʤäƤ��뼭������ץ�������餺�˸�������饤�֥��Ǥ���


;;; Install:

;; (1) �����Ŭ�ڤʷ������Ѵ����ơ�Ŭ���ʾ��( ��: /usr/dict/ )����¸
;;     ���Ʋ������������Ѵ��ѥ�����ץȤȤ��ưʲ��� Perl ������ץȤ�
;;     ���ѤǤ��ޤ���
;;
;;         gene.perl    - GENE95 ����
;;         jgene.perl   - GENE95 ���񤫤��±Ѽ������������
;;         eijirou.perl - �Ѽ�Ϻ
;;
;; (2) �Ȥ���褦�ˤ���������������� xdic-eiwa-dictionary-list �ޤ�
;;     �� xdic-waei-dictionary-list ���ɲä��Ʋ�������
;;
;;         (setq xdic-eiwa-dictionary-list
;;               (cons '(xdic-gene "/usr/dict/gene.dic") xdic-eiwa-dictionary-list))
;;
;;     �����������ϼ��Τ褦�ʹ����ˤʤäƤ��ޤ���
;;
;;         (xdic-gene �ե�����̾ (���ץ����A ��A) (���ץ����B ��B) ...)
;;
;;     ���̤ʻ��꤬���פʾ��ˤϡ����ץ����Ͼ�ά�Ǥ��ޤ���
;;
;;         (xdic-gene �ե�����̾)


;;; Options:

;; xdic-gene.el ���Ф��ƻ���Ǥ��륪�ץ����ϼ����̤�Ǥ���
;;
;; coding-system
;;     ����δ��������ɤ���ꤷ�ޤ�����ά�������ϡ�
;;     xdic-default-coding-system ���ͤ�Ȥ��ޤ���
;;
;; title
;;     ����Υ����ȥ����ꤷ�ޤ�����ά�������ϡ�����ե������ 
;;     basename �򥿥��ȥ�Ȥ��ޤ���
;;
;; extract
;;     ���̼����Ÿ�����뤿��γ������ޥ�ɤ���ꤷ�ޤ�����ά�������
;;     �ϡ����񤬰��̤���Ƥ��ʤ��ȸ��ʤ��ޤ���
;;
;; extract-option
;;     extract ���ץ����ˤ�äƻ��ꤵ�줿�������ޥ�ɤ��Ф��ơ�����
;;     ��Ÿ������ɸ����Ϥ˽��Ϥ����뤿��Υ��ޥ�ɥ饤���������ꤷ
;;     �ޤ�����ά�������� xdic-gene-extract-option ���ͤ�Ȥ��ޤ���


;;; Note:

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

(defconst xdic-gene-search-buffer-name " *xdic-gene*")



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
	    (insert "\n")
	    (prog1 (if (get dic 'extract)
		       (= 0 (xdic-call-process (get dic 'extract) nil t nil
					       (get dic 'coding-system)
					       (get dic 'extract-option)
					       (get dic 'file-name)))
		     (condition-case err
			 (xdic-insert-file-contents (get dic 'file-name) (get dic 'coding-system))
		       (error nil)))
	      (setq buffer-read-only t)
	      (set-buffer-modified-p nil))))
      dic))


(defun xdic-gene-close-dictionary (dic)
  "Function to close dictionary"
  (kill-buffer (get dic 'xdic-gene-search-buffer))
  (put dic 'xdic-gene-search-buffer nil))


(defsubst xdic-gene-search-internal (string)
  "�̾�θ�����Ԥ������ؿ�"
  (let (ret (case-fold-search t))
    (while (search-forward string nil t)
      (save-excursion
	(setq ret (cons (cons (buffer-substring (progn (beginning-of-line) (point))
						(progn (skip-chars-forward "^\t") (point)))
			      (1+ (point)))
			ret))))
    (reverse ret)))


(defsubst xdic-gene-re-search-internal (string)
  "����ɽ��������Ԥ������ؿ�"
  (let (ret (case-fold-search t))
    (while (re-search-forward string nil t)
      (save-excursion
	(setq ret (cons (cons (buffer-substring (progn (beginning-of-line) (point))
						(progn (skip-chars-forward "^\t") (point)))
			      (1+ (point)))
			ret))))
    (reverse ret)))


(defun xdic-gene-search-entry (dic string &optional search-type) "\
Function to search word with look or grep, and write results to current buffer.
search-type ���ͤˤ�äƼ��Τ褦��ư����ѹ����롣
    nil    : �������׸���
    t      : �������׸���
    lambda : �������׸���
    0      : ��ʸ����
    regexp : ����ɽ������
������̤Ȥ��Ƹ��Ĥ��ä����Ф���򥭡��Ȥ����������ʸ����Ƭ�� point ���ͤȤ���
Ϣ��������֤���
"
  (save-excursion
    (set-buffer (get dic 'xdic-gene-search-buffer))
    (goto-char (point-min))
    (cond
     ;; �������׸���
     ((eq search-type nil)
      (xdic-gene-search-internal (concat "\n" string)))
     ;; �������׸���
     ((eq search-type t)
      (xdic-gene-search-internal (concat string "\t")))
     ;; �������׸���
     ((eq search-type 'lambda)
      (xdic-gene-search-internal (concat "\n" string "\t")))
     ;; ��ʸ����
     ((eq search-type 0)
      (xdic-gene-search-internal string))
     ;; ����ɽ������
     ((eq search-type 'regexp)
      (xdic-gene-re-search-internal string))
     ;; ����ʳ��θ�����������ꤵ�줿���
     (t (error "Not supported search type is specified. \(%s\)"
	       (prin1-to-string search-type))))))


(defun xdic-gene-get-content (dic point)
  (save-excursion
    (set-buffer (get dic 'xdic-gene-search-buffer))
    (if (<= point (point-max))
	(buffer-substring (goto-char point) (progn (end-of-line) (point)))
      (error "Can't find content. (ID=%d)" point))))
