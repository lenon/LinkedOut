# LinkedOut

LinkedIn has become unbearable, so I wrote this script to mass unfollow all
connections there. Feel free to use it as you like.

## Requirements

* Ruby. You can install it with [rbenv/ruby-build][ruby-build].
* Google Chrome and [chromedriver][chromedriver].

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
[chromedriver]: https://chromedriver.chromium.org/downloads
