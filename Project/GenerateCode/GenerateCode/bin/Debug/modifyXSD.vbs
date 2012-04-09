'==========================================================================
'
' VBScript Source File -- Created with SAPIEN Technologies PrimalScript 2011
'
' NAME: 
'
' AUTHOR: user , Litle & Co.
' DATE  : 4/6/2012
'
' COMMENT: 
'
'==========================================================================

Function GetFileContents(FullPath)
	Dim fso, fileBeingRead, stringToReturn, lastCharacterInString
    Const ForReading = 1
    Set fso = CreateObject("Scripting.FileSystemObject")
                
    ' Read the contents of the file.
    Set fileBeingRead = fso.OpenTextFile(FullPath, ForReading)
    Do Until fileBeingRead.AtEndOfStream
    	lastCharacterInString = Right(stringToReturn,1)
        If(StrComp(lastCharacterInString,Chr(34)) = 0) Then
        	stringToReturn = Trim((stringToReturn & " ") & Trim(Replace(fileBeingRead.Readline, vbCrLf, "")))
        Else
            stringToReturn = Trim(stringToReturn & Trim(Replace(fileBeingRead.Readline, vbCrLf, "")))
        End If       
    Loop
    fileBeingRead.Close
    GetFileContents = stringToReturn
End Function

Function WriteFileContents(stringToWrite, filePathToWrite)
   Dim fso, fileToWrite
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set fileToWrite = fso.CreateTextFile(filePathToWrite, True)
   ' Write the contents.
   fileToWrite.Write (stringToWrite)
   fileToWrite.Close
   WriteFileContents = filePathToWrite
End Function

Function EditTheXSDString(stringToEdit,version)
	Dim stringToReturn
	stringToReturn = Replace(stringToEdit, "<xs:choice><xs:sequence>", "<xs:sequence>")
	stringToReturn = Replace(stringToReturn, "</xs:sequence></xs:choice>", "</xs:sequence>")
	stringToReturn = Replace(stringToReturn, "</xs:sequence><xs:sequence>", "")
	stringToReturn = Replace(stringToReturn, "base64binary", "string")
	stringToReturn = Replace(stringToReturn,".xsd", "_toGenerate.xsd")
	EditTheXSDString = stringToReturn
End Function


Dim xmlFileFullContents, xmlFileEditedContents, editedXml, writeFilePath
xmlFileFullContents = GetFileContents(WScript.Arguments.Item(0))
editedXml = EditTheXSDString(xmlFileFullContents)
writeFilePath = WriteFileContents(editedXml, Wscript.Arguments.Item(1))
WScript.Quit
