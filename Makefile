#--------------------------------------------------------------------
# Step 1.
#     �ץ�������Τ򥤥󥹥ȡ��뤹��ǥ��쥯�ȥ�� LISPDIR �ˡ�����
#     �򥤥󥹥ȡ��뤹��ǥ��쥯�ȥ�� DICTDIR �˻��ꤷ�Ʋ��������ޤ���
#     Info �򥤥󥹥ȡ��뤹��ǥ��쥯�ȥ�� INFODIR �˻��ꤷ�Ʋ�������
PREFIX  = /usr/local
LISPDIR = $(PREFIX)/lib/mule/site-lisp
INFODIR = $(PREFIX)/info
DICTDIR = $(LISPDIR)



#--------------------------------------------------------------------
# Step 2.
#     sdic �����Ѥ��� Emacs ��̾������ꤷ�Ʋ������������ǻ��ꤵ�줿 
#     Emacs ����*.el ��Х��ȥ���ѥ��뤹�뤿��˻Ȥ��ޤ���
# EMACS = emacs
# EMACS = xemacs
EMACS = mule



#--------------------------------------------------------------------
# Step 3.
#     �ǥե���Ȥǻ��Ѥ��뼭�����ꤷ�Ʋ����������¼���Ȥ������Ѥ���
#     �����̾���� EIWA_DICTIONARY �ˡ��±Ѽ���Ȥ������Ѥ��뼭��� 
#     WAEI_DICTIONARY �˻��ꤷ�Ʋ�������
#
# (1) ���¼����GENE95�����Ȥ���EDICT������±Ѽ���Ȥ��ƻȤ���� (�侩)
#       gene95.lzh �ޤ��� gene95.tar.gz �� edict.gz �򡢤��� Makefile 
#       ��Ʊ���ǥ��쥯�ȥ���֤��Ƥ��� make install ���Ʋ��������ܺ٤�
#       �Ĥ��Ƥ� INSTALL �򻲾ȡ�
EIWA_DICTIONARY = gene.sdic
WAEI_DICTIONARY = jedict.sdic
#
# (2) GENE95�������¼�����±Ѽ����ξ���˻Ȥ����
#       gene95.lzh �ޤ��� gene95.tar.gz �򡢤��� Makefile ��Ʊ���ǥ���
#       ���ȥ���֤��Ƥ��顢make install ���Ʋ�������
# EIWA_DICTIONARY = gene.sdic
# WAEI_DICTIONARY = jgene.sdic
#
# (3) EDICT�������¼�����±Ѽ����ξ���˻Ȥ����
#       edict.gz �򡢤��� Makefile ��Ʊ���ǥ��쥯�ȥ���֤��Ƥ��顢
#       make install ���Ʋ�������
# EIWA_DICTIONARY = ejdict.sdic
# WAEI_DICTIONARY = jedict.sdic
#
# (4) GENE95�����COMPAT�������Ѵ����ơ����¼�����±Ѽ����ξ�������Ѥ�����
#       gene95.lzh �ޤ��� gene95.tar.gz �򡢤��� Makefile ��Ʊ���ǥ���
#       ���ȥ���֤��Ƥ��顢make install ���Ʋ�������
# EIWA_DICTIONARY = gene.dic
# WAEI_DICTIONARY = jgene.dic
#
# (5) �ֱѼ�Ϻ�פ����Ѥ�����
#       �ֱѼ�Ϻ����°�����Ƥμ���ե�����򤳤� Makefile ��Ʊ���ǥ���
#       ���ȥ�˥��ԡ����Ƥ��顢make install ���Ʋ��������ܺ٤ˤĤ���
#       �� INSTALL �򻲾ȡ�
# EIWA_DICTIONARY = eijirou.sdic
# WAEI_DICTIONARY =
#
# (6) �ǥե���Ȥǻ��Ѥ��뼭��̵�����
#       ��ʸ�������ꤷ�Ʋ�������
# EIWA_DICTIONARY =
# WAEI_DICTIONARY =



#--------------------------------------------------------------------
# Step 4. (optional)
#     �Ƽ�ġ����̾������ꤷ�Ʋ�������
#
#     ���λ���� UNIX �Ķ��ǥ��󥹥ȡ��뤹�뤿�������Ǥ���
NKF  = nkf -S -e
PERL = perl
GZIP = gzip -dc
BZIP = bzip2 -dc
CP   = cp -f
#
#     SunOS �ʤɡ�-f ���ץ����Τʤ� cp ��ȤäƤ�����ϡ�������
#     �Ƥ���������
# CP = cp
#     
#     Windows �Ķ��ǥ��󥹥ȡ��뤹����ϡ�Ʊ���ε�ǽ����ĥ��ޥ�ɤ�
#     ̾���򡢳�ĥ�Ҥ�ޤ�ƻ��ꤷ�Ʋ�������
# NKF  = nkf.exe -S -e
# PERL = perl.exe
# GZIP = gzip.exe -dc
# CP   = copy



