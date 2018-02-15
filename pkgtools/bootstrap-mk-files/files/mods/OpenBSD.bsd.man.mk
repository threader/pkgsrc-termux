#	$NetBSD: OpenBSD.bsd.man.mk,v 1.2 2012/04/15 13:03:11 obache Exp $
#	@(#)bsd.man.mk	8.1 (Berkeley) 6/8/93

.if !target(__initialized__)
__initialized__:
.if exists(${.CURDIR}/../Makefile.inc)
.include "${.CURDIR}/../Makefile.inc"
.endif
.include <bsd.own.mk>
.include <bsd.obj.mk>
.include <bsd.depall.mk>
.MAIN:		all
.endif

.PHONY:		catinstall maninstall catpages manpages catlinks manlinks cleanman html installhtml cleanhtml
.if ${MKMAN} != "no"
realinstall:	${MANINSTALL}
.endif
cleandir: cleanman

HTMLDIR?=	${DESTDIR}/usr/share/man

MANTARGET?=	cat
MANDOC?=	mandoc -Tascii


.SUFFIXES: .1 .2 .3 .3p .4 .5 .6 .7 .8 .9 \
	   .cat1 .cat2 .cat3 .cat4 .cat5 .cat6 .cat7 .cat8 .cat9 \
	   .html1 .html2 .html3 .html4 .html5 .html6 .html7 .html8 .html9

.9.cat9 .8.cat8 .7.cat7 .6.cat6 .5.cat5 .4.cat4 3p.cat3p .3.cat3 .2.cat2 .1.cat1:
	@echo "${MANDOC} ${.IMPSRC} > ${.TARGET}"
	@${MANDOC} ${.IMPSRC} > ${.TARGET} || \
	 (rm -f ${.TARGET}; false)

.9.html9 .8.html8 .7.html7 .6.html6 .5.html5 .4.html4 .3p.html3p .3.html3 .2.html2 .1.html1:
	@echo "${MANDOC} -Thtml ${.IMPSRC} > ${.TARGET}"
	@${MANDOC} -Thtml ${.IMPSRC} > ${.TARGET} || \
	 (rm -f ${.TARGET}; false)

.if defined(MAN) && !empty(MAN)
MANPAGES=	${MAN}
CATPAGES=	${MANPAGES:C/(.*).([1-9]p?)/\1.cat\2/}
.NOPATH:	${CATPAGES}
.if !defined(NOHTML)
HTMLPAGES=	${MANPAGES:C/(.*).([1-9]p?)/\1.html\2/}
.endif
.endif

MINSTALL=	${INSTALL} ${RENAME} ${PRESERVE} ${COPY} ${INSTPRIV} \
		    -o ${MANOWN} -g ${MANGRP} -m ${MANMODE}

.if defined(MANZ)
# chown and chmod are done afterward automatically
MCOMPRESS=	gzip -cf
MCOMPRESSSUFFIX= .gz
.endif

catinstall: catlinks
maninstall: manlinks

__installpage: .USE
.if defined(MCOMPRESS) && !empty(MCOMPRESS)
	@rm -f ${.TARGET}
	${MCOMPRESS} ${.ALLSRC} > ${.TARGET}
	@chown ${MANOWN}:${MANGRP} ${.TARGET}
	@chmod ${MANMODE} ${.TARGET}
.else
	@cmp -s ${.ALLSRC} ${.TARGET} > /dev/null 2>&1 || \
	    (echo "${MINSTALL} ${.ALLSRC} ${.TARGET}" && \
	     ${MINSTALL} ${.ALLSRC} ${.TARGET})
.endif


# Rules for cat'ed man page installation
.if defined(CATPAGES) && !empty(CATPAGES) && ${MKCATPAGES} != "no"
catpages:: ${CATPAGES:@P@${DESTDIR}${MANDIR}/${P:T:E}${MANSUBDIR}/${P:T:R}.0${MCOMPRESSSUFFIX}@}
.PRECIOUS: ${CATPAGES:@P@${DESTDIR}${MANDIR}/${P:T:E}${MANSUBDIR}/${P:T:R}.0${MCOMPRESSSUFFIX}@}
.if !defined(UPDATE)
.PHONY: ${CATPAGES:@P@${DESTDIR}${MANDIR}/${P:T:E}${MANSUBDIR}/${P:T:R}.0${MCOMPRESSSUFFIX}@}
.endif

