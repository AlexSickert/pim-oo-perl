# import MySQLdb as mdb
import sys

class DataAccessLayer:
	# -----------------------------------------------------------------------------------------------------------
	#constructor
	def __init__(self):
		self._server = ""
		self._modul = ""
		#db = _mysql.connect("85.214.79.126","dataDev","aDxfgH","dataDev", charset = "utf8", use_unicode = True)