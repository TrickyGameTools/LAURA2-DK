# Exporting to Mac from Windows

The LAURA II DK does support exporting to Mac, even from Windows. After all, LAURA II is only an interpreter, so the DK isn't dependent on XCode, the official development kit for Mac on which nearly all compilers for Mac are reliant.
There are are few things you should know when exporting to Mac, or you may get your mac users pretty angry.

# .app bundles

What you will see when exporting your game to Mac is that a folder will be created. Like this "<mygame>.app". This folder contains one folder named "Contents" and in there you'll find several folders, files most notably "MacOS" and "Resources".
Now it's pretty important to realize that I've just let you into the secret that makes Mac applications so portable. 

When distributing your game for Mac, you must distribute this .app folder AS A WHOLE, (which includes the folder with the .app name itself). A mac user will not see your game as a folder, but just as an application. Clicking it twice in the Finder (the file manager on Mac) will not open the folder, but the application inside the folder. All other folders and files are just the data belonging to the game. Neglecting to do this properly will lead into either a broken application or no application at all.

The exporter does support the bundle to be packed properly, so if you are not sure how to deal with Mac application bundles, you can best check the proper checkbox for it, in order to get this done right.



# Invalid application

Sometimes it can still happen Mac will say an application is broken. This is not a bug in the exporter. This is an issue between Windows and Mac.
To explain why that happens I need to tell you a few nerdy details about the two OSes. 
Windows is part of the DOS family, along with MS-DOS, OS/2, DR-DOS, FreeDOS.
Mac is part of the Unix family, along with Linux, and many other OSes.

The systems in the DOS family recognize program files by the .exe (executable) or .com (command) suffixes (although .com is no longer commonly used). 
That makes exporting your game to Windows for Mac quite easily as Mac can just put .exe behind the executable files, and Windows will never be the wiser.
To Mac things are a bit more complicated, as Unix as a different approach to this. Unix uses the attribute system for this and puts the "x" attribute to a file in order to make it recognizable as an executable. Without this attribute, Unix will not execute a file, wether it's a program file or not.
Windows has as a member of the DOS family no support at all for the "x"-attribute. 

To make matters even worse as that packer systems such as zip, rar and 7z so no need to attach these attributes during packing from Windows. When using these packers, even directly from the exporter this issue can therefore come up.
Mac versions will therefore come with a little shellscript that can put all the attributes to the respective files.


The only way to get around this from Windows is to install Linux in a VM (like Virtual Box) copy the game in there and attach the attribute to the correct files, but as this is a pretty time-consuming and inefficient way of working, I am currently experimenting with ways to solve this properly.


# Cheap trick

Mac is able to read FAT32, NTFS and ExFAT. File systems native to Windows. When you put the app bundle on a memory stick from Windows, and plug it in a Mac, and zip everything from there, the application will work on other Mac (as Mac will put the x attribute automatically on all files located on a "foreign" file system). This even works when you perform the zipping on an outdated PPC mac. 
This trick does unfortunately NOT work on Linux (unless you specifically confired Linux in the same manner as Mac is configured for this, but that can be one hell of a job if you are not well-versed in the inner usage of Unix based systems).


