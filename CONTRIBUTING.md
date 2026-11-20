# Contributing to HIMAL Video Player

Thank you for considering contributing! HIMAL is free and open source, and we welcome
contributions of all kinds.

## How to contribute

1. **Fork** the repository and create a branch from `main`.
2. **Set up** your environment: install Flutter 3.19+, run `flutter pub get`.
3. **Make your changes** with tests where applicable.
4. **Run** `flutter analyze` and `flutter test` — both must pass.
5. **Commit** with clear, descriptive messages (Conventional Commits preferred).
6. **Open a Pull Request** against `main`.

## Development setup

```bash
git clone https://github.com/<you>/himal-video-player.git
cd himal-video-player
flutter pub get
flutter create --platforms=android,ios,linux,macos,windows .
flutter run -d <device>
```

## Code style

- Follow `flutter_lints` (see `analysis_options.yaml`).
- Keep widgets small and reusable; prefer `const` constructors.
- Use `provider` for state management; do not introduce a second state solution without discussion.
- Add documentation comments to public APIs.

## Reporting bugs

Use the bug report issue template. Include:
- HIMAL version, OS and version, device
- Steps to reproduce
- Expected vs actual behavior
- Logs / screenshots

## Feature requests

Use the feature request template. Describe the use case, not just the solution.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.