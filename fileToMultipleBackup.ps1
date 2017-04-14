#LICENSE: Creative Commons CC-BY-SA.
#Script Written by matmutant
#The aim of this PowerShell script is to copy a timestamped file (in name) to a directory where only the $nkeep most recent copies will be kept (sorted by timestamped name using alpha order)
#The source file should be named BACK_YYYYMMDD_HHmm.foo to make sure the most recent files are at the end of the generated array
#Make sure there is ONLY the file of interest in the Source or you'll get in trouble.
#Set the source and target directories and file extension using the parameters:
#Note: don't put a trailing \ at the end of the path
#Note: use ABSOLUTE path if you ever want to use task scheduler to launch the script
#Use parameters for source $sdir, target $tdir, file extension $filext and nb of file(s) to keep as following:
# .\BackupAndVersXLS.ps1 -sdir ".\data_Source" -tdir ".\data_Target" -filext "csv" -nkeep 3
Param
(
	[string]$sdir,
	[string]$tdir,
	[string]$filext,
	[int]$nkeep
)
#display parameters for debugging 
"parameters passed to script:"
"source dir: $sdir"
"target dir: $tdir"
"file extension: $filext"
"nb of file(s) to keep in target: $nkeep"
if (($sdir -like "") -or ($tdir -like "") -or ($filext -like "") -or ($nkeep -lt 1)) {
	"MISSING or INVALID arguments -sdir, -tdir, -filext or -kneep"
	"Use parameter for source $sdir, target $tdir, file extension $filext and nb of file(s) to keep as following:"
	'".\BackupAndVersXLS.ps1 -sdir ".\data_Source" -tdir ".\data_Target" -filext "csv" -nkeep 3'
	Start-Sleep -s 10
	exit
}
#Source filename is set by scanning the folder for the .$filext file:
$source = Get-ChildItem "$sdir" -Name -Filter *.$filext
#The script logs everything in fileToMultipleBackup.log
Add-Content $tdir\fileToMultipleBackup.log "`r`n`r`n`r`n$(Get-Date) - Started Copying and Cleaning processs"
#checks if there is only one single file listed.
if ($source.Count -ne 1) {
	"Aborted, there is not only one file of interest in there."
	Add-Content $tdir\fileToMultipleBackup.log "$(Get-Date) - Copy aborted, reason: 0 or more than 1 file in source."
}
else {
	#Copies the source *.$filext from source directory to target directory
	"Copying process:"
	">>> Copying $source file to folder"
	Copy-Item $sdir\$source $tdir\
	Add-Content $tdir\fileToMultipleBackup.log "$(Get-Date) - Copied $source from source directory"
	#Starts the cleaning process
	$a = Get-ChildItem "$tdir" -Name -Filter *.$filext
	"Deletion process:"
	#note that arrays start at 0...
	$n = $nkeep + 1
	#$a.Count -ge $n ==> checks if there are at least $nkeep files in the directory
	if ($a.Count -ge $n) {
		">>> This will delete every single *.$filext present in the directory but the $nkeep latest ones, sorted by name."
		">>> Files to be considered: $a"
		#$b is the array size minus $n, to keep the $nkeep last items
		$b = ($a.Count-$n)
		Foreach ($filebak in $a[0..$b]) {
			">>> deleting: $filebak"
			Add-Content $tdir\fileToMultipleBackup.log "$(Get-Date) - Deleted $filebak from target directory, kept $nkeep backup(s)"
			Remove-Item $tdir\$filebak
		}
	}
	else {
		">>> Deletion aborted, there is at most $nkeep files in the directory. Keep Yo Backup!"
		Add-Content $tdir\fileToMultipleBackup.log "$(Get-Date) - Deletion aborted, reason: not enough backup files"
	}
}
#enable sleep for debugging purpose
Start-Sleep -s 10
