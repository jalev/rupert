require 'erb'
require 'rexml/document'

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
    def value_from_xml tree, attribute=nil
      xml = REXML::Document.new(@xml_desc)
      # If we didn't provide an attribute, then we must assume that we want a
      # specific value from the xml tree. If we do provide an attribute, then
      # it is assumed that we want an attribute from an element.
      attribute.nil? ? xml.elements[tree].text : xml.elements[tree].attributes[attribute]
    end

    def template
      File.read("#{File.dirname __FILE__}/./templates/#{template_path}")
    end

    # Return our template with the values of the template filled in.
    #
    def xml_template 
      ERB.new(template, nil, '-').result(binding)
   end
  end
end
