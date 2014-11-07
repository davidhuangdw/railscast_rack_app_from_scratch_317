require 'haml'
gem 'rack'

class Greeter
  def call(env)
    request = Rack::Request.new(env)
    case request.path
      when '/'
        response render('index')
      when '/change'
        response request.params['name']
      else
        response "Not Found", 404
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}.haml", __FILE__)
    Haml::Engine.new(File.read(path)).render
  end

  def response(*args)
    Rack::Response.new(*args)
  end
end


