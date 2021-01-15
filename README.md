# virtualbox-tools
Scripts and libraries to use VirtualBox ( https://www.virtualbox.org )

## How to use
* create-vm.sh
  * Create VirtualBox VM for Linux X64
  * Currently, only available for Ubuntu 
  * Use VBoxManage unattened install command to initialize OS-ready environment 
  * Example 
  ```
  ./create-vm.sh --vm-name u2004-desktop-headless  \
        --image-path /mnt/tools/archives/ubuntu-20.04.1-desktop-amd64.iso \
        --vrde-port 2005 --cpus 8
  ```

  ```
  $> ./create-vm.sh -h
  ARGUMENTS is  -h --
  --vm-name | -n VM Name
  --image-path | -i ISO Image path
  --base-dir | -b base directory, default = /mnt/work/virtualbox
  --vrde-port | -v port number for vrde
  --cpus | -c Number of cpus
  --memory-size | -m Memory Size ( in MB )
  --video-memory-size Video Memory Size ( in MB ), default = 64
  --ostype | -o OS Type (--ostype on vboxmanage createvm)
  --root-disk-size Root disk size in MB, default = 15000
  ```
* ccreate-vm-nat-network-host-only.sh
  * Example
  ```
  ./create-vm-nat-network-host-only.sh --vm-name webosbuild --image-path /mnt/tools/archives/ubuntu-18.04.4-desktop-amd64.iso --base-dir /mnt/work2/virtualbox --vrde-port 9090 --memory-size 64000 --video-memory-size 128 --root-disk-size 500000
  ```

## Link
* https://www.virtualbox.org
