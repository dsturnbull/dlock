require 'lib/dlock/dlock'

class MailChecker
  def initialize
    DLock.lock :debug => true do
      sleep 5
      puts "checked"
    end
  end
end

if __FILE__ == $0
  MailChecker.new
end
