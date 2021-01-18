#!/usr/bin/env python3 
import argparse
import subprocess
import configparser
import re
print("")
parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--vm-name', required=True)
args = parser.parse_args()
vm_name = args.vm_name
# Parse vm information as configuration format
get_info_cmd ="VBoxManage showvminfo '" + vm_name + "' --machinereadable"
vm_info_str = "[vm_info]\n" + subprocess.check_output(get_info_cmd, shell=True).decode("utf8")
config_parser = configparser.RawConfigParser()
config_parser.optionxform =  lambda option:option 
config_parser.read_string(vm_info_str)
vm_info = config_parser['vm_info']
assigned_storage_controllers = filter(lambda vm_element: re.compile(r"^storagecontrollername[0-9]$").match(vm_element), vm_info)
for controller_id in assigned_storage_controllers:
    controller_name = vm_info[controller_id]
    print(f"Controller ID = {controller_id}, Controller name = {controller_name}")
    elements = []
    temp_name = controller_name.replace("\"", "")
    for each_ele in vm_info:
        if re.compile(rf"\"{temp_name}.*").match(each_ele) and vm_info[each_ele] != "\"none\"":
            elements.append(each_ele)
    for each_name in elements:
        print(" .   ", each_name, vm_info[each_name])