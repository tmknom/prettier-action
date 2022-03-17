# Prettier for GitHub Actions

Check that files are formatted with Prettier.

## Description

Prettier is an opinionated code formatter.
This action allows you to check that files are formatted correctly.
It supports for Markdown, YAML, and so on.

See details: [Prettier documentation](https://prettier.io/docs/en/).

## Usage

### YAML

```yaml
- name: Prettier
  uses: tmknom/prettier-action@v0.4.0
  with:
    parser: "yaml"
```

### Markdown

```yaml
- name: Prettier
  uses: tmknom/prettier-action@v0.4.0
  with:
    parser: "markdown"
```

### Specify all input parameters

```yaml
- name: Prettier
  uses: tmknom/prettier-action@v0.4.0
  with:
    parser: "yaml"
    paths: "action.yml .github/workflows/*.yml"
    prettier-version: "2.5.0"
    cache: "false"
```

## Inputs

| Name             | Description                                                                   | Default | Required |
| ---------------- | ----------------------------------------------------------------------------- | ------- | :------: |
| parser           | Which parser to use.                                                          | n/a     |   yes    |
| paths            | Paths to check target files.                                                  | n/a     |    no    |
| prettier-version | The Prettier version.                                                         | `2.5.1` |    no    |
| cache            | The flag to enable/disable cache. Specify false, if you wish disabling cache. | `true`  |    no    |

## Outputs

N/A

## Environment variables

N/A

## `GITHUB_TOKEN` Permissions

N/A

## Developer Guide

### Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [GitHub CLI](https://cli.github.com/)

### Update documents

Update usage automatically in [README.md](/README.md).

```shell
make docs
```

### Release

#### 1. Bump up to a new version

Run the following command to bump up.

```shell
make bump
```

This command will execute the following steps:

1. Update [VERSION](/VERSION)
2. Update [README.md](/README.md)
3. Commit and push
4. Create a pull request
5. Open the web browser automatically for reviewing pull request

Then review and merge, so the release is ready to go.

#### 2. Create a new GitHub Release

Run the following command to create a new release.

```shell
make release
```

This command will execute the following steps:

1. Push tag
2. Create a new GitHub Release as a draft
3. Open the web browser automatically for editing GitHub Release

#### 3. Publish actions in GitHub Marketplace

Edit to publicize the GitHub Release.

1. Click the edit icon on the right side of the page
2. Edit the release notes
3. Click `Publish release`

Then, the new version are published in GitHub Marketplace.
Finally, we can use the new version! :tada:

## License

Apache 2 Licensed. See LICENSE for full details.
