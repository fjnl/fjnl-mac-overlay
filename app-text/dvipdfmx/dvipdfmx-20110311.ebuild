# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvipdfmx/dvipdfmx-20110311.ebuild,v 1.2 2011/08/07 17:49:07 armin76 Exp $

EAPI=2
inherit autotools eutils texlive-common

DESCRIPTION="DVI to PDF translator with multi-byte character support"
HOMEPAGE="http://project.ktug.or.kr/dvipdfmx/"
SRC_URI="http://project.ktug.or.kr/${PN}/snapshot/latest/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86-macos ~x64-macos"
IUSE=""

DEPEND="app-text/libpaper
	media-libs/libpng
	sys-libs/zlib
	virtual/tex-base
	app-text/libpaper"
RDEPEND="${DEPEND}
	>=app-text/poppler-0.12.3-r3
	app-text/poppler-data"

src_prepare() {
	epatch "${FILESDIR}"/20090708-fix_file_collisions.patch
	eautoreconf
}

src_install() {
	# Override dvipdfmx.cfg default installation location so that it is easy to
	# modify it and it gets config protected. Symlink it from the old location.
	emake configdatadir="${EPREFIX}/etc/texmf/dvipdfmx" DESTDIR="${D}" install || die
	dosym /etc/texmf/dvipdfmx/dvipdfmx.cfg /usr/share/texmf/dvipdfmx/dvipdfmx.cfg || die

	# Symlink poppler-data cMap, bug #201258
	dosym /usr/share/poppler/cMap /usr/share/texmf/fonts/cmap/cMap || die
	dodoc AUTHORS ChangeLog README || die

	# Remove symlink conflicting with app-text/dvipdfm (bug #295235)
	rm "${ED}"/usr/bin/ebb
}

pkg_postinst() {
	etexmf-update
}

pkg_postrm() {
	etexmf-update
}
