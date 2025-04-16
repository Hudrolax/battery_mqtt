@echo off
chcp 1252 >nul
set SCRIPT_DIR=%~dp0

set TASK_NAME=BatteryMQTT
set XMLTMPFILE=%TEMP%\BatteryMQTT.xml.tmp
set XMLFILE=%TEMP%\BatteryMQTT.xml

(
    echo ^<?xml version="1.0" encoding="UTF-16" ?^>
    echo ^<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^>
    echo     ^<RegistrationInfo^>
    echo         ^<Date^>2021-01-01T00:00:00^</Date^>
    echo         ^<Author^>YourName^</Author^>
    echo         ^<Description^>Task to run BatteryMQTT application</Description^>
    echo     ^</RegistrationInfo^>
    echo     ^<Triggers^>
    echo         ^<LogonTrigger^>
    echo             ^<Enabled^>true^</Enabled^>
    echo         ^</LogonTrigger^>
    echo     ^</Triggers^>
    echo     ^<Principals^>
    echo         ^<Principal id="Author"^>
    echo             ^<LogonType^>InteractiveToken^</LogonType^>
    echo             ^<RunLevel^>HighestAvailable^</RunLevel^>
    echo         ^</Principal^>
    echo     ^</Principals^>
    echo     ^<Settings^>
    echo         ^<MultipleInstancesPolicy^>IgnoreNew^</MultipleInstancesPolicy^>
    echo         ^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^>
    echo         ^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^>
    echo         ^<AllowHardTerminate^>false^</AllowHardTerminate^>
    echo         ^<StartWhenAvailable^>true^</StartWhenAvailable^>
    echo         ^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^>
    echo         ^<IdleSettings^>
    echo             ^<StopOnIdleEnd^>false^</StopOnIdleEnd^>
    echo             ^<RestartOnIdle^>false^</RestartOnIdle^>
    echo         ^</IdleSettings^>
    echo         ^<AllowStartOnDemand^>true^</AllowStartOnDemand^>
    echo         ^<Enabled^>true^</Enabled^>
    echo         ^<Hidden^>true^</Hidden^>
    echo         ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^>
    echo         ^<WakeToRun^>true^</WakeToRun^>
    echo         ^<ExecutionTimeLimit^>PT0S^</ExecutionTimeLimit^>
    echo         ^<Priority^>7^</Priority^>
    echo     ^</Settings^>
    echo     ^<Actions Context="Author"^>
    echo         ^<Exec^>
    echo             ^<Command^>cmd.exe^</Command^>
    echo             ^<Arguments^>/c "%SCRIPT_DIR%run.bat"^</Arguments^>
    echo             ^<WorkingDirectory^>%SCRIPT_DIR%^</WorkingDirectory^>
    echo         ^</Exec^>
    echo     ^</Actions^>
    echo ^</Task^>
) > "%XMLTMPFILE%"

REM Convert the temporary XML file to UTF-16 LE using PowerShell
powershell -Command "Get-Content '%XMLTMPFILE%' | Out-File -FilePath '%XMLFILE%' -Encoding Unicode"

echo Creating scheduled task "%TASK_NAME%"...
schtasks /create /tn "%TASK_NAME%" /xml "%XMLFILE%" /f

del "%XMLTMPFILE%"
del "%XMLFILE%"

echo Scheduled task created.
pause
