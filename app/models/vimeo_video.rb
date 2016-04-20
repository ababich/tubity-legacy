class VimeoVideo

  class << self

    def get_id(url)
      return nil unless url =~ /(vimeo.com)[\D]+(\d+)/
      video_id = $2

      begin
        video = Vimeo::Simple::Video.info(video_id).first
        [video['id'], video]
      rescue
        nil
      end
    end

    def init(video, opts) #, url)
      vv = opts[:video_obj]

      video.service       = TubityLink::SERVICES[:vimeo]
      video.service_id    = opts[:service_id]
      video.url           = vv['url']

      video.title         = vv['title']

      video.uploaded_time = vv['upload_date']
      video.duration      = vv['duration']

      video.author        = vv['user_name']

      video.width         = vv['width']
      video.height        = vv['height']

      video.save

      #setup images
      setup_thumbs video, vv


      video.dump_data! vv
    end


    def setup_thumbs(video, vv)
      thumbs = [
              {key: "thumbnail_small",  width: 100},
              {key: "thumbnail_medium", width: 200},
              {key: "thumbnail_large",  width: 640}
      ]
      ratio = video.height.to_f / video.width.to_f

      thumbs.each do |vthumb|
        thumb = TubityLink.new

        thumb.init_thumb(video.service, vv[vthumb[:key]])

        thumb.parent  = video

        thumb.width = vthumb[:width]
        thumb.height = (vthumb[:width] * ratio).round

        thumb.duration = thumb.width #stub to make them uniq by duration => important for output

        thumb.save

        video.thumbs << thumb
      end
    end

  end
end