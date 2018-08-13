import sys
reload(sys)
import xml.etree.ElementTree as ET
import urllib2
import datetime

cDATE = sys.argv[1]
STNID = sys.argv[2]

print('%s %s' % (cDATE,STNID))

cou = STNID+"_"+cDATE+".csv"
f = open(cou,'w')
f.write("%s,%s, \n" % ('DATE,TA',STNID))

sKEY = 'VqiOgHQ69nSztT32yg3%2BlWlqKEvWF%2Bx8OKWzhW5N7nVht%2BlraEw4LSVbDodJTs7r'
url1 = 'https://data.kma.go.kr/apiData/getData?type=xml&dataCd=ASOS&dateCd=HR&startDt='
url2 = '&startHh=00'
url3 = '&endDt='
url4 = '&endHh=23'
url5 = '&stnIds='
url6 = '&schListCnt=999&pageIndex=1&apiKey='

cRequest = url1+cDATE+url2+url3+cDATE+url4+url5+STNID+url6+sKEY
print('%s' % (cRequest))

# Load XML
doc = ET.ElementTree(file=urllib2.urlopen(cRequest))
root = doc.getroot()
# info_tag = root.find("info")
# print(info_tag.tag, info_tag.text)

for itemtag in root.iter("info"):
  STN_NM = itemtag.findtext("STN_NM")
  TM = itemtag.findtext("TM")
  STN_ID = itemtag.findtext("STN_ID")
  TA = itemtag.findtext("TA")
  #f.write("%s,%s,%s,%s, \n" % (TM,STN_ID,STN_NM,TA))
  f.write("%s,%s, \n" % (TM,TA))
f.close()
