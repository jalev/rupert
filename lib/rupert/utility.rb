require 'erb'

module Rupert
  module Utility

    # Return our template with the values of the template filled in.
    #
    def xml_template type = nil
      # Provide the template type, or use the name of the class as the type.
      temp = type || self.class.to_s.split("::").last.downcase
      template = File.read("#{File.dirname __FILE__}/./templates/#{temp}.xml.erb")
      ERB.new(template, nil, '-').result(binding)
   end
  end
end
