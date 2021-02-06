import hashlib
import sys
import mysql.connector


plain = sys.argv[1]
encoded = hashlib.md5(plain.encode()).hexdigest().lower()


                
print ("hash = " , encoded )


