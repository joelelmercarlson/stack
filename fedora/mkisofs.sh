#!/usr/bin/env bash
set -ex

CFG="${HOME}/stack/fedora"
ISOCFG="${CFG}/isolinux.cfg"
KSCFG="${CFG}/ks.cfg"
REPOCFG="${CFG}/local.repo"
EXPORT=/export/ISO

echo "Content in ${EXPORT}..."
if [ ! -d $EXPORT ]
then
	mkdir -p $EXPORT
fi

echo "Config from ${CFG}..."
cp $ISOCFG  $EXPORT/isolinux
cp $KSCFG   $EXPORT/
cp $REPOCFG $EXPORT

echo "inst.stage2 iso LABEL..."
LABEL=$(awk '/inst.stage2/{print $3}' $ISOCFG|sed 's/.*=//'|head -n 1)
RELEASE=$(awk '/inst.stage2/{print $3}' $ISOCFG|sed 's/.*=//'|tail -n 1)
LOWER=$(echo $RELEASE|tr '[A-Z]' '[a-z]')
ISO="/export/${LOWER}.iso"

CNT=$(echo $LABEL|wc -l)
if [ $CNT -lt 1 ]
then
	echo "LABEL missing..."
	exit 1
fi

CNT=$(echo $RELEASE|wc -l)
if [ $CNT -lt 1 ]
then
	  echo "RELEASE missing..."
	  exit 1
fi

echo "mkisofs ${ISO}..."
mkisofs -o $ISO \
-b isolinux/isolinux.bin -J -R -l \
-c isolinux/boot.cat \
-no-emul-boot -boot-load-size 4 -boot-info-table \
-eltorito-alt-boot \
-e images/efiboot.img -no-emul-boot -graft-points \
-V "$LABEL" .

echo "all done..."
