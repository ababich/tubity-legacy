class LinksLog < ActiveRecord::Base

  include BelongsToTubityLink

  REDIS_KEY = "Tubity:LinksLog"
  include Cacheable

end
