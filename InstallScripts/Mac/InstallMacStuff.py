# Installer script for 3rd party apps LAURA II DK
# Please note this script ONLY works in Python 2

from os.path import isfile
from os.path import isdir
from os.path import expanduser
from os import system
from os import makedirs

def cls():
	system("clear")
	
def yes(Question):
	answer = raw_input("%s ? <Y/N> "%Question)
	if answer=="": return False
	return answer[0].upper()=="Y"	

cls()
print "Hello, I'm going to install any 3rd party stuff you may want or need."
print "In order to do this I'll need HomeBrew."

if isfile("/usr/local/bin/brew"):
	 print "Since HomeBrew appears to be present on your system already it appears I can go to the next step"
	 raw_input("Hit enter to continue ")
else:
	 print "Since HomeBrew is not yet installed I will need to do it now."
	 if not yes("Am I allowed to install HomeBrew"):
		 print "In that case I'm sorry, but then I cannot continue"
		 print "You may go on with the LAURA II DK and install or accosiate stuff yourself."
		 raw_input("Hit enter to continue ")
		 quit()
	 print "Installing HomeBrew..."
	 system("/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"")
	 if isfile("/usr/local/bin/brew"):
		 print "Installation appears to be succesful!"
	 else:
		 print "Installation appears to have failed."
		 print "That means I cannot continue."
		 print "You can find this script inside the LAURA2DK.app bundle in Contents/Resources/InstallMacStuff.py"
		 print "If you find out what went wrong you can run this script again from there by using Python"
		 raw_input("Hit enter to continue ")
		 quit()
		 
# When we got Home Brew itself let's get to all packages.

packages = []

packages.append({ 'Doel':"Editing Graphics", 'Title':"GIMP",     'Cask':"gimp",     'app':"GIMP.app",    'CFG':"GFX"})
packages.append({ 'Doel':"Editing Audio",    'Title':"Audacity", 'Cask':"audacity", 'app':"Audacity.app",'CFG':"AUDIO"})
packages.append({ 'Doel':"Editing Scripts and text files", 
                                             'Title':"Geany",    'Cask':"geany",    'app':"Geany.app",   'CFG':"TXT"})

cls()
print "Right I'm now going to recommend some programs, install them if they are not installed yet."
print "Don't worry, I'll ask your permission for every install, so I'm not going to do things you don't want me to!"
print "Are you ready? Let's go then!"
raw_input("Hit enter to continue ")

LuaConfig = ""

for pkg in packages:
	cls()
	print "For %s I recommend the application %s"%(pkg['Doel'],pkg['Title'])
	okay = yes("Do you want this to use this application for this action")
	app = "/Applications/%s"%pkg['app']
	print app
	if okay and (not isdir(app)):
		print "This application appears not to be installed on your system"
		okay = yes("Do you allow me to install it")
		if okay:
			system("brew cask install %s"%pkg['Cask'])
	if okay:
		LuaConfig = "%s\n%s"%(LuaConfig,"ret.%s = '/Applications/%s'"%(pkg['CFG'],pkg['app']))
				 

configfile = "%s/Library/Application Support/LAURA2DK/GlobalConfig.lua"%expanduser("~")

cls()
print "Saving config file"
if isfile(configfile):
	with open(configfile, "a") as myfile:
		myfile.write("\n\n%s"%LuaConfig)
else:
	if not isdir("%s/Library/Application Support/LAURA2DK/"%expanduser("~")): makedirs("%s/Library/Application Support/LAURA2DK/"%expanduser("~"))
	with open(configfile, "w") as myfile:
		myfile.write("ret = {} \n\n%s"%LuaConfig)
print "All done!"
print "You can now hit enter to continue, and if this Window does not close automatically you can do so manually."
print "Have fun with the LAURA II DK"
raw_input()
