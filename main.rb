require_relative 'image_screenshooter'
require_relative 'image_uploader'
require_relative 'generate_pairs'

SYMBOLS = %w[
  BTC
  ETH
  INJ
  DOT
  SOL
].freeze

GeneratePairs.new.generate_screenshots
