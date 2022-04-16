require 'telegram/bot'
require 'json'
require_relative 'chuck_norris.rb'

class Bot
  def initialize
    telegram_bot_token = ENV['TELEGRAM_BOT_ONEBITCODE']
    lastests_memes = []
    lastests_quizzes = []
    quizzes = File.read('quiz.json')
    quizzes_parsed = JSON.parse(quizzes)
    Telegram::Bot::Client.run(telegram_bot_token) do |bot|
      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          case message.text
          when '/site', '/site@onebitcode_bot'
            bot.api.send_message(chat_id: message.chat.id, 
              text: "<b>Site oficial OneBitCode 🤘</b>\nhttps://onebitcode.com/", parse_mode: "HTML")
          when '/instagram', 'instagram@onebitcode_bot'
            bot.api.send_message(chat_id: message.chat.id, 
              text: "<b>Instagram OneBitCode 🤘 </b>\nNovos posts irados todos dias!\nhttps://www.instagram.com/onebitcode/", parse_mode: "HTML")
          when '/youtube', '/youtube@onebitcode_bot'
            bot.api.send_message(chat_id: message.chat.id, 
              text: "<b>OneBitCode está no Youtube também 🤘</b>\n" + 
              "<a href='https://www.youtube.com/channel/UC44Mzz2-5TpyfklUCQ5NuxQ'><b>Acesse o canal OneBitCode</b></a>\n" +
              "Veja também:\n👉 <a href='https://www.youtube.com/watch?v=2js9Q_BMD-8&list=PLdDT8if5attEOcQGPHLNIfnSFiJHhGDOZ'>Curso de Ruby</a>\n" +
              "👉 <a href='https://www.youtube.com/watch?v=_J-c5yAugpU&list=PLdDT8if5attGp7S63lMS-Vj6qgpvmnTvi'>OneBitCode HandsOn</a>\n" +
              "👉 <a href='https://www.youtube.com/watch?v=EqOoElCjpNI&list=PLdDT8if5attHadvt0bVyW6TaQvD4c64xn'>API Rails Completa</a>", 
              parse_mode: "HTML", disable_web_page_preview: true)
          when '/meme', '/meme@onebitcode_bot'
            meme = Dir["memes/*"].sample
            while lastests_memes.include? meme
              meme = Dir["memes/*"].sample
            end
            lastests_memes << meme
            extension = meme.split('.')[1]
            if %(png jpg jpeg webp).include? extension
              bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new(meme, "image/#{extension}"))
            else
              bot.api.send_document(chat_id: message.chat.id, document: Faraday::UploadIO.new(meme, "image/#{extension}"))
            end
            if lastests_memes.length == 20
              lastests_memes.slice!(0..9)
            end
          when '/chuck', '/chuck@onebitcode_bot'
            chuck = ChuckNorris.new.get_joke
            bot.api.send_message(chat_id: message.chat.id, 
              text: "<b>Chuck Norris Joke:</b> #{chuck}", parse_mode: "HTML")
          when '/joke', '/joke@onebitcode_bot'
            joke = Joke.new(['single', 'twopart'].sample)
            jokes = joke.run
            if joke.type == 'twopart'
              bot.api.send_message(chat_id: message.chat.id, 
                text: "<b>- #{jokes[0]}</b>\n\n- #{jokes[1]}", parse_mode: "HTML")
            else
              bot.api.send_message(chat_id: message.chat.id, 
                text: "#{jokes[0]}")
            end
          when '/quiz', '/quiz@onebitcode_bot'
            quiz = quizzes_parsed.sample
            while lastests_quizzes.include? quiz
              quiz = quizzes_parsed.sample
            end
            lastests_quizzes << quiz
            if quiz.key?('explanation')
              bot.api.send_poll(chat_id: message.chat.id, 
                question: quiz['question'], 
                options: quiz['options'], 
                correct_option_id: quiz['correct_option_id'],
                explanation: quiz['explanation'],
                explanation_parse_mode: "HTML",
                is_anonymous: true,
                type: 'quiz')
            else
              bot.api.send_poll(chat_id: message.chat.id, 
                question: quiz['question'], 
                options: quiz['options'], 
                correct_option_id: quiz['correct_option_id'],
                is_anonymous: true,
                type: 'quiz')
            end
            if lastests_quizzes.length == 30
              lastests_quizzes.slice!(0..15)
            end
          end
        end
      end
    end
  end
end