;;; -*- Emacs-Lisp -*-
;;; $Id$

;;; Author: Tsuchiya Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;; Keywords: dictionary

;;; Commentary:

;; This file is a part of xdic. Please see xdic.el for more detail.

;; XDIC �����μ���򰷤�����Υ饤�֥��Ǥ���


;;; Install:

;; (1) �����Ŭ�ڤʷ������Ѵ����ơ�Ŭ���ʾ��( ��: /usr/dict/ )����¸
;;     ���Ʋ������������Ѵ��ѥ�����ץȤȤ��ưʲ��� Perl ������ץȤ�
;;     ���ѤǤ��ޤ���
;;
;;         gene.perl    - GENE95 ����
;;         edict.perl   - EDICT ����
;;         eijirou.perl - �Ѽ�Ϻ
;;
;; (2) �Ȥ���褦�ˤ���������������� xdic-eiwa-dictionary-list �ޤ�
;;     �� xdic-waei-dictionary-list ���ɲä��Ʋ�������
;;
;;         (setq xdic-eiwa-dictionary-list
;;               (cons '(xdic-sgml "/usr/dict/gene.dic") xdic-eiwa-dictionary-list))
;;
;;     �����������ϼ��Τ褦�ʹ����ˤʤäƤ��ޤ���
;;
;;         (xdic-sgml �ե�����̾ (���ץ����A ��A) (���ץ����B ��B) ...)
;;
;;     ���̤ʻ��꤬���פʾ��ˤϡ����ץ����Ͼ�ά�Ǥ��ޤ���
;;
;;         (xdic-sgml �ե�����̾)


;;; Options:

;; xdic-sgml.el ���Ф��ƻ���Ǥ��륪�ץ����ϼ����̤�Ǥ���
;;
;; coding-system
;;     ����δ��������ɤ���ꤷ�ޤ�����ά�������ϡ�
;;     xdic-default-coding-system ���ͤ�Ȥ��ޤ���
;;
;; title
;;     ����Υ����ȥ����ꤷ�ޤ�����ά�������ϡ�����ե������ 
;;     basename �򥿥��ȥ�Ȥ��ޤ���
;;
;; add-keys-to-headword
;;     ���Ƥθ���������ޤ�Ƹ��Ф������������� t �����ꤷ�Ʋ���
;;     �����±Ѽ���򸡺�������ˡ����겾̾��ޤ�ƽ��Ϥ��������
;;     �Ѥ��ޤ���
;;
;; extract
;;     ���̼����Ÿ�����뤿��γ������ޥ�ɤ���ꤷ�ޤ�����ά�������
;;     �ϡ����񤬰��̤���Ƥ��ʤ��ȸ��ʤ��ޤ���
;;
;; extract-option
;;     extract ���ץ����ˤ�äƻ��ꤵ�줿�������ޥ�ɤ��Ф��ơ�����
;;     ��Ÿ������ɸ����Ϥ˽��Ϥ����뤿��Υ��ޥ�ɥ饤���������ꤷ
;;     �ޤ�����ά�������� xdic-sgml-extract-option ���ͤ�Ȥ��ޤ���


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
(provide 'xdic-sgml)
(put 'xdic-sgml 'version "1.1")
(put 'xdic-sgml 'init-dictionary 'xdic-sgml-init-dictionary)
(put 'xdic-sgml 'open-dictionary 'xdic-sgml-open-dictionary)
(put 'xdic-sgml 'close-dictionary 'xdic-sgml-close-dictionary)
(put 'xdic-sgml 'search-entry 'xdic-sgml-search-entry)
(put 'xdic-sgml 'get-content 'xdic-sgml-get-content)


;;;----------------------------------------------------------------------
;;;		���/�ѿ������
;;;----------------------------------------------------------------------

(defvar xdic-sgml-extract-option "-dc" "\
*Option for archiver.
���̼����Ÿ�����뤿��˻Ȥ����ץ����")

(defconst xdic-sgml-buffer-name " *xdic-sgml*")



;;;----------------------------------------------------------------------
;;;		����
;;;----------------------------------------------------------------------

(defun xdic-sgml-init-dictionary (file-name &rest option-list)
  "Function to initialize dictionary"
  (let ((dic (xdic-make-dictionary-symbol)))
    (if (file-readable-p (setq file-name (expand-file-name file-name)))
	(progn
	  (mapcar '(lambda (c) (put dic (car c) (nth 1 c))) option-list)
	  (put dic 'file-name file-name)
	  (put dic 'identifier (concat "xdic-sgml+" file-name))
	  (or (get dic 'title)
	      (put dic 'title (file-name-nondirectory file-name)))
	  (if (get dic 'extract)
	      (or (get dic 'extract-option)
		  (put dic 'extract-option xdic-sgml-extract-option)))
	  (or (get dic 'coding-system)
	      (put dic 'coding-system xdic-default-coding-system))
	  dic)
      (error "Can't read dictionary: %s" (prin1-to-string file-name)))))


(defun xdic-sgml-open-dictionary (dic)
  "Function to open dictionary"
  (if (or (xdic-buffer-live-p (get dic 'xdic-sgml-buffer))
	  (save-excursion
	    (set-buffer (put dic 'xdic-sgml-buffer (generate-new-buffer xdic-sgml-buffer-name)))
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


(defun xdic-sgml-close-dictionary (dic)
  "Function to close dictionary"
  (kill-buffer (get dic 'xdic-sgml-buffer))
  (put dic 'xdic-sgml-buffer nil))


(defun xdic-sgml-search-entry (dic string &optional search-type) "\
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
    (set-buffer (get dic 'xdic-sgml-buffer))
    (goto-char (point-min))
    (setq string (xdic-sgml-make-query-string string search-type))
    (let ((case-fold-search nil) ret)
      (while (search-forward string nil t)
	(setq ret (cons (xdic-sgml-get-entry (get dic 'add-keys-to-headword)) ret)))
      (reverse ret))))


(defun xdic-sgml-make-query-string (string search-type)
  "STR ����Ŭ�ڤʸ���ʸ�������������"
  (cond
   ;; �������׸����ξ��
   ((eq search-type nil) (concat "<K>" (xdic-sgml-escape-string (downcase string))))
   ;; �������׸����ξ��
   ((eq search-type t) (concat (xdic-sgml-escape-string (downcase string)) "</K>"))
   ;; �������׸����ξ��
   ((eq search-type 'lambda) (concat "<K>" (xdic-sgml-escape-string (downcase string)) "</K>"))
   ;; ��ʸ�����ξ��
   ((eq search-type 0) (xdic-sgml-escape-string string))
   ;; ����ʳ��θ�����������ꤵ�줿���
   (t (error "Not supported search type is specified. \(%s\)"
	     (prin1-to-string search-type)))))


(defun xdic-sgml-get-entry (&optional add-keys-to-headword)
  "���߹Ԥ��鸫�Ф������Ф�������ʸ����Ƭ�ΰ��֤���롣"
  (save-excursion
    (save-match-data
      (let ((start (progn (beginning-of-line) (point)))
	    (point))
	(end-of-line)
	(if (search-backward "</H>" start t)
	    (progn
	      (setq point (match-beginning 0))
	      (search-backward "<H>" start))
	  (search-backward "</K>" start)
	  (setq point (match-beginning 0))
	  (search-backward "<K>" start))
	(cons (xdic-sgml-recover-string
	       (apply 'concat
		      (buffer-substring (match-end 0) point)
		      (and add-keys-to-headword
			   (/= start (match-beginning 0))
			   (cons " "
				 (mapcar
				  (function (lambda (s) (format "[%s]" s)))
				  (xdic-split-string (buffer-substring (+ start 3)
								       (- (match-beginning 0) 4))
						     "</K><K>"))))))
	      (+ 4 point))
	))))


(defun xdic-sgml-get-content (dic point)
  (save-excursion
    (set-buffer (get dic 'xdic-sgml-buffer))
    (if (<= point (point-max))
	(xdic-sgml-recover-string (buffer-substring (goto-char point)
						    (progn (end-of-line) (point))))
      (error "Can't find content. (ID=%d)" point))))


(defun xdic-sgml-recover-string (str &optional recover-lf)
  "STR �˴ޤޤ�Ƥ��륨��������ʸ�������������"
  (save-match-data
    (setq str (xdic-sgml-replace-string str "&lt;" "<"))
    (setq str (xdic-sgml-replace-string str "&gt;" ">"))
    (if recover-lf
	(setq str (xdic-sgml-replace-string str "&lf;" "\n")))
    (xdic-sgml-replace-string str "&amp;" "&")))


(defun xdic-sgml-recover-region (start end &optional recover-lf)
  "�꡼�����˴ޤޤ�Ƥ��륨��������ʸ�������������"
  (save-excursion
    (save-match-data
      (save-restriction
	(narrow-to-region start end)
	(goto-char (point-min))
	(while (search-forward "&lt;" nil t)
	  (replace-match "<" t t))
	(goto-char (point-min))
	(while (search-forward "&gt;" nil t)
	  (replace-match ">" t t))
	(if recover-lf
	    (progn
	      (goto-char (point-min))
	      (while (search-forward "&lf;" nil t)
		(replace-match "\n" t t))))
	(goto-char (point-min))
	(while (search-forward "&amp;" nil t)
	  (replace-match "&" t t))
	))))


(defun xdic-sgml-escape-string (str &optional escape-lf)
  "STR �˴ޤޤ�Ƥ����ü�ʸ���򥨥������פ���"
  (save-match-data
    (setq str (xdic-sgml-replace-string str "&" "&amp;"))
    (if escape-lf
	(setq str (xdic-sgml-replace-string str "\n" "&lf;")))
    (setq str (xdic-sgml-replace-string str "<" "&lt;"))
    (xdic-sgml-replace-string str ">" "&gt;")))


(defun xdic-sgml-escape-region (start end &optional escape-lf)
  "�꡼�����˴ޤޤ�Ƥ����ü�ʸ���򥨥������פ���"
  (save-excursion
    (save-match-data
      (save-restriction
	(narrow-to-region start end)
	(goto-char (point-min))
	(while (search-forward "&" nil t)
	  (replace-match "&amp;" t t))
	(goto-char (point-min))
	(while (search-forward "<" nil t)
	  (replace-match "&lt;" t t))
	(goto-char (point-min))
	(while (search-forward ">" nil t)
	  (replace-match "&gt;" t t))
	(if escape-lf
	    (progn
	      (goto-char (point-min))
	      (while (search-forward "\n" nil t)
		(replace-match "&lf;" t t))))
	))))


(defun xdic-sgml-replace-string (string from to) "\
ʸ���� STRING �˴ޤޤ�Ƥ���ʸ���� FROM ������ʸ���� TO ���ִ�����ʸ������֤�
FROM �ˤ�����ɽ����ޤ�ʸ��������Ǥ��뤬��TO �ϸ���ʸ���󤷤������
���ʤ��Τǡ���դ��ƻȤ����ȡ�"
  (let ((start 0) list)
    (while (string-match from string start)
      (setq list (cons to (cons (substring string start (match-beginning 0)) list)))
      (setq start (match-end 0)))
    (apply 'concat (reverse (cons (substring string start) list)))))
