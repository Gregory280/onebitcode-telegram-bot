require 'net/http'
require 'json'

class Trivia

  API_ENDPOINT = 'https://opentdb.com/api.php?amount=2&category=18&type=boolean'

  def run
    make_request
    get_trivias
  end

  private
  def make_request
    uri = URI(API_ENDPOINT)
    response = Net::HTTP.get(uri)  
    @result = JSON.parse(response)
  end

  def get_trivias
    trivias = []
    @result['results'].each do |trivia|
      trivias << trivia.slice("question", "difficulty", "correct_answer")
    end
    return trivias
  end
end