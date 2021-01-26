<div align="center">

# Markdown URL sanitiser - Github Action

![Markdown URL Sanitiser](https://github.com/markbattistella/markdown-safe-link-action/workflows/Markdown%20URL%20Sanitiser/badge.svg?branch=main)

[![Help donate](https://img.shields.io/badge/%20-@markbattistella-blue?logo=paypal)](https://www.paypal.me/markbattistella/6AUD) [![Buy me a coffee](https://img.shields.io/badge/%20-buymeacoffee-black?logo=buy-me-a-coffee)](https://www.buymeacoffee.com/markbattistella)

---

</div>

Search and replace any unsafe urls in your repos using the Google Safe Browsing API

## Background

I started with this tweet by [@seanallen](https://twitter.com/seanallen_dev/status/1332696819625844736) where he added a URL into a YouTube video description.

The URL became compromised within the week of adding it, and his channel was flagged with **strike 1**.

I realised there isn't anything out there to prevent this from happening to anyone's repository.

## Usage

### Github Action

1. Get an API for [Google Safe Browsing](https://developers.google.com/safe-browsing/)

1. Add the step to your workflow (required minimum):

    ```yaml
    # You can change this to use a specific version
    - uses: markbattistella/markdown-safe-links-action@v1
      with:

        # scope of markdown files (required)
        directory: "."

        # Google Safe Browsing API (required)
        api: ${{ secrets.GOOGLE_API }}

        # replace malicious urls text (required)
        replace: "~~UNSAFE_URL~~"

        # Github token (required)
        github_token: ${{ secrets.GITHUB_TOKEN }}
    ```

## Configuration

| Name               | Value     | Required | Default                       | Description                           |
|--------------------|-----------|----------|-------------------------------|---------------------------------------|
| `directory`        | `string`  | Y        | `'.'`                         | Scope of where to scan urls           |
| `api`              | `string`  | Y        | nil                           | Google API for scanning URLs          |
| `replace`          | `string`  | Y        | `~~UNSAFE_URL~~`              | What to replace the URLs with         |
| `github_token`     | `string`  | Y        | `${{ secrets.GITHUB_TOKEN }}` | Token for the repository              |
| `author_email`     | `string`  |          | Github bot email              | Email for commit                      |
| `author_name`      | `string`  |          | Github Bot                    | Name for commit                       |
| `message`          | `string`  |          | Sanitised URLs on DATE        | Message for commit                    |
| `branch`           | `string`  |          | `main`                        | Destination branch to push changes    |
| `empty`            | `boolean` |          | `false`                       | Allow empty commits                   |
| `force`            | `boolean` |          | `false`                       | Determines if force push is used      |
| `tags`             | `boolean` |          | `false`                       | Determines if `--tags` is used        |
| `commit_directory` | `string`  |          | `'.'`                         | Directory to change to before pushing |

### Examples

#### Normal use

```yaml
name: Markdown URL Sanitiser
on:
  [push]
jobs:
  markdown-safe-link:
    name: markdown-safe-link
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Markdown Safe Link Sanitisation
        uses: markbattistella/markdown-safe-links-action@v1.0.0
        id: sanitise
        with:
          directory:  "."
          api: ${{ secrets.GOOGLE_API }}
          replace: "~~UNSAFE_URL~~"
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

#### Full use

```yaml
name: Markdown URL Sanitiser
on:
  [push]
jobs:
  markdown-safe-link:
    name: markdown-safe-link
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Markdown Safe Link Sanitisation
        uses: markbattistella/markdown-safe-links-action@v1.0.0
        id: sanitise
        with:
          directory:  "."
          api: ${{ secrets.GOOGLE_API }}
          replace: "~~UNSAFE_URL~~"
          github_token: ${{ secrets.GITHUB_TOKEN }}
          author_email: "my.email@domain.ltd"
          author_name: "My Name"
          message: "Sanitised message - not default"
          branch: "master" # if your branch hasn't changed to `main`
          empty: true
          force: true
          tags: true
          commit_directory: "./docs"
```

#### On CRON schedule

This is perfect if you want it to scan on an interval if you don't commit frequently.

```yaml
name: Markdown URL Sanitiser
on:
  schedule:
  - cron: "30 1 * * *"
jobs:
  markdown-safe-link:
    name: markdown-safe-link
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Markdown Safe Link Sanitisation
        uses: markbattistella/markdown-safe-links-action@v1.0.0
        id: sanitise
        with:
          directory:  "."
          api: ${{ secrets.GOOGLE_API }}
          replace: "~~UNSAFE_URL~~"
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

#### Locally

You can use the `node` module from [Github](https://github.com/markbattistella/markdown-safe-link) or from [npm](https://www.npmjs.com/package/@markbattistella/markdown-safe-link).

Installing it for the command line:

```sh
# locally
npm i @markbattistella/markdown-safe-link

# globally
npm i @markbattistella/markdown-safe-link -g
```
