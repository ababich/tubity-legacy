class TubityLink < Ohm::Model

  SERVICES = {:thumb => 't',

              :youtube => 'y',
              :vimeo => 'v',
              :dailymotion => 'd'
  }

  require 'ohm/contrib'
  require 'counter'
  require 'links_log'

  include Ohm::Callbacks
  include Ohm::WebValidations
  include Ohm::ExtraValidations

  attribute :hash
  attribute :url

  attribute :service # from lib/type
  attribute :service_id # an id in external service for video only

  reference :parent, TubityLink #and id of parent Link when current object is for thumb
  collection :thumbs, TubityLink, :parent #child images for the Link (with TYPE = 'i' only

  attribute :title

  attribute :width # in pixels
  attribute :height # in pixels

  attribute :uploaded_time # uploaded to service time
  attribute :duration # in seconds for video, thumb time for images if exists

  attribute :author # hash with at least :name key

  index :hash
  index :parent
  index :service
  index :service_id


  counter :hits


  before :create, :get_hash!

  def validate
    assert_present :url
    assert_url :url

    assert_member :service, SERVICES.values
  end

  def get_hash!
    self.hash = Counter.get_hash
  end

  def self.get_new_video(opts)
    begin
      new_video = self.create
      new_video.init_video(opts)

      new_video
    rescue Exception => e
      Rails.logger.fatal e.message
      Rails.logger.fatal e.backtrace.inspect

      nil
    end
  end


  def init_video(opts)
    case opts[:service]
      when SERVICES[:youtube] then
        YoutubeVideo.init(self, opts)
      when SERVICES[:vimeo] then
        VimeoVideo.init(self, opts)
      when SERVICES[:dailymotion] then
        DailymotionVideo.init(self, opts)
    end
  end

  def init_thumb(service, url)
    self.service = SERVICES[:thumb]
    self.url = url
  end


  def dump_data!(object)
    LinksLog.cache! tubity_link_id: self.id,
                    compressed_data: Zlib::Deflate.deflate(YAML::dump(object), Zlib::BEST_COMPRESSION)
  end

  def readable_duration
    units = [24, 60, 60].reverse.inject([self.duration.to_i]) { |result, unitsize|
      result[0, 0] = result.shift.divmod(unitsize)
      result
    }

    res = units.last(3).map { |s| "%02d" % s }.join(":")
    res = "#{units.first} days #{res}" if units.first > 0

    res
  end

end
