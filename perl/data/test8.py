#!/usr/bin/python3.1

import sys
# reload(sys)
# sys.setdefaultencoding('utf-8')

# import pymysql

import MySQLdb
# import _mysql

# import pip

# import sys

# from unidecode import unidecode



print('Content-Type: text/html; charset=utf-8\n\n')

print("------------------------------------------------------------------------ start ------------------------------- ")


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