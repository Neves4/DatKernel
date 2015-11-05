clear																		# Start Compilation

cd ~/android/kernel/														# Go to find last build

lastversion=$(find -maxdepth 1 -name 'DatKernel-r*' | sort --version-sort -f | tail -1)
lastversion=${lastversion:13:${#lastversion}}								# Remove everything except the numbers,
lastversion=${lastversion::-4}												# remove extension and
newversion=$((lastversion+1))												# increment version number

echo -e "==============================================="
echo -e "Initializing Toolchain"
echo -e "==============================================="

export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=~/android/kernel/toolchains/archi5.2/bin/arm-eabi-

echo -e ""

cd ~/android/kernel/DatKernel/												# Back to working folder

make datkernel_defconfig													# make config

echo ''
echo "==============================================="
echo "Done!"
echo ''
echo "Build Kernel and output to Saida/output/ ..."
echo "==============================================="
echo ''

sleep 6																		# Sleep to be human-readable

time make -j4 2>&1 | tee ~/android/kernel/Saida/output/DatKernel-r$newversion.txt	# Make build and output to a build file

echo ''
echo "==============================================="
echo "copying files to ./out"
echo "==============================================="
echo ''

mkdir -p out/modules                                                       	# make dirs for zImage and modules
cp arch/arm/boot/zImage out/zImage                                        	# copy zImage

find -name '*.ko' | xargs -I {} cp {} ./out/modules/						# Find and copy modules
cp -r out/modules/*.ko ~/android/kernel/Saida/datkernel/lib/modules/
cp -r out/zImage ~/android/kernel/Saida/kernel/                           	# copy zImage and modules to Saida

echo "==============================================="
echo "Done"
echo "==============================================="
echo ''

if [ -a arch/arm/boot/zImage ]; 
then																		# If zImage is done, continue	

echo "==============================================="
echo 'Copy empty-zip'
echo "==============================================="
echo ''

cp ~/android/kernel/DatKernel/empty-zip.zip ~/android/kernel/Saida/boot.zip			# Copy the empty zip to the working folder

echo ''
echo "==============================================="
echo "Copying modules to zip"
echo "==============================================="
echo ''

cd ~/android/kernel/Saida/													# Change to working folder 
shopt -s globstar															# list everything on the folder (including structures)
zip -u boot.zip ./datkernel/lib/modules/*.ko								# Copy all modules to zip (update)
zip -u boot.zip ./kernel/zImage												# Copy zImage (update)
mv boot.zip ~/android/kernel/DatKernel-r$newversion.zip						# move last to main folder, and all working folders are now clean
                                                            
echo ''
echo "==============================================="
echo 'build finished successful, cleaning everything'
echo "==============================================="
echo ''

cd datkernel/lib/modules/													# Cleaning all modules after zip is done
rm *

cd ~/android/kernel/Saida/kernel/											# Cleaning zImage as well
rm *

cd ~/android/kernel/DatKernel												# Going to initial folder,
make clean mrproper															# cleaning all build stuff,	
rm -rf out																	# and clean out folder and wipe it

git checkout -- drivers/misc/vc04_services/interface/vchiq_arm/vchiq_version.c	# Checkout that fucker

echo ''
echo "==============================================="
echo ''
echo "Last version was = DatKernel-r$lastversion"
echo ''
echo "==============================================="

sleep 6																		# Sleep a little to be human readable

echo ''
echo "New version is = DatKernel-r$newversion"
echo ''
echo "==============================================="

echo ''
echo "NEW BUILD IS DONE!!!!"
echo ''
echo "==============================================="
echo ''

else																		# if zImage was not done, build failed

echo "==============================================="
echo 'build failed!'
echo "==============================================="
echo ''

make -j1																	# Find where the build failed.

fi