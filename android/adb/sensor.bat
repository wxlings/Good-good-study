@echo off

chcp 65001
setlocal enabledelayedexpansion
set host=wshifu.app.android

for /f %%i in ('adb shell pidof %host%') do @set pid=%%i

@echo 当前应用进程ID:  %pid%
adb logcat -c
@echo 清空历史缓存数据

adb logcat --pid=%pid% -v color -v long  -f D:\test.txt -s Sensor:E SA.SensorsDataAPI:I 


pause 
