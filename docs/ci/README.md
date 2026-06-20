# CI / CD reference

This directory holds a ready-to-go GitHub Actions workflow that the
maintainers can drop into `.github/workflows/` whenever they next push
from a client whose credentials carry the `workflow` scope.

## Why isn't this in `.github/workflows/` already?

The GitHub App used to commit code into this repo deliberately does
**not** carry the `workflow` permission. Attempting to push a YAML file
under `.github/workflows/` from that App therefore gets rejected with:

```
refusing to allow a GitHub App to create or update workflow
`.github/workflows/ci.yml` without `workflows` permission
```

Rather than weaken the App's permissions, the workflow lives here under
`docs/ci/` until a human can install it.

## Installing

From any local clone whose `origin` remote is authenticated with a PAT
or SSH key that includes the `workflow` scope:

```bash
mkdir -p .github/workflows
cp docs/ci/ci.yml .github/workflows/ci.yml
git add .github/workflows/ci.yml
git commit -m "ci: activate Flutter + backend GitHub Actions pipeline"
git push
```

Within a minute or two, GitHub will start running the pipeline on every
push to `main`, `develop`, `feature/**`, `fix/**`, `chore/**` and on
every PR into `main` / `develop`.

## What the pipeline does

Two jobs run in parallel:

| Job       | Steps                                                                                                               |
| --------- | ------------------------------------------------------------------------------------------------------------------- |
| `flutter` | `pub get` → `dart format --set-exit-if-changed` → `flutter analyze` → `flutter test` → `flutter build web --release` |
| `backend` | `./gradlew clean build -x test` → `./gradlew test`                                                                  |

Both jobs upload their artefacts (the web bundle and the Spring Boot
fat jar) to the run, retained for 7 days.

## Pinned versions

The workflow pins Flutter to **3.35.4** and Java to **21 (Temurin)** so
CI matches the locked sandbox environment we ship from. Do not bump
these in isolation — see the top-level `README.md` for the upgrade
policy.
