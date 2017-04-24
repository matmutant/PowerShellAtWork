#LICENSE: Creative Commons CC-BY-SA.
#Script Written by matmutant
#The aim of this PowerShell script is to copy a timestamped file (in name) to a directory where only the $nbFileToKeep most recent copies will be kept (sorted by timestamped name using alpha order)
#The source file should be named BACK_YYYYMMDD_HHmm.foo to make sure the most recent files are at the end of the generated array
#Make sure there is ONLY the file of interest in the Source or you'll get in trouble.
#Set the source and target directories and file extension using the parameters:
#Note: don't put a trailing \ at the end of the path
#Note: use ABSOLUTE path if you ever want to use task scheduler to launch the script
#Use parameters for source, target, file extension and nb of file(s) to keep in $iniFile
#
Param
(
	[string]$iniFile
)
#Checks if iniFile parameter is set or exist
$ifExist = Test-Path $iniFile
if (($iniFile -like "") -or ($ifExist -eq $false)) {
	"`n`r`n`r`nMISSING or INVALID parameter: -iniFile"
	Start-Sleep -s 10
	exit
}
#grabs ini content and push it to hash table
Get-Content $iniFile |
foreach-object -process {
	$k = [regex]::split($_,'=')
	if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True) -and ($k[0].StartsWith("#") -ne $True)) {
		New-Variable -Name $k[0] -Value $k[1]
		#Get-Variable -Name $k[0] -ValueOnly
	} 
}
#displays parameters for debugging 
"parameters passed to script:"
">>> source dir: $sourceDirectory"
">>> target dir: $targetDirectory"
">>> log filename: $logFile"
">>> file extension: $fileExtension"
">>> nb of file(s) to keep in target: $nbFileToKeep`n"
if (($sourceDirectory -like "") -or ($targetDirectory -like "") -or ($fileExtension -like "") -or ($logFile -like "") -or ([int]$nbFileToKeep -lt 1)) {
	"`n`r`n`r`nMISSING or INVALID parameters in $iniFile"
	"Use parameter for source, target, file extension and nb of file(s) to keep as following:"
	'[workDirectories]'
	'sourceDirectory=.\data_Source'
	'targetargetDirectoryectory=.\data_Target'
	'[logFileName]'
	'logFile=logFile.log'
	'[fileExtension]'
	'fileExtension=csv'
	'[nbFileToKeep]'
	'nbFileToKeep=3'
	Start-Sleep -s 10
	exit
}
#Source filename is set by scanning the folder for the .$fileExtension file:
$source = Get-ChildItem "$sourceDirectory" -Name -Filter *.$fileExtension
#The script logs everything in $logFile
Add-Content $targetDirectory\$logFile "`r`n`r`n`r`n$(Get-Date) - Started Copying and Cleaning processs"
#checks if there is only one single file listed.
if ($source.Count -ne 1) {
	"Aborted, there is not only one file of interest in there."
	Add-Content $targetDirectory\$logFile "$(Get-Date) - Copy aborted, reason: 0 or more than 1 file in source."
}
else {
	#Copies the source *.$fileExtension from source directory to target directory
	"Copying process:"
	">>> Copying $source file to folder"
	Copy-Item $sourceDirectory\$source $targetDirectory\
	Add-Content $targetDirectory\$logFile "$(Get-Date) - Copied $source from source directory"
	#Starts the cleaning process
	$a = Get-ChildItem "$targetDirectory" -Name -Filter *.$fileExtension
	"Deletion process:"
	#note that arrays start at 0...
	$n = [int]$nbFileToKeep + 1
	#$a.Count -ge $n ==> checks if there are at least $nbFileToKeep files in the directory
	if ($a.Count -ge $n) {
		">>> This will delete every single *.$fileExtension present in the directory but the $nbFileToKeep latest ones, sorted by name."
		">>> Files to be considered: $a"
		#$b is the array size minus $n, to keep the $nbFileToKeep last items
		$b = ($a.Count-$n)
		Foreach ($filebak in $a[0..$b]) {
			">>> deleting: $filebak"
			Add-Content $targetDirectory\$logFile "$(Get-Date) - Deleted $filebak from target directory, kept $nbFileToKeep backup(s)"
			Remove-Item $targetDirectory\$filebak
		}
	}
	else {
		">>> Deletion aborted, there is at most $nbFileToKeep files in the directory. Keep Yo Backup!"
		Add-Content $targetDirectory\$logFile "$(Get-Date) - Deletion aborted, reason: not enough backup files"
	}
}
#enable sleep for debugging purpose
Start-Sleep -s 10
