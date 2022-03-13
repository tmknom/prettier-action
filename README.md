# Prettier for GitHub Actions

Format code with Prettier.

## Description

[Prettier](https://github.com/prettier/prettier) is an opinionated code formatter.
This action allows you to run prettier command simply.

## Usage

```yaml
- name: Check formatting for markdown
  uses: tmknom/prettier-action@v0.1.0
    with:
      parser: "markdown"
      paths: "README.md"
```

## Developer Guide

### Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [GitHub CLI](https://cli.github.com/)

### Update documents

Update usage automatically in [README.md](/README.md).

```shell
make docs
```

### Prepare Release

Bump up to new release version.

```shell
make bump
```

This command perform the following process:

1. Update [VERSION](/VERSION)
2. Update [README.md](/README.md)
3. Commit and push
4. Create a pull request and open the web browser

### Release

#### 1. Create a new GitHub Release

```shell
make release
```

This command perform the following process:

1. Push tag
2. Create a new GitHub Release as a draft
3. Open the GitHub Release in the web browser

#### 2. Publish actions in GitHub Marketplace

1. Click the edit icon on the right side of the page
2. Edit the release notes
3. If you're ready to publicize your release, click "Publish release"

## License

Apache 2 Licensed. See LICENSE for full details.
