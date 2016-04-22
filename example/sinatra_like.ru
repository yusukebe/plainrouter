$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'plainrouter/method'
require 'rack'

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
