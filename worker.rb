require "faraday"

module ExchangeRatePusher
  module_function

  EXCHANGER_URL = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"

  def current_rate
    Faraday.get(EXCHANGER_URL)
           .then { |response| JSON.parse(response.body) }
           .then { |rates| rates.find { |r| r["cc"] == "USD" }["rate"] }
  end

  def push_to_ga
    ga_client.post("/mp/collect") do |req|
      req.body = {
        client_id: "489158357.1698913803",
        events: [
          {
            name: 'usd_uah',
            params: {
              rate: current_rate
            }
          }
        ]
      }.to_json
    end
  end

  def ga_client
    Faraday.new(
      url: "https://www.google-analytics.com",
      params: {  
        measurement_id: "G-TV35ER4RBK",
        api_secret: "9wLJyUdoTx-V0m4Nibe8Mw"
      },
      headers: { "Content-Type" => "application/json" }
    )
  end
end

loop do
  ExchangeRatePusher.push_to_ga
  sleep 60
end
