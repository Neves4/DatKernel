clear																		# Start Compilation
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=~/android/kernel/toolchains/archi5.2/bin/arm-eabi-

cd ~/android/kernel/DatKernel/												# Back to working folder

make datkernel_defconfig													# make config

time make -j1