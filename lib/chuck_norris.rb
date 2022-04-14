require 'net/http'
require 'json'

class ChuckNorris
  @result = nil
  def initialize
    @result = make_request
  end
  def make_request
    url = 'https://api.chucknorris.io/jokes/random'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
  end
  def get_joke
    return @result['value']
  end
end