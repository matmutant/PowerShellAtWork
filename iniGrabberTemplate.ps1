#LICENSE: Creative Commons CC-BY-SA.
#Script Written by matmutant
#built using SS64 and powershelladmin.com
#This is a small template to use ini file to store parameters, push the iniFile content to a hastable and then extract that content to obtain simple variables (as in my use case hastable.key variables don't work at some point)
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
foreach-object -begin {$h=@{}} -process {
	$k = [regex]::split($_,'=')
	if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True) -and ($k[0].StartsWith("#") -ne $True)) {
		$h.Add($k[0], $k[1])
	} 
}
#extracts hashtable content as many simple variables
foreach ($var in $h.keys.GetEnumerator()) {
	$var
	New-Variable -Name "$var" -Value $h.$var
	Get-Variable -Name "$var" -ValueOnly
}
#now any variable declared in the iniFile can be used in the script 'as is'.
