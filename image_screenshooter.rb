require 'watir'

# ImageScreenshooter -  Module for screenshooting a url and saving the png file
module ImageScreenshooter
  def take_url_screenshot(url, filename: 'screenshoot')
    browser = Watir::Browser.new :chrome, headless: true

    # Set the desired window size
    window_width = 650
    window_height = 1044

    begin
      # Navigate to the specified URL
      browser.goto(url)
      # Set the window size
      browser.window.resize_to(window_width, window_height)

      sleep 3

      # Find and click on the button
      button = browser.button(aria_label: 'Watchlist, details and news', tabindex: '-1')
      button.click if button.exists?

      # Take a screenshot and save it to a file
      screenshot_file = "#{filename}.png"
      browser.screenshot.save(screenshot_file)
      puts "Screenshot saved to: #{screenshot_file}"
    rescue StandardError => e
      puts "Error: #{e.message}"
    ensure
      # Close the browser
      browser.close
    end
  end

  module_function :take_url_screenshot
end
