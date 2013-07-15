#!/usr/bin/env python

'''
check_memcache.py

 # A quick and *very* dirty script to health check memcache    #
 # server(s) and dump their stats. Requires python-memcache.   #
 # Author: Florian Hines <florian.hines<AT>gmail.com           #

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.

Authors:
    Florian Hines <florian.hines<AT>gmail.com>
'''


import memcache
import optparse
import time
import socket
from subprocess import call

def main():
    restart_attempted = False
    restarted = ''
    usage = "usage: %prog [-h host] [-p port] [-s|-d] OR %prog [-m host1:port,host2:port,...] [-d]"
    p = optparse.OptionParser(usage)
    p.add_option('--host', '-H', default="127.0.0.1", help="Default = 127.0.0.1")
    p.add_option('--port', '-p', default="11211", help="Default = 11211")
    p.add_option('--stats', '-s', action="store_true", help="dump output of stats command")
    p.add_option('--debug', '-d', action="store_true", help="debug/verbose")
    p.add_option('--multihost', '-m', default=False, help="(host:port,host:port,...)")
    p.add_option('--zenoss', '-z', action='store_true', help="output in a zenoss friendly format")
    p.add_option('--fix','-f', action='store_true', help="try to fix by restarting")
    options, arguments = p.parse_args()
    if options.multihost is not False:
        servers = options.multihost.split(",")
        result = mconnect(servers, options.stats, options.debug)
    else:
        result = single_connect(options.host, options.port, options.stats, options.debug)
        if result is False:
            if memrestart(options.host):
                #recheck
                time.sleep(2)
                result = single_connect(options.host, options.port, options.stats, options.debug)
                restart_attempted = True
                restarted = True
            else:
                restart_attempted = True
                restarted = False

    if result is True:
        if options.zenoss is True:
            print "MEMCACHED OK - OK"
            exit(0)
        else:
            print "check:ok"
            if restart_attempted is True:
                print "Entering short sleep after SUCCESSFUL restart"
                time.sleep(5)
            exit(0)
    else:
        if options.zenoss is True:
            print "MEMCACHED CRITICAL - No response from " + options.host
            exit(2)
        else:    
            print "check:failed"
            if restart_attempted is True:
                print "Entering short sleep after FAILED restart"
                time.sleep(5)
            exit(2)

def mconnect(servers, collectstats, debug):
    try:
        mc = memcache.Client(servers, debug)
        stats = mc.get_stats()
    except socket.timeout:
        print "memcache socket.timeout received, likely dead."
        return False
    except:
        raise
    if debug:
        print "-> Checking %s servers" % len(servers)
        print "-> Successfully queried %s of %s servers" % (len(stats),len(servers))
    if collectstats:
        print "-> No stats for you!"
    if len(servers) is not len(stats):
        return False
    else:
        return True

def single_connect(host, port, collectstats, debug):
    server = host + ":" + port
    if debug:
        print "-> %s" % server
    try:
        sc = memcache.Client([server], debug)
        stats = sc.get_stats()
    except socket.timeout:
        print "memcache socket.timeout received, likely dead."
        return False
    except:
        raise
        

    if not stats:
        return False

    if not stats[0][1]['uptime']:
        return False

    if collectstats:
        for item in stats[0][1]:
            print item + ":" + stats[0][1][item]
    
    return True
    
def memrestart(server):
    print "Attempting restart of %s" % server
    command = "/etc/init.d/memcached"
    sudo = False
    args = "restart"
    #command = "uptime"
    if sudo:
        retcode = call(['sudo', command, args])
    else:
        retcode = call([command, args])
    if retcode is 0:
        return True
    else:
        return False

if __name__ == '__main__':
    main()


