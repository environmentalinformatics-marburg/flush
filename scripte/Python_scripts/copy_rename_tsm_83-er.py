
"""Prepare reprocessing of level 0000 to level 0050 files (DFG-Exploratories).
Copyright (C) 2011 Thomas Nauss, Insa Otte, Falk Haensel

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

__author__ = "Thomas Nauss <nausst@googlemail.com>, Insa Otte, Falk Haensel"
__version__ = "2012-02-06"
__license__ = "GNU GPL, see http://www.gnu.org/licenses/"

import ConfigParser
import fnmatch
import os

def locate(pattern, patternpath, root=os.curdir):
    '''Locate files matching filename pattern recursively
    
    This routine is based on the one from Simon Brunning at
    http://code.activestate.com/recipes/499305/ and extended by the patternpath.
     
    Args:
        pattern: Pattern of the filename
        patternpath: Pattern of the filepath
        root: Root directory for the recursive search
    '''
    for path, dirs, files in os.walk(os.path.abspath(root)):
        for filename in fnmatch.filter(files, pattern):
            # Modified by Thomas Nauss
            if fnmatch.fnmatch(path, patternpath):
                yield os.path.join(path, filename)

def find_between( s, first, last ):
    try:
        start = s.index( first ) + len( first )
        end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""

def main():
    """Main program function
    Move data from initial logger import to level 0 folder structure.
    """
  
 
    start_dir = "adl-m/AEW/"
    station_dataset=locate("*.dat", "*", start_dir)
    
    for dataset in station_dataset:
	
	station = find_between(dataset,  start_dir, "/backup/"+ os.path.basename(dataset))
	print station
        if (station != "") :
		"""cmd =  "mv " + dataset + " " + start_dir + station + os.sep + "backup/"
			
		cmd = "mkdir -p " + start_dir + station + os.sep + "backup"
		os.system(cmd)
		print cmd
		"""
		ziel_dir = start_dir + station + os.sep + "backup/"
		
		if os.path.isdir(ziel_dir) :
			cmd = "mkdir -p " + start_dir + station + os.sep + "tsm "
			os.system(cmd)
			cmd =  "scp " + dataset + " " + start_dir + station + os.sep + \
			"tsm/" + os.path.basename(dataset).split(".dat")[0] + "_" + station + ".dat"
 			os.system(cmd)
					
	 		
     
        
if __name__ == '__main__':
    main()
