# Everyday Bible Study

A responsive Flutter Web Bible study journal based on the supplied worksheet design.

## Included

- Bible Character Study
- Chapter Study
- Quiet Time Notes
- Reflection Journal
- New Testament chapter tracker
- Browser-local saving
- Responsive phone/tablet/desktop layout
- GitHub Pages deployment workflow

## Run locally

```bash
flutter pub get
flutter run -d chrome
```

## Build

```bash
flutter build web --release
```

The release files are generated in `build/web`.

## GitHub Pages

Push the project to a GitHub repository using the `main` branch. The included GitHub Actions workflow builds and deploys the web app to GitHub Pages.

In GitHub, open:

Settings → Pages → Build and deployment → Source: GitHub Actions

The expected address is:

https://YOUR-USERNAME.github.io/YOUR-REPOSITORY/

Notes are stored in the browser's local storage through `shared_preferences`; they are not synchronized between devices.
