"""Handle users on linux systems.
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

import os
import commands

class User:   
    """Class for handling users on linux systems.
    """

    def __init__(self, user):
        """Inits DataFile.
        
        Args:
            username: Name of the user
            usertype: Default type for group settings etc.
        """       
        self.user_id = user[0]
        self.user_name = user[1]
        self.user_login = user[2]
        self.user_type = user[3]
        if self.check_user_existance() != True:
            self.set_groups()
            self.add_groups()
            self.add_user()
        
    def check_user_existance(self):
        """Check if home directory for the user exists already
        """
        exists = commands.getstatusoutput('egrep -i "' + self.user_login + \
                                    '" /etc/passwd')[0]
        if exists == 0:
            return True
        else:
            return False


    def set_groups(self):
        """Set groups for the user
        """
        if self.user_type == 'prime':
            self.groups=['ei_developers','ei_primes','ei_processors', \
                         'ei_staff','ei_students']

        elif self.user_type == 'staff':
            self.groups=['ei_developers','ei_processors', \
                         'ei_staff','ei_students']
        
        elif self.user_type == 'student':
            self.groups=['ei_students']
        
        elif self.user_type == 'student-developer':
            self.groups=['ei_developers','ei_processors','ei_students']
        
        elif self.user_type == 'student-processor':
            self.groups=['ei_processors','ei_students']
        
        elif self.user_type == 'processor':
            self.groups=['ei_processors']
        
        elif self.user_type == 'external-developer':
            self.groups=['ei_developers','ei_processors']
        
        elif self.user_type == 'external-prime':
            self.groups=['ei_developers','ei_primes','ei_processors']


    def add_user(self):
        """Adds a user to the system.
        """
        command = '/usr/sbin/useradd -c "' + self.user_name + '" "' + \
                  self.user_login + '" -u ' + self.user_id + \
                  ' -p porov123 -m -s /bin/bash -G ' + \
                  ",".join(self.groups)
        print command
        os.system(command)
        command = 'chage -d 0 ' + self.user_login
        print command
        os.system(command)


    def add_groups(self):
        """Add groups to system.
        """
        for group in self.groups:
            if self.check_group(group) == False:
                command = '/usr/sbin/groupadd -g ' + \
                          self.get_group_id(group) + ' ' + group
                print command
                os.system(command)


    def get_group_id(self, group):
        """Get group ID.
        """
        if group == 'ei_primes':
            return '9100'
        elif group == 'ei_developers':
            return '9125'
        elif group == 'ei_processors':
            return '9150'
        elif group == 'ei_staff':
            return '9200'
        elif group == 'ei_students':
            return '9300'


    def check_group(self, group):
        """Check if group exists.
        """
        exists = commands.getstatusoutput('egrep -i "' + \
                                          group + '" /etc/group')[0]
        if exists == 0:
            return True
        else:
            return False
