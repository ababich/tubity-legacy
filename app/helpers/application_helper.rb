module ApplicationHelper

  def service_icon(service)
    case service
      when TubityLink::SERVICES[:youtube] then
        "http://s.ytimg.com/yt/img/creators_corner/YouTube/youtube_24x24.png"
      when TubityLink::SERVICES[:vimeo] then
        full_url "assets/vimeo.png"
      when TubityLink::SERVICES[:dailymotion] then
        full_url "assets/dailymotion.jpg"
    end
  end

  def full_url(url)
    url = url.last(url.size - 1) if url.starts_with?('/') #remove first "/" from path if exists

    "#{root_url}#{url}"
  end

  def lang_badge(lang = :en)
    render partial: 'root/lang', locals: {lang: lang}
  end

end
