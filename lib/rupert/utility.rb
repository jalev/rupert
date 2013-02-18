require 'erb'

module Rupert
  module Utility

    # Read a template directly from one of our template stores
    #
    def template
      File.read("#{File.dirname __FILE__}/../../templates/#{template_path}")
    end

    # Return our template with the values of the template filled in.
    #
    def xml_template
      ERB.new(template, nil, '-').result(binding)
    end

end