#--------------------------------------------------------------------
# Step 5.
#     Makefile ���Խ��Ϥ���ǽ���Ǥ����ʲ��Τ����줫��¹Ԥ��Ʋ�������
#
#     �ץ����ȼ�������ƥ��󥹥ȡ��뤹����
#         make install
#
#     �ץ����Τߤ򥤥󥹥ȡ��뤹����
#         make install-lisp
#
#     Info �Τߤ򥤥󥹥ȡ��뤹����
#         make install-info
#
#     ����Τߤ򥤥󥹥ȡ��뤹����
#         make install-dic



#--------------------------------------------------------------------
#     ����   ( �������鲼�ϡ��̾���Խ�����ɬ�פϤ���ޤ��� )

SOURCES    = sdic.el sdic-sgml.el sdic-grep.el sdic-array.el sdic-compat.el \
		sdic-gene.el stem.el
TARGETS    = sdic.elc sdic-sgml.elc sdic-grep.elc sdic-array.elc sdic-compat.elc \
		sdic-gene.elc stem.elc
DICTIONARY = $(EIWA_DICTIONARY) $(WAEI_DICTIONARY)

###CUT BEGIN

# ��ʬ�λȤäƤ��� Makefile �Υ롼�뤬����ˤʤ�Τǡ�CUT BEGIN ���� 
# CUT END �ޤǤ��ϰϤ������� Makefile ��Ĥ��ä����ۤ��롣

VERSION = `perl -ne 'next unless /\(defconst sdic-version "([^"]+)"\)/;print "$$1";last;' sdic.el.in`
DIR     = sdic-$(VERSION)
WWW     = $(HOME)/usr/doc/homepage/sdic

# �����ѥѥå�������ź�դ���ե�����Υꥹ�� (Makefile �ʳ�)
SCRIPTS = gene.perl eijirou.perl jgene.perl edict.perl
FILES   = README INSTALL COPYING sdic.texi \
		sdic.el.in sdic-sgml.el sdic-grep.el sdic-array.el sdic-compat.el sdic-gene.el \
		stem.el lp.el sample.emacs.in $(SCRIPTS)

homepage: archive
	@echo -n '�ۡ���ڡ����򹹿����ޤ���? '
	@read YN ; test "$$YN" = y
	@file=$(DIR).tar.gz ;\
	cp -f $$file $(WWW) ;\
	cd $(WWW) ;\
	echo �������ޤ�����
	@touch homepage

archive: $(FILES) Makefile
	@dir=$(DIR) ;\
	echo �����ѥѥå����� $$dir.tar.gz ������ ;\
	rm -rf $$dir ;\
	mkdir $$dir ;\
	sed -e '/^###CUT BEGIN/,/^###CUT END/d' -e 's/^_clean:/clean:/' Makefile >$$dir/Makefile ;\
	cp -fp $(FILES) $$dir ;\
	tar czvf $$dir.tar.gz $$dir
	@touch archive

sdic.el.in: sdic.el.orig
	@echo �����ѥ����� sdic.el.in ������ ;\
	perl -p -e 's!"~/usr/dict/gene.sdic"!"%%EIWA_DICTIONARY%%"!;' \
		-e 's!"~/usr/dict/edict.sdic"!"%%WAEI_DICTIONARY%%"!;' sdic.el.orig >sdic.el.in

info: sdic.info sdic_toc.html
	cp -fp sdic*.html $(WWW)
	cp -fp sdic.info $(HOME)/usr/info

sdic_toc.html: texi2html sdic.texi
	perl texi2html -split_node sdic.texi

clean: _clean
	dir=$(DIR) ;\
	rm -rf $$dir $$dir.tar.gz sdic.el.in archive homepage sdic*.html

version:
	@echo $(DIR)

# �Ƽ� Emacsen ��Ȥä�����˥Х��ȥ���ѥ���Ǥ��뤫�ƥ��Ȥ���롼��
build: archive
	cd $(DIR) && \
	$(MAKE) compile clean && \
	$(MAKE) EMACS=mule-19.28 compile clean && \
	$(MAKE) EMACS=emacs compile clean && \
	$(MAKE) EMACS=xemacs compile clean

