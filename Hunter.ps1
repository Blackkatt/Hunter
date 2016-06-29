#requires -Version 1
Param($asset1, $asset2, $asset3, $asset4, $asset5, $asset6, $asset7, $asset8)

$Author = 'Blackkatt'
$Version = '1.0.0'
$ScriptName = 'Hunter'

#region Index
<#
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

		.PARAMETER Tool
		file path to par2.exe

		.EXAMPLE
		$par2Path='C:\PROGRA~2\sabnzbd\win\par2\x64\par2.exe'
		$par2Path="C:\Program Files (x86)\SABnzbd\win\par2\x64\par2.exe"

		.PARAMETER Search
		Find obfuscated & deobfuscated file name.

		.EXAMPLE
		Search methods:

		Extended:
		the value of "FMaxObFSize" is used to determen the obfuscated file. Typical exexution time 0.7 sec.
		$Search = 'extended'

		Basic:
		par2 files is read to get deobfuscated file name. Typical exexution time 13 sec.
		$Search = 'basic'

		.PARAMETER Filter
		Find obfuscated file.

		.EXAMPLE
		FMaxObFSize:
		filters out any par2's and assues that a file larger than "FMaxObFSize" can be the obfuscated file.
		$FMaxObFSize = '200000'

		.PARAMETER Exclude
		Find deobfuscated file name.

		.EXAMPLE
		EMaxPaFSize:
		excludes par2's larger then value of "EMaxPaFSize" as they are unlikly to contain the deobfuscated file name.
		$EMaxPaFSize = '50000'
#>
#endregion Index
#region Setup

# Tool
$par2Path = 'C:\PROGRA~2\sabnzbd\win\par2\x64\par2.exe' # file path to par2.exe.
    
# Search
$Search = 'extended' # method to use.
    
# Filter
$FMaxObFSize = '200000' # default is '200000' kilobyte (200 MB)

# Exclude
$EMaxPaFSize = '50000' # default is '50000' kilobyte (50 KB)

#endregion Setup

# DON'T CHANGE ANYTHING AFTER THIS LINE, THANKS.

#region SABnzbd variables

Set-Variable -Name SABvar1 -Value "$asset1" # 1	The final directory of the job (full path)
Set-Variable -Name SABvar2 -Value "$asset2" # 2	The original name of the NZB file		
Set-Variable -Name SABvar3 -Value "$asset3" # 3	Clean version of the job name (no path info and ".nzb" removed)
Set-Variable -Name SABvar4 -Value "$asset4" # 4	Indexer's report number (if supported)
Set-Variable -Name SABvar5 -Value "$asset5" # 5	User-defined category
Set-Variable -Name SABvar6 -Value "$asset6" # 6	Group that the NZB was posted in e.g. alt.binaries.x
Set-Variable -Name SABvar7 -Value "$asset7" # 7	Status of post processing. 0 = OK, 1=failed verification, 2=failed unpack, 3=1+21, -1=failed download
Set-Variable -Name SABvar8 -Value "$asset8" # 8	URL to be called when job failed (if provided by the server, it is always sent, so check parameter 7!) The URL is provided by some indexers as the X-DNZB-Failure header.2

#endregion Status
#region Evaluate

# set source directory prior to process.
Set-Location -Path $SABvar1

# get obfuscated & deobfuscated.
$SrcDirExc = Get-ChildItem -Exclude '*par2'
$SrcDirFil = Get-ChildItem -Filter '*par2'

# select file based on "FMaxObFSize / EMaxPaFSize"
$ObfFile = ForEach ($fileO in $SrcDirExc) 
{
	if ($fileO.Length -gt $FMaxObFSize) 
	{$fileO}
	$fn = $ObfFile
	$fileO = $fn
} # save name for later
		
$ParFile = ForEach ($fileP in $SrcDirFil) 
{
	if ($fileP.Length -lt $EMaxPaFSize) 
	{$fileP}
}

#endregion Evaluate
#region Output
$intro = "$ScriptName $Version by $Author `n"

$slowMethod = @"
Search Method: $Search - will use $($ParFile.Name) to repair $($ObfFile.Name)
"@
$alreadyDeobfuscated = @"
file already deobfuscated --> $($ObfFile.Name) `n the old name was $($fileO.Name) <--
"@
$skip = @"
no obfuscated file found in $SABvar1
"@
$extendedMethod = @"
Search Method: $Search - will look for deobfuscated name inside "$($ParFile.Name)"
Renaming:
"@
$report = @"
 $($ObfFile.Name) -->
"@

#endregion Output
#region Rename

if ($Search -match 'basic') 
{
	Write-Host $intro $slowMethod
	& $par2Path Repair $ParFile.Name $ObfFile.Name # Repair source files with par2.exe.
}
else
{
	if ($DeoFile -match $ObfFile.Name)
	{Write-Host $intro $alreadyDeobfuscated}
	else
	{
		if (-not ($ParFile | Test-Path)) 
		{Write-Host $intro $skip}
		else
		{
			$TrgFile = & $par2Path verify -q $ParFile.Name | Select-String -Pattern 'Target:'
			$DeoFile = if ($TrgFile -match '(?<=").*(?=")')	
			{$matches.Values}
			Write-Host $intro $extendedMethod
			Rename-Item -Path $ObfFile.Name -NewName $DeoFile
			Write-Host $report $DeoFile
		}
	}
}

#endregion Rename

