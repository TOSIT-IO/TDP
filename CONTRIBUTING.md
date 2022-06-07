
# Contributing to TDP

TDP is an open source project hosted on [GitHub](https://github.com/TOSIT-IO/TDP) administered by the [TOSIT association](https://tosit.fr/). It is released under the [Apache License 2.0](https://github.com/TOSIT-IO/TDP/blob/main/LICENSE).

We appreciate your interest and efforts to contribute to TDP.

## How to help

Contributions go far beyond pull requests and commits. We would be thrilled to receive a variety of other contributions including the following:

- Write and publish your own actions
- Write articles and blog posts, create a tutorial, and spread the words
- Submit new ideas of features and documentation
- Submitting documentation updates, enhancements, designs, or bugfixes
- Submitting spelling or grammar fixes
- Additional unit or functional tests
- Help to answer questions and issues on GitHub

## Getting help

### Discussions

There is currently no channel dedicated to discussing TDP. For now, you may simply open a new issue.

### Requesting changes

Expressing your opinions and desires is encouraged to influence the work on TDP. You can submit new issues on GitHub and upvote existing features.

### Bugs

#### Where to Find Known Issues

TDP is using GitHub issues to manage public bugs. We keep a close eye on this and try to make it clear when we have an internal fix in progress.

Before filing a new issue, try to ensure your problem is not already reported.

#### Reporting New Issues

The best way to get your bug fixed is to provide a reduced test case. You can get inspiration from our current tests' suite. Note, tests are filtered by tags and some tests require a specific environment which is provided through Docker or LXD environments.

## Getting involved

### Open development

All work on TDP happens directly on GitHub. Both core team members and external contributors send pull requests which go through the same review process.

### Code of conduct

This project, and everyone participating in it, are governed by the TDP code of conduct which adopts [Contributor Covenant](https://www.contributor-covenant.org/) version 1.4, available at (https://contributor-covenant.org/version/1/4). Before participating, you must read and acknowledge its content. Later, you are expected to respect it.

### Request For Comments (RFC)

...to be discussed...

### Contributor License Agreement (CLA)

#### Individual contribution

You need to sign an Individual Contributor License Agreement (ICLA) to accept your pull request. You only need to do this once. If you submit a pull request for the first time, you can complete our CLA.

The document is downloadable from our website. In the future, we will look for a solution to automate the CLA signature such as [CLA bot](https://github.com/apps/cla-bot), which automatically ask you to sign before merging the pull request.

<!-- See: https://www.apache.org/licenses/icla.pdf -->

#### Company contribution

If you make contributions to our repositories on behalf of your company, we will need a Corporate Contributor License Agreement (CCLA) signed. To do that, please get in touch with us.

<!-- See: https://www.apache.org/licenses/cla-corporate.pdf -->

## Development

### Documentation

Managing an open source project a huge time sink and most of us are non-native English speakers. We greatly appreciate any time spent fixing typos or clarifying sections in the documentation.

Pull requests related to fixing documentation for the latest release should be directed towards the [documentation repository](https://github.com/TOSIT-IO/TDP).

### Branch organization

We will do our best to keep the `main` branch in good shape, with tests passing at all times. The objective is to preserve the `main` branch in a releasable state. But in order to move fast, we will make API changes that your application might not be compatible with. We recommend that you use the latest stable version of TDP.

If you send a pull request, please do it against the `main` branch. We maintain stable branches for major versions separately but we don’t accept pull requests to them directly. Instead, we cherry-pick non-breaking changes from `main` to the latest stable major version.

### Semantic versioning

TDP follows Semantic Versioning (aka SemVer). We release patch versions for bug fixes, minor versions for new features, and major versions for any breaking changes. When we make breaking changes, we also introduce deprecation warnings in a minor version so that our users learn about the upcoming changes and migrate their code in advance.

Every significant change is documented in the Changelog file.

### Contributor skills

- Ansible
- CI/CD tooling
- Devops/ Open source advocate
- Knowledgable in Hadoop services deployment, maintenance and upgrading
- Python2/Python3 scripting
- Bash scripting

## Proposing a Change

### Testing

Before sending a pull request for a feature, be sure to have tests to cover your code.

### Pull requests

If you intend to change the public API or make any non-trivial changes to the implementation, we recommend [filing an issue](https://github.com/TOSIT-IO/TDP/issues/new). This lets us reach an agreement on your proposal before you put significant effort into it.

If you’re only fixing a bug, it’s fine to submit a pull request right away but we still recommend filing an issue detailing what you’re fixing. This is helpful in case we don’t accept that specific fix but want to keep track of the issue.

### Conventional Commits


The TDP git repositories follows the Conventional Commits specification that provides an easy set of rules for creating an explicit commit history.

Here's how a commit message looks like:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The `<type>` message follows [the Angular convention](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit) and must be one from the list: `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test`. The `[optional scope]` message is associated to the directory name of [the available packages](https://github.com/adaltas/node-nikita/tree/master/packages). A scope is optional and is contained within parentheses, e.g., `feat(engine): ability to parse arrays`. Follow [the specification](https://www.conventionalcommits.org) to learn more about Conventional Commits.

Commit messages are automatically validated, in case of any mistake the error message is prompted. Internally, we use [Husky](https://typicode.github.io/husky/) which plugs into Git by registering a hook to call [commitlint](https://commitlint.js.org/) to validate the format of the messages.
