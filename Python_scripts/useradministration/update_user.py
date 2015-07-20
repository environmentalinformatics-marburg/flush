""" Test Handle users on linux systems.
Copyright (C) 2011 Thomas Nauss

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

__author__ = "Thomas Nauss <nausst@googlemail.com>"
__version__ = "2011-12-17"
__license__ = "GNU GPL, see http://www.gnu.org/licenses/"

# To run the script as cronjob enter the following line in sudo crontab -e
# */30 * * * * bash python /home/dogbert/administration/update_user.py >> /home/dogbert/administration/update_user.log 2>&1


import os

os.chdir('/home/dogbert/administration')

command = 'hg clone /mnt/sd19003/ui-staff/development/administration/user-management'
os.system(command)

os.chdir('/home/dogbert/administration/user-management/src/')
command = 'sudo python add_user.py'
os.system(command)

os.chdir('/home/dogbert/administration')
command = 'sudo rm -r user-management'
os.system(command)

