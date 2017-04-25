#one line csv to xml converter proof of concept, that features lots of un-assigned issues and would be quite hard to maintain
#this is based on a use case where the csv content has fixed strings and numbers size in each member of the list like the following example: 
#4char;6num;0or35char;0or35char;0or14char;1char;13char;6num;0or35char;....
#regex matches:
#matches 4 non ';' char string
$C4 = '([^;]{4}?)'
#matches 6 numbers
$N6 = '([0-9]{6}?)'
#matches 0 or 35 non ';' char, non-mandatory content
$Cf35 = '([^;]{35}?)??'
#matches 0 or 14 non ';' char, non-mandatory content
$Cf14 = '([^;]{14}?)??'
#matches 1 non ';' char
$C1 = '([^;])'
#matches 13 non ';' char
$C13 = '([^;]{13}?)'
#separator:
$s = ';'
#hashtable that contains the csv content
$content = @{
	c0='ENR1;012345;abcdefghijklmnopqrstuvwyxzAZERTYU35;ABCDEFGHIJKLMNOPQRSTUVWYXZazertyu35;0123456789014C;C;azertyuiop13C;012345;ABCDEFGHIJKLMNOPQRSTUVWYXZazertyu35;khkgixchfghdifO0987';
	c1='ENR1;012345;;ABCDEFGHIJKLMNOPQRSTUVWYXZazertyu35;;C;azertyuiop13C;012345;;khkgixchfghdifO0987';
	c2='ENR1;012345;;;;C;azertyuiop13C;012345;;khkgixchfghdifO0987'}
$template = '<top><First>$1</First></top><content><second>$2</second><code3>$3</code3><codeFour>$4</codeFour><fiVe>$5</fiVe><typeAct>$6</typeAct><Sev>$7</Sev><nfour>$8</nfour><coden>$9</coden><reliq:$10/></content>'
foreach ($csv in $content.values.getEnumerator()) {
	"`ninput: `n$csv`n"
	"Full regex : `n`'^$C4$s$N6$s$Cf35$s$Cf35$s$Cf14$s$C1$s$C13$s$N6$s$Cf35$s(.*)`'`n"
	"result:"
	$workVar = [regex]::Replace($csv, "^$C4$s$N6$s$Cf35$s$Cf35$s$Cf14$s$C1$s$C13$s$N6$s$Cf35$s(.*)", $template)
	#removes empty tags
	$workVar = $workVar -replace '><[a-zA-Z0-9]*></[a-zA-Z0-9]*><', '><'
	#adds line breaks
	$workVar -replace '><',">`r`n<"
}
