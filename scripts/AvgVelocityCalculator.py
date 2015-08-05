#!/usr/bin/python

import os
import sys
import math
import xml.dom.minidom

class AppInfo(object):
	def __init__(self):
		self.infilename = None

def usageExit():
	sys.stderr.write("usage: gpxlen infile\n")
	sys.exit(1)

def parseCommandLine(argv):
	ai = AppInfo()

	argv.pop(0)

	while len(argv) > 0:
		if ai.infilename == None:
			ai.infilename = argv[0]
		else:
			usageExit()

		argv.pop(0)

	if ai.infilename == None:
		usageExit()

	return ai

def getSegmentLength(segmentNode):
	t = 0.0
	d = 0.0
	totald = 0.0
	totalt = 0.0
	oldLat = None
	oldLon = None
	oldTime = None

	for pt in segmentNode.getElementsByTagName("trkpt"):
		lat = float(pt.getAttribute("lat")) * math.pi/180.0
		lon = float(pt.getAttribute("lon")) * math.pi/180.0
		ele = float(pt.getElementsByTagName('ele')[0].firstChild.data)
        	time = pt.getElementsByTagName('time')[0].firstChild.data

		if oldLat != None:
			#t += math.acos(
			#	math.cos(lat) * math.cos(lon) * math.cos(oldLat) * math.cos(oldLon) +
			#	math.cos(lat) * math.sin(lon) * math.cos(oldLat) * math.sin(oldLon) +
			#	math.sin(lat) * math.sin(oldLat)
			#) * 6378100.0

			cosa = (math.sin(lat) * math.sin(oldLat) +
				math.cos(lat) * math.cos(oldLat) *
				math.cos(oldLon - lon))

			if cosa > 1.0: cosa = 1.0

			#sys.stdout.write("T: %s \n " % t)
			d = math.acos(cosa) * 6378100.0
			totald += d

		oldLat = lat
		oldLon = lon

		if oldTime !=None:
			t=getTime(time)
			totalt += (t-oldTime)
			oldTime=0
			
		oldTime = t
		
		sys.stdout.write("D: %s \n " % d)
		sys.stdout.write("T: %s \n " % t)
	
	h=totalt/3600	
	vel=totald/h
	sys.stdout.write("TotalT : %s\n" % totalt)
	sys.stdout.write("Avg vel : %s\n" % vel)
	return totald

def getTime(inputTime):

	time=inputTime.split('T')
	t=time[1].replace('Z','').split(':')
	
	#sys.stdout.write("T0 : %s\n" % t[0])
	#sys.stdout.write("T1 : %s\n" % t[1])
	#sys.stdout.write("T2 : %s\n" % t[2])
	totalTime=float(t[2])+(60*float(t[1]))+(3600*float(t[0]))
	return totalTime

def getTrackLength(trackNode):
	t = 0.0
	for seg in trackNode.getElementsByTagName("trkseg"):
		t = t + getSegmentLength(seg)

	return t

def main(argv):
	folderCount = 0
	total = 0.0
	ai = sys.argv[1]
	#ai = parseCommandLine(argv)

	for root, subFolders, files in os.walk(ai):
		folderCount += len(subFolders)
		for file in files:
        		f = os.path.join(root,file)
			if f.lower().endswith('.gpx'):
	        		#fileSize = fileSize + os.path.getsize(f)
	        		#print(f)
	        		#fileList.append(f)
				sys.stdout.write("%s : " % f)
				dom = xml.dom.minidom.parse(f)	
				#gpxNode = dom.firstChild
				#for track in gpxNode.getElementsByTagName("trk"):
				for track in dom.getElementsByTagName("trk"):
					#nameNode = track.getElementsByTagName("name")
					#if nameNode != None:
					#	name = nameNode[0].firstChild.data
					#else:
					#	name = "<no name>"

					total = total + getTrackLength(track)
					km = getTrackLength(track)/1000
					
					sys.stdout.write("%d km\n" % km)
					#sys.stdout.write("%.3f" % getTrackLength(track))
	
	
	tkm = total/1000
	sys.stdout.write("Total : %d km\n" % tkm)
	fichier=open(ai+"/length","w")
	fichier.writelines("%s" % ai)
	fichier.writelines(" : %d km\n" % tkm)
	fichier.close()
			#return 0

if __name__ == "__main__": sys.exit(main(sys.argv))

