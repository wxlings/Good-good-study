@echo off
chcp 65001
setlocal enabledelayedexpansion
set com=wshifu.app.android

for /f %%i in ('adb shell pidof %com%') do @set pid=%%i
echo %PID%
adb logcat --pid=%pid%
pause 