DEFAULT_PREFERENCE = "0"

DEPENDS += "python-mako-native libomxil wayland"

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI = " \
        git://anongit.freedesktop.org/mesa/mesa.git;branch=master \
        file://nir_include_dirs.patch \
        "
SRCREV = "1762568fd39b9be42d963d335e36daea25df7044"
S = "${WORKDIR}/git"
PV="git+${SRCPV}"

EXTRA_OECONF = "--enable-gles1 --enable-gles2 --enable-gbm --enable-glx-tls --disable-glx"

#because we cannot rely on the fact that all apps will use pkgconfig,
#make eglplatform.h independent of MESA_EGL_NO_X11_HEADER
do_install_append() {
    sed -i -e 's/^#if defined(MESA_EGL_NO_X11_HEADERS)/#if ${@bb.utils.contains('DISTRO_FEATURES', 'x11', '0', '1', d)}/' ${D}${includedir}/EGL/eglplatform.h
}

PACKAGECONFIG[gallium-egl]  = "--enable-gallium-egl, --disable-gallium-egl"
PACKAGECONFIG[gallium-gbm]  = "--enable-gallium-gbm, --disable-gallium-gbm"
PACKAGECONFIG[gallium-llvm] = "--enable-gallium-llvm --with-llvm-shared-libs, --disable-gallium-llvm, llvm${MESA_LLVM_RELEASE} \
                               ${@'elfutils' if ${GALLIUMDRIVERS_LLVM33_ENABLED} else ''}"

FILES_libegl-gallium = "${libdir}/egl/egl_gallium.so*"
FILES_libgbm-gallium = "${libdir}/gbm/gbm_gallium_drm.so*"

# Those packages actually don't exist on mesa 10.6
ALLOW_EMPTY_libgbm-gallium = "1"
ALLOW_EMPTY_libegl-gallium = "1"
ALLOW_EMPTY_mesa-driver-pipe-swrast = "1"
ALLOW_EMPTY_mesa-driver-pipe-vmwgfx = "1"

PACKAGES =+ "mesa-driver-pipe-swrast mesa-driver-pipe-vmwgfx"

# Enabling gallium-llvm creates a dependency on llvm.
# meta-openembedded provides that.

PACKAGECONFIG_append = " gallium"
PACKAGECONFIG_append = " gallium-egl"
PACKAGECONFIG_append = " gallium-gbm"
PACKAGECONFIG_append = " gallium-llvm"

DRIDRIVERSTIZEN = "swrast"
PACKAGECONFIG[dri] = "--enable-dri --with-dri-drivers=${DRIDRIVERSTIZEN}, --disable-dri, dri2proto libdrm"

GALLIUMDRIVERSTIZEN = "swrast"
GALLIUMDRIVERSTIZEN_append_raspberrypi2 = ",vc4"

GALLIUMDRIVERSTIZEN_LLVM33 = ""
GALLIUMDRIVERSTIZEN_LLVM33_ENABLED = "${@base_version_less_or_equal('MESA_LLVM_RELEASE', '3.2', False, len('${GALLIUMDRIVERSTIZEN_LLVM33}') > 0, d)}"
GALLIUMDRIVERSTIZEN_LLVM = "svga,"
# keep --with-gallium-drivers separate, because when only one of gallium versions is enabled, other 2 were adding --without-gallium-drivers
PACKAGECONFIG[gallium]      = "--with-gallium-drivers=${GALLIUMDRIVERSTIZEN}, --without-gallium-drivers"
