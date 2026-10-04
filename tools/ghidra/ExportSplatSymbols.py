# Export user-named functions to a splat symbol_addrs file
# @category SSX
import re

fm = currentProgram.getFunctionManager()
lines = []
seen = set()

for func in fm.getFunctions(True):          # True = iterate in address order
    symbol = func.getSymbol()

    # Skip Ghidra's auto names (FUN_xxxxxxxx) so only real names are exported
    if symbol.getSource().toString() == "DEFAULT" or func.getName().startswith("FUN_"):
        continue

    addr = func.getEntryPoint().getOffset()

    # Include the namespace (class name) so Init, ~cGame, etc. are unique
    name = func.getName(True)
    # Replace anything that isn't a valid assembler label character
    name = re.sub(r"[^A-Za-z0-9_]", "_", name)
    # If it's still a duplicate, add the address to make it unique
    if name in seen:
        name = name + "_%08X" % addr
    seen.add(name)

    lines.append("%s = 0x%08X; //type:func" % (name, addr))

out_file = askFile("Save splat symbol file", "Save")
with open(out_file.getAbsolutePath(), "w") as fp:
    fp.write("\n".join(lines) + "\n")

print("Exported %d symbols to %s" % (len(lines), out_file.getAbsolutePath()))