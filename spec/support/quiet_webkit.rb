# Stolen from https://github.com/thoughtbot/capybara-webkit/issues/581

Capybara.register_driver :quiet_webkit do |app|
  Capybara::Webkit::Driver.new(app, stderr: HushLittleWebkit.new)
end

class HushLittleWebkit
  IGNOREABLE = /CoreText performance|userSpaceScaleFactor|QFont::setPixelSize/

  def write(message)
    if message =~ IGNOREABLE
      0
    else
      puts message
      1
    end
  end
end