###CUT END

.SUFFIXES:
.SUFFIXES: .el .elc

.el.elc:
	$(EMACS) -batch -q -l ./lp.el -f batch-byte-compile $<


## ���̤˻��Ѥ���롼��
default:
	@echo "Edit this makefile first." ;\
	echo 'Type "make install" to install all' ;\
	echo 'Type "make install-lisp" to install lisp programs' ;\
	echo 'Type "make install-info" to install sdic.info' ;\
	echo 'Type "make install-dic" to install $(DICTIONARY)'

install: install-lisp install-info install-dic sample.emacs
	@echo 'Add configuration for sdic-mode to "~/.emacs"' ;\
	echo 'There is a sample of configuration in "sample.emacs"'

install-lisp: compile
	$(CP) $(SOURCES) $(TARGETS) $(LISPDIR)

install-info: sdic.info
	$(CP) sdic.info $(INFODIR)

install-dic: $(DICTIONARY)
	$(CP) $(DICTIONARY) $(DICTDIR)


## ������������뤿��Υ롼��
gene.dic: gene.perl gene.txt
	$(NKF) gene.txt | $(PERL) gene.perl --compat > gene.dic

gene.sdic: gene.perl gene.txt
	$(NKF) gene.txt | $(PERL) gene.perl > gene.sdic

jgene.dic: jgene.perl gene.dic
	$(PERL) jgene.perl --compat < gene.dic > jgene.dic

jgene.sdic: jgene.dic
	$(PERL) jgene.perl < gene.dic > jgene.sdic

gene.txt:
	test -f gene95.lzh -o -f gene95.tar.gz -o -f gene95.tar.bz2
	if [ -f gene95.lzh ]; then \
		lha x gene95.lzh gene.txt; \
	elif [ -f gene95.tar.gz ]; then \
		$(GZIP) gene95.tar.gz | tar xf - gene.txt; \
	else \
		$(BZIP) gene95.tar.bz2 | tar xf - gene.txt; \
	fi

eijirou.dic: eijirou.perl
	$(NKF) *.txt | $(PERL) eijirou.perl --compat >eijirou.dic

eijirou.sdic: eijirou.perl
	$(NKF) *.txt | $(PERL) eijirou.perl >eijirou.sdic

ejdict.sdic: edict edict.perl
	$(PERL) edict.perl --reverse edict >ejdict.sdic

jedict.sdic: edict edict.perl
	$(PERL) edict.perl edict >jedict.sdic

edict: edict.gz
	$(GZIP) edict.gz >edict


## ����ץ�����ե��������������롼��
sample.emacs: sample.emacs.in Makefile
	$(PERL) -p -e 's#%%LISPDIR%%#$(LISPDIR)#' sample.emacs.in >sample.emacs


## ���󥹥ȡ���ǥ��쥯�ȥ�˱����� *.el ��������롼��
sdic.el: sdic.el.in Makefile
	cp sdic.el.in sdic.el
	if [ $(EIWA_DICTIONARY)z != z ]; then \
	$(PERL) -pi~ -e 's#%%EIWA_DICTIONARY%%#$(DICTDIR)/$(EIWA_DICTIONARY)#;' sdic.el ; fi
	if [ $(WAEI_DICTIONARY)z != z ]; then \
	$(PERL) -pi~ -e 's#%%WAEI_DICTIONARY%%#$(DICTDIR)/$(WAEI_DICTIONARY)#;' sdic.el ; fi


## *.el ��Х��ȥ���ѥ��뤹��롼��
compile: $(TARGETS)

sdic.info: sdic.texi
	$(EMACS) -batch -q -l texinfmt -f batch-texinfo-format $?

_clean:
	rm -f *~ *.elc sdic.el sdic.info sample.emacs

distclean: clean
	rm -f gene.dic gene.sdic jgene.dic jgene.sdic edict.sdic eijirou.sdic

config: sample.emacs
	@echo -n "������ $$HOME/.emacs ��񤭴����ޤ���[yes/no] " ;\
	read YN ;\
	test "$$YN" = yes
	@if [ -f "$$HOME/.emacs" ] ;\
	then \
		echo "���� $$HOME/.emacs �� $$HOME/.emacs.orig �Ȥ�����¸���ޤ�" ;\
		cp -p $$HOME/.emacs $$HOME/.emacs.orig ;\
	fi
	( echo ; cat sample.emacs )>>$$HOME/.emacs
