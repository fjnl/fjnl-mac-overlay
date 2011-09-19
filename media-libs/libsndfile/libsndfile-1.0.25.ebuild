# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsndfile/libsndfile-1.0.25.ebuild,v 1.6 2011/09/12 14:43:23 xarthisius Exp $

EAPI=4
inherit eutils autotools

MY_P=${P/_pre/pre}

DESCRIPTION="A C library for reading and writing files containing sampled sound"
HOMEPAGE="http://www.mega-nerd.com/libsndfile"
if [[ "${MY_P}" == "${P}" ]]; then
	SRC_URI="http://www.mega-nerd.com/libsndfile/files/${P}.tar.gz"
else
	SRC_URI="http://www.mega-nerd.com/tmp/${MY_P}b.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~x86-macos ~x64-macos"
IUSE="alsa minimal sqlite static-libs"

RDEPEND="!minimal? ( >=media-libs/flac-1.2.1
		>=media-libs/libogg-1.1.3
		>=media-libs/libvorbis-1.2.3 )
	alsa? ( media-libs/alsa-lib )
	sqlite? ( >=dev-db/sqlite-3.2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e "s/noinst_PROGRAMS/check_PROGRAMS/" "${S}/tests/Makefile.am" \
		"${S}/examples/Makefile.am" || die "sed failed"

	epatch "${FILESDIR}"/${PN}-1.0.17-regtests-need-sqlite.patch

	AT_M4DIR=M4 eautoreconf
	epunt_cxx
}

src_configure() {
	econf $(use_enable sqlite) \
		$(use_enable static-libs static) \
		$(use_enable alsa) \
		$(use_enable !minimal external-libs) \
		htmldocdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--disable-octave \
		--disable-gcc-werror \
		--disable-gcc-pipe
}

src_install() {
	emake DESTDIR="${D}" htmldocdir="${EPREFIX}/usr/share/doc/${PF}/html" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
