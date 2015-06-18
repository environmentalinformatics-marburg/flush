"""This programm renames the images from the given directory. 
The name have to be created by datetime from the meta data datetime exif
Copyright (C) 2013, Spaska forteva

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
reports to spaska.forteva@geo.uni-marburg.de
"""
from string import split

__author__ = "Spaska Froteva<spaska.forteva@geo.uni-marburg.de>"
__version__ = "2013-08-08"
__license__ = "GNU GPL, see http://www.gnu.org/licenses/"

import os
import re 
from PIL import Image
from PIL.ExifTags import TAGS
from optparse import OptionParser
from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw

""" Read from the console the directory with the images
"""
parser = OptionParser()
parser.add_option('-s', '--source', 
                  dest = "source", 
                  default = "/home/dogbert/workspace/tlc/video_data",
                  )
parser.add_option('-d', '--dest', 
                  dest = "dest", 
                  default = "/home/dogbert/workspace/tlc/test_bilder",
                  )
(options, args) = parser.parse_args()

src = options.source
dest = options.dest
print 'Module: be_process_level0100'
print 'Version: ' + __version__
print 'Author: ' + __author__
print 'License: ' + __license__
print   


def get_exif(image):
    ret = {}
    from PIL.ExifTags import TAGS as id_names
    image_tags = image._getexif()
    creation_date = image_tags[36867]
    date = (split(creation_date, " "))[0]
    time = split(creation_date, " ")[1]
    date = re.sub (':', '-', date)
    return date + " " + time  
   
def rename_files(root, files):
    '''Matching filename to datetime as name

    Args:
        root: Root directory 
        files: List with the files
    '''
    try:
        index = 0
        for filename in files:
           ret = {}
           from PIL.ExifTags import TAGS as id_names
           stringFileName = str(index) 
           image = Image.open(root + "/" + filename)
           dateTime = get_exif(image)
           if index < 10: 
               stringFileName = "0000" + str(index) 
               
           else:
               if index == 10 or index < 100:
                   stringFileName = "000" + str(index) 
               else:
                   if index == 100 or index < 1000:
                       stringFileName = "00" + str(index) 
               
                   else:
                       if index == 1000 or index < 10000:
                           stringFileName = "0" + str(index) 
               
           #font = str(request.GET.get('font', 'arial'))        
           draw = ImageDraw.Draw(image)
           draw.text((10, 830),dateTime,(255,255,255),)
           draw = ImageDraw.Draw(image)
           
           if not os.path.exists(stringFileName):
               image.save(dest + "/" + stringFileName + ".JPG")
               #os.rename(root + "/" + filename, root + "/" + stringFileName + ".JPG")
               index = index + 1

    except Exception as inst:
        print "An error occured."
        print "Some details:"
        print "Exception type: " , type(inst)
        print "Exception args: " , inst.args
        print "Exception content: " , inst     


def main(src):
    '''Call the file rename recursively

    Args:
        src: Source directory for the recursive search
    '''
    try:
        for mainRoot, meinDirs, mainFiles in os.walk(src):
            if len(mainFiles) > 0:
                rename_files(mainRoot, mainFiles)
            if len(meinDirs) > 0:
                for dir in meinDirs:
                    main(mainRoot + dir)
            
                
    except Exception as inst:
        print "An error occured."
        print "Some details:"
        print "Exception type: " , type(inst)
        print "Exception args: " , inst.args
        print "Exception content: " , inst     
            

main(src)