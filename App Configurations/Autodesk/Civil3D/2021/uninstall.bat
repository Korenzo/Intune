::========================================================================================
::Prepare uninstallation's command-line options
::========================================================================================

::Set the output file for uninstallation's log data
::DEFAULT: a log file with the same filename but with extension .log
::         is created in the Windows temporary folder (environment variable TEMP)
set msi_log_file_path="%TEMP%\%~n0.log"
::Delete the current log file
if exist %msi_log_file_path% del /Q %msi_log_file_path%

::Set the path for the network log file
set network_log_folder=""
md %network_log_folder%
set network_log_file_path="%network_log_folder%%~n0_Admin.log"
echo ========================== %Date% %Time% =========================== >> %network_log_file_path%
echo Uninstallation Started on Computer Name: %COMPUTERNAME%, Username: %USERNAME%, Domain: %USERDNSDOMAIN% >> %network_log_file_path%

::DEFAULT: silent uninstallation
set non_silent_mode=/norestart /L*+ %msi_log_file_path% REMOVE=ALL REBOOT=ReallySuppress ADSK_SETUP_EXE=1
set silent_mode=/quiet %non_silent_mode%
set uninstallation_mode=%silent_mode%

::========================================================================================
::Helper Functions
::========================================================================================
goto END_FUNCTIONS_SECTION_
:BEGIN_FUNCTIONS_SECTION_

::---------------------------------
::Performs uninstallation and reports failure in the Network Log File
::---------------------------------
:funcUninstall
  setlocal
  set msi_ERROR_SUCCESS=0
  set product_code=%~1
  set product_name=%~2
  msiexec /uninstall %product_code% %uninstallation_mode%

  if %errorlevel%==%msi_ERROR_SUCCESS% goto SUCCESS_

  :ERROR_
    ::------------------------------------------
    ::print out Machine Name, product code, product name
    ::to the network log file for the product that failed to uninstall
    set uninstallation_result=Failed, Result=%errorlevel%
    goto DONE_

  :SUCCESS_
    set uninstallation_result=Succeeded
    goto DONE_

  :DONE_
    echo %Date% %Time% %USERNAME% %COMPUTERNAME% Uninstall %product_name% (Product Code: %product_code%) %uninstallation_result% >> %network_log_file_path%
  endlocal
GOTO:EOF

:END_FUNCTIONS_SECTION_



::::== Autodesk Civil 3D 2021
call :funcUninstall {28B89EEF-4100-0409-2102-CF3F3A09B77D}, "Autodesk Civil 3D 2021"

::::== Autodesk Civil 3D 2021 Language Pack - English
call :funcUninstall {28B89EEF-4100-0409-1102-CF3F3A09B77D}, "Autodesk Civil 3D 2021 Language Pack - English"

::::== Autodesk Storm and Sanitary Analysis 2021 x64 Plug-in
call :funcUninstall {58E36D07-2512-0000-8518-C854F44898ED}, "Autodesk Storm and Sanitary Analysis 2021 x64 Plug-in"

::::== Autodesk Subassembly Composer 2021
call :funcUninstall {33CFED50-4100-442A-84FA-4D26DB590854}, "Autodesk Subassembly Composer 2021"