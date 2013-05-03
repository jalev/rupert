module Rupert
  module Errors

    # General Errors

    class DefinitionError < StandardError
      def message
        "Tried to define an object with nonstandard name. Please redefine with normal name"
      end
    end

    class NoHypervisor < StandardError
      def message
        "Rupert could not detect a valid hypervisor"
      end
    end

    class AttributeNotExist < ArgumentError
      def message
        "A variable is missing"
      end
    end

    class NotValidURL < ArgumentError
      def message
        "URL provided is not valid. Please use 'http://', 'ftp://', or 'nfs:', and terminate with a /"
      end
    end

    class MissingRequiredAttribute < ArgumentError
      def message
        "A required attribute is missing."
      end
    end

    class NoOSSpecified < ArgumentError
      def message
        "The OS name was not specified. Please specify the name of the OS you are installing."
      end
    end

    class MissingRemoteUrl < ArgumentError
      def message
        "Requires a remote url!"
      end
    end

    class AlreadyExist < StandardError; end

    class ConnectionError < StandardError
      def message
        "There was an error with the connection"
      end
    end

    class NoConnectionError < StandardError
      def message
        "There is currently no connection to libvirt. Please connect to libvirt."
      end
    end

    class NoHostToConnect < StandardError
      def message
        "Please provide a connection to libvirt"
      end
    end

    # Guest Errors

    class GuestAlreadyExist < StandardError 
      def message
        "The guest with this name already exists."
      end
    end

    class GuestNotFound < StandardError 
      def message
        "The guest has not been found with information provided"
      end
    end
    
    class GuestNotCreated < StandardError 
      def message
        "The guest has not been created"
      end
    end

    class GuestNotStarted < StandardError
      def message
        "The guest has not been started"
      end
    end

    class GuestNeedsRam < StandardError
      def message
        "The guest cannot be defined with less than 32mb of RAM"
      end
    end

    class GuestAlreadyRunning < StandardError
      def message
        "The guest has already been started"
      end
    end

    class GuestIsNotRunning < StandardError
      def message
        "Operation cannot be completed as guest is not running"
      end
    end

    class GuestIsRunning < StandardError
      def message
        "Operation cannot be completed as guest is currently running"
      end
    end

    # Pool Errors
    #

    class PoolAlreadyStarted < StandardError
      def message
        "Pool has already been started"
      end
    end

    class PoolAlreadyStopped < StandardError
      def message
        "Pool has already been stopped"
      end
    end

    class PoolNotCreated < StandardError
      def message
        "Pool has not been created"
      end
    end
    
    class PoolPathError < StandardError
      def message
        "Must provide a path"
      end
    end

    class PoolAlreadyExist < StandardError
      def message
        "Pool already exists"
      end
    end

    class PoolNotFound < StandardError
      def message
        "Cannot find Pool with information provided"
      end
    end

    class PoolNeedSave < StandardError
      def message
        "Pool needs to be saved before any operations can occur on it."
      end
    end

    class DiskNotFound < StandardError
      def message
        "A disk with that name has not been found"
      end
    end

    class NotDiskObject< StandardError
      def message
        "Pool needs a disk object to save disk"
      end
    end

    # NIC Errors

    class NicAlreadyRunning < StandardError
      def message
        "NIC is currently running"
      end
    end

    class NicNotDefined < StandardError
      def message
        "NIC has not been defined"
      end
    end

    class NicNotRunning < StandardError
      def message
        "NIC is not currently active"
      end
    end

    class NicNotFound < StandardError
      def message
        "NIC with that info has not been found"
      end
    end


    class NotFound < StandardError
      def message
        "The specified object could not be found"
      end
    end

    # Disk Classes

    class DiskLargerThanPool < StandardError
      def message
        "You cannot define a disk with more space than the pool"
      end
    end

    class DiskCannotBeZero < StandardError
      def message
        "You cannot define a zero-capacity disk. Please alter the size of your disks"
      end
    end

    class DiskNotCreated < StandardError
      def message
        "Disk has not been created yet"
      end
    end

    class DiskNeedsName < StandardError
      def message
        "Disk needs a name"
      end
    end

    class DiskAllocGreaterThanSize < StandardError
      def message
        "You cannot allocate more space than the maximum size"
      end
    end

    class DiskAlreadyExist< StandardError
      def message
        "A disk with this name already exists"
      end
    end

  end
end
