#!/usr/bin/env bash
# Install a built package on a clean system and use it for real: record a few seconds from a
# virtual microphone fed with a test tone, with the hands-free and clean-up options.
# Runs as root inside the distro's container:
#   install-test.sh <deb|rpm|arch> <package-file> <version>
set -euo pipefail
kind=$1 pkg=$(realpath "$2") version=$3

case "$kind" in
  deb)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get install -y -qq pulseaudio >/dev/null
    apt-get install -y -qq "$pkg" >/dev/null
    ;;
  rpm)
    dnf install -y -q pulseaudio
    dnf install -y -q "$pkg"
    ;;
  arch)
    pacman-key --init >/dev/null 2>&1
    pacman -Syu --noconfirm --needed pulseaudio >/dev/null
    pacman -U --noconfirm "$pkg" >/dev/null
    ;;
esac

echo "--- version and help"
record -V | tee /tmp/version
grep -q "$version" /tmp/version
command -v sox pactl perl
record -h | head -2

echo "--- a real recording from a virtual microphone"
# A sound server of its own (no PipeWire in the container), a null sink as the "microphone",
# and a 440 Hz tone played into it while record listens to its monitor.
pulseaudio --daemonize=yes --exit-idle-time=-1 --system=false -n \
  --load="module-null-sink sink_name=mic" --load="module-native-protocol-unix" 2>/dev/null || \
  pulseaudio --daemonize=yes --exit-idle-time=-1 -n --load="module-null-sink sink_name=mic" --load="module-native-protocol-unix"
sleep 1
pactl set-default-source mic.monitor
( sleep 1; sox -n -t pulseaudio mic synth 3 sine 440 vol 0.5 ) &
export RECORD_DIR=/tmp/rec
record -n -c -d 0:05 test < /dev/null
wait
ls -la /tmp/rec
f=$(ls /tmp/rec/*_test.ogg)
dur=$(soxi -D "$f")
echo "recorded $f ($dur s)"
awk -v d="$dur" 'BEGIN { exit !(d > 3.5 && d < 6) }'
echo "Install test passed on $kind"
