require 'greeter'

use Rack::Reloader,0

run Greeter.new