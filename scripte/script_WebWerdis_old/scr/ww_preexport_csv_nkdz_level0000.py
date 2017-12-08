"""Create timeseries of climate elements.
Copyright (C) 2012 Insa Otte

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Please send any comments, suggestions, criticism, or (for our sake) bug
reports to nausst@googlemail.com
"""

__author__ = "Spaska Forteva"
__version__ = "2014-07-07"
__license__ = "GNU GPL, see http://www.gnu.org/licenses/"

import datetime
import time
import optparse
import os
import csv
from xml.dom import minidom
import xml.dom.minidom as dom
import xml.etree.ElementTree as ET

def findChildNodeByName(parent, name):
    for node in parent.childNodes:
        if node.nodeType == node.ELEMENT_NODE and node.localName == name:
            return node
    return None

def getText(nodelist):
    rc = []
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            rc.append(node.data)
    return ''.join(rc)

def _lese_text(element): 
    typ = element.get("date") 
    return eval("%s('%s')" % (typ, element.text))

def main():
    """Main program function
    Create timeseries of climate elements
    """
    print
    print 'Module: timeseries of climate elements'
    print 'Version: ' + __version__
    print 'Author: ' + __author__
    print 'License: ' + __license__
    print
    
    # Set framework for command line arguments and runtime configuration.
    parser = optparse.OptionParser(\
        "usage: %prog [options] data_file_01 " + \
        "data_file_02")
    parser.add_option("-p", "--pla", dest="top_level_station_path", \
        default = "/media/dogbert/dev/be/WebWerdis/preexp_in/", \
        help = "Name of top level station path", \
        metavar="string", type="str")
    parser.add_option("-o", "--out", dest="output_path", \
        default = "/media/dogbert/dev/be/WebWerdis/preexp_out/", \
        help = "Name of output path", \
        metavar="string", type="str")
    parser.set_description('Options for module timeseries.')
    (options, args) = parser.parse_args()

    if options.top_level_station_path == None:
        parser.print_help()
    else:
        top_level_station_path = options.top_level_station_path   

    output_path = options.output_path

    # source directory
    dirList = os.listdir(top_level_station_path)
    dirList.sort()
    flag = 'RRMS' #SDMS TAMM RRMS
    
    #Datei Schleife
    for file in dirList:
        if flag in file:
            station_path = top_level_station_path + os.sep + file
            print "Station ... " + station_path 
            tree = ET.parse(station_path)
            root = tree.getroot()

            
            # Stationen Schleife
            for child in root:
                dataset_1 = []
                
                station_id = child.get('value')
                print "Station ... " + station_path + "station=" +station_id
                station_id = station_id.replace(" ","")
                station_id = station_id.replace("/","_")
                station_id = station_id.replace("-","_")
                station_id = station_id.replace("(","")
                station_id = station_id.replace(")","")
                station_id = station_id.replace(",","_")
                station_id = station_id.replace(", ","_")
                
                if unichr(228) in station_id:
                    station_id = station_id.replace(unichr(228),"ae")
                if unichr(252) in station_id:
                    station_id = station_id.replace(unichr(252), 'ue')
                if unichr(246) in station_id:
                    station_id = station_id.replace(unichr(246),"oe")
            
                outdir = output_path +  station_id 
                print "Station ... " + station_path + "station=" +station_id
                try:
                    os.stat(outdir)
                except:
                    os.mkdir(outdir)     
                
                lat = 'NaN'
                lon = 'NaN'
                alt = 'NaN'
                start_date = 'NaN' 
                # Values Schleife
                for neighbor in child:
                    try:
                        date = neighbor.get('date')
                        if start_date == 'NaN':
                            start_date = date
                        end_date = date
                        value_2 = neighbor.text
                        lat_temp = neighbor.get('latitude')
                        try:
                            if lat_temp != None: 
                                lat = neighbor.get('latitude')
                                lon = neighbor.get('longitude')
                                alt = neighbor.get('altitude')
                            
                            dataset_1.append([date, station_id, lat, lon, alt, value_2])
                        except:
                            continue                 
                    except:
                        continue
    
                 
                outfile = outdir + os.sep +  start_date + "_" + end_date + "_" + station_id + "_" + flag + ".txt"
                print "Writing data..." + station_path + "station=" +station_id
                outfile = open(outfile,"w")
                writer = csv.writer(outfile, delimiter=',')
                for row in dataset_1:
                    writer.writerow(row)
                outfile.close()
        
if __name__ == '__main__':
    main()