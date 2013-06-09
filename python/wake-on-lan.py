exec /usr/bin/python -x "$0" "$@"
# -*- coding: ISO-8859-15 -*-

"""
DETAILS : WOL magic-packet sende sender
AUTHOR  : Santanu Das, London
USAGE	: wake-on-lan <hostname>  

## ----- Local nodes ------------------- ##
## Modify this to put your own hostname/MAC 
## address pair here. The format is:
## "abc xx:xx:xx:xx:xx:xx", where "abc" could
## be any name you like and the "xx:xx..." is
## the MAC address of the machine.
"""

node_lst = [
        'serv01 00:11:12:a1:25:4d', 
        'serv02 01:12:13:a1:b4:ce', 
]
## ----- don't change anything below ------------ ##
## ---------------------------------------------- ##

from time import sleep
import sys,re,commands
import struct,socket,time

retval = 0

mac_addr = "mac_addr.txt"
X = '([a-zA-Z0-9]{2}[:|\-|.]?){5}[a-zA-Z0-9]{2}$'
S = re.compile(r'\s+')

mmap = {}

## Exit on error
def sys_exit():
    sys.stdout.flush()
    sys.exit(1)

## First argument 'None' in str.translate is new in 2.6. 
## Previously, it was a string of 256 characters 
if sys.version_info < (2, 6):
    f1_arg = ''.join(chr(i) for i in xrange(256))
else:
    f1_arg = None

## broadcast address
sysOS = "uname -s"
BSD = "ifconfig | grep -w broadcast | cut -d\  -f 6"
LNX = "ip -o addr show | grep -w inet | grep -e eth | cut -d\  -f 9"
#
if commands.getoutput(sysOS) == "Linux":
    bCast = commands.getoutput(LNX)
elif commands.getoutput(sysOS) == "Darwin":
    bCast = commands.getoutput(BSD)
else:
    print "System not supported!!"
    sys_exit()


def WakeOnLan(mac_address):

    ## Building the Wake-On-LAN "Magic Packet"...
    ## Pad the synchronization stream.
    data = "".join(['FFFFFFFFFFFF', mac_address * 20])
    msg = ""

    ## Split up the hex values and pack.
    for i in range(0, len(data), 2):
        msg = "".join([msg, struct.pack('B', int(data[i: i + 2], 16))])

    #print "DaTa: %s\nMsG: %s\n" % (data,msg) 

    ## ...and send it to the broadcast address using UDP
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    s.sendto(msg, (bCast, 9))
    s.close()

## check if hostname is provided
if len(sys.argv) != 2:
    print "Usage: %s <hostname>" % sys.argv[0]
    sys_exit()

for i in node_lst:
    # strip off everything from first "#" found
    i = i.split('#',1)[0]
    if not re.search(X,i): continue

    h = S.split(i,1)[0]                 ## host name
    m = S.split(i,1)[-1]                ## MAC address
    mmap[h] = m.strip('\t|" "')

def main():
    host = sys.argv[1]; i = 0
    cmd = 'ping -c1 -t1 %s' % host
    msg = "Waiting for %s to wake up..... " % host
    print ""

    for j,k in mmap.iteritems():
        if host not in mmap.keys():
            print "Host [%s] doesn't exist!!\n" % host
            return 1
        else: pass

        if host == j:
            print "Host name: %s" % j
            if not re.search(X.replace('zA-Z','fA-F'), k):
                print "Invalid MAC address [",k,"]; nothing to do!!\n"
                sys_exit()

            #(cS,cO) = commands.getstatusoutput(cmd)
            WakeOnLan(k.translate(f1_arg,':.-'))
            print "WOL request has been sent to %s [%s]" % (j,k)
            break

    ## Send the first ECHO_REQUEST
    (cS,cO) = commands.getstatusoutput(cmd)

    while True:
        if cS == 0:
            print "Host %s is up and running......\n" % h
            return 0
        else:
            (cS,cO) = commands.getstatusoutput(cmd)
            sys.stdout.write('\r%s\b%d' % (msg,i))
            sys.stdout.flush()
            sys.stdout.write('\r \b')
            i += 1

            if i == 80:
                print "Host %s is not running yet, try again!!\n" % h
                return 1 # don't you want to return 1 here?

if __name__ == '__main__':
    try: sys.exit(main())
    except KeyboardInterrupt: pass

