require_relative 'image_screenshooter'
require_relative 'image_uploader'

SYMBOLS = %w[
  BTC
  ETH
  INJ
  DOT
  SOL
].freeze

SYMBOLS.each do |symbol|
  ImageScreenshooter.take_url_screenshot(
    "https://www.tradingview.com/chart/?symbol=BINANCE%3A#{symbol}USDT",
    filename: symbol
  )

  ImageUploader.new.upload_image("#{symbol}.png", symbol)
end
