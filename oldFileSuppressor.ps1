$nbDays = 100
$tdir = '.\'
"date {1} days before today: {0}`n" -f $((Get-date).AddDays(-$nbDays)), $nbDays
"building the report..."
$files = (Get-ChildItem -Path $tdir | ? {$_.LastWriteTime -le (Get-date).AddDays(-$nbDays)})
"size of the files older than $nbDays days to be deleted"
($files | Measure-Object -Property Length -Sum).sum/1Gb
#deleting process
foreach ($file in $files) {
	"fileName: {0}; LastWriteTime: {1}" -f $file.name, $file.LastWriteTime
	"deleting : {0}" -f $file.fullName
	#Un-comment following line to REALLY REMOVE OBJECT
	#Remove-Item $file.fullName
}
