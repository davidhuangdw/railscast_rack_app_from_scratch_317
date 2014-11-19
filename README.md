        # test
        require_relative '../lib/greeter'
        require 'rack'

        describe Greeter do
          let(:request) {Rack::MockRequest.new(subject)}            # use MockRequest
          it 'returns a 404 response for unknown request' do
            expect(request.get('/unknown').status).to be 404
          end
          it '/ displays Hello World by default' do
            expect(request.get('/').body).to include 'Hello World!'
          end
          it '/ displays Hello World by default' do
            expect(request.get('/', 'HTTP_COOKIE'=>'greet=Ruby').body).to include 'Hello Ruby!'
          end
          it '/change sets cookie and redirects to root' do
            response = request.post('/change', params:{name:'Ruby'})
            expect(response.status).to be 302
            expect(response['Location']).to eq '/'
            expect(response['Set-Cookie']).to include 'greet=Ruby'
          end
        end

        # auth
        use Rack::Auth::Basic  do |user, password|
          password == 'secret'
        end

        # example
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

        # render haml
        gem 'haml'
        class Greeter
          def render(template_file, **locals)
            path=File.expand_path("../views/#{template_file}.haml",__FILE__)
            Haml::Engine.new(File.read(path)).render

            # for locals
            Haml::Engine.new(File.read(path)).render(self)              # access self's method
            Haml::Engine.new(File.read(path)).render(self, name:'hi')
          end
          def name
            @request.cookies["greet"]||'david'
          end
        end


        # auto-reload(watch files)
        use Rack::Reloader,0

        # basic
        rackup -Ilib          # will run config.ru; '-Ilib' include '.rb' for require
        # config.ru
        class Greeter
          def call(env)
            Rack::Response.new('Hello')
          end
        end
        obj = Greeter.new
        obj = ->(env){...}
        use Rack::Reloader,0
        use ...                     # use middlewares
        run obj                     # will call obj.call(env)