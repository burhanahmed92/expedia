class HomeController < ApplicationController
	def index
		if params[ :term]
			@api = Expedia::Api.new
			find_hotel
			find_cities
 			render json: [@cities].flatten.collect{|e| {label: e, category: "Cities"}} +[@names].flatten.collect{|e| {label: e, category: "Hotel name"}} + [label: '', category: 'Airports']
		end
	end

	protected
	def find_cities
		response = @api.geo_search({:destinationString => params[:term]})
		@location_info = response.body["LocationInfoResponse"]["LocationInfos"]["LocationInfo"]
		@cities = if @location_info.class == Hash
			@location_info["city"]
		else
			@location_info.collect{|e| e["city"]}
		end
	end

	def find_hotel
		response = @api.get_list({:propertyName => params[:term], :destinationString => 'berlin'})
		@names = response.body["HotelListResponse"]["HotelList"]["HotelSummary"].collect{|e| e["name"]}
	end
end
