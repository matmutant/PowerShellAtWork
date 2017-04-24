#LICENSE: Creative Commons CC-BY-SA.
#Script Written by matmutant
#The aim of this PowerShell script is to remove file(s) from a directory where only the $nbFileToKeep most recent copies will be kept (sorted by timestamped name using alpha order)
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
">>> target dir: $targetDirectory"
">>> log filename: $logFile"
">>> file extension: $fileExtension"
">>> nb of file(s) to keep in target: $nbFileToKeep`n"
if (($targetDirectory -like "") -or ($fileExtension -like "") -or ($logFile -like "") -or ($nbFileToKeep -lt 1)) {
	"`n`r`n`r`nMISSING or INVALID parameters in $iniFile"
	"Use parameter for source, target, file extension and nb of file(s) to keep as following:"
	'[workDirectory]'
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
#The script logs everything in $logFile
Add-Content $targetDirectory\$logFile "`r`n`r`n`r`n$(Get-Date) - Started Cleaning processs"
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
#enable sleep for debugging purpose
Start-Sleep -s 10
