require 'greeter'

use Rack::Reloader,0
# use Rack::File.new('public')

# run Greeter.new

use Rack::Auth::Basic  do |user, password|
  password == 'secret'
end

run Greeter.new
# run Rack::Cascade.new([Rack::File.new('public'), Greeter.new])
# run Rack::File.new('public')