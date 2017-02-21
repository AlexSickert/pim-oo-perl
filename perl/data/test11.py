#!/usr/bin/python



import cgi
form_data = cgi.FieldStorage()
file_data = form_data['myfile'].value




print """

<form method="post" enctype="multipart/form-data" id="myform" name="myform"  action="test10.py"  >
Username: <input type="text" name="user">
yyyyy: <input type="text" name="yyyyyy">
<input type="file" name="fffff" id="ffff">
<input type="submit" value="Submit">
</form> 

"""

print data
