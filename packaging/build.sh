#!/usr/bin/env bash
# Build the tree the deb, rpm and pacman packages install, then the packages themselves.
#
#   /usr/bin/record   the recorder (a Bash script; its version must match the one being built)
#
#   packaging/build.sh <version> <out-dir>      (needs nfpm and envsubst)
set -euo pipefail

version=${1:?version}
out=$(realpath -m "${2:?out-dir}")
root=$(cd "$(dirname "$0")/.." && pwd)

inscript=$(sed -n 's/^VERSION="\(.*\)"/\1/p' "$root/bin/record")
[ "$inscript" = "$version" ] || { echo "version mismatch: bin/record says $inscript, building $version" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
stage="$work/stage"
mkdir -p "$stage/usr/bin" "$out"
install -m755 "$root/bin/record" "$stage/usr/bin/record"
install -Dm644 "$root/LICENSE" "$stage/usr/share/licenses/ross-record/LICENSE"
install -Dm644 "$root/README.md" "$stage/usr/share/doc/ross-record/README.md"

# nfpm doesn't expand variables in file paths: fill the config in first.
VERSION="$version" STAGE="$stage" envsubst '${VERSION} ${STAGE}' < "$root/packaging/nfpm.yaml" > "$work/nfpm.yaml"
for packager in deb rpm archlinux; do
  nfpm package --config "$work/nfpm.yaml" --packager "$packager" --target "$out/"
done
ls -la "$out"
