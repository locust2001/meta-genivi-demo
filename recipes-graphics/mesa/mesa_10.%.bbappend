SECTION = "Graphics & UI Framework/Hardware Adaptation"

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
