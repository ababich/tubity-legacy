class RootController < ApplicationController


  skip_before_filter :predefine_background, :except => [:index, :api]
  skip_before_filter :set_locale, :except => [:index, :api]

  def lang
    session[:locale] = params[:lang]

    redirect_to request.headers["Referer"] ? :back : root_path
  end

  def redirect
    link = TubityLink.find(hash: params[:key]).to_a.first

    if link
      link.incr :hits

      register_openstat!

      HitsLog.cache! tubity_link_id: link.id,
                     remote_ip: request.remote_ip,
                     referer: request.referer,
                     remote_host: request.headers["REMOTE_HOST"],
                     user_agent: request.headers["HTTP_USER_AGENT"],
                     http_cookie: request.headers["HTTP_COOKIE"]

      redirect_to link.url
    else
      redirect_to root_url
    end
  end

  private

  def register_openstat!
    # register in Openstat
    #RestClient.get "http://openstat.net/cnt", {
    #        cid: 2227313,
    #        p: 3, # count as site exits, not site pages
    #        pg: request.url,
    #        r: request.referer
    #}

    url = "http://openstat.net/cnt"
    params = {
            cid: 2227313,
            p: 3, # count as site exits, not site pages
            pg: request.url,
            r: request.referer
    }

    begin
      RestClient.get "#{url}?#{params.to_query}"
    rescue Exception => e
      Rails.logger.error e.message
    end

  end
end