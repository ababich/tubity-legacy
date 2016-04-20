Tubity::Application.routes.draw do


  post "/u" => "links#url", via: :post
  post "/c" => "links#caption_switch", as: :caption_switch

  get "/a" => "root#api", as: :api

  get "/:lang" => "root#lang", lang: /ru|en/, as: :lang

  get "/*key" => "root#redirect"

  root :to => "root#index"
end
