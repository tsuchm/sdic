;;; -*- Emacs-Lisp -*-
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: dictionary

;;; Commentary:

;; This file is a part of xdic. Please see xdic.el for more detail.

;; XDIC �����μ���� grep �����Ѥ��Ƹ�������饤�֥��Ǥ���


;;; Install:

;; (1) ����򸡺����뤿��� grep �����Ѥ��Ƥ��ޤ����ѥ����̤äƤ��뤫
;;     ��ǧ���Ʋ�������
;;
;; (2) �����Ŭ�ڤʷ������Ѵ����ơ�Ŭ���ʾ��( ��: /usr/dict/ )����¸
;;     ���Ʋ������������Ѵ��ѥ�����ץȤȤ��ưʲ��� Perl ������ץȤ�
;;     ���ѤǤ��ޤ���
;;
;;         gene.perl    - GENE95 ����
;;         edict.perl   - EDICT ����
;;         eijirou.perl - �Ѽ�Ϻ
;;
;; (3) �Ȥ���褦�ˤ���������������� xdic-eiwa-dictionary-list �ޤ�
;;     �� xdic-waei-dictionary-list ���ɲä��Ʋ�������
;;
;;         (setq xdic-eiwa-dictionary-list
;;               (cons '(xdic-grep "/usr/dict/gene.dic") xdic-eiwa-dictionary-list))
;;
;;     �����������ϼ��Τ褦�ʹ����ˤʤäƤ��ޤ���
;;
;;         (xdic-grep �ե�����̾ (���ץ����A ��A) (���ץ����B ��B) ...)
;;
;;     ���̤ʻ��꤬���פʾ��ˤϡ����ץ����Ͼ�ά�Ǥ��ޤ���
;;
;;         (xdic-grep �ե�����̾)


;;; Options:

;; xdic-grep.el ���Ф��ƻ���Ǥ��륪�ץ����ϼ����̤�Ǥ���
;;
;; coding-system
;;     ����δ��������ɤ���ꤷ�ޤ�����ά�������ϡ�
;;     xdic-default-coding-system ���ͤ�Ȥ��ޤ���
;;
;; title
;;     ����Υ����ȥ����ꤷ�ޤ�����ά�������ϡ�����ե������ 
;;     basename �򥿥��ȥ�Ȥ��ޤ���
;;
;; command
;;     �������ޥ�ɤ�̾������ꤷ�ޤ�����ά�������� 
;;     xdic-grep-command ���ͤ�Ȥ��ޤ���


;;; Note;

;; xdic-sgml.el , xdic-grep.el , xdic-array.el �� XDIC �����μ����
;; �����뤿��Υ饤�֥��Ǥ������줾��ΰ㤤�ϼ����̤�Ǥ���
;;
;; ��xdic-sgml.el
;;     ����ǡ��������ƥ�����ɤ߹���Ǥ��鸡����Ԥ��ޤ�����������
;;     ��ɤ�ɬ�פȤ��ޤ��󤬡����̤Υ��꤬ɬ�פˤʤ�ޤ���
;;
;; ��xdic-grep.el
;;     grep �����Ѥ��Ƹ�����Ԥ��ޤ������Ū��®�Ǥ���
;;
;; ��xdic-array.el
;;     array �����Ѥ��Ƹ�����Ԥ��ޤ�������� index file �����������
;;     ���Ƥ����Ƥ��鸡����Ԥ��ޤ��Τǡ���®�˸�������ǽ�Ǥ�����������
;;     index file �ϼ����3�����٤��礭���ˤʤ�ޤ���
;;
;; ���Ū�����Ϥμ���򸡺�������� xdic-grep.el ����Ŭ�Ǥ��礦����
;; ������5MByte ����礭������ξ��� xdic-array.el �����Ѥ��θ����
;; �����Ȼפ��ޤ���
;;
;; XDIC �����μ���ι�¤�ˤĤ��Ƥϡ�xdic-sgml.el �򻲾Ȥ��Ƥ���������


;;; �饤�֥���������
(require 'xdic)
(require 'xdic-sgml)
(provide 'xdic-grep)
(put 'xdic-grep 'version "1.0")
(put 'xdic-grep 'init-dictionary 'xdic-grep-init-dictionary)
(put 'xdic-grep 'open-dictionary 'xdic-grep-open-dictionary)
(put 'xdic-grep 'close-dictionary 'xdic-sgml-close-dictionary)
(put 'xdic-grep 'search-entry 'xdic-grep-search-entry)
(put 'xdic-grep 'get-content 'xdic-grep-get-content)


;;;----------------------------------------------------------------------
;;;		���/�ѿ������
;;;----------------------------------------------------------------------

(defvar xdic-grep-command
  (catch 'which
    (mapcar '(lambda (file)
	       (mapcar '(lambda (path)
			  (if (file-executable-p (expand-file-name file path))
			      (throw 'which (expand-file-name file path))))
		       exec-path))
	    '("grep" "grep.exe")))
  "*Executable file name of grep")

(defconst xdic-grep-buffer-name "*xdic-grep*")



;;;----------------------------------------------------------------------
;;;		����
;;;----------------------------------------------------------------------

(defun xdic-grep-init-dictionary (file-name &rest option-list)
  "Function to initialize dictionary"
  (let ((dic (xdic-make-dictionary-symbol)))
    (if (file-readable-p (setq file-name (expand-file-name file-name)))
	(progn
	  (mapcar '(lambda (c) (put dic (car c) (nth 1 c))) option-list)
	  (put dic 'file-name file-name)
	  (put dic 'identifier (concat "xdic-grep+" file-name))
	  (or (get dic 'title)
	      (put dic 'title (file-name-nondirectory file-name)))
	  (or (get dic 'command)
	      (put dic 'command xdic-grep-command))
	  (or (get dic 'coding-system)
	      (put dic 'coding-system xdic-default-coding-system))
	  dic)
      (error "Can't read dictionary: %s" (prin1-to-string file-name)))))


(defun xdic-grep-open-dictionary (dic)
  "Function to open dictionary"
  (and (or (xdic-buffer-live-p (get dic 'xdic-sgml-buffer))
	   (put dic 'xdic-sgml-buffer (generate-new-buffer xdic-grep-buffer-name)))
       dic))


(defun xdic-grep-search-entry (dic string &optional search-type) "\
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
    (set-buffer (get dic 'xdic-sgml-buffer))
    (let (limit ret)
      (if (get dic 'xdic-grep-erase-buffer)
	  (delete-region (point-min) (point-max)))
      (setq limit (goto-char (point-max)))
      (put dic 'xdic-grep-erase-buffer nil)
      (xdic-call-process (get dic 'command) nil t nil
			 (get dic 'coding-system)
			 (xdic-sgml-make-query-string string search-type)
			 (get dic 'file-name))
      ;; �Ƹ�����̤� ID ����Ϳ����
      (goto-char limit)
      (while (progn
	       (if (looking-at "<K>")
		   (setq ret (cons (xdic-sgml-get-entry) ret)))
	       (= 0 (forward-line 1))))
      (reverse ret))))


(defun xdic-grep-get-content (dic point)
  (put dic 'xdic-grep-erase-buffer t)
  (xdic-sgml-get-content dic point))
