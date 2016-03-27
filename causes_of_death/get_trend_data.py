from pytrends.pyGTrends import pyGTrends
import time
from random import randint
import os

google_username = "poldracklab@gmail.com"
google_password =open('plab.pw').readline().strip()
path = "./trends_data/"
if not os.path.exists(path):
    os.mkdir(path)

# connect to Google
try:
    connector
except:
    connector = pyGTrends(google_username, google_password)

# heart attack
# Breast cancer
# Lung cancer
# Stroke
# COPD
# Influenza/pneumonia
# Liver disease
# Diabetes mellitus
# alzheimer
# HIV/AIDS
# Traffic collision
# Poison
# kidney disease
# Suicide
# Homicide
# accidental fall
# food allergy death
# pneumonitis
searchcodes={}
searchcodes['heart attack']='/m/0gk4g'
searchcodes['breast cancer']='/m/0j8hd'
searchcodes['lung cancer']='/m/04p3w'
searchcodes['stroke']='/m/02y0js'
searchcodes['COPD']='/m/0gzv0'
searchcodes['influenza']='/m/0cycc'
searchcodes['pneumonia']='pneumonia'
searchcodes['liver disease']='/m/097ns'
searchcodes['diabetes']='/m/0c58k'
searchcodes['alzheimer']='/m/0dcsx'
searchcodes['AIDS']='/m/0d19y2'
searchcodes['traffic collision']='/m/08q1tg'
searchcodes['poisoning']='/m/0dh11'
searchcodes['kidney disease']='kidney disease'
searchcodes['suicide']='/m/06z5s'
searchcodes['homicide']='/m/0x2fg'
searchcodes['fall']='accidental fall'
searchcodes['pneumonitis']='pneumonitis'



for k in searchcodes.keys():
    connector.request_report(searchcodes[k])

    # wait a random amount of time between requests to avoid bot detection
    time.sleep(randint(5, 10))

    # download file
    connector.save_csv(path, k.replace(' ','_'))
