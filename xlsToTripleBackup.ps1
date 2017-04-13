#The aim of this PowerShell script is to copy a timestamped file (in name) to a directory where only the 3 most recent copies will be kept (sorted by timestamped name using alpha order)
#The source file should be named BACK_YYYYMMDD_HHmm.xls to make sure the most recent files are at the end of the generated array
#Make sure there is ONLY the file of interest in the Source or you'll get in trouble.
#Set the source and target directories using the parameters:
#Note: don't put a trailing \ at the end of the path
#Note: use ABSOLUTE path if you ever want to use task scheduler to launch the script
#Use parameters for source $sdir and target $tdir as following:
# .\BackupAndVersXLS.ps1 -sdir ".\data_Source" -tdir ".\data_Target"
Param
(
	[string]$sdir,
	[string]$tdir
)
if (($sdir -like "") -or ($tdir -like "")) {
	"MISSING arguments -sdir and -tdir"
	"Use parameter for source $sdir and target $tdir as following:"
	'".\BackupAndVersXLS.ps1 -sdir ".\data_Source" -tdir ".\data_Target"'
	exit
}
#Source filename is set by scanning the folder for the .xls file:
$source = Get-ChildItem "$sdir" -Name -Filter *.xls
#The script logs everything in log.txt
Add-Content $tdir\log.txt "`r`n`r`n`r`n$(Get-Date) - Started Copying and Cleaning processs"
#checks if there is only one single file listed.
if ($source.Count -ne 1) {
	"Aborted, there is not only one file of interest in there."
	Add-Content $tdir\log.txt "$(Get-Date) - Copy aborted, reason: 0 or more than 1 file in source."
}
else {
	#Copies the source *.xls from source directory to target directory
	"Copying process:"
	">>> Copying $source file to folder"
	Copy-Item $sdir\$source $tdir\
	Add-Content $tdir\log.txt "$(Get-Date) - Copied $source from source directory"
	#Starts the cleaning process
	$a = Get-ChildItem "$tdir" -Name -Filter *.xls
	"Deletion process:"
	#$a.Count -ge 4 ==> checks if there are at least 3 files in the directory
	if ($a.Count -ge 4) {
		">>> This will delete every single *.xls present in the directory but the 3 latest ones, sorted by name."
		">>> Files to be considered: $a"
		#$b is the array size minus 4, to keep the 3 last items
		$b = ($a.Count-4)
		Foreach ($filexls in $a[0..$b]) {
			">>> deleting: $filexls"
			Add-Content $tdir\log.txt "$(Get-Date) - Deleted $filexls from target directory"
			Remove-Item $tdir\$filexls
		}
	}
	else {
		">>> Deletion aborted, there is at most 3 files in the directory. Keep Yo Backup!"
		Add-Content $tdir\log.txt "$(Get-Date) - Deletion aborted, reason: not enough backup files"
	}
}
#enable sleep for debugging purpose
Start-Sleep -s 10
