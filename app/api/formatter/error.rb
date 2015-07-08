module Formatter
  module Error
    def self.call message, backtrace, options, env
      { :message => message }.to_json
    end
  end
end

