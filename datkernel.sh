# Start Compilation
clear
echo "Giving executing permissions to clean script"
echo "==============================================="
echo -e ""
chmod +x clean.sh
./clean.sh
echo -e ""
echo -e ""
read -p "Cleaning done Enter to proceed ..."
echo -e "==============================================="
echo -e ""
clear

read -p "Initialize Toolchain by pressing ENTER ..."
echo -e "==============================================="

# Show stuff to compiler

export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=~/android/kernel/toolchains/linaro4.9-2015/bin/arm-eabi-

echo "Done"
echo "==============================================="
echo -e ""

# make config
make datkernel_defconfig

echo -e ""
echo "==============================================="
echo "Done"
echo "==============================================="
echo -e ""

read -p "Press Enter to build Kernel ..."
echo "==============================================="
echo -e ""

make -j4
