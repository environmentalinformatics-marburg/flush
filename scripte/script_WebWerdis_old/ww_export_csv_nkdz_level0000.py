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
__version__ = "2014-07-08"
__license__ = "GNU GPL, see http://www.gnu.org/licenses/"

import datetime
import time
import optparse
import os
import csv
import sys

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
    parser.add_option("-s","--sdt", dest="start_datetime",  \
        default = "1900", \
        help="Start year of the output time series (YYYY).", \
        metavar="integer", type="int")
    parser.add_option("-e","--edt", nargs=1, dest="end_datetime",  \
        default = "2014", \
        help="End year of the output time series (YYYY)", \
        metavar="integer", type="int")
    parser.add_option("-p", "--pla", dest="top_level_station_path", \
        default = "/media/dogbert/dev/be/WebWerdis/preexp_out", \
        help = "Name of top level station path", \
        metavar="string", type="str")
    parser.add_option("-o", "--out", dest="output_path", \
        default = "/media/dogbert/dev/be/WebWerdis/preexp_out", \
        help = "Name of output path", \
        metavar="string", type="str")
    parser.set_description('Options for module timeseries.')
    (options, args) = parser.parse_args()

    if options.top_level_station_path == None:
        parser.print_help()
    else:
        top_level_station_path = options.top_level_station_path   
    start_datetime = options.start_datetime
    end_datetime = options.end_datetime
    output_path = options.output_path

    # Look for subfolders in top level path
    
    a = os.walk(top_level_station_path)
    data_output = []
    for station_id in a.next()[1]:
        data_output = []
        station_path = top_level_station_path + os.sep + station_id
        
         # Set filepath with respect to actual station
        act_file_1 = ""
        act_file_2 = ""
        act_file_3 = ""
        for file in os.listdir(station_path):
            if "TAMM" in file:
                act_file_1 =  file
            if "RRMS" in file:
                act_file_2 = file
            if "SDMS" in file:
                act_file_3 = file
       

        print "Processing files:"
        print act_file_1
        print act_file_2
        print act_file_3
        
        # Check if input files exist
        ta_exists = False
        p_exists = False
        sd_exists = False
        if os.path.isfile(station_path + os.sep + act_file_1):
            ta_exists = True
            data_1 = open(station_path + os.sep + act_file_1, 'r')
        if os.path.isfile(station_path + os.sep + act_file_2):
            p_exists = True
            data_2 = open(station_path + os.sep + act_file_2, 'r')
        if os.path.isfile(station_path + os.sep + act_file_3):
            sd_exists = True
            data_3 = open(station_path + os.sep + act_file_3, 'r')
       
        # Open files
        header =  "Datetime, Aggregationtime, Station, lat, lon, " + \
                  "alt, Qualityflag, Ta_200, P_RT_NRT, SD"
        
        lat = False
        lon = False
        alt = False
        dataset_1 = []
        dataset_2 = []
        dataset_3 = []
        coord = []
        lat = 'NaN'
        lon = 'NaN'
        alt = 'NaN'
 
        if p_exists:
            i = 0
            for row in data_2:
                i = i + 1
                try:
                    date = row.split(",")[0]
                    value = float(row.split(",")[5])
                    lat = float(row.split(",")[2])
                    lon = float(row.split(",")[3])
                    alt = float(row.split(",")[4]) 
                    dataset_2.append([date, value, lat, lon, alt])  
            
                except:
                    continue    
        if sd_exists:
            i = 0
            for row in data_3:
                i = i + 1
                try:
                    date = row.split(",")[0]
                    value= float(row.split(",")[5])
                    lat = float(row.split(",")[2])
                    lon = float(row.split(",")[3])
                    alt = float(row.split(",")[4]) 
                    dataset_3.append([date, value, lat, lon, alt])
                except:
                   continue
        if ta_exists:
            i = 0
            for row in data_1:
                i = i + 1
                try:
                    date = row.split(",")[0]
                    value = float(row.split(",")[5])
                    lat = float(row.split(",")[2])
                    lon = float(row.split(",")[3])
                    alt = float(row.split(",")[4]) 
                    dataset_1.append([date, value, lat, lon, alt])
                except:
                    continue

        #print len(dataset_1)
        #print len(dataset_2)
        #print len(dataset_3)
        
        for act_year in range(start_datetime, end_datetime+1):
            for act_month in range(1, 13):
                act_time = str(act_year) + "-" + str(act_month)
                act_time = datetime.datetime.strptime(act_time, \
                                                      "%Y-%m")
                temp = [time.strftime("%Y-%m",act_time.timetuple())]
                temp = temp + ["s1m01"] + [station_id] 
                
####################################################################                             
                found_corresponding_data1 = False
                for i in range(len(dataset_1)):
                    if act_time == datetime.datetime.strptime(\
                                       dataset_1[i][0],"%Y-%m"):
                        temp = temp + [dataset_1[i][2]] + [dataset_1[i][3]] + [dataset_1[i][4]] + ['xxxxxxxxx'] + [dataset_1[i][1]] 
                        found_corresponding_data1 = True
                        
####################################################################
                found_corresponding_data2 = False
                for i in range(len(dataset_2)):
                    if act_time == datetime.datetime.strptime(\
                                       dataset_2[i][0],"%Y-%m"):
                        if found_corresponding_data1 == True:
                            temp = temp + [dataset_2[i][1]] 
                            found_corresponding_data2 = True
                        else :
                            temp = temp + [dataset_2[i][2]] + [dataset_2[i][3]] + [dataset_2[i][4]] + ['xxxxxxxxx'] + ['NaN'] + [dataset_2[i][1]] 
                            found_corresponding_data2 = True
                    
                if (found_corresponding_data2 != True) and (found_corresponding_data1 == True):
                    temp = temp + ['NaN']     
####################################################################        
                found_corresponding_data3 = False
                for i in range(len(dataset_3)):
                    if act_time == datetime.datetime.strptime(\
                                       dataset_3[i][0],"%Y-%m"):
                        if found_corresponding_data1 == True or found_corresponding_data2 == True :
                            temp = temp + [dataset_3[i][1]] 
                            found_corresponding_data3 = True
                if (found_corresponding_data3 != True) and ((found_corresponding_data2 == True) or (found_corresponding_data1 == True)):
                    temp = temp + ['NaN']
                if (found_corresponding_data1 != True) and (found_corresponding_data2 != True) and (found_corresponding_data3 != True):
                    temp = temp + ['NaN']  + ['NaN'] + ['NaN'] + ['xxxxxxxxx'] + ['NaN'] + ['NaN'] + ['NaN']
                data_output.append(temp)
               
                
        outdir = output_path + os.sep +station_id 
        print "Writing data ... " + station_path + "station=" +station_id
        try:
            os.stat(outdir)
        except:
            os.mkdir(outdir)     
        print station_id
        outfile = outdir + os.sep + station_id + "_level0000.txt"       
        outfile = open(outfile,"w")
        outfile.write(header + '\n')
        writer = csv.writer(outfile, delimiter=',')
        for row in data_output:
            writer.writerow(row)
        outfile.close()
        
if __name__ == '__main__':
    main()