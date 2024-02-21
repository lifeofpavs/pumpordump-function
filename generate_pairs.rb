require_relative 'database'
require 'pry'
# GeneratePairs - Class for generating pairs
class GeneratePairs
  attr_accessor :db

  def initialize
    @db = Database.client
  end

  def generate_screenshots
    pairs = db.collection('symbols').get.map(&:data)

    pairs.each do |pair|
      ImageScreenshooter.take_url_screenshot(
        "https://www.tradingview.com/chart/?symbol=BINANCE%3A#{pair[:symbol]}",
        filename: pair[:symbol]
      )
      puts "Took screenshot for #{pair[:symbol]}"

      ImageUploader.new.upload_image("#{pair[:symbol]}.png", pair[:symbol])
      puts "Uploaded screenshot for #{pair[:symbol]}"
    end
  end
end
