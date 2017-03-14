#The aim of this PowerShell script is to copy a timestamped file (in name) to a directory where only the 3 most recent copies will be kept (sorted by timestamped name using alpha order)
#The source file should be named BACK_YYYYMMDD_HHmm.xls to make sure the most recent files are at the end of the generated array
#The script logs everything in log.txt
Add-Content .\log.txt "`r`n`r`n`r`n$(Get-Date) - Started Copying and cleaning processs"
#Make sure there is ONLY the file of interest in the Source or you'll get in trouble.
#Sets the source filename:
$source = Get-ChildItem ".\data_Source" -Name -Filter *.xls
#checks if there is only one single file listed.
if ($source.Count -ne 1) {
	"Aborted, there is not only one file of interest in there."
	Add-Content .\log.txt "$(Get-Date) - Copy aborted, reason: 0 or more than 1 file in source."
}
else {
	#Copies the source *.xls from source directory to .\data
	"Copying process:"
	">>> Copying $source file to folder"
	Copy-Item .\data_Source\$source .\data\
	Add-Content .\log.txt "$(Get-Date) - Copied $source from source"
	#Starts the cleaning process
	$a = Get-ChildItem ".\data" -Name -Filter *.xls
	"Deletion process:"
	#$a.Count -ge 4 ==> checks if there are at least 3 files in the directory
	if ($a.Count -ge 4) {
		">>> This will delete every single *.xls present in the directory but the 3 latest ones, sorted by name."
		">>> Files to be considered: $a"
		#$b is the array size minus 4, to keep the 3 last items
		$b = ($a.Count-4)
		Foreach ($filexls in $a[0..$b]) {
			">>> deleting: $filexls"
			Add-Content .\log.txt "$(Get-Date) - Deleted: $filexls"
			Remove-Item .\data\$filexls
		}
	}
	else {
		">>> Deletion aborted, there is at most 3 files in the directory. Keep Yo Backup!"
		Add-Content .\log.txt "$(Get-Date) - Deletion aborted, reason: not enough backup files"
	}
}
