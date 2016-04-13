FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

USE_FAYTECH_MONITOR ?= "0"

SRC_URI_append = "\
    file://rpi2-defconfig.patch \
    ${@base_conditional('USE_FAYTECH_MONITOR', '1', 'file://0001-faytech-fix-rpi.patch', d)} \
"

CMDLINE_append = " cma=256M usbhid.mousepoll=0"

KERNEL_MODULE_AUTOLOAD += "snd-bcm2835"

RDEPENDS_${PN} += "kernel-module-snd-bcm2835"
PACKAGES += "kernel-module-snd-bcm2835"
