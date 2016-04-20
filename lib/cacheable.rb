module Cacheable

  def self.included(klass)
    klass.class_eval do

      extend ClassMethods
    end
  end

  module ClassMethods

    def cache!(hash)
      hash.merge!({time: Time.now})

      Ohm.redis.rpush(self::REDIS_KEY, hash.to_yaml)
    end


    def dump_cache!
      while hash = Ohm.redis.lpop(self::REDIS_KEY) do
        hash = YAML::load(hash)
        hash.each{|k, v| v.encode!("UTF-8") if v.is_a?(String)}

        created_at = hash.delete(:time)

        instance = self.new hash
        instance.created_at = created_at

        instance.save!
      end
    end
  end

end