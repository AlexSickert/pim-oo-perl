#!/usr/bin/python

import sys

print('Content-Type: text/html; charset=utf-8\n\n')


import os

print os.environ.get("QUERY_STRING", "No Query String in url")



#import cgi
#import cgitb; cgitb.enable()
#print('Content-Type: text/html; charset=utf-8\n\n')
#form = cgi.FieldStorage()
#value = form['xxx']
#print value


print """

<form method="post" enctype="multipart/form-data" id="myform" name="myform"  action="test10.py"  >
Username: <input type="text" name="user">
yyyyy: <input type="text" name="yyyyyy">
<input type="file" name="fffff" id="ffff">
<input type="submit" value="Submit">
</form> 

"""

#print sys.stdin.readline()
#print sys.stdin.readline()
#print sys.stdin.readline()
#print sys.stdin.readline()


data = sys.stdin.readlines()
print data
