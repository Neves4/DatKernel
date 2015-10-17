clear										# Start Compilation

echo "==============================================="
echo "Giving executing permissions to clean script"
echo "==============================================="

if [ -a arch/arm/boot/zImage ]; 						# If it's already build, clean everything
then

./clean.sh
echo -e ""
echo -e "==============================================="
echo -e "Cleaning done"
echo -e "==============================================="
echo -e ""
clear

else										#If not, continue

echo -e "==============================================="
echo -e "Initializing Toolchain"
echo -e "==============================================="

fi 										# Show stuff to compiler

export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=~/android/kernel/toolchains/linaro4.9-2015/bin/arm-eabi-

echo "Done"
echo "==============================================="
echo -e ""

make datkernel_defconfig							# make config

echo -e ""
echo "==============================================="
echo "Done"
echo "==============================================="
echo -e ""

echo -e "Build Kernel ..."
echo "==============================================="
echo -e ""
clear

time make -j4

echo "==============================================="
echo 'copying files to ./out'
echo "==============================================="
echo ''

mkdir -p out/modules                                                       	# make dirs for zImage and modules
cp arch/arm/boot/zImage out/zImage                                        	# copy zImage

find -name '*.ko' | xargs -I {} cp {} ./out/modules/				# Find and copy modules
cp -r out/modules/*.ko ~/android/kernel/Saida/codekidX/lib/modules/
cp -r out/zImage ~/android/kernel/Saida/kernel/                           	# copy zImage and modules to Saida

echo "==============================================="
echo 'done'
echo "==============================================="
echo ''

if [ -a arch/arm/boot/zImage ]; 
then										# If zImage is done, continue	

echo "==============================================="
echo 'Copy empty-zip'
echo "==============================================="
echo ''

cp ~/android/kernel/empty-zip.zip ~/android/kernel/Saida/boot.zip		# Copy the empty zip to the working folder

echo ''
echo "==============================================="
echo 'Copying modules to zip'
echo "==============================================="
echo ''

cd ~/android/kernel/Saida/							# Change to working folder 
shopt -s globstar								# list everything on the folder (including structures)
zip -u boot.zip ./codekidX/lib/modules/*.ko					# Copy all modules to zip (update)
zip -u boot.zip ./kernel/zImage							# Copy zImage (update)
mv boot.zip ~/android/kernel/DatKernel-last.zip					# move last to main folder, and all working folders are now clean
                                                            
echo ''
echo "==============================================="
echo 'build finished successful, cleaning everything'
echo "==============================================="

cd codekidX/lib/modules/							# Cleaning all modules after zip is done
rm *

cd ~/android/kernel/Saida/kernel/						# Cleaning zImage as well
rm *

cd ~/android/kernel/DatKernel							# Going to initial folder,
./clean.sh									# cleaning all build stuff,	
rm -rf out									# and clean out folder and wipe it

git checkout -- drivers/misc/vc04_services/interface/vchiq_arm/vchiq_version.c	# Checkout that fucker

else										# if zImage was not done, build failed

echo "==============================================="
echo 'build failed!'
echo "==============================================="

make -j1									# Find where the build failed.

fi
