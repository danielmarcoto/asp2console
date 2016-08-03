<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="asp2console.asp" -->
<%
console.log("Hello log")
console.log("Hello log - Line 2")
console.log("Hello log - Line 3")
console.info("An info test!!")
console.warn("My warning message")
console.error("A log for error")
%>
<p>Empty page, look at the Browser console for checking the debug messages ;)</p>