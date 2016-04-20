root = global? this

$(->
          $('#video_link').observe_field 0.25, ->
            $('#video_link_form').submit()
)


namespace "Tubity", (exports, top) ->
  exports.call = (url) ->
    $.post url

  class exports.Link

    SELECTED_CLASS: "selected"

    MOVIE_MASK: "tubity_movie_url"
    THUMB_MASK: "tubity_thumb_url"

    CAPTION_MASK: "tubity_caption"
    MOVIE_TEXT_MASK: "tubity_movie_text_url"
    SERVICE_ICON_MASK: "tubity_service_icon_url"


    FORUM_LINK: "[URL=#{Link::MOVIE_MASK}][IMG]#{Link::THUMB_MASK}[/IMG]#{Link::CAPTION_MASK}[/URL]"
    FORUM_CAPTION: " [IMG]#{Link::SERVICE_ICON_MASK}[/IMG] #{Link::MOVIE_TEXT_MASK}"

    HTML_LINK: "<a href=\"#{Link:: MOVIE_MASK}\" target=\"_blank\" title=\"YouTube video via Tubity video link shortener service\"><img src=\"#{Link::THUMB_MASK}\"/>#{Link::CAPTION_MASK}</a>"
    HTML_CAPTION: " <img src=\"#{Link::SERVICE_ICON_MASK}\"/> #{Link::MOVIE_TEXT_MASK}"

    TWITTER_LINK: "#{Link:: MOVIE_MASK}#{Link::CAPTION_MASK}"
    TWITTER_CAPTION: " #{Link::MOVIE_TEXT_MASK}"

    constructor: ->
      self = @

      $('#thumbs tr.thumb').click ->
        $('#thumbs tr.thumb').removeClass(Link:: SELECTED_CLASS)

        self.prepare_links($(this))

      $('#links input[type="text"]').click ->
        this.select()

      $('#thumbs tr.thumb :first').click()



    prepare_links: (thumb) =>
      thumb.addClass(Link:: SELECTED_CLASS)

      @service_icon_url = $('#service_icon').html().trim()
      @movie_text = $('#movie_text').html().trim()
      @movie_url = $('#link_direct').val()
      @thumb_url = thumb.find('img').first().attr('src')
      @no_caption = eval $('#no_caption').html().trim()

      $('#link_forum').val @forum_link
      $('#link_html').val @html_link
      $('#link_twitter').val @twitter_link


    thumb_link_link: (link_mask, caption_mask) =>
      caption = ""
      caption = caption_mask.replace(Link::MOVIE_TEXT_MASK, @movie_text)
                             .replace(Link::SERVICE_ICON_MASK, @service_icon_url) unless @no_caption

      link_mask.replace(Link::MOVIE_MASK, @movie_url)
                .replace(Link::THUMB_MASK, @thumb_url)
                .replace(Link::CAPTION_MASK, caption)


    forum_link: =>
      @thumb_link_link(Link::FORUM_LINK, Link::FORUM_CAPTION)

    html_link: =>
      @thumb_link_link(Link::HTML_LINK, Link::HTML_CAPTION)

    twitter_link: =>
      @thumb_link_link(Link::TWITTER_LINK, Link::TWITTER_CAPTION)
