class DailymotionVideo

  class << self

    def get_id(url)
      return nil unless url =~ /(dailymotion.com)(.+)(video\/([^_]+)+)/
      video_id = $4

      begin
        video = get_video(video_id)
        [video['id'], video]
      rescue
        nil
      end
    end

    def init(video, opts) #, url)
      dv = opts[:video_obj]

      video.service       = TubityLink::SERVICES[:dailymotion]
      video.service_id    = opts[:service_id]
      video.url           = dv['url']

      video.title         = dv['title']

      video.uploaded_time = Time.at(dv['created_time'].to_i)
      video.duration      = dv['duration']

      video.author        = dv['owner.username']

      video.save

      #setup images
      setup_thumbs video, dv


      video.dump_data! dv
    end


    def setup_thumbs(video, dv)
      thumbs = [
              {key: "thumbnail_small_url",  width: 80},
              {key: "thumbnail_medium_url", width: 160},
              {key: "thumbnail_large_url",  width: 320}
      ]

      thumbs.each do |dthumb|
        thumb = TubityLink.new

        thumb.init_thumb(video.service, dv[dthumb[:key]])

        thumb.parent  = video

        thumb.width = dthumb[:width]

        thumb.duration = thumb.width #stub to make them uniq by duration => important for output

        thumb.save

        video.thumbs << thumb
      end
    end


    private

    def get_video(video_id)
      url = "https://api.dailymotion.com/video/#{video_id}?fields="

      url << %w(created_time id duration owner.username title url
                thumbnail_large_url thumbnail_medium_url thumbnail_small_url).join(',')

      res = RestClient.get(url)

      return if res.code != 200
      JSON.parse res
    end

  end
end