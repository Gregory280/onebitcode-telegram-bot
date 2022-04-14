require 'net/http'
require 'json'

class Joke
  @result = nil
  def initialize
    @result = make_request
  end
  def make_request
    url = 'https://v2.jokeapi.dev/joke/Programming?type=twopart'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
  end
  def get_joke
    setup = @result['setup']
    delivery = @result['delivery']
    return setup, delivery
  end
end