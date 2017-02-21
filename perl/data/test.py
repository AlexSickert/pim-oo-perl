#!/usr/bin/python3.1



# import pymysql

# import MySQLdb
import _mysql

import pip

import sys



print('Content-Type: text/html; charset=utf-8\n\n')



installed_packages = pip.get_installed_distributions()
installed_packages_list = sorted(["%s==%s" % (i.key, i.version)
# for i in installed_packages])
# print installed_packages_list



# db = Mysql.connect("85.214.79.126","dataDev","aDxfgH","dataDev", charset = "utf8", use_unicode = True)



#conn = pymysql.connect(host='85.214.79.126', user='dataDev', passwd='aDxfgH', db='dataDev')
#conn.autocommit(True)
#cur = conn.cursor()

#memory = '100'

#cur.execute("""select id, parent_id, description, list_ids , 'childs' as childs  from the_list_cross""".format(memory))

#for x in cur.fetchall(): # only runs once
#    print(x[0])


print(sys.version_info )