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
;;         jgene.perl   - GENE95 ���񤫤��±Ѽ������������
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
;; extract
;;     ���̼����Ÿ�����뤿��γ������ޥ�ɤ���ꤷ�ޤ�����ά�������
;;     �ϡ����񤬰��̤���Ƥ��ʤ��ȸ��ʤ��ޤ���
;;
;; extract-option
;;     extract ���ץ����ˤ�äƻ��ꤵ�줿�������ޥ�ɤ��Ф��ơ�����
;;     ��Ÿ������ɸ����Ϥ˽��Ϥ����뤿��Υ��ޥ�ɥ饤���������ꤷ
;;     �ޤ�����ά�������� xdic-sgml-extract-option ���ͤ�Ȥ��ޤ���


;;; Format:

;; XDIC �����μ���ϼ��Τ褦�ʹ�¤�ˤʤäƤ��ޤ���
;;
;;     file     := line+
;;     line     := key* headkey content | key+ headword content
;;     headkey  := key
;;     key      := '<K>' word '</K>'
;;     headword := '<H>' word '<H>'
;;     word     := char+
;;     char     := [^<>&] | '&lt;' | '&gt;' | '&amp;'
;;     content  := string
;;     string   := char_lf+
;;     char_lf  := char | '&lf;'
;;
;; ���μ���ե����ޥåȤϡ�grep �ʤɤιԻظ��θ����ץ�����Ȥä���
;; �����׸����ڤӸ������׸������������׸�������ʸ�������ưפ˹Ԥʤ���
;; �褦���߷פ��ޤ�����
;;
;; (1) ��������ʸ����ʸ������̤��롣����ե��٥åȤ���ʸ���Ⱦ�ʸ�������
;;     ���ʤ�����( case-ignore search )����������Ƥ��ʤ������ץ�����
;;     ���Ѥ����ǽ�������뤿�ᡣ
;;
;; (2) �����μ�����˸����᥿����饯�� <>& �Ϥ��줾�� &lt; &gt; &amp; 
;;     ���ִ����롣���äơ�string �ˤ� <> �ϸ���ʤ������������ʸ�˴ޤ�
;;     ��Ƥ�����ԥ����ɤ� &lf; ���ִ����롣
;;
;; (3) headword �ϸ��Ф�����ݻ����빽ʸ���ǤǤ��롣
;;
;; (4) content ������ʸ���ݻ����빽ʸ���ǤǤ��롣
;;
;; (5) key �ϼ���θ��Ф��측�����оݤȤʤ빽ʸ���ǤǤ��롣���äơ�
;;     headword �˰ʲ�����������ܤ���ʸ������������롣
;;
;;       ������ե��٥åȤ���ʸ�������ƾ�ʸ�����Ѵ�����
;;       ��ʣ���ζ���ʸ����1�ĤΥ��ڡ������ִ�����
;;
;;     ����������ʸ���� headword �Ȱ��פ����硢����ʸ����� headkey 
;;     �Ȥ��� headword ���ά���뤳�Ȥ�����롣����ϼ�����礭��������
;;     �뤿��Ǥ��롣headkey ��ʣ���� key �κǸ���֤���롣


;;; �饤�֥���������
(require 'xdic)
(provide 'xdic-sgml)
(put 'xdic-sgml 'version "1.0")
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

(defconst xdic-sgml-buffer-name "*xdic-sgml*")



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
			 (xdic-insert-file-contents (get dic 'file-name) nil nil nil nil (get dic 'coding-system))
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
    0      : Ǥ�ո���
������̤Ȥ��Ƹ��Ĥ��ä����Ф���򥭡��Ȥ����������ʸ����Ƭ�� point ���ͤȤ���
Ϣ��������֤���
"
  (save-excursion
    (set-buffer (get dic 'xdic-sgml-buffer))
    (goto-char (point-min))
    (setq string (cond
		  ;; �������׸����ξ��
		  ((eq search-type nil) (concat "<K>" (regexp-quote (downcase string))))
		  ;; �������׸����ξ��
		  ((eq search-type t) (concat (regexp-quote (downcase string)) "</K>"))
		  ;; �������׸����ξ��
		  ((eq search-type 'lambda) (concat "<K>" (regexp-quote (downcase string)) "</K>"))
		  ;; �桼��������Υ����ˤ�븡���ξ��
		  ((eq search-type 0) string)
		  ;; ����ʳ��θ�����������ꤵ�줿���
		  (t (error "Not supported search type is specified. \(%s\)"
			    (prin1-to-string search-type)))))
    (let ((case-fold-search nil) ret)
      (while (re-search-forward string nil t)
	(setq ret (cons (xdic-sgml-get-entry) ret)))
      (reverse ret))))


(defun xdic-sgml-recover-string (str)
  "STR �˴ޤޤ�Ƥ��륨��������ʸ�������������"
  (while (string-match "&lt;" str)
    (setq str (replace-match "<" t t str)))
  (while (string-match "&gt;" str)
    (setq str (replace-match ">" t t str)))
  (while (string-match "&amp;" str)
    (setq str (replace-match "&" t t str)))
  (while (string-match "&lf;" str)
    (setq str (replace-match "\n" t t str)))
  str)


(defun xdic-sgml-get-entry ()
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
	(cons (xdic-sgml-recover-string (buffer-substring (match-end 0) point))
	      (+ 4 point))
	))))


(defun xdic-sgml-get-content (dic point)
  (save-excursion
    (set-buffer (get dic 'xdic-sgml-buffer))
    (if (<= point (point-max))
	(xdic-sgml-recover-string (buffer-substring (goto-char point)
						    (progn (end-of-line) (point))))
      (error "Can't find content. (ID=%d)" point))))
