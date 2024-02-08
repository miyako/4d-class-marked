# 4d-class-marked
class to export HTML versions of mark down documentation

```4d
var $marked : cs._Marked

$marked:=cs._Marked.new()

$path:=METHOD Get path(Path class; "_Marked")

$htmlFile:=$marked.generate($path)

OPEN URL($htmlFile.platformPath)
```
