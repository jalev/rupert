rupert(1) -- Simple Virtual-Machine Management Tool
===================================================

## DESCRIPTION
Rupert is a very simply virtual machine management tool created in Ruby. Its
purpose is to provide CRUD functions on virtual machines and their components
via a libvirt driver.

## SYNOPSIS

`rupert` [command] <name> [<options>]

## DESCRIPTION
**rupert** is a very simple virtual machine management tool created in Ruby.
It can create, update and delete virtual machines, pools, and disks. It is
also able to also start, restart, and stop guests/pools. It is also possible
to query a local or foreign host 

<command> can be one of the following commands: <br/>
* create name [options] <br/>
* delete name [optoins] <br/> 
* update name [options] <br/>
* start name [options] <br/>
* shutdown name [options] <br/>
* restart name<br/>
* stop name [options]<br/>
* snapshot name<br/>
* list [<guests|disks|nics|pools>] [<--inactive|--all>]<br/>
* capabilities [-c|--connection]<br/>

* **create**:<br/>
Create is used to create things in the libvirt environment specified with
the `--type` switch. Rupert can create guests (virtual-machines), disks,
storage pools, and networks.

* **delete**:<br/>
Delete is used to delete a thing in the libvirt environment. If specifying
to delete a virtual-machine, rupert will not delete the disks unless
specifically attached.

* **update**: <br/>
Update is used to modify a resource.

* **start**: <br/>
Start is used to start a virtual-machine, pool or network. If you are
specifying a virtual machine, this will move it from a state where it does not
consume CPU/RAM to a state that does. If specifying a pool, it will allow the
resources provided by that pool to be allocated.
By default, if no type is specified, then rupert will assume you are starting
a virtual machine.

* **shutdown**: <br/>
rarara 

* **restart**: <br/>
Restart is used to send a restart signal to the virtual machine.

* **stop**: <br/>
Stop is used to stop a virtual-machine. Stop is the harder version of
shutdown, and a virtual machine that has been sent the **stop** signal will
immediately stop using resources.

* **snapshot**: <br/>
Snapshot is a command that will take a snapshot of the virtual-machine
provided. 

* **list**: <br/>
List, when provided with an option, will list all resources of that type
currently defined and stored by the libvirt daemon. 

* **capabilities**: <br/>
Capabilities is a command used to find out the capabilities of the libvirt
daemon that rupert is currently connected to.

## GENERAL OPTIONS
These are the general options that can be passed to Rupert.

  * `-c`, `--connection`=<uri> :
    Specifies a connection to a host with a libvirt driver. You can either use a
    local connection or a remote connection. URIs can be decorated as followed:

    Local:<br/>
    qemu:///session (User-limited connection) <br/>
    qemu:///system  (System connection) <br/>

    Remote:<br/>
    qemu+ssh://<user>@<host>/session  <br/>
    qemu+ssh://<user>@<host>/system   <br/>

    If no connection is specified, then rupert will attempt to connect to the
    local libvirt daemon. By default, it will try to connect to whichever
    connection works first.

  * `-h`, `--help`:
    Brings up a list of available commands.

## CREATE OPTIONS
*create* takes a series of arguments to create a **thing**: be it a guest or
volume, and so forth. With only the *name* argument, rupert will assume that
you want to create a virtual machine.

  * `--cmdargs`="<args>":
    Command-line arguments that you wish to pass to the guest during creation.
    If you wish to use a kickstart or any other unattended automation tools,
    you must pass them here.

  * `-cpu` <num>:
    The number of logical CPUs the guest will use.

  * `--disk-name`, `-dn` <name>:
    The name of the disk you want to use. You can use this to either specify a
    different name for the disk, or to specify an existing disk. If the
    disk-name is not specified, then Rupert will use the name provided. 

  * `--disk-size`, `-ds` <numKB|MB|GB|TB> :
    The size of the disk. Can take options of KB|MB|GB|TB.

  * `--disk-type`, `-dt` <type>:
    The format of the disk. Valid formats are `raw`, `qcow`, `qcow2`. Other
    formats are dependant on what formats `qemu-img` on the operating-system
    supports.

  * `--iso`:
    The location of an ISO file that you wish to load on startup.

  * `--network` <name>:
    Specify a specific network device to attach to the guest. If none is
    specified, then the `Default` network is used.

  * `--pool-name`, `-pn` <name>:
    The name of the storage pool you wish to use to create the disk on. Unless
    specified, Rupert will attempt to create the disk on the `Default` storage
    pool.

  * `--ram`, `-r` <numKB|MB|GB|TB>:
    The amount of RAM the guest will use.

  * `--type` <guest|pool|disk|network>:
    Specify a type of thing you wish to create. 

  * `--xml` <xml|file>:
    Another way to completely avoid setting up all these fields is to provide
    an XML definition of the thing you want to create. 

## DELETE
  Delete takes only a single argument.

## UPDATE OPTIONS

## ACTIONS


## EXAMPLES

Create a guest with a disk size of 10gb, 512mb of RAM, and 2 cpus, and an
option to take an ISO on boot:

  $ rupert create rupert_disk --type guest --disk-size 10gb --ram 512mb --cpu 2 --iso /tmp/Cent.iso

Create a volume with a size of 10GB and a format of qcow:
  $ rupert create rupert_disk --type disk --disk-size 10gb --disk-format qcow2

Modify a guest to have 1GB of ram:
  $ rupert update rupert_guest --ram 1gb

## COPYRIGHT

## SEE ALSO


