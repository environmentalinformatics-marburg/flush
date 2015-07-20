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
         #('1000', 'Dogbert', 'dogbert', 'prime', False), \

         # Auto processors
         #('1600', 'EI-Autoprocessor', 'eiautoprocessor', 'processor', False), \
         #('1610', 'EI-KI-Stations', 'eikistations', 'processor', False), \
         #('1620', 'EI-BE-Stations', 'eibestations', 'processor', False), \

         # Staff
         ('2000', 'Thomas Nauss', 'tnauss', 'staff', False), \
         ('2003', 'Tim Appelhans', 'tappelhans', 'staff', False), \
         ('2004', 'Falk Haensel', 'fhaensel', 'staff', False), \
         ('2005', 'Spaska Forteva', 'sforteva', 'staff', False), \
      	 ('2006', 'Florian Detsch', 'fdetsch', 'staff', False), \
      	 ('2007', 'Insa Otte', 'iotte', 'staff', False), \
         ('2008', 'Felix Staeps', 'fstaeps', 'staff', False), \
         ('2009', 'Ephraim Mwangomo', 'emwangomo', 'staff', False), \
         ('2010', 'Stephan Woellauer', 'swoellauer', 'staff', False), \
         # Student helpers
         ('3001', 'Alice Ziegler', 'aziegler', 'student-processor', False), \
         ('3002', 'Eva-Vanessa Wilzek', 'ewilzek', 'student-processor', False), \
	 ('3003', 'Benjamin Schumacher', 'bschumacher', 'student-processor', False), \
	 ('3004', 'Jan Moll', 'jmoll', 'student-processor', False), \
	 ('3005', 'Annika Ludwig', 'aludwig', 'student-processor', False), \
	 ('3006', 'Elena Rinn', 'erinn', 'student-processor', False), \
         ('3007', 'Jochen Weiland', 'jweiland', 'student-processor', False)
         # Externals         
         #('4000', 'Maik Dobbermann', 'mdobbermann', 'prime', False), \
         #('4001', 'Tobias Ebert', 'tebert', 'prime', False) \
        ]  
         
for user in users:
    new_user = User(user)

