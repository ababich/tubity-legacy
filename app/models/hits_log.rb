class HitsLog < ActiveRecord::Base

  include BelongsToTubityLink

  REDIS_KEY = "Tubity:HitsLog"
  include Cacheable

end
