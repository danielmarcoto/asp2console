<%
' asp2console v 1.0.1
'
' MIT License
' 
' Copyright (c) 2016 Daniel Ramos Marcoto
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in all
' copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.
%>
<!--#include file="dependencies/JSON_2.0.4.asp" -->
<!--#include file="dependencies/str_to_base64.asp" -->
<%
Class Asp2Console

	Private messagesDict
	Private typesDict
	Private currentItem

	Public Sub Class_Initialize()
		Set messagesDict = Server.CreateObject( "Scripting.Dictionary" )
		Set typesDict = Server.CreateObject( "Scripting.Dictionary" )
		currentItem = 0
	End Sub

	Public Sub log( message )
		currentItem = currentItem + 1
		messagesDict.Add currentItem, message
		typesDict.Add currentItem, "log"
	End Sub

	Public Sub error( message )
		currentItem = currentItem + 1
		messagesDict.Add currentItem, message
		typesDict.Add currentItem, "error"
	End Sub

	Public Sub info( message )
		currentItem = currentItem + 1
		messagesDict.Add currentItem, message
		typesDict.Add currentItem, "info"
	End Sub

	Public Sub warn( message )
		currentItem = currentItem + 1
		messagesDict.Add currentItem, message
		typesDict.Add currentItem, "warn"
	End Sub

	Public Sub Flush()

		If messagesDict.Count = 0 Then Exit Sub

		Dim jsonObj : Set jsonObj = jsObject()

		jsonObj("version") = "1.0"

		Dim columnsElement : Set columnsElement = jsArray()
		columnsElement(Null) = "log"
		columnsElement(Null) = "backtrace"
		columnsElement(Null) = "type"

		Set jsonObj("columns") = columnsElement

		Dim dataRows : Set dataRows = jsArray()

		For Each keyName In messagesDict.Keys
			Dim currentRow : Set currentRow = jsArray()

			Dim dataRow : Set dataRow = jsArray()
			dataRow(Null) = messagesDict(keyName)

			' This element could be an object
			Set currentRow(Null) = dataRow
			currentRow(Null) = ""
			currentRow(Null) = typesDict(keyName)

			' It sets the current row to the dataset
			Set dataRows(Null) = currentRow
		Next

		Set jsonObj("rows") = dataRows

		encoded = str_to_base64(jsonObj.jsString)

		Response.AddHeader "X-ChromeLogger-Data", encoded

		Set jsonObj = Nothing
		Set messagesDict = Nothing
		Set typesDict = Nothing
	End Sub

	Private Sub Class_Terminate()
		Flush		
	End Sub
End Class

' Instance created for being used along the code
Set console = New Asp2Console
%>