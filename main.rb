require_relative 'image_screenshooter'

SYMBOLS = %w[
  BTC
  ETH
  DOT
  INJ
  SOL
].freeze

SYMBOLS.each do |symbol|
  ImageScreenshooter.take_url_screenshot("https://www.tradingview.com/chart/?symbol=BINANCE%3A#{symbol}USDT",
                                         filename: symbol)
end
