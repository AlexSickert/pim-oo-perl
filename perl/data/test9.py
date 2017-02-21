#!/usr/bin/python3.1

import cgi
import cgitb
cgitb.enable()
import sys

import MySQLdb

print('Content-Type: text/html; charset=utf-8\n\n')

print("------------------------------------------------------------------------ start ------------------------------- ")




print("<br>parameters<br>")


f = cgi.FieldStorage()
for i in f.keys():
    print "- <p>",i,":",f[i].value

print("<br>parameters end<br>")


form = cgi.FieldStorage() 
xxx = form.getvalue('xxx')

print("<br>-----------------------------<br>")

print xxx 

print("<br>-----------------------------<br>")
yyy = form.getvalue('yyy')
print yyy 

print("<br>-----------------------------<br>")


#form = cgi.FieldStorage()
#variable = ""
#value = ""
#r = "" 
#for key in form.keys():
#    variable = str(key)
#    value = str(form.getvalue(variable))
#    r += "<p>"+ variable +", "+ value +"</p>\n" 
#fields = "<p>"+ str(r) +"</p>"  
#print fields

# ---------------------------

#d = parse_qs(environ['QUERY_STRING'])
#print d
# age = d.get('age', [''])[0] 

# /var/www/vhosts/alex-admin.net/statistics/logs 

# /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/python


# db = MySQLdb.connect("85.214.79.126","dataDev","aDxfgH","dataDev", charset="utf8", use_unicode=True)
db = MySQLdb.connect("85.214.79.126","dataDev","aDxfgH","dataDev", use_unicode=True, charset="UTF8")



# con = mdb.connect('loclhost', 'root', '', 'mydb',                   use_unicode=True, charset='utf8')

print db.character_set_name()

cur = db.cursor() 


# Use all the SQL you like
cur.execute("select id, parent_id, description, list_ids  from the_list_cross")

# print all the first cell of all the rows
for row in cur.fetchall() :
    print row[0]
    print row[1]
    #print row[2]
    # print unicode(row[2], 'utf8')
    string = row[2]
    print string.encode('utf8', 'replace')
    print "<br>"
     





# db=_mysql.connect("localhost","joebob","moonpie","thangs")

#conn = pymysql.connect(host='85.214.79.126', user='dataDev', passwd='aDxfgH', db='dataDev')
#conn.autocommit(True)
#cur = conn.cursor()

#memory = '100'

#cur.execute("""select id, parent_id, description, list_ids , 'childs' as childs  from the_list_cross""".format(memory))

#for x in cur.fetchall(): # only runs once
#    print(x[0])

print(sys.version_info )