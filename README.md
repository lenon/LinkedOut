# LinkedOut

LinkedIn has become unbearable, so I wrote this script to mass unfollow all
connections there. The script is written in Ruby using Capybara and Selenium
Webdriver, so it opens up a browser window (Chrome) to take actions through the
UI the same way you would, but much faster.

Feel free to use it as you like.

## Requirements

* Ruby. You can install it with [rbenv/ruby-build][ruby-build].
* Google Chrome.

## Installation

Clone the repo:

```
git clone git@github.com:lenon/LinkedOut.git && cd LinkedOut
```

Install the correct Ruby with `rbenv`:

```
rbenv install
```

And then install all Ruby dependencies with `bundler`:

```
bundle install
```

## Usage

Just run the following command:

```
bundle exec ruby linkedout.rb
```

Fill in your credentials and the script will start unfollowing everyone.

[ruby-build]: https://github.com/rbenv/ruby-build#readme
