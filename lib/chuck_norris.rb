require 'net/http'
require 'json'

class ChuckNorris
  
  API_ENDPOINT = 'https://api.chucknorris.io/jokes/random'

  def run
    make_request
    get_joke
  end

  private 

  def make_request
    uri = URI(API_ENDPOINT)
    response = Net::HTTP.get(uri)  
    @result = JSON.parse(response)
  end

  def get_joke
    joke = @result['value']
  end
end