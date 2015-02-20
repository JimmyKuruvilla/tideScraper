
require 'uri'
require 'net/http'
require 'json'

class TideScraper
	attr_accessor :product, :application, :station, :begin_date, :end_date, :datum, :units, :time_zone, :format, :response, :station_list

	def initialize
		@host_path={host: "tidesandcurrents.noaa.gov", path: "/api/datagetter"}
		@product = "hourly_height"
		@application = "NOS.COOPS.TAC.WL"
		@station = "8735180"
		@begin_date = "20130217"
		@end_date = "20140217"
		@datum = "MLLW"
		@units = "english"
		@time_zone = "GMT"
		@format = "csv"
		@query_params={product: "#{product}", application: "#{application}", station: "#{station}", begin_date: "#{begin_date}", end_date: "#{end_date}",  datum: "#{datum}", units: "#{units}", time_zone: "#{time_zone}", format: "#{format}" }

		@station_list = ["8735180", "8531680", "8519483"] ##fill in this array with station ids as Strings
	end

	def scrape(station, begin_date, end_date)
		@station = station
		@begin_date = begin_date
		@end_date = end_date

		uri=URI::HTTP.build(@host_path)
		uri.query=URI.encode_www_form(@query_params)
		@response=Net::HTTP.get(URI(uri.to_s))
	end

	def writeFile
		f = File.open("#{@station}.#{begin_date}-#{end_date}.csv", "w")
		f.write(@response)
		f.close
	end


end


Tidester = TideScraper.new
Tidester.station_list.each do |station|
	Tidester.scrape(station, Tidester.begin_date, Tidester.end_date)
	Tidester.writeFile
	end
