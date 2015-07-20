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

from User import User

users = [ \
         #('1000', 'Dogbert', 'dogbert', 'prime'), \

         # Auto processors
         #('1600', 'EI-Autoprocessor', 'eiautoprocessor', 'processor'), \
         ('1610', 'EI-KI-Stations', 'eikistations', 'processor'), \
         ('1620', 'EI-BE-Stations', 'eibestations', 'processor'), \

         # Staff
         ('2000', 'Thomas Nauss', 'tnauss', 'staff'), \
         ('2001', 'Meike Kuehnlein', 'mkuehnlein', 'staff'), \
         ('2003', 'Tim Appelhans', 'tappelhans', 'staff'), \
         ('2004', 'Falk Haensel', 'fhaensel', 'staff'), \
         ('2005', 'Renate Fortevar', 'rforteva', 'staff'), \
      	 ('2006', 'Florian Detsch', 'fdetsch', 'staff'), \
      	 ('2007', 'Insa Otte', 'iotte', 'staff'), \
         ('2008', 'Josephine Sonnenberg', 'jsonnenberg', 'staff'), \
         ('2009', 'Ephraim Mwangomo', 'emwangomo', 'staff'), \
         # Student helpers
         ('3001', 'Melanie Schnelle', 'schnell3', 'student-processor'), \
         ('3004', 'Simon Schlauss', 'sschlauss', 'student-processor'), \
         #('3005', 'Johanes Droenner', 'jdroenner', 'student-processor')
         # Externals         
         #('4000', 'Maik Dobbermann', 'mdobbermann', 'prime'), \
         #('4001', 'Tobias Ebert', 'tebert', 'prime') \
        ]  
         
for user in users:
    new_user = User(user)

