//%attributes = {}
var $marked : cs:C1710._Marked

$marked:=cs:C1710._Marked.new()

$path:=METHOD Get path:C1164(Path class:K72:19; "_Marked")

$htmlFile:=$marked.generate($path)

OPEN URL:C673($htmlFile.platformPath)