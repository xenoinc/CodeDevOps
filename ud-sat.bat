REM @ECHO OFF

net start RabbitMQ

net start MSSQLServer

net start SQLServerAgent

MSBuild /t:UpdateDependencies

PRINT DONE - UpdateDependencies

REM FixTools.bat

SET source="C:\dev\_BuildToolsFixed\*.dll"
SET dest="%cd%\tools\"
xcopy %source% %dest% /y


PRINT DONE - Fix Service

REM MSBuild /t:CompileCode
MSBuild /t:SetupAT

PRINT DONE - Compiling
