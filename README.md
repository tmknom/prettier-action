# Prettier for GitHub Actions

Format code with Prettier.

## Usage

```yaml
- name: Check formatting for markdown
  uses: tmknom/prettier-action@v0.0.1
    with:
      parser: "markdown"
      paths: "README.md"
```

## Description

[Prettier](https://github.com/prettier/prettier) is an opinionated code formatter.
This action allows you to run prettier command simply.

## License

Apache 2 Licensed. See LICENSE for full details.
