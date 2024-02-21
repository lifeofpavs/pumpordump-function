require 'httparty'

# CompareSymbols - Compare symbol change in the last 24hours using coingecko api

module CompareSymbols
  def self.compare_24hr_change(coingecko_id)
    coingecko_url = "https://api.coingecko.com/api/v3/simple/price?ids=#{coingecko_id}&vs_currencies=usd&include_24hr_change=true"

    result = HTTParty.get(coingecko_url, {
                            headers: {
                              "Content-Type": 'application/json'
                            }
                          })

                        result[coingecko_id]['usd_24h_change'].positive?
  end
end
