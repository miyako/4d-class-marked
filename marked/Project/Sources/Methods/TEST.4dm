//%attributes = {"preemptive":"capable"}
var $marked : cs:C1710._Marked

$marked:=cs:C1710._Marked.new()

If ($marked.isPreemptive())
	$path:="[class]/_Marked"
Else 
	//%T-
	$path:=METHOD Get path:C1164(Path class:K72:19; "_Marked")
	//%T+
End if 

$htmlFile:=$marked.generate($path)

OPEN URL:C673($htmlFile.platformPath)