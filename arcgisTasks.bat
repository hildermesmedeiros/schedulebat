@echo off
setlocal enableDelayedExpansion
:start
cls
set restartprogram=N
::build "array" of folders
set folderCnt=0
for /f "eol=: delims=" %%F in ('dir %localappdata%\Esri\ArcGISPro\Geoprocessing\ScheduledTools /a:d /b') do (
  set /a folderCnt+=1
  set "folder!folderCnt!=%%F"
)

::print menu
for /l %%N in (1 1 %folderCnt%) do echo %%N - !folder%%N!
echo(

:get selection
set selection=
set /p "selection=Enter a folder number: "
for /F "tokens=* USEBACKQ" %%F IN (`echo !folder%selection%!`) do (
set task=%%F
)
echo %task%

schtasks /query /fo LIST /tn "%task%"

:stopStartQuestion
echo Do you wish to stop or start the task, type (stopt) or (startt):
set /p question=
if %question%==startt GOTO startTask
if %question%==stopt GOTO stopTask
GOTO endBatch

:stopTask
echo Trying to stop task %task%
for /F "tokens=* USEBACKQ" %%F IN (`schtasks /change /tn "%task%" /DISABLE`) do (
set comand=%%F
)
echo %comand%
GOTO endProgram


:startTask
echo Trying to start task %task%
for /F "tokens=* USEBACKQ" %%F IN (`schtasks /change /tn "%task%" /ENABLE`) do (
set comand=%%F
)
echo %comand%
GOTO endProgram


:endProgram
echo Do you wish to restart the program, Type (Y) to restart:
set /p restartprogram=
if %restartprogram%==Y GOTO START
if %restartprogram%==y GOTO START
if %restartprogram%==NO echo The program will now end when any key is pressed.
pause
