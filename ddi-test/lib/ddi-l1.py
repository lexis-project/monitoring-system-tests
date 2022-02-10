import platform    # For getting the operating system name
import subprocess  # For executing a shell command
import socket
import paramiko
from socket import error as socket_error
import os
import json
import logging

def load_machines(file):
    with open(file, 'r') as f:
        machines = json.load(f)
        print(machines["Machines"])
    return machines["Machines"]

def get_all_IPs(machines):
    result = [sub['ip'] for sub in machines]
    print(result)
    return result

#get_all_IPs(load_machines("input.json"))

def ping(host): # From https://stackoverflow.com/questions/2953462/pinging-servers-in-python
    """
    Returns True if host (str) responds to a ping request.
    Remember that a host may not respond to a ping (ICMP) request even if the host name is valid.
    """

    # Option for the number of packets as a function of
    param = '-n' if platform.system().lower()=='windows' else '-c'

    # Building the command. Ex: "ping -c 1 google.com"
    command = ['ping', param, '1', host]
    print(command)
    result = subprocess.call(command)
    return result == 0

#test= ping("138.246.225.23")
#print(test)

def check_port(host, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(5)
    result = sock.connect_ex((host, port))
    if result == 0:
        logging.info("Port "+str(port)+ " is opened!")
        return True
    else:
        logging.info("Port "+str(port)+ " is closed!")
        return False

    sock.close()

def check_ports(host,ports):
    count = 0
    for port in ports:
        result = check_port(host,port)
        if result == False:
            count +=1
    if count != 0:
        return False
    return True


def check_cpu_stats(host,username):
    try:
        ssh_remote =paramiko.SSHClient()
        ssh_remote.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        privatekeyfile = os.path.expanduser('~/.ssh/id_rsa')
        mykey = paramiko.RSAKey.from_private_key_file(privatekeyfile)
        ssh_remote.connect(host, username = username, pkey = mykey)
        idin, idout, iderr = ssh_remote.exec_command("iostat -xtc")
        id_out = idout.read().decode().splitlines()
        print(id_out)
        id_out_1 = id_out[0]
        rein, reout, reerr = ssh_remote.exec_command("ps -p %s -o %s" %(id_out_1 ,'%cpu'))
        cp = reout.read().decode().splitlines()
        logging.info(cp)
    except paramiko.SSHException as sshException:
        logging.info("Unable to establish SSH connection:{0}".format(host))
    except socket_error as socket_err:
        logging.info("Unable to connect connection refused")