.   for P in ${CATPAGES:O:u}
.	if !defined(BUILD) && !make(all) && !make(${P})
${DESTDIR}${MANDIR}/${P:T:E}${MANSUBDIR}/${P:T:R}.0${MCOMPRESSSUFFIX}: .MADE
.	endif
${DESTDIR}${MANDIR}/${P:T:E}${MANSUBDIR}/${P:T:R}.0${MCOMPRESSSUFFIX}: ${P} __installpage
.   endfor
.else
catpages::
.endif

# Rules for source page installation
.if defined(MANPAGES) && !empty(MANPAGES)
manpages:: ${MANPAGES:@P@${DESTDIR}${MANDIR}/man${P:T:E}${MANSUBDIR}/${P}${MCOMPRESSSUFFIX}@}
.PRECIOUS: ${MANPAGES:@P@${DESTDIR}${MANDIR}/man${P:T:E}${MANSUBDIR}/${P}${MCOMPRESSSUFFIX}@}
.if !defined(UPDATE)
.PHONY: ${MANPAGES:@P@${DESTDIR}${MANDIR}/man${P:T:E}${MANSUBDIR}/${P}${MCOMPRESSSUFFIX}@}
.endif

.   for P in ${MANPAGES:O:u}
${DESTDIR}${MANDIR}/man${P:T:E}${MANSUBDIR}/${P}${MCOMPRESSSUFFIX}: ${P} __installpage
.   endfor
.else
manpages::
.endif

.if ${MKCATPAGES} != "no"
catlinks: catpages
.if defined(MLINKS) && !empty(MLINKS)
	@set ${MLINKS}; \
	while test $$# -ge 2; do \
		name=$$1; \
		shift; \
		dir=${DESTDIR}${MANDIR}/cat$${name##*.}; \
		l=$${dir}${MANSUBDIR}/$${name%.*}.0${MCOMPRESSSUFFIX}; \
		name=$$1; \
		shift; \
		dir=${DESTDIR}${MANDIR}/cat$${name##*.}; \
		t=$${dir}${MANSUBDIR}/$${name%.*}.0${MCOMPRESSSUFFIX}; \
		if test $$l -nt $$t -o ! -f $$t; then \
			echo $$t -\> $$l; \
			ln -f $$l $$t; \
		fi; \
	done
.endif
.else
catlinks:
.endif

manlinks: manpages
.if defined(MLINKS) && !empty(MLINKS)
	@set ${MLINKS}; \
	while test $$# -ge 2; do \
		name=$$1; \
		shift; \
		dir=${DESTDIR}${MANDIR}/man$${name##*.}; \
		l=$${dir}${MANSUBDIR}/$${name}${MCOMPRESSSUFFIX}; \
		name=$$1; \
		shift; \
		dir=${DESTDIR}${MANDIR}/man$${name##*.}; \
		t=$${dir}${MANSUBDIR}/$${name}${MCOMPRESSSUFFIX}; \
		if test $$l -nt $$t -o ! -f $$t; then \
			echo $$t -\> $$l; \
			ln -f $$l $$t; \
		fi; \
	done
.endif

# PS rules
ps: ${PSPAGES}

.if defined(HTMLPAGES) && !empty(HTMLPAGES)
.for P in ${HTMLPAGES:O:u} 
${HTMLDIR}/${P:T:E}/${P:T:R}.html: ${P}
	${MINSTALL} ${.ALLSRC} ${.TARGET}
.endfor
.endif
installhtml: ${HTMLPAGES:@P@${HTMLDIR}/${P:T:E}/${P:T:R}.html@}

cleanhtml:
.if defined(HTMLPAGES) && !empty(HTMLPAGES)
	rm -f ${HTMLPAGES}
.endif


.if defined(CATPAGES)
.if ${MKCATPAGES} != "no" && ${MKMAN} != "no"
realall: ${CATPAGES}
.else
realall:
.endif

cleanman:
	rm -f ${CATPAGES}
.else
cleanman:
.endif

# Make sure all of the standard targets are defined, even if they do nothing.
clean depend includes lint regress tags:
