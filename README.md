# danger-clubhouse

A pull request plugin to [danger.systems](http://danger.systems) that
links to stories from [Clubhouse](https://app.clubhouse.io) to
[GitHub](https://github.com/).

## Why?

Clubhouse currently only supports [one-way linking](https://help.clubhouse.io/hc/en-us/articles/207540323-Using-The-Clubhouse-GitHub-Integration) from Clubhouse to
GitHub. As part of our GitHub workflow, we need to link to stories in
Clubhouse so that reviewer will have more context about the pull request.

This danger plugin does exactly that :)

## How?

The plugin will parse branch name, commit messages, Pull Request 
description, Pull Request comments and find the pattern of `chXXXX` where `XXXX`
is the story id to Clubhouse. Then, it will link to all the stories 
as a separated message in the format of
`https://app.clubhouse.io/#{organization}/story/#{id}` for each story.

## Example

![Screen Shot](/pictures/screenshot.png?raw=true)

## Installation

Add `danger-clubhouse` to your Gemfile.

```
gem 'danger-clubhouse'
```

## Usage

### clubhouse.organization

Set the orgazination name for Clubhouse.

### clubhouse.link_stories!

Find stories in the format of `chXXX` from branch name, commit messages, Pull Request 
description, Pull Request comments. Then, it will link to all the stories.

## Thanks

* Plugin example by [dblock](https://github.com/dblock) from the [danger
  changelog plugin](https://github.com/dblock/danger-changelog).

## Contact

You can find me at [siong.com](https://siong.com).

## Copyright

Copyright (c) Teng Siong Ong, 2016

MIT License, see [LICENSE](LICENSE.txt) for details.
