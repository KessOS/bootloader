ISONAME=KESSOS.ISO


all:
	cargo +nightly build --target x86_64-unknown-uefi
	cp target/x86_64-unknown-uefi/debug/kessboot.efi ./BOOTX64.EFI
	dd if=/dev/zero of=fat.img bs=1k count=1440
	mformat -i fat.img -f 1440 ::
	mmd -i fat.img ::/EFI
	mmd -i fat.img ::/EFI/BOOT
	mcopy -i fat.img startup.nsh ::
	mcopy -i fat.img BOOTX64.EFI ::/EFI/BOOT
	rm *.img

iso:
	cargo +nightly build --target x86_64-unknown-uefi
	cp target/x86_64-unknown-uefi/debug/kessboot.efi ./BOOTX64.EFI
	dd if=/dev/zero of=fat.img bs=1k count=1440
	mformat -i fat.img -f 1440 ::
	mmd -i fat.img ::/EFI
	mmd -i fat.img ::/EFI/BOOT
	mcopy -i fat.img startup.nsh ::
	mcopy -i fat.img BOOTX64.EFI ::/EFI/BOOT
	rm *.EFI
	mkdir iso
	cp fat.img iso/
	xorriso -as mkisofs -R -f -e fat.img -no-emul-boot -o $(ISONAME) iso
	rm -rf iso
	rm *.img

run:
	qemu-system-x86_64 -cdrom $(ISONAME) -m 2G -cpu qemu64 -drive if=pflash,format=raw,unit=0,file="OVMFbin/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="OVMFbin/OVMF_VARS-pure-efi.fd" -net none -monitor stdio -d int -no-reboot -M smm=off

clean:
	@ rm -f *.img
	@ rm -f *.EFI
	@ rm -f *.ISO
	@ rm -rf iso
