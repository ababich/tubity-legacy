require 'counter'

files = Dir["#{Rails.root}/db/dictionary/*"]
sizes = [3, 4]

files.each do |filename|
  puts filename

  File.open filename do |file|
    until file.eof do
      word = file.readline

      if word.valid_encoding?
        word = word.strip.downcase.split(/\W/).first

        if sizes.include? word.length
          puts word
          Ohm.redis.sadd(Counter::KEY_DICTIONARY, word)
        end
      end
    end
  end
end
