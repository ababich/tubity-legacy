class Counter

  # originally aplhabet is 64 symbols:
  #          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"
  # and is a bit shuffled to be more interesting

  ALPHABET = "akybrPzq1S7cFe9IZR0V2f-mlQ3NWuiGnhgY_wOX6o4tUHCxDEjLMA5TBdJ8pvsK"

  ALPHABET_SKIPPABLE = "-_"
  ALPHABET_EXTRA     = /\d/

  #database jeys of global counters
  KEY = "Tubity:Counter"
  KEY_DICTIONARY = "Tubity:Dictionary"

  def self.get_hash
    hash = Ohm.redis.get(KEY)
    new_hash = next_hash_with_dictionary(hash, ALPHABET)
    Ohm.redis.set(KEY, new_hash)

    new_hash
  end


  private

  def self.next_hash_with_dictionary(current, alphabet)
    words = []
    new = current

    while words.empty?
      new = next_hash(new, alphabet)
      words = new.delete(ALPHABET_SKIPPABLE)\
                 .split(ALPHABET_EXTRA)\
                 .select{|w| !w.empty? && !Ohm.redis.sismember(KEY_DICTIONARY, w)}
    end

    new
  end

  def self.next_hash(current, alphabet)
    return alphabet.first * 3 unless current

    new = current.dup
    h_index = new.length
    a_index = alphabet.length

    while a_index == alphabet.length
      h_index -= 1
      new << alphabet.first and break if h_index < 0

      last = new[h_index]
      a_index = alphabet.index(last) + 1

      new[h_index] = alphabet[a_index % alphabet.length]
    end

    new
  end
end
