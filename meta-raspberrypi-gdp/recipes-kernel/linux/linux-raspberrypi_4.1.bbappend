LINUX_VERSION = "4.1.0"

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRCREV = "07009cab090ade3dd180e8a55d590b1a00072eed"
SRC_URI = "\
    git://git.baserock.org/delta/linux.git;protocol=git;branch=baserock/pedroalvarez/rpi2-drm-rebased-on-vc4-kms-v3d-rpi2 \
    file://0001-rpi2-setup.patch \
    file://0002-drm-vc4-Use-the-fbdev_cma-helpers.patch \
    file://0003-drm-vc4-Allow-vblank-to-be-disabled.patch \
    file://0004-Add-rpi-ft5406-overlay.dts.patch \
    file://rpi2-defconfig.patch \
    file://HULK_SMASH.patch \
    file://defconfig \
"

CMDLINE_append = " cma=256M usbhid.mousepoll=0"

KERNEL_MODULE_AUTOLOAD += "snd-bcm2835"

RDEPENDS_${PN} += "kernel-module-snd-bcm2835"
PACKAGES += "kernel-module-snd-bcm2835"
