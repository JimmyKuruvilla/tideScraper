
require 'uri'
require 'net/http'
require 'json'

class TideScraper
	attr_accessor :product, :application, :station, :datum, :units, :time_zone, :format, :response, :station_list, :years, :begin_year, :begin_month, :begin_day, :end_year, :end_month, :end_day, :begin_date, :end_date, :query_params

	def initialize
		@host_path={host: "tidesandcurrents.noaa.gov", path: "/api/datagetter"}

		@application = "NOS.COOPS.TAC.WL"
		@format = "csv"
		@station = ""
		@begin_year = ""
		@end_year = ""

		@begin_month = "01"
		@begin_day = "01"
		@end_month = "12"
		@end_day = "31"

		@datum = "MLLW"
		@units = "english"
		@time_zone = "GMT"
		@product = "hourly_height"
		@station_list = ["8735180", "8531680", "8519483"] ##fill in this array with station ids as Strings
		# @station_list = ["8420411"]
		@years = [2011,2012,2013,2014] ## enter years of data required

	end

	def query_params
		return {product: "#{@product}", application: "#{@application}", station: "#{@station}", begin_date: "#{@begin_year}#{@begin_month}#{@begin_day}", end_date: "#{@end_year}#{@end_month}#{@end_day}",  datum: "#{@datum}", units: "#{@units}", time_zone: "#{@time_zone}", format: "#{@format}"}
	end

	def writeFile
		f = File.open("#{@station}.csv", "a")
		f.write(@response)
		f.close
	end

	def scrape
		uri=URI::HTTP.build(@host_path)
		uri.query=URI.encode_www_form(query_params)
		puts query_params
		@response=Net::HTTP.get(URI(uri.to_s))
	end	

	def scrape_all
		self.station_list.each do |station_item|
			self.station = station_item
			i=0
			while i <= self.years.length-1 do 
				self.begin_year = "#{self.years[i]}"
				self.end_year = "#{self.years[i]}"
				self.scrape
				self.writeFile
				i += 1
			end
		end

	end


end

t = TideScraper.new
t.scrape_all
