#!/usr/bin/env bash
#
# Integrate the pre-built Equicord browser extension into the Neutron
# (Firefox-based) build so that it ships as a built-in add-on.
#
# This is idempotent: it can be run any number of times and always leaves the
# neutron/ tree in the same, buildable state.
#
# Usage: scripts/integrate-equicord.sh
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NEUTRON="$ROOT/neutron"
EXT_SRC="$ROOT/extensions/equicord"

if [ ! -d "$NEUTRON" ]; then
    echo "error: neutron submodule not found at $NEUTRON" >&2
    echo "       run 'git submodule update --init --recursive' first" >&2
    exit 1
fi

if [ ! -f "$EXT_SRC/manifest.json" ]; then
    echo "error: extensions/equicord/manifest.json not found." >&2
    echo "       Build it from tools/build-equicord.sh and commit the result." >&2
    exit 1
fi

echo "==> Copying Equicord extension into neutron/src/equicord"
rm -rf "$NEUTRON/src/equicord"
cp -r "$EXT_SRC" "$NEUTRON/src/equicord"

echo "==> Writing neutron/src/scripts/inject-equicord"
cat > "$NEUTRON/src/scripts/inject-equicord" <<'INJECT'
#!/usr/bin/env bash
#
# Run from inside mozilla-unified/, before ./mach configure.
# Installs the Equicord browser extension as a Firefox built-in add-on.
#
set -euo pipefail

SRC="../src/equicord"
DST="browser/extensions/equicord"
NAME="equicord"

if [ ! -d "$SRC" ]; then
    echo "inject-equicord: $SRC not found" >&2
    exit 1
fi

rm -rf "$DST"
cp -r "$SRC" "$DST"

# Generate jar.mn mapping every file into resource://builtin-addons/equicord/
{
    echo "browser.jar:"
    ( cd "$DST" && find . -type f ! -name 'jar.mn' | sed 's|^\./||' | LC_ALL=C sort ) \
        | while read -r f; do
            echo "    builtin-addons/$NAME/$f ($f)"
        done
} > "$DST/jar.mn"

echo 'JAR_MANIFESTS += ["jar.mn"]' > "$DST/moz.build"

# Register the add-on directory in browser/extensions/moz.build (idempotent).
MOZBUILD="browser/extensions/moz.build"
if ! grep -q "\"$NAME\"" "$MOZBUILD"; then
    cp "$MOZBUILD" "$MOZBUILD.equicord.bak"
    printf '\nDIRS += [\n    "%s",\n]\n' "$NAME" >> "$MOZBUILD"
fi

echo "inject-equicord: Equicord built-in add-on installed."
INJECT
chmod +x "$NEUTRON/src/scripts/inject-equicord"

echo "==> Hooking the injection into the Linux build scripts"
python3 - "$NEUTRON" <<'PY'
import sys, pathlib

neutron = pathlib.Path(sys.argv[1])
marker = "commacord: equicord integration"
block = (
    "\n# --- commacord: equicord integration ---\n"
    'if [ -f ../src/scripts/inject-equicord ]; then bash ../src/scripts/inject-equicord; fi\n'
    "# --- end commacord: equicord integration ---\n"
)

targets = {
    "src/scripts/build/linux": "cp ../src/mozconfig.linux mozconfig",
    "src/scripts/build/linux-aarch64": "cp ../src/mozconfig.linux-aarch64 mozconfig",
}

for rel, anchor in targets.items():
    path = neutron / rel
    text = path.read_text()
    if marker in text:
        print(f"    {rel}: already patched")
        continue
    if anchor not in text:
        print(f"    warning: anchor not found in {rel}, skipping", file=sys.stderr)
        continue
    text = text.replace(anchor, anchor + block, 1)
    path.write_text(text)
    print(f"    {rel}: patched")
PY

echo "==> Done. Equicord will be bundled into the Linux builds."
