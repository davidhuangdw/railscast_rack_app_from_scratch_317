require 'haml'
gem 'rack'

class Greeter
  attr_reader :request
  def call(env)
    @request = Rack::Request.new(env)
    case request.path
      when '/'
        response render('index')
      when '/change'
        response request.params['name'] do |res|
          res.set_cookie("greet", request.params['name'])
          res.redirect("/")
        end
      else
        response "Not Found", 404
    end
  end

  def render(template, **locals)
    path = File.expand_path("../views/#{template}.haml", __FILE__)
    Haml::Engine.new(File.read(path)).render(self)
  end

  def response(*args, &blk)
    Rack::Response.new(*args, &blk)
  end
  def name
    request.cookies["greet"] || "Guest"
  end
end


