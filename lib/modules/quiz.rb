require 'json'

module Quiz
  
  file_quiz = File.read('quiz.json')
  QUIZES = JSON.parse(file_quiz)
  @@lastests_quizes = []

  def self.send_quiz
    
    quiz = QUIZES.sample
    while @@lastests_quizes.include? quiz
      quiz = QUIZES.sample
    end
    @@lastests_quizes << quiz
    if @@lastests_quizes.length == 34
      @@lastests_quizes.slice!(0..17)
    end
    return quiz
  end
  
end