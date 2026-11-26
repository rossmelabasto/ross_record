# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

## [0.1.0] - 2026-11-25

### Added

- `record` as its own project (it used to ship inside ross_transcribe 0.2.0): record from the microphone with a live level meter, then transcribe, save a `.txt` or nothing.
- `-s` hands-free mode, `-c` clean-up, `-d` maximum length, `-f` format, `-i`/`-l` sources, `-L` transcript language, `-t`/`-o`/`-n`.
- `-V` shows the version.
- Signed packages `ross-record` for pacman, APT and DNF on repo.rossmel.com.
