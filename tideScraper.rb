
require 'uri'
require 'net/http'
require 'json'

class TideScraper
	attr_accessor :product, :application, :station, :datum, :units, :time_zone, :format, :response, :station_list, :years, :begin_month, :begin_day, :end_month, :end_day, :begin_date, :end_date, :query_params

	def initialize
		@host_path={host: "tidesandcurrents.noaa.gov", path: "/api/datagetter"}
		@product = "hourly_height"
		@application = "NOS.COOPS.TAC.WL"
		@station = "8735180"

		@begin_year ="2013"
		@begin_month = "02"
		@begin_day = "17"

		@end_year ="2014"
		@end_month = "02"
		@end_day = "17"

		@years = [2011,2012,2013]
		@datum = "MLLW"
		@units = "english"
		@time_zone = "GMT"
		@format = "csv"
		
		@station_list = ["8735180", "8531680", "8519483"] ##fill in this array with station ids as Strings

	end

	def query_params
		return {product: "#{@product}", application: "#{@application}", station: "#{@station}", begin_date: "#{@begin_year}#{@begin_month}#{@begin_day}", end_date: "#{@end_year}#{@end_month}#{@end_day}",  datum: "#{@datum}", units: "#{@units}", time_zone: "#{@time_zone}", format: "#{@format}"}
	end

	def scrape
		uri=URI::HTTP.build(@host_path)
		uri.query=URI.encode_www_form(query_params)
		@response=Net::HTTP.get(URI(uri.to_s))
	end	

	def writeFile
		# f = File.open("#{@station}.#{@begin_date}-#{@end_date}.csv", "w")
		f = File.open("#{@station}.csv", "a")
		f.write(@response)
		f.close
	end

end

t = TideScraper.new

t.station_list.each do |station|
	t.station = station
	i=0
	while i < t.years.length-1 do 
		t.begin_date = "#{t.years[i]}#{t.begin_month}#{t.begin_day}"
		t.end_date = "#{t.years[i+1]}#{t.end_month}#{t.end_day}"
		t.scrape
		t.writeFile
		i += 1
	end
end

# needs trouble shooting but should be working. 