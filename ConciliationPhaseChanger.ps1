Param
(
	[string]$iniData
)
#Checks if iniFile parameter is set or exist
$ifExist = Test-Path $iniData
if (($iniData -like "") -or ($ifExist -eq $false)) {
	"`n`r`n`r`nMISSING or INVALID parameter: -iniData"
	Start-Sleep -s 10
	exit
}
###var init
$htmlFile = 'Conciliation_rebase.html' #which file to work on (source file)
$outFile = "View.html" #which file to write on
$tagPatternBegin = '^<script class="customDataFile" src="' #what first part on the pattern  to find /!\ NOTA : the class prevents from replacing any sourced file...
$tagPatternEnd = '"></script>$' #what end part of the pattern to find /!\ Nota : the string parameter actually is the core par of the pattern

###verbose output
"Parameter sent to script : $iniData"
$iniData = $iniData.Replace('.\', '' ) #Remove ".\" if path is passed as parameter and not only the filename!
"var used : $iniData"

###actually do the replace
$workVar = $(Get-Content $htmlFile -Encoding UTF8) -replace "$tagPatternBegin(.*)$tagPatternEnd", "$tagPatternBegin$iniData$tagPatternEnd"

###verbose output (testing if replace has been succesfull)
$test = "$workVar" -match $iniData
"Update done succesfully ? ==> $test"

###write to $outFile and launch Chrome.exe
Out-File $outFile -InputObject $workVar -Encoding UTF8
$fullPath = (Get-Item -Path ".\").FullName
Start-Process "chrome.exe" "$fullPath\$outFile"
