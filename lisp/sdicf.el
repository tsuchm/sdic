;;; sdicf.el --- Search library for SDIC format dictionary

;; Copyright (C) 1999 TSUCHIYA Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>

;; Author: TSUCHIYA Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;;	   NISHIDA Keisuke <knishida@ring.aist.go.jp>
;; Maintainer: TSUCHIYA Masatoshi <tsuchiya@pine.kuee.kyoto-u.ac.jp>
;; Created: $Date$
;; Version: $Revision$
;; Keywords: dictionary

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


;;; Commentary:

;; SDIC $B7A<0<-=q$+$i$N8!:wMQ%i%$%V%i%j!#<!$N4X?t$+$i@.$k!#(B

;;     sdicf-open           - SDIC $B<-=q$N%*!<%W%s(B
;;     sdicf-close          - SDIC $B<-=q$N%/%m!<%:(B
;;     sdicf-search         - SDIC $B<-=q$+$i8!:w(B
;;     sdicf-entry-headword - $B%(%s%H%j$N8+=P$78l$rF@$k(B
;;     sdicf-entry-keywords - $B%(%s%H%j$N8!:w%-!<$N%j%9%H$rF@$k(B
;;     sdicf-entry-text     - $B%(%s%H%j$NK\J8$rF@$k(B

;; $B4X?t(B `sdicf-open' $B$K$h$j<-=q$r%*!<%W%s$9$k!#0z?t$H$7$F<-=q%U%!%$%k$r(B
;; $B;XDj$9$k!#%*%W%7%g%s0z?t(B STRATEGY $B$K$h$C$F8!:w$NJ}<0$r;XDj=PMh$k!#(B
;; $B>JN,$7$?>l9g$O!"<!$N<j=g$K$h$C$F<+F0E*$K7hDj$9$k!#(B
;; 
;; 1) $B<-=q%U%!%$%k$K(B ".ary" $B$rIU2C$7$?%U%!%$%k$,B8:_$9$k$J$i(B `array' $BJ}<0!#(B
;; 2) fgrep $B$b$7$/$O(B grep $B%3%^%s%I$,<B9T%Q%9$KB8:_$9$k$J$i(B `grep' $BJ}<0!#(B
;; 3) $B$I$A$i$G$b$J$1$l$P(B `direct' $BJ}<0!#(B
;; 
;; $B%*!<%W%s$K@.8y$9$l$P<-=q%*%V%8%'%/%H(B(sdic)$B$,JV$5$l$k!#<:GT$9$l$P%(%i!<!#(B

;; $B4X?t(B `sdicf-search' $B$K$h$j<-=q$+$i8!:w$r9T$J$&!#A4J88!:w$r;XDj$7$?>l9g!"(B
;; `array' $BJ}<00J30$G$O8!:w8l$NBgJ8;z>.J8;z$rL5;k$7$F8!:w$9$k!#8+IU$+$C$?(B
;; $B%(%s%H%j!&%*%V%8%'%/%H(B(entry)$B$N%j%9%H$rJV$9!#(B
;; 
;; $B%(%s%H%j$N>pJs$O4X?t(B `sdicf-entry-headword' $B$H(B `sdicf-entry-text' $B$K$h$j(B
;; $BF@$i$l$k!#$=$l$>$l8+=P$78l$HK\J8$rJV$9!#$3$N$H$-JQ?t(B 
;; `sdicf-headword-with-keyword' $B$,(B non-nil $B$G$"$l$P!"8+=P$78l$K%-!<%o!<%I$r(B
;; $BDI2C$9$k!#(B

;; $B4X?t(B `sdicf-close' $B$K$h$j<-=q$r%/%m!<%:$9$k!#(B

;; $B3F<oJQ?t(B:
;; 
;; sdicf-version       - sdicf.el $B$N%P!<%8%g%s(B
;; sdicf-grep-command  - grep $B%3%^%s%I(B
;; sdicf-array-command - array $B%3%^%s%I(B

;; $BCm0U;v9`(B:
;; 
;; * $B4X?t$N0z?t%A%'%C%/$O40A4$G$J$$!#4|BT$5$l$?CM$rEO$9$3$H!#(B
;; 
;; * $BJ8;z%3!<%I$N@_Dj$O0l@Z9T$J$C$F$$$J$$!#I,MW$K1~$8$F(B
;; `coding-system-for-write' $B$d(B `process-coding-system-alist' $B$J$I$r(B
;; $B@_Dj$9$k$+!"$"$k$$$O%f!<%6$K@_Dj$rG$$;$k$3$H!#(B
;; 
;; * GNU Emacs 19.30 $B0J9_$G$"$l$P!"(B`auto-compression-mode' $B$rM-8z$K$9$k(B
;; $B$3$H$G!"(B`direct' $BJ}<0$G05=L$7$?<-=q$rMQ$$$k$3$H$,=PMh$k!#E83+$O<+F0$G(B
;; $B9T$J$o$l$k$?$a!"FCJL$J@_Dj$OI,MW$G$J$$!#(B
;; 
;; * $BB.EY=E;k$N$?$a(B `save-match-data' $B$O0l@ZMQ$$$F$$$J$$!#1F6A$,$"$k$h$&(B
;; $B$G$"$l$PCm0U$9$k$3$H!#(B
;; 
;; * $B<-=q$r%*!<%W%s$9$k$H!":n6HMQ%P%C%U%!$,@8@.$5$l$k$,!"%P%C%U%!$r(B kill
;; $B$7$F$b8!:w;~$K$O2sI|$5$l$k!#(B`array' $BJ}<0$G$O!"%W%m%;%9$,(B kill $B$5$l$F$b(B
;; $B2sI|$9$k!#$3$l$i$NLdBj$G%(%i!<$,5/$3$k$3$H$O$J$$(B($B$O$:(B)$B!#(B

;;; Code:

(provide 'sdicf)
(defconst sdicf-version "0.8")

;;;
;;; Customizable variables
;;;

(defvar sdicf-grep-command
  (catch 'which
    (mapcar (lambda (file)
	      (mapcar (lambda (path)
			(if (file-executable-p (expand-file-name file path))
			    (throw 'which (expand-file-name file path))))
		      exec-path))
	    '("fgrep" "fgrep.exe" "grep" "grep.exe")))
  "*Executable file name of grep")

(defvar sdicf-array-command
  (catch 'which
    (mapcar (lambda (file)
	      (mapcar (lambda (path)
			(if (file-executable-p (expand-file-name file path))
			    (throw 'which (expand-file-name file path))))
		      exec-path))
	    '("array" "array.exe")))
  "*Executable file name of array")

;;;
;;; Internal variables
;;;

(defconst sdicf-strategy-alist
  '((direct sdicf-direct-init sdicf-direct-quit sdicf-direct-search)
    (grep sdicf-grep-init sdicf-grep-quit sdicf-grep-search)
    (array sdicf-array-init sdicf-array-quit sdicf-array-search)))

;;;
;;; Internal functions
;;;

(defsubst sdicf-object-p (sdic)
  "$B<-=q%*%V%8%'%/%H$+$I$&$+8!::$9$k(B"
  (and (vectorp sdic) (eq 'SDIC (aref sdic 0))))

(defsubst sdicf-entry-p (entry)
  (and (stringp entry) (string-match "^<.>\\([^<]+\\)</.>" entry)))

(defsubst sdicf-get-filename (sdic)
  "$B<-=q%*%V%8%'%/%H$+$i%U%!%$%kL>$rF@$k(B"
  (aref sdic 1))

(defsubst sdicf-get-strategy (sdic)
  "$B<-=q%*%V%8%'%/%H$+$i(B strategy $B$rF@$k(B"
  (aref sdic 2))

(defsubst sdicf-get-buffer (sdic)
  "$B<-=q%*%V%8%'%/%H$+$i8!:wMQ%P%C%U%!$rF@$k(B"
  (aref sdic 3))

(defun sdicf-common-init (sdic)
  "$B6&DL$N<-=q=i4|2=%k!<%A%s(B
$B:n6HMQ%P%C%U%!$,B8:_$9$k$3$H$r3NG'$7!"$J$1$l$P?7$7$/@8@.$9$k!#(B"
  (or (buffer-live-p (sdicf-get-buffer sdic))
      (aset sdic 3 (generate-new-buffer (format " *sdic %s*" (sdicf-get-filename sdic))))))

(defun sdicf-search-internal () "\
$B9T$r%A%'%C%/$7!"%(%s%H%j$J$i$P%j%9%H$K2C$($k(B
$B$3$N4X?t$r8F$S=P$9A0$K!"(B(let (entries) ... $B$H$7$?>e$G!"%]%$%s%H$r9T$N(B
$B@hF,$K0\F0$7$F$*$+$J$1$l$P$J$i$J$$!#4X?t$N<B9T8e!"%]%$%s%H$O<!$N9TF,$K(B
$B0\F0$9$k!#(B"
  (if (eq (following-char) ?<)
      (setq entries (cons (buffer-substring (point) (progn (end-of-line) (point))) entries)))
  (forward-char))

(defun sdicf-encode-string (string)
  "STRING $B$r%(%s%3!<%I$9$k(B"
  (let ((start 0) ch list)
    (while (string-match "[&<>\n]" string start)
      (setq ch (aref string (match-beginning 0)))
      (setq list (cons (if (eq ch ?&) "&amp;"
			 (if (eq ch ?<) "&lt;"
			   (if (eq ch ?>) "&gt;" "&lf;")))
		       (cons (substring string start (match-beginning 0))
			     list)))
      (setq start (match-end 0)))
    (apply 'concat (nreverse (cons (substring string start) list)))))

(defun sdicf-decode-string (string)
  "STRING $B$r%G%3!<%I$9$k(B"
  (let ((start 0) list)
    (while (string-match "&\\(\\(lt\\)\\|\\(gt\\)\\|\\(lf\\)\\|\\(amp\\)\\);"
			 string start)
      (setq list (cons (if (match-beginning 2) "<"
			 (if (match-beginning 3) ">"
			   (if (match-beginning 4) "\n" "&")))
		       (cons (substring string start (match-beginning 0))
			     list)))
      (setq start (match-end 0)))
    (apply 'concat (nreverse (cons (substring string start) list)))))


;;;
;;; Strategy `direct'
;;;

(defun sdicf-direct-init (sdic)
  (or (buffer-live-p (sdicf-get-buffer sdic))
      (if (sdicf-common-init sdic)
	  (save-excursion
	    (set-buffer (sdicf-get-buffer sdic))
	    (delete-region (point-min) (point-max))
	    (insert-file-contents (sdicf-get-filename sdic))
	    (while (re-search-forward "^#" nil t)
	      (delete-region (1- (point)) (progn (end-of-line) (min (1+ (point)) (point-max)))))
	    t))))

(defun sdicf-direct-quit (sdic) nil)

(defun sdicf-direct-search (sdic case pattern)
  (sdicf-direct-init sdic)
  (save-excursion
    (set-buffer (sdicf-get-buffer sdic))
    (goto-char (point-min))
    (let ((case-fold-search case) entries)
      (while (search-forward pattern nil t)
	(beginning-of-line)
	(sdicf-search-internal))
      (nreverse entries))))

;;;
;;; Strategy `grep'
;;;

(defalias 'sdicf-grep-init 'sdicf-common-init)

(defun sdicf-grep-quit (sdic) nil)

(defun sdicf-grep-search (sdic case pattern)
  (sdicf-grep-init sdic)
  (save-excursion
    (set-buffer (sdicf-get-buffer sdic))
    (delete-region (point-min) (point-max))
    (call-process sdicf-grep-command nil t nil (if case "-i" "-e") pattern
		  (sdicf-get-filename sdic))
    (goto-char (point-min))
    (let (entries)
      (while (not (eobp))
	(sdicf-search-internal))
      (nreverse entries))))

;;;
;;; Strategy `array'
;;;

(defun sdicf-array-init (sdic)
  (sdicf-common-init sdic)
  (let ((process (get-buffer-process (sdicf-get-buffer sdic))))
    (or (and process (eq (process-status process) 'run))
	(progn
	  (setq process (start-process "array"
				       (sdicf-get-buffer sdic)
				       sdicf-array-command
				       (sdicf-get-filename sdic)))
	  (accept-process-output process)
	  (process-kill-without-query process)
	  (process-send-string process "style line\n")
	  (accept-process-output process)
	  (process-send-string process "order index\n")
	  (accept-process-output process)
	  (set-process-filter process 'sdicf-array-wait-prompt)
	  t))))

(defun sdicf-array-quit (sdic)
  (if (buffer-live-p (sdicf-get-buffer sdic))
      (let ((process (get-buffer-process (sdicf-get-buffer sdic))))
	(and process
	     (eq (process-status process) 'run)
	     (process-send-string process "quit\n")))))

(defun sdicf-array-send-string (proc string) "\
Send STRING as command to process."
  (save-excursion
    (let ((sdicf-array-wait-prompt-flag t))
      (set-buffer (process-buffer proc))
      (goto-char (point-max))
      (set-marker (process-mark proc) (point))
      (process-send-string proc (concat string "\n"))
      (while sdicf-array-wait-prompt-flag (accept-process-output proc))
      )))

(defun sdicf-array-wait-prompt (proc string) "\
Process filter function of Array.
$B%W%m%s%W%H$,8=$l$?$3$H$r8!CN$7$F!"(Bsdicf-array-wait-prompt-flag $B$r(B nil 
$B$K$9$k!#(B"
  (let ((old-buffer (current-buffer)))
    (unwind-protect
	(save-match-data ; Emacs-19.34 $B0J9_$O<+F0E*$K8!:w7k2L$NBTHr(B/$B2sI|$,9T$o$l$k$N$GITMW(B
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
		  (setq sdicf-array-wait-prompt-flag nil))
	      (goto-char start))))
      (set-buffer old-buffer))))

(defun sdicf-array-search (sdic case pattern)
  (sdicf-array-init sdic)
  (save-excursion
    (let ((case-fold-search nil)		; array cannot search case sensitively
	  (process (get-buffer-process (set-buffer (sdicf-get-buffer sdic)))))
      (sdicf-array-send-string process "init")
      (delete-region (point-min) (point-max))
      (sdicf-array-send-string process (concat "search " pattern))
      (forward-line -1)
      (beginning-of-line)
      (if (looking-at "FOUND:")
	  (progn
	    (delete-region (point-min) (point-max))
	    (sdicf-array-send-string process "show")
	    (goto-char (point-min))
	    (let (entries (prev ""))
	      (while (not (eobp))
		(sdicf-search-internal))
	      (delq nil (mapcar (function (lambda (s) (if (string= prev s) nil (setq prev s))))
				(sort entries 'string<))))
	    )))))


;;;
;;; Interface functions
;;;

(defun sdicf-open (filename &optional strategy) "\
SDIC$B7A<0$N<-=q$r%*!<%W%s$9$k(B
FILENAME $B$O<-=q$N%U%!%$%kL>!#(BSTRATEGY $B$O>JN,2DG=$G!"8!:w$r9T$J$&J}<0$r(B
$B;XDj$9$k!#(B

 `direct' - $B<-=q$r%P%C%U%!$KFI$s$GD>@\8!:w!#(B
 `grep'   - grep $B%3%^%s%I$rMQ$$$F8!:w!#(B
 `array'  - SUFARY $B$rMQ$$$?9bB.8!:w!#(B

STRATEGY $B$,>JN,$5$l$?>l9g!"$$$:$l$+$r<+F0E*$KH=Dj$9$k!#(B

$B<-=q%*%V%8%'%/%H$O(B CAR $B$,(B `SDIC' $B$N%Y%/%?$G!"MWAG$H$7$F%U%!%$%kL>$H(B 
strategy $B$H:n6HMQ%P%C%U%!$r;}$D!#(B"
  (let ((sdic (vector 'SDIC
		      (if (file-readable-p (setq filename (expand-file-name filename)))
			  filename
			(error "Cannot open file: %s" filename))
		      (if strategy
			  (if (memq strategy (mapcar 'car sdicf-strategy-alist))
			      strategy
			    (error "Invalid search strategy: %S" strategy))
			(or (and (stringp sdicf-array-command)
				 (file-exists-p (concat filename ".ary"))
				 'array)
			    (and (stringp sdicf-grep-command)
				 'grep)
			    'direct))
		      nil)))
    (and (funcall (nth 1 (assq (sdicf-get-strategy sdic) sdicf-strategy-alist)) sdic)
	 sdic)))

(defun sdicf-close (sdic)
  "SDIC $B7A<0$N<-=q$r%/%m!<%:$9$k(B"
  (or (sdicf-object-p sdic)
      (signal 'wrong-type-argument (list 'sdicf-object-p sdic)))
  (funcall (nth 2 (assq (sdicf-get-strategy sdic) sdicf-strategy-alist)) sdic)
  (if (sdicf-get-buffer sdic) (kill-buffer (sdicf-get-buffer sdic))))

(defun sdicf-search (sdic method word)
  "SDIC $B7A<0$N<-=q$+$i8!:w$r9T$J$&(B
METHOD $B$O8!:wK!$G!"<!$N$$$:$l$+$H$9$k!#(B
 `prefix' - $BA0J}0lCW8!:w(B
 `suffix' - $B8eJ}0lCW8!:w(B
 `exact'  - $B40A40lCW8!:w(B
 `text'   - $BA4J88!:w(B
WORD $B$O8!:w8l!#8+IU$+$C$?%(%s%H%j$N%j%9%H$rJV$9!#(B"
  (or (sdicf-object-p sdic)
      (signal 'wrong-type-argument (list 'sdicf-object-p sdic)))
  (or (stringp word)
      (signal 'wrong-type-argument (list 'stringp word)))
  (funcall (nth 3 (assq (sdicf-get-strategy sdic) sdicf-strategy-alist))
	   sdic
	   (eq method 'text)
	   (cond
	    ((eq method 'prefix) (concat "<K>" (sdicf-encode-string (downcase word))))
	    ((eq method 'suffix) (concat (sdicf-encode-string (downcase word)) "</K>"))
	    ((eq method 'exact) (concat "<K>" (sdicf-encode-string (downcase word)) "</K>"))
	    ((eq method 'text) word)
	    (t (error "Invalid search method: %S" method)))))

(defun sdicf-entry-headword (entry &optional add-keys-to-headword)
  "$B%(%s%H%j(B ENTRY $B$N8+=P$78l$rJV$9!#(B"
  (or (sdicf-entry-p entry)
      (signal 'wrong-type-argument (list 'sdicf-entry-p entry)))
  (let ((head (substring entry (match-beginning 1) (match-end 1))))
    (if add-keys-to-headword
	(let ((start (match-end 0)) keys)
	  (while (string-match "<.>\\([^<]+\\)</.>" entry start)
	    (setq keys (cons (format "[%s]" (substring entry (match-beginning 1) (match-end 1)))
			     keys)
		  start (match-end 0)))
	  (setq head (apply 'concat head " " (nreverse keys)))))
    (sdicf-decode-string head)))

(defun sdicf-entry-text (entry)
  "$B%(%s%H%j(B ENTRY $B$NK\J8$rJV$9!#(B"
  (or (stringp entry)
      (signal 'wrong-type-argument (list 'stringp entry)))
  (sdicf-decode-string (substring entry (string-match "[^>]*$" entry))))


;;; sdicf.el ends here
