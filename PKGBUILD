# Maintainer: Shikoba Kage <darkfeather@aninix.net>
pkgname=theraven
pkgver=0.1
pkgrel=1
epoch=
pkgdesc="AniNIX::TheRaven \\\\ IRC Bot"
arch=("x86_64")
url="https://aninix.net/foundation/TheRaven"
license=('custom')
groups=()
depends=('mono>=5.0.0' 'curl' 'grep' 'bash>=4.4' 'git>=2.13' 'pushbullet-cli' 'lynx' 'wget')
makedepends=('make>=4.2')
checkdepends=()
optdepends=()
provides=('theraven')
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=()
noextract=()
md5sums=()
validpgpkeys=()

prepare() {
    git pull
}

build() {
    make -C ..
}

check() {
    # We're not using test because it makes an actual connection. That case is useful but not quite as a regression the way PKGBUILD needs.
	ls -l ../raven.mono
}

package() {
    export pkgdir="${pkgdir}"
	make -C .. install
    install -D -m644 ../LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
