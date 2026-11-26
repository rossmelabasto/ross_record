# Contributing

Thanks for wanting to improve record! Issues and pull requests are welcome, in English or Spanish.

- `record` is a single Bash script in `bin/record`. Run it straight from the repo: `bin/record -h`.
- Keep it working with `set -u` and pass [ShellCheck](https://www.shellcheck.net/) (`shellcheck bin/record`); the CI runs it.
- It needs SoX with PulseAudio input, `pactl` and Perl. Test with a real microphone, or with a virtual one:
  `pactl load-module module-null-sink sink_name=test` and `record -i test.monitor`.
- Commits follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`…) and versions follow SemVer.
- When you bump the version, change `VERSION=` in `bin/record` and add the entry to `CHANGELOG.md`.
