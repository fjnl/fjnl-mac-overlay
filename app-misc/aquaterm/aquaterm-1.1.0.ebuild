# Distributed under the terms of the GNU General Public License v2

EAPI="3"

inherit git-2 eutils

DESCRIPTION=""
HOMEPAGE="http://sourceforge.net/projects/aquaterm/"
SRC_URI=""
EGIT_REPO_URI="git://aquaterm.git.sourceforge.net/gitroot/aquaterm/aquaterm"
EGIT_COMMIT="844223a4f350aaf0642aea1ea6d3665ad79b34ed"

SLOT="0"
KEYWORDS="~x86-macos ~amd64-macos"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	[[ "$CHOST" == *-darwin9 || "$CHOST" == *-darwin10 || "$CHOST" == *-darwin11 ]] || eerror "AquaTerm does not support ${CHOST}."

	cd "$S"
	epatch "${FILESDIR}/increase-optimization-level.patch" || die
}

src_compile() {
	local arch sdk

	if [[ "$CHOST" == x86_64-* ]]; then
		arch="x86_64"
	else
		arch="i386"
	fi

	if [[ "$CHOST" == *-darwin9 ]]; then
		sdk="MacOSX10.5.sdk"
	elif [[ "$CHOST" == *-darwin10 ]]; then
		sdk="MacOSX10.6.sdk"
	elif [[ "$CHOST" == *-darwin11 ]]; then
		sdk="MacOSX10.7.sdk"
	fi

	cd "${WORKDIR}/${P}" && \
		/usr/bin/xcodebuild \
		-arch $arch \
		-sdk "/Developer/SDKs/${sdk}" \
		-configuration Deployment \
		USER_APPS_DIR="${EPREFIX}/Applications" \
		LOCAL_LIBRARY_DIR="${EPREFIX}/Library"
}

src_install() {
	insinto "/Library/Frameworks"
	doins -r "${S}/build/Deployment/AquaTerm.framework"
	chmod +x "${ED}/Library/Frameworks/AquaTerm.framework/AquaTerm"
	chmod +x "${ED}/Library/Frameworks/AquaTerm.framework/Versions/A/AquaTerm"

	insinto "/Applications"
	doins -r "${S}/build/Deployment/AquaTerm.app"
	chmod +x "${ED}/Applications/AquaTerm.app/Contents/MacOS/AquaTerm"
}
