require 'erb'

module Rupert
  module Utility

    # Read a template directly from one of our template stores. We need to go
    # two levels down since the 'current directory' will always be the lib
    # directory.
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
end
