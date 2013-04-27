require 'etc'

module Rupert
  module Config

    def get_config_file
      if get_user == "root"
        @config_dir = root_config_dir
        @config_file = root_config_file
      else
        @config_dir = user_config_dir
        @config_file = user_config_file
      end
    end
   
    private 

    def config_dir_name
      return default_config_dir_name
    end

    def config_file_name
      return default_config_name
    end

    def user_config_dir
      return File.join("#{Dir.home}", ".#{config_dir_name}")
    end

    def root_config_dir 
      return File.join("/etc", "#{config_dir_name}")
    end

    def user_config_file
      return File.join(user_config_dir, "#{config_file_name}")
    end

    def root_config_file
      return File.join(root_config_dir, "#{config_file_name}")
    end

    def config_dir_name
      return default_config_dir_name
    end

    # Get the user running the script
    #
    # Currently uses linux environment variable. This needs to change in the
    # future.
    def get_user
      return ENV['USERNAME']
    end

    def default_config_dir_name
      "rupert"
    end

    def default_config_name
      "rupert.cfg"
    end

  end
end
