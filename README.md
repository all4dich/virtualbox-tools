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

## Link
* https://www.virtualbox.org
