class YoutubeVideo

  class << self

    def get_id(url)
      #url = url.dup
      #
      ##BAD featured fix
      #url.gsub!($1, "") if url =~ /\?(.+)(v=)/
      #
      ## complex url from http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      ## extended with "vi" variant
      #res = (url =~ /^.*((youtu.be\/)|(v\/)|(vi\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/) ? $8 : url
      #
      #
      ##youtube IDs are always 11 alphanumeric chars
      #return nil unless res =~ /^[\w\-_]{11}$/
      #
      #res

      # YouTubeIt method
      begin
        video = YouTubeIt::Client.new.video_by url
        [video.unique_id, video]
      rescue
        nil
      end
    end

    def init(video, opts) #, url)
      yv = opts[:video_obj]

      video.service       = TubityLink::SERVICES[:youtube]
      video.service_id    = opts[:service_id]
      video.url           = yv.player_url.gsub "youtube_gdata_player", "tubity"
#      video.url           = "http://www.youtube.com/watch?v=#{video.service_id}" # can use input var: url

      video.title         = yv.title

      video.uploaded_time = yv.published_at
      video.duration      = yv.duration

      video.author        = yv.author.name

      video.save

      #setup images
      setup_thumbs(video, yv.thumbnails)


      video.dump_data! yv
    end


    def setup_thumbs(video, thumbs)
      thumbs = [thumbs] unless thumbs.is_a? Array

      thumbs.each do |ythumb|
        thumb = TubityLink.new

        thumb.init_thumb(video.service, ythumb.url)

        thumb.parent  = video

        #thumb.title = ythumb.attributes['yt:name']
        thumb.duration = ythumb.time #if ythumb.attributes.has_key? :time
        thumb.width = ythumb.width
        thumb.height = ythumb.height

        thumb.save

        video.thumbs << thumb
      end
    end

  end
end