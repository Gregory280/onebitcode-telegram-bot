module Meme

  @@lastests_memes = []
  
  def self.send_meme
    meme = Dir["memes/*"].sample
    while @@lastests_memes.include? meme
      meme = Dir["memes/*"].sample
    end
    @@lastests_memes << meme
    if @@lastests_memes.length == 20
      @@lastests_memes.slice!(0..9)
    end
    return meme
  end

end