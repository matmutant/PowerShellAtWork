#LICENSE: Creative Commons CC-BY-SA.
#Script Written by matmutant
#built using SS64 and powershelladmin.com
#This is a small template to use ini file to store parameters, and use them as simple variables
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
#grabs ini content and push it to variables
Get-Content $iniFile |
foreach-object -process {
	$k = [regex]::split($_,'=')
	if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True) -and ($k[0].StartsWith("#") -ne $True)) {
		New-Variable -Name $k[0] -Value $k[1]
		#Get-Variable -Name $k[0] -ValueOnly
	} 
}
#now any variable declared in the iniFile can be used in the script 'as is'.
