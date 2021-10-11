import sys
import os 

dir_path = os.path.dirname(os.path.realpath(__file__))

sys.path.insert(0, dir_path)
sys.path.insert(0, dir_path + '/venv/lib/python3.8/site-packages')


from flaskapp import app as application