require 'erb'
require 'rexml'

module Rupert
  module Utility

    def size_split str
      #splits a string based on a digit delimiter. 
      str.split(/(\d+)/)
    end

    # Return a value from an xml document by navigating a provided tree-path.
    # We first fetch the xml of an libvirt object by calling its xml_desc
    # method.
    #
    def value_from_xml tree, attribute
      xml = REXML::Document.new(@xml_desc)
      # if we didn't provide an attribute, assume that we want a specific
      # value from a tree, otherwise provide the attributes of an entire tree.
      attribute.nil? ? xml.elements[tree].text : xml.elements[path].attributes[attribute]
    end

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
