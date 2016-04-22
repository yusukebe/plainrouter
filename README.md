# PlainRouter

[![Build Status](https://travis-ci.org/yusukebe/plainrouter.svg?branch=master)](https://travis-ci.org/yusukebe/plainrouter)

PlainRouter is a **fast** and **simple** routing engine for Ruby. Using `PlainRouter::Method`, you can quickly make web application framework like Sinatra. PlainRouter is a porting project of [Route::Boom](https://metacpan.org/pod/Router::Boom).

## Install

Add this line to your application's Gemfile:

```
gem 'plainrouter'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install plainrouter
```

## Usage

Here is synopsis of using **PlainRouter**

```ruby
router = PlainRouter.new
router.add('/', 'dispatch_root')
router.add('/entries', 'dispatch_entries')
router.add('/entries/:id', 'dispatch_permalink')
router.add('/users/:user/{year}', 'dispatch_year')
router.add('/users/:user/{year}/{month:\d+}', 'dispatch_month')

dest, captured = router.match(env['PATH_INFO'])
```

**PlainRouter::Method** supports HTTP methods. Sinatra-like Web Framework and Application are below

```ruby
class SinatraLikeFramework
  def initialize
    @router = PlainRouter::Method.new
    self.routes
  end
  def routes
  end
  def get(path, &block)
    @router.add('GET', path, block)
  end
  def call(env)
    block, params = @router.match(env['REQUEST_METHOD'], env['PATH_INFO'])
    unless block.instance_of?(Proc)
      return not_found
    end
    response = block.call(params)
    if response.instance_of?(Array)
      return response
    elsif response.instance_of?(String)
      return [200, {"Content-Type" => "text/plain"}, [res]]
    end
    not_found
  end
  def not_found
    [404, {"Content-Type" => "text/plain"}, ['Not Found']]    
  end
end

class SinatraLikeApplication < SinatraLikeFramework
  def routes
    get '/' do
      'Hello World!'
    end
    get '/user/:name' do |params|
      "Hello #{params['name']}!"
    end
  end
end

run SinatraLikeApplication.new
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## See Also

* [Rooter::Boom](https://metacpan.org/pod/Router::Boom)
* [rack-router](https://github.com/pjb3/rack-router)

## Author

Yusuke Wada <https://github.com/yusukebe>

