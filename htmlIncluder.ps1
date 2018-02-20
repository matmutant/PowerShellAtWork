#HTML compiler
#the main purpose of this script is to include code snippet(s) into a main file by looking for a dedicated tags: 
# eg :"<div mgr-include-html='$file'></div>" (where $file is the filename of the snippet that needs to be included.)
#when nesting snippets into other snippets, make sure the latter are included in main before the other (eg : name those with higher priority, ie lower number at the begenning of the filename)

#absolute dir path, withou trailing '\'
$targetDirectory = 'C:\Users\mathieu.grivois\Documents\Projets\specsConcilliation\maquetteConciliationV0.1'
$outputDirectory = 'C:\Users\mathieu.grivois\Documents\Projets\specsConcilliation\maquetteConciliationV0.1\out'
#file extension
$fileExtension = 'html'
#main code file
$mainFile = '001_Main.html'
#output code file
$outputFile = 'output.html'

#content reader for main code file
$mainContent = [System.IO.File]::ReadAllText("$targetDirectory\$mainFile")
#file crawler
$names = Get-ChildItem "$targetDirectory" -Name -Filter *.$fileExtension
"files to include :"
$names
"____"


Foreach ($file in $names) {
	if ( $file -NotLike $mainFile) {
		#content reader for the snippet file
		$inputData = [System.IO.File]::ReadAllText("$targetDirectory\$file")
		"Including ... : $file"
		#search&replace tags refering to snippet by snippet content
		$mainContent = $mainContent.Replace("<div mgr-include-html='$file'></div>",$inputData)
	}
}
#output writer
[System.IO.File]::WriteAllText("$outputDirectory\$outputFile", $mainContent)

Start-Process "chrome.exe" "$outputDirectory\$outputFile"
