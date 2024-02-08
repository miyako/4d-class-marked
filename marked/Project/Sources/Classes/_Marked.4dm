property area : Text  //option for WA Run offscreen area
property url; result : 4D:C1709.File  //result from WA Run offscreen area

Class constructor
	
	Case of 
		: (Is macOS:C1572)
			This:C1470._platform:="macOS"
			This:C1470._contentsFolder:=Folder:C1567(Application file:C491; fk platform path:K87:2).folder("Contents")
		: (Is Windows:C1573)
			This:C1470._platform:="Windows"
			This:C1470._contentsFolder:=File:C1566(Application file:C491; fk platform path:K87:2).parent.folder("Contents")
	End case 
	
	This:C1470._rootFolderName:="documentation"
	This:C1470._indexPageName:="index.html"
	
	This:C1470._libraryRootFolder:=This:C1470._contentsFolder\
		.folder("Resources")\
		.folder("Internal Components")\
		.folder("development.4dbase")\
		.folder("Resources")\
		.folder(This:C1470._rootFolderName)
	
	This:C1470._documentationFolder:=Folder:C1567(fk database folder:K87:14; *).folder("Documentation")
	
	This:C1470.url:=This:C1470._getIndexPage()
	This:C1470.area:="Marked"
	This:C1470["onEvent"]:=This:C1470._onEvent  //to hide from autocomplete
	
	//MARK:-private
	
Function _createTempFolder()->$folder : 4D:C1709.Folder
	
	var $tempFolder : 4D:C1709.Folder
	
	$tempFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
	$tempFolder.create()
	
	This:C1470._libraryRootFolder.copyTo($tempFolder)
	
	$folder:=$tempFolder.folder(This:C1470._rootFolderName)
	
Function _getDocumentationFile($components : Object)->$mdFile : 4D:C1709.File
	
	If ($components#Null:C1517)
		
		Case of 
			: ($components.className="projectMethod")
				
				$mdFile:=This:C1470._documentationFolder.folder("Methods").file($components.objectName+".md")
				
			: ($components.className="databaseMethod")
				
				$mdFile:=This:C1470._documentationFolder.folder("DatabaseMethods").file($components.objectName+".md")
				
			: ($components.className="projectForm")
				
				$mdFile:=This:C1470._getFormFile(This:C1470._documentationFolder.folder("Forms"); $components.objectName)
				
			: ($components.className="tableForm")
				
				$mdFile:=This:C1470._getFormFile(This:C1470._documentationFolder.folder("TableForms").folder($components.objectName); $components.formName)
				
			: ($components.className="trigger")
				
				$mdFile:=This:C1470._documentationFolder.folder("Triggers").file($components.objectName+".md")
				
			: ($components.className="class")
				
				$mdFile:=This:C1470._documentationFolder.folder("Classes").file($components.objectName+".md")
				
		End case 
		
	End if 
	
Function _getFormFile($folder : 4D:C1709.Folder; $formName : Text)->$file : 4D:C1709.File
	
	If (OB Instance of:C1731($folder; 4D:C1709.Folder)) && ($formName#"")
		$file:=$folder.folder($formName).file("form.md")
	End if 
	
Function _getIndexPage()->$indexPage : 4D:C1709.File
	
	$indexPage:=This:C1470._libraryRootFolder.file(This:C1470._indexPageName)
	
Function _onEvent()
	
	var $event : Object
	
	$event:=FORM Event:C1606
	
	Case of 
		: ($event.code=On Load:K2:1)
			
			This:C1470._html:=""
			
		: ($event.code=On End URL Loading:K2:47)
			
			WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; This:C1470.area; "refresh"; *; This:C1470._md)
			
			This:C1470._html:=WA Get page content:C1038(*; This:C1470.area)
			
			This:C1470.result:=This:C1470._createTempFolder().file("index.html")
			
			This:C1470.result.setText(This:C1470._html)
			
		: ($event.code=On Unload:K2:2)
			
			This:C1470._html:=""
			
	End case 
	
Function _splitPath($path : Text)->$components : Object
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("(?:\\[([^\\]]+)\\])\\/([^\\/]+)(?:\\/([^\\/]+))?(?:\\/([^\\/]+))?"; $path; 1; $pos; $len; *))
		
		$components:=New object:C1471
		$components.className:=Substring:C12($path; $pos{1}; $len{1})
		$components.objectName:=Substring:C12($path; $pos{2}; $len{2})
		$components.formName:=Substring:C12($path; $pos{3}; $len{3})
		
	Else 
		
		$components:=New object:C1471
		$components.className:="projectMethod"
		$components.objectName:=$path
		
	End if 
	
	//MARK:-public
	
Function generate($path : Text)->$htmlFile : 4D:C1709.File
	
	$components:=This:C1470._splitPath($path)
	
	$mdFile:=This:C1470._getDocumentationFile($components)
	
	If ($mdFile#Null:C1517) && ($mdFile.exists)
		
		$htmlFile:=This:C1470.parse($mdFile)
		
	End if 
	
Function parse($mdFile : 4D:C1709.File)->$htmlFile : 4D:C1709.File
	
	This:C1470._md:=$mdFile.getText()
	
	$htmlFile:=WA Run offscreen area:C1727(This:C1470)