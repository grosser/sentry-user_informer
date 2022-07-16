Show exception ids on error pages and headers, so users or support can track them down faster

![Example](https://raw.githubusercontent.com/grosser/sentry-user_informer/master/example.png)

Install
=======

```Bash
gem 'sentry-user_informer'
```

Usage
=====

```Ruby
# Gemfile
gem 'sentry-user_informer'

# config/initializers/sentry.rb
Sentry.configure do |config|
  ... regular config ...
end

# optional: customize placeholder (make sure it matches public/500.html)
# Sentry::UserInformer.placeholder = '<!-- SENTRY-USER-INFORMER -->'

# optional: customize template
# Sentry::UserInformer.template = # replaces `placeholder` on 500 pages
#   "<br/><br/>Error number: <a href='https://sentry.io/organizations/foo/issues/?query=%{event_id}'>%{event_id}</a>"

# public/500.html
<!-- SENTRY-USER-INFORMER -->
```

Details
=======
- adds a new middleware to render placeholder
- modifies `Sentry::Rails::Middleware` to store the exceptions it sends to sentry

middleware basically ends up like this:
```
use Sentry::UserInformer::ExceptionRenderer # replace placeholder
use ActionDispatch::ShowExceptions          # render 500.html
use Sentry::Rails::CaptureExceptions        # store exception
```

Development
===========
- run tests: `bundle && rake default integration` (github actions cannot run integration tests)
- example app: `cd example && bundle && rails s` then go to `localhost:3000` or `localhost:3000/error`

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![coverage](https://img.shields.io/badge/coverage-100%25-success.svg)](https://github.com/grosser/single_cov)
