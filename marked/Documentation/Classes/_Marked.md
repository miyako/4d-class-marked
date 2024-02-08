# _Marked

`_Marked` is a class to generate HTML renditions of project documentation. 

## .generate()

**.generate**($path : Text)->$htmlFile : 4D.File

Converts a documentation of a resource reference by `$path` to an HTML file.  Use [METHOD Get path](https://doc.4d.com/4Dv20/4D/20/METHOD-Get-path.301-6238308.en.html) to obtain `$path`. The documentation is searched in the host project. 

* Project methods
* Database methods
* Trigger methods
* Project form methods
* Table form methods
* Classes

Returns `Null` If the resource reference by `$path` has no documentation.

## .parse()

**.parse**($mdFile : 4D.File)->$htmlFile : 4D.File

Converts a markdown file to an HTML file. Internally uses an offscreen web area to invoke the [Marked.js](https://marked.js.org) library.

Returns `Null` If `$mdFile` does not exist.