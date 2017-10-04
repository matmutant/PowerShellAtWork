# Syntax Examples and usage  
## Syntax and use cases  
Use cases are detailed in embedded script help. See Get-Help .\Custom_Mac_Address.ps1  

### Set given custom mac address
Here is an example showing how to set a given custom Mac address: 

```
.\Custom_Mac_Address.ps1 -InterfaceIndexNumber <AdapterIndex> -SpoofedMacAddress <CustomMacToApply>
```
Note that the script only checks if the address is 12 digits long ranging from 0 to F (Hex) but doesn't check if the given address is valid (no vendor check or anything).

### Set random (but valid) mac address)
For a random but valid Mac address, simply run the script without passing any address, the script will build a valid address

### Other parameters  
WIP
