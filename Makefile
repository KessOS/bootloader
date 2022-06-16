NAME=KessOS
OVMFDIR=OVMFbin

all:
	cargo build --target x86_64-unknown-uefi	
	cp target/x86_64-unknown-uefi/debug/kess_os.efi ./main.efi
	dd if=/dev/zero of=$(NAME).img bs=512 count=93750
	mformat -i $(NAME).img
	mmd -i $(NAME).img ::/EFI
	mmd -i $(NAME).img ::/EFI/BOOT
	mcopy -i $(NAME).img startup.nsh ::
	mcopy -i $(NAME).img main.efi ::/EFI/BOOT
	rm *.efi
	cp $(NAME).img ../

run:
	qemu-system-x86_64 -drive file=$(NAME).img -m 256M -cpu qemu64 -drive if=pflash,format=raw,unit=0,file="$(OVMFDIR)/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="$(OVMFDIR)/OVMF_VARS-pure-efi.fd" -net none -serial stdio -d int -no-reboot -D logfile.txt -M smm=off -soundhw pcspk
