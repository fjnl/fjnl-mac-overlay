# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/msgpack/msgpack-0.5.6.ebuild,v 1.1 2011/05/10 14:16:23 matsuu Exp $

EAPI="3"

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="http://msgpack.org/"
SRC_URI="http://msgpack.org/releases/cpp/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos ~x64-macos"
IUSE="static-libs test"

DEPEND="test? ( dev-util/gtest )"
RDEPEND=""

src_configure() {
	econf $(use_enable static-libs static) || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -exec rm {} +
	fi
	dodoc AUTHORS ChangeLog NEWS README || die
}
