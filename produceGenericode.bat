@echo off

if not "a%~4" == "a" goto :argsokay  
echo Missing results directory, platform, label, date-stamp, user, password arguments
exit /B 1
:argsokay

if exist "%~1\." goto :resultokay
echo Cannot find result directory "%~1".
echo (perhaps the argument is ending in "/" when it is not supposed to)
exit /B 1
:resultokay

if exist "hub.console.%~3.txt" del "hub.console.%~3.txt"

set package=genericode-1.0-v1.0
set thisStage=csdXXwdYY
set prevStage=csd03
set label=%~3

echo Building package...
java "-Dant.home=utilities/ant" -classpath "db/spec-0.8/validate/xjparse.jar;utilities/ant/lib/ant-launcher.jar;db/spec-0.8/validate/saxon9he.jar;." org.apache.tools.ant.launch.Launcher -buildfile produceGenericode.xml "-Ddir=%~1" "-Dstage=%thisStage%" "-DprevStage=%prevStage%" "-Dpackage=%package%" "-Dlabel=%label%" "-Ddatetimelocal=%~4" "-Drealtauser=%~5" "-Drealtapass=%~6" >"hub.console.%label%.txt"
set serverReturn=%errorlevel%

if not exist "%~1\" mkdir "%~1" 2>&1
if not exist "%~1\%package%-%thisStage%-%label%\" mkdir "%~1\%package%-%thisStage%-%label%" 2>&1
if not exist "%~1\%package%-%thisStage%-%label%\archive-only-not-in-final-distribution\" mkdir "%~1\%package%-%thisStage%-%label%\archive-only-not-in-final-distribution" 2>&1

move "hub.console.%label%.txt" "%~1\%package%-%thisStage%-%label%\archive-only-not-in-final-distribution"
echo %serverReturn% >"%~1\%package%-%thisStage%-%label%\archive-only-not-in-final-distribution\hub.exit.%label%.txt"

pushd "%~1"
7z a "%package%-%thisStage%-%label%.zip" "%package%-%thisStage%-%label%"
popd
