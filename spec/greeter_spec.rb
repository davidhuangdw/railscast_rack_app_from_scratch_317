require_relative '../lib/greeter'
require 'rack'

describe Greeter do
  let(:request) {Rack::MockRequest.new(subject)}
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