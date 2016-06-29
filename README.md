# Hunter
Hünter is a powershell post processing script for @SABnzbd that renames obfuscated files


	.SYNOPSIS
	  Renames obfuscated files.

	.DESCRIPTION
	  Uses par2.exe included with SABnzbd++ to read *par2 files to get the deobfuscated file name.

	.NOTES
	  Put "HunterLNCHR.cmd" and "Hunter.ps1" inside "C:\Users\YourUserName\AppData\Local\sabnzbd\post-processing".
	  Set "HunterLNCHR.cmd" location in ../sabnzbd/config/folders/ "Post-Processing Scripts Folder".
	  Select "HunterLNCHR.cmd" for desired category in ../sabnzbd/config/categories/ "Script" (only tv-series have been tested).
	  Set your settings in 'Hunter.ps1'
	  Use at own risk. I'm no programmer =).
