# Bunto Avatar

*A Bunto plugin for rendering GitHub avatars*

[![Build Status](https://travis-ci.org/bunto/bunto-avatar.svg)](https://travis-ci.org/bunto/bunto-avatar)

Bunto Avatar makes it easy to add GitHub avatars to your Bunto site by specifying a username. If performance is a concern, Bunto Avatar is deeply integrated with the GitHub avatar API, ensuring avatars are cached and load in parallel. It even automatically upgrades users to Retina images, when supported.

## Installation

Add the following to your site's `Gemfile`:

```ruby
gem 'bunto-avatar'
```

And add the following to your site's `_config.yml` file:

```yaml
gems:
  - bunto-avatar
```

## Usage

Simply add the following, anywhere you'd like a user's avatar to appear:

```
{% avatar [USERNAME] %}
```

With `[USERNAME]` being the user's GitHub username:

```
{% avatar hubot %}
```

That will output:

```html
<img class="avatar avatar-small" src="https://avatars3.githubusercontent.com/hubot?v=3&amp;s=40" alt="hubot" srcset="https://avatars3.githubusercontent.com/hubot?v=3&amp;s=40 1x, https://avatars3.githubusercontent.com/hubot?v=3&amp;s=80 2x, https://avatars3.githubusercontent.com/hubot?v=3&amp;s=120 3x, https://avatars3.githubusercontent.com/hubot?v=3&amp;s=160 4x" width="40" height="40" />
```

### Customizing

You can customize the size of the resulting avatar by passing the size argument:

```
{% avatar hubot size=50 %}
```

That will output:

```html
<img class="avatar" src="https://avatars3.githubusercontent.com/hubot?v=3&amp;s=50" alt="hubot" srcset="https://avatars3.githubusercontent.com/hubot?v=3&amp;s=50 1x, https://avatars3.githubusercontent.com/hubot?v=3&amp;s=100 2x, https://avatars3.githubusercontent.com/hubot?v=3&amp;s=150 3x, https://avatars3.githubusercontent.com/hubot?v=3&amp;s=200 4x" width="50" height="50" />
```

### Passing the username as variable

You can also pass the username as a variable, like this:

```
{% assign username="hubot" %}
{% avatar {{ username }} %}
```

Or, if the variable is someplace a bit more complex, like a loop:

```
{% assign employees = "alice|bob" | split:"|" %}
{% for employee in employees %}
  {% avatar user=employee %}
{% endfor %}
```
