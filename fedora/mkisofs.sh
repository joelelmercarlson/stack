mkisofs -o /export/rhel8.iso \
-b isolinux/isolinux.bin -J -R -l \
-c isolinux/boot.cat \
-no-emul-boot -boot-load-size 4 -boot-info-table \
-eltorito-alt-boot \
-e images/efiboot.img -no-emul-boot -graft-points \
-V "RHEL-8-3-0-BaseOS-x86_64" .
