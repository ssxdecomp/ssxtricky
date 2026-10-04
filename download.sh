#[[ -d "tools/binutils" ]] && {
#	echo "You don't need to run this script again. Alternatively,"
#	echo "if you are intentionally running this script again,"
#	echo "delete tools/binutils."
#	exit 0;
#}

mkdir "tools/binutils"
curl -Lo - https://github.com/decompals/binutils-mips-ps2-decompals/releases/latest/download/binutils-mips-ps2-decompals-linux-x86-64.tar.gz | tar -C tools/binutils -xzvf -
mkdir "tools/objdiff"
curl -sSL https://github.com/encounter/objdiff/releases/latest/download/objdiff-cli-linux-x86_64 -o tools/objdiff/objdiff-cli-linux-x86_64
curl -sSL https://github.com/encounter/objdiff/releases/latest/download/objdiff-linux-x86_64 -o tools/objdiff/objdiff-linux-x86_64