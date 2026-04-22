# Release Checklist

## Versioning

This project follows [Semantic Versioning](https://semver.org):
- **Patch** (1.0.x) — bug fixes
- **Minor** (1.x.0) — new features, backward compatible
- **Major** (x.0.0) — breaking changes

## Branching

- `master` is always releasable
- Use short-lived branches for features and hotfixes, then merge into master
- Tags mark releases — no long-lived release branches needed

```bash
git checkout -b feature/my-feature
# ... work ...
git checkout master
git merge feature/my-feature
```

## Steps to Release

1. Update `VERSION` in `muck` and `muck-serve`
2. Update `CHANGELOG.md` — add a new section at the top for the new version
3. Commit and tag:
   ```bash
   git add .
   git commit -m "Release v1.x.x"
   git tag -a v1.x.x -m "v1.x.x"
   git push origin master --tags
   ```
4. Create a GitHub release:
   ```bash
   gh release create v1.x.x --notes-from-tag --title "v1.x.x"
   ```
