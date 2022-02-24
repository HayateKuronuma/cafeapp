class SearchesController < ApplicationController
  require 'httpclient'

  def top
    
  end

  def around_shops
    @lat = params[:lat]
    @lng = params[:lng]
    client = HTTPClient.new
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    query = {
      "key" => Rails.application.credentials.api[:hotpepper_api],
      "lat" => @lat,
      "lng" => @lng,
      "pet" => 1,
      "format": "json"
    }
    response = client.get(url, query)
    @results = JSON.parse(response.body)
    @shops = @results['results']['shop']
    render partial:'ajax_shops', locals: { shops: @shops }
  end
end
