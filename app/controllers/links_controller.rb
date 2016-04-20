class LinksController < ApplicationController
  skip_before_filter :predefine_background
  skip_before_filter :set_locale


  def url
    @url = params[:video_link].to_s.strip
    @link = get_video_link(@url)

    @partial = @link ? "url" : "cannot_parse"
  end

  def caption_switch
    session[:no_caption] =! session[:no_caption]
  end


  private

  def get_video_link(url)
    return nil unless url

    service = get_service(url)

    return nil unless service

    get_link(service, url)
  end


  def get_service(url)
    return TubityLink::SERVICES[:youtube]     if url.include?("youtu") || url.length == 11
    return TubityLink::SERVICES[:vimeo]       if url.include? "vimeo"
    return TubityLink::SERVICES[:dailymotion] if url.include? "dailymotion"

    nil
  end

  def get_link(service, url)
    id, video_obj = get_id(service, url)

    video = TubityLink.find(service: service, service_id: id).to_a.first
    video = TubityLink.get_new_video(service: service,
                                     service_id: id,
                                     url: url,
                                     video_obj: video_obj) if video.nil? && id

    video
  end

  def get_id(service, url)
    case service
      when TubityLink::SERVICES[:youtube] then
        YoutubeVideo.get_id(url)
      when TubityLink::SERVICES[:vimeo] then
        VimeoVideo.get_id(url)
      when TubityLink::SERVICES[:dailymotion] then
        DailymotionVideo.get_id(url)
      else
        nil
    end
  end

end