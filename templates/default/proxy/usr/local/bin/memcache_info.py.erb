#!/usr/bin/env python

'''

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

'''


import memcache
import optparse
import time
import socket
import os,sys

def main():

    usage = "usage: %prog [-s] [-d] "
    p = optparse.OptionParser(usage)
    p.add_option('--stats', '-s', action="store_true", help="Full dump of stats command")
    p.add_option('--debug', '-d', action="store_true", help="Verbose mode")
    p.add_option('--connections', '-c', action="store_true", help="Just return connections value")

    options, arguments = p.parse_args()

    server = find_bound()
    mc_conn = single_connect(server, options.debug)

    if options.connections and options.stats :
        print "\n\t Only -s or -c can be specified at once "
        sys.exit(1)

    if options.connections:
        stat_type=1
        get_info(mc_conn, stat_type)
    elif options.stats:
        stat_type=2
        get_info(mc_conn, stat_type)
    else:
        stat_type=3
        get_info(mc_conn, stat_type)
       
    sys.exit(0) 


def find_bound():
    mc_bound = os.popen("netstat -ntl4 | grep 11211 | awk '{ print $4}' | tr -d '\n' ").readlines()
    if len(mc_bound) == 1 :
        bind_ip,bind_port = mc_bound[0].split(':')
        server = bind_ip + ":" + bind_port
    else:
        print "Could not determined if memcache is bound to any ip/port \n"
        sys.exit(1)

    return server



def single_connect(server, debug):

    if debug:
        print "\n\t Connecting to Server -> %s" % server

    try:
        sc = memcache.Client([server], debug)
    except socket.timeout:
        print "memcache socket.timeout received, likely dead.\n"
        sys.exit(1)
    except:
        sys.exit(1)

    return sc 

    
   

def get_info (mc_conn, stat_type):
    stats = mc_conn.get_stats()

    if stat_type == 1 :
        print "\t Current Open Connections " + stats[0][1]['curr_connections']
    
    if stat_type == 2 :
        for item in stats[0][1]:
            print "\t " + item + ":" + stats[0][1][item]
    
    if stat_type == 3 :
        print "\n\t Accepting Connections " + stats[0][1]['accepting_conns']
        print "\t Current Open Connections " + stats[0][1]['curr_connections']
        print "\t Number of Items Cached " + stats[0][1]['curr_items']
        print "\t Bytes Currently Used " + stats[0][1]['bytes']
        print "\t Get Count " + stats[0][1]['cmd_get']
        print "\t Set Count " + stats[0][1]['cmd_set']
        print "\t Get Hits " + stats[0][1]['get_hits']
        print "\t Get Misses " + stats[0][1]['get_misses']
        print "\t Cache HitRate %.5f" % ( float(stats[0][1]['get_hits']) / float(stats[0][1]['cmd_get']) )
        print "\n" 

 
if __name__ == '__main__':
    main()


