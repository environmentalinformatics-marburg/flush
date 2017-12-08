"""Create timeseries of climate elements (air temperature, precipitation, sunshine duration).
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

__author__ = "Insa Otte"
__version__ = "2012-01-16"
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
    parser = optparse.OptionParser("usage: %prog [options] data_file_01 " + \
                                       "data_file_02") 
    parser.add_option("-s","--sdt", dest="start_datetime",
                          help="Start year of the output time series (YYYY).",
                          metavar="integer", type="int")
    parser.add_option("-e","--edt", nargs=1, dest="end_datetime",
                          help="End year of the output time series (YYYY)",
                          metavar="integer", type="int")
    parser.add_option("-p", "--pla", dest="top_level_station_path", 
                          help = "Name of top level station path",
                          metavar="string", type="str")
    parser.add_option("-o", "--out", dest="output_path", 
                          help = "Name of output path",
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
    print top_level_station_path
    a = os.walk(top_level_station_path)
    write_header = True
    for station_id in a.next()[1]:
        print station_id
        station_path = top_level_station_path + os.sep + station_id
    

        # Set filepath with respect to actual station
        act_file_1 = station_path + os.sep + "de.dwd.nkdz.TAMM.xml"
        act_file_2 = station_path + os.sep + "de.dwd.nkdz.RRMS.xml"
        act_file_3 = station_path + os.sep + "de.dwd.nkdz.SDMS.xml"
        #outfile = os.path.split(act_file_1)[0] + os.sep + os.path.split(act_file_1)[0].split("/")[-1] + ".txt"
        outfile = output_path + os.sep + station_id + ".txt"
        outfile = output_path + os.sep + "nkdz_level0000.txt"
        print "Processing files:"
        print act_file_1
        print act_file_2
        print act_file_3
        print outfile

        
        # Check if input files exist
        ta_exists = False
        p_exists = False
        sd_exists = False
        if os.path.isfile(act_file_1):
            ta_exists = True
            data_1 = open(act_file_1, 'r')
        if os.path.isfile(act_file_2):
            p_exists = True
            data_2 = open(act_file_2, 'r')
        if os.path.isfile(act_file_3):
            sd_exists = True
            data_3 = open(act_file_3, 'r')
       
        # Open files
        
        header =  "Datetime, Aggregationtime, Station, Lat, Lon, Alt, Qualityflag, Ta_200, P_RT_NRT, SD"
        coordinates = []
        first_row = False
        dataset_1 = []
        if ta_exists:
            for row in data_1:
                try:
                    date = row.split(">")[0].split('"')[1]
                    value_1 = float(row.split(">")[1].split("<")[0])
                    dataset_1.append([date, value_1])
                    var_1 = str(row.split(">")[0].split('"')[2])
                    if var_1 == ' latitude=':
                        lat = row.split('"')[3]
                        lon = row.split('"')[5]
                        alt = row.split('"')[7]
                    elif var_1 == ' longitude=':
                        lon = row.split('"')[3]
                        alt = row.split('"')[5]
                    elif first_row == False:
                        lat = row.split('"')[5]
                        lon = row.split('"')[7]
                        alt = row.split('"')[9]
                        first_row = True
                    coordinates.append([date, lat, lon, alt])
                except:
                    continue
                
        dataset_2 = []
        if p_exists:
            for row in data_2:
                try:
                    date = row.split(">")[0].split('"')[1]
                    value_2 = float(row.split(">")[1].split("<")[0])
                    dataset_2.append([date, value_2])
                    var_2 = str(row.split(">")[0].split('"')[2])
                    if var_2 == ' latitude=': 
                        lat = row.split('"')[3]
                        lon = row.split('"')[5]
                        alt = row.split('"')[7]
                    elif var_2 == ' longitude=': 
                        lon = row.split ('"')[3]
                        alt = row.split ('"')[5]
                    elif first_row == False: 
                        lat = row.split('"')[5]
                        lon = row.split('"')[7]
                        alt = row.split('"')[9]
                        first_row = True
                    coordinates.append([date, lat, lon, alt])
                except:
                    continue
                
        dataset_3 = []
        if sd_exists:
           for row in data_3:
               try:
                    date = row.split(">")[0].split('"')[1]
                    value_3 = float(row.split(">")[1].split("<")[0])
                    dataset_3.append([date, value_3])
                    var_3 = str(row.split(">")[0].split('"')[2])
                    if var_3 == ' latitude=':
                        lat = row.split('"')[3]
                        lon = row.split('"')[5]
                        alt = row.split('"')[7]
                    elif var_3 == ' longitude=':
                        lon = row.split('"')[3]
                        alt = row.split('"')[5]
                    if first_row == False:
                        lat = row.split('"')[5]
                        lon = row.split('"')[7]
                        alt = row.split('"')[9]
                        first_row = True
                    coordinates.append([date, lat, lon, alt])
               except:
                   continue

        
        print len(dataset_1)
        print len(dataset_2)
        print len(dataset_3)
       
        
        
        if first_row == True:
            data_output = []
            for act_year in range(start_datetime, end_datetime+1):
                for act_month in range(1, 13):
                    act_time = str(act_year) + "-" + str(act_month)
                    act_time = datetime.datetime.strptime(act_time, "%Y-%m")
                    dt = [time.strftime("%Y-%m",act_time.timetuple())]
                    station = ["s1m01"] + [station_id]

                    found_corresponding_data = False
                    found_coord = False
                    for i in range(len(dataset_1)):
                        if act_time == datetime.datetime.strptime(dataset_1[i][0],"%Y-%m"):
                            datavalue = [dataset_1[i][1]]
                            coord = coordinates[i][1:4]
                            found_coord = True
                            found_corresponding_data = True
                    if found_corresponding_data != True:
                        datavalue = ['NaN']
                        coord = ['NaN', 'NaN', 'NaN']
    
                    found_corresponding_data = False
                    for i in range(len(dataset_2)):
                        if act_time == datetime.datetime.strptime(dataset_2[i][0],"%Y-%m"):
                            datavalue = datavalue + [dataset_2[i][1]]
                            coord = coordinates[i][1:4]
                            found_coord = True
                            found_corresponding_data = True
                    if found_corresponding_data != True:
                        datavalue = datavalue + ['NaN']
    
                    found_corresponding_data = False
                    for i in range(len(dataset_3)):
                        if act_time == datetime.datetime.strptime(dataset_3[i][0],"%Y-%m"):
                            datavalue = datavalue + [dataset_3[i][1]]
                            coord = coordinates[i][1:4]
                            found_coord = True
                            found_corresponding_data = True
                    if found_corresponding_data != True:
                        datavalue = datavalue + ['NaN']
        
                    data_output.append(dt + station + coord + ['xxxxxxxxx'] + datavalue)
    
            outfile = open(outfile,"a")
            if write_header == True:
                outfile.write(header + '\n')
                write_header = False
            writer = csv.writer(outfile, delimiter=',', quoting=csv.QUOTE_NONNUMERIC)
            for row in data_output:
                writer.writerow(row)
            outfile.close()
            header = None
            lat = None
            lon = None
            alt = None
        
if __name__ == '__main__':
    main()





