
# Contributor guide

## Conventionnal commit

Install `pre-commit` on your system. For example, using the `nix` package manager:

```bash
nix-env -e pre-commit
```

Then activate the GIT hook located in [`.pre-commit-config.yaml`](../.pre-commit-config.yaml).

```
pre-commit install --hook-type commit-msg
```
