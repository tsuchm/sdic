;;; -*- Emacs-Lisp -*-
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: dictionary

;;; Commentary:

;; This file is a part of xdic. Please see xdic.el for more detail.

;; XDIC �����μ���� array �����Ѥ��Ƹ�������饤�֥��Ǥ���


;;; Install:

;; (1) array �Ȥϡ�SUFARY ����°���Ƥ������÷������ץ����Ǥ���
;;     SUFARY �ˤĤ��Ƥϰʲ��� URL �򻲾Ȥ��Ʋ�������
;;
;;         http://cactus.aist-nara.ac.jp/lab/nlt/ss/
;;
;;     �����оݤΥƥ����Ȥκ���������˺������Ƥ��������פθ����ץ�
;;     ���ʤΤǡ�grep �����®�ʸ�������ǽ�Ǥ���
;;
;;     ��°ʸ��λؼ��ˤ������äơ�array �� mkary �򥤥󥹥ȡ��뤷�Ʋ�
;;     ������
;;
;; (2) �����Ŭ�ڤʷ������Ѵ����ơ�Ŭ���ʾ��( ��: /usr/dict/ )����¸
;;     ���Ʋ������������Ѵ��ѥ�����ץȤȤ��ưʲ��� Perl ������ץȤ�
;;     ���ѤǤ��ޤ���
;;
;;         gene.perl    - GENE95 ����
;;         edict.perl   - EDICT ����
;;         eijirou.perl - �Ѽ�Ϻ
;;
;; (3) ����κ������������ޤ���/usr/dict/gene.dic �κ���������������
;;     �ϡ����Τ褦�˥��ޥ�ɤ����Ϥ��Ʋ�������
;;
;;         mkary /usr/dict/gene.dic
;;
;;     ����ȡ�/usr/dict/gene.dic.ary ����������ޤ���
;;
;;
;; (4) �Ȥ���褦�ˤ���������������� xdic-eiwa-dictionary-list �ޤ�
;;     �� xdic-waei-dictionary-list ���ɲä��Ʋ�������
;;
;;         (setq xdic-eiwa-dictionary-list
;;               (cons '(xdic-array "/usr/dict/gene.dic") xdic-eiwa-dictionary-list))
;;
;;     �����������ϼ��Τ褦�ʹ����ˤʤäƤ��ޤ���
;;
;;         (xdic-array �ե�����̾ (���ץ����A ��A) (���ץ����B ��B) ...)
;;
;;     ���̤ʻ��꤬���פʾ��ˤϡ����ץ����Ͼ�ά�Ǥ��ޤ���
;;
;;         (xdic-array �ե�����̾)


;;; Options:

;; xdic-array.el ���Ф��ƻ���Ǥ��륪�ץ����ϼ����̤�Ǥ���
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
;;     xdic-array-command ���ͤ�Ȥ��ޤ���
;;
;; array-file-name
;;     ����� array file ��̾������ꤷ�ޤ�����ά�������ϡ���������
;;     ��ɤΥǥե�����ͤ��Ȥ��ޤ���


;;; Note;

;; xdic-sgml.el , xdic-grep.el , xdic-array.el �� XDIC �����μ����
;; �����뤿��Υ饤�֥��Ǥ������줾��ΰ㤤�ϼ����̤�Ǥ���
;;
;; ��xdic-sgml.el
;;     ����ǡ��������ƥ�����ɤ߹���Ǥ��鸡����Ԥ��ޤ�����������
;;     ��ɤ�ɬ�פȤ��ޤ��󤬡����̤Υ��꤬ɬ�פˤʤ�ޤ���
;;
;; ��xdic-grep.el
;;     grep �����Ѥ��Ƹ�����Ԥ��ޤ���
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
;; XDIC �����μ���ι�¤�ˤĤ��Ƥϡ�dictionary-format.txt �򻲾Ȥ��Ƥ�
;; ��������


;;; �饤�֥���������
(require 'xdic)
(require 'xdic-sgml)
(provide 'xdic-array)
(put 'xdic-array 'version "1.0")
(put 'xdic-array 'init-dictionary 'xdic-array-init-dictionary)
(put 'xdic-array 'open-dictionary 'xdic-array-open-dictionary)
(put 'xdic-array 'close-dictionary 'xdic-array-close-dictionary)
(put 'xdic-array 'search-entry 'xdic-array-search-entry)
(put 'xdic-array 'get-content 'xdic-array-get-content)


;;;----------------------------------------------------------------------
;;;		���/�ѿ������
;;;----------------------------------------------------------------------

(defvar xdic-array-command
  (catch 'which
    (mapcar '(lambda (file)
	       (mapcar '(lambda (path)
			  (if (file-executable-p (expand-file-name file path))
			      (throw 'which (expand-file-name file path))))
		       exec-path))
	    '("array" "array.exe")))
  "*Executable file name of array")

(defvar xdic-array-wait-prompt-flag nil)

(defconst xdic-array-buffer-name "*xdic-array*")



;;;----------------------------------------------------------------------
;;;		����
;;;----------------------------------------------------------------------

(defun xdic-array-init-dictionary (file-name &rest option-list)
  "Function to initialize dictionary"
  (let ((dic (xdic-make-dictionary-symbol)))
    (if (file-readable-p (setq file-name (expand-file-name file-name)))
	(progn
	  (mapcar '(lambda (c) (put dic (car c) (nth 1 c))) option-list)
	  (put dic 'file-name file-name)
	  (put dic 'identifier (concat "xdic-array+" file-name))
	  (or (get dic 'title)
	      (put dic 'title (file-name-nondirectory file-name)))
	  (or (get dic 'command)
	      (put dic 'command xdic-array-command))
	  (or (get dic 'coding-system)
	      (put dic 'coding-system xdic-default-coding-system))
	  dic)
      (error "Can't read dictionary: %s" (prin1-to-string file-name)))))


(defun xdic-array-open-dictionary (dic)
  "Function to open dictionary"
  (let	((old-buffer (current-buffer))
	 (buf (or (xdic-buffer-live-p (get dic 'xdic-sgml-buffer))
		  (put dic 'xdic-sgml-buffer (generate-new-buffer xdic-array-buffer-name)))))
    (unwind-protect
	(and (or (xdic-array-process-live-p dic)
		 (let ((limit (progn (set-buffer buf) (goto-char (point-max))))
		       (proc (xdic-start-process "array" buf
						 (get dic 'coding-system)
						 (get dic 'command)
						 (get dic 'file-name)
						 (or (get dic 'array-file-name) ""))))
		   (accept-process-output proc 5)
		   (if (search-backward "ok\n" limit t)
		       (progn
			 (set-process-filter proc 'xdic-array-wait-prompt)
			 (process-kill-without-query proc)
			 (xdic-array-send-string proc "style line")
			 t))))
	     dic)
      (set-buffer old-buffer))))


(defun xdic-array-close-dictionary (dic)
  "Function to close dictionary"
  (let ((proc (xdic-array-process-live-p dic)))
    (if proc
	(progn
	  (set-process-filter proc nil)
	  (process-send-string proc "quit\n"))))
  (kill-buffer (get dic 'xdic-sgml-buffer))
  (put dic 'xdic-sgml-buffer nil))


(defun xdic-array-search-entry (dic string &optional search-type) "\
Function to search word with look or grep, and write results to current buffer.
search-type ���ͤˤ�äƼ��Τ褦��ư����ѹ����롣
    nil    : �������׸���
    t      : �������׸���
    lambda : �������׸���
    0      : ��ʸ����
������̤Ȥ��Ƹ��Ĥ��ä����Ф���򥭡��Ȥ����������ʸ����Ƭ�� point ���ͤȤ���
Ϣ��������֤���
"
  (save-excursion
    (let* ((buf (set-buffer (get dic 'xdic-sgml-buffer)))
	   (proc (get-buffer-process buf))
	   limit ret)
      (if (get dic 'xdic-array-erase-buffer)
	  (delete-region (point-min) (point-max))
	(goto-char (point-max)))
      (put dic 'xdic-array-erase-buffer nil)
      (xdic-array-send-string proc "init") ; ������������
      (setq limit (point))
      (xdic-array-send-string proc (format "search %s" (xdic-sgml-make-query-string string search-type)))
      (if (re-search-backward "^FOUND: [0-9]+$" limit t)
	  (progn
	    (setq limit (+ 3 (match-end 0)))
	    (xdic-array-send-string proc "show")
	    ;; �Ƹ�����̤� ID ����Ϳ����
	    (goto-char limit)
	    (while (progn
		     (if (looking-at "<K>")
			 (setq ret (cons (xdic-sgml-get-entry) ret)))
		     (= 0 (forward-line 1))))
	    (reverse ret))))))


(defun xdic-array-get-content (dic point)
  (put dic 'xdic-array-erase-buffer t)
  (xdic-sgml-get-content dic point))


(defun xdic-array-process-live-p (dic)
  (let ((proc (get-buffer-process (get dic 'xdic-sgml-buffer))))
    (and (processp proc)
	 (eq (process-status proc) 'run)
	 proc)))


(defun xdic-array-send-string (proc string) "\
Send STRING as command to process."
  (setq string (concat string "\n"))
  (let ((old-buffer (current-buffer)))
    (unwind-protect
	(let ((xdic-array-wait-prompt-flag t))
	  (set-buffer (process-buffer proc))
	  (goto-char (point-max))
	  (insert string)
	  (set-marker (process-mark proc) (point))
	  (process-send-string proc string)
	  (while xdic-array-wait-prompt-flag (accept-process-output proc)))
      (set-buffer old-buffer))))


(defun xdic-array-wait-prompt (proc string) "\
Process filter function of Array.
�ץ��ץȤ����줿���Ȥ��Τ��ơ�xdic-array-wait-prompt-flag �� nil 
�ˤ��롣"
  (let ((old-buffer (current-buffer)))
    (unwind-protect
	(save-match-data ; Emacs-19.34 �ʹߤϼ�ưŪ�˸�����̤�����/�������Ԥ���Τ�����
	  (set-buffer (process-buffer proc))
	  (let ((start (point)))
	    (goto-char (process-mark proc))
	    (insert string)
	    (set-marker (process-mark proc) (point))
	    (skip-chars-backward " \t\n")
	    (beginning-of-line)
	    (if (looking-at "ok\n")
		(progn
		  (goto-char (match-end 0))
		  (setq xdic-array-wait-prompt-flag nil))
	      (goto-char start))))
      (set-buffer old-buffer))))
