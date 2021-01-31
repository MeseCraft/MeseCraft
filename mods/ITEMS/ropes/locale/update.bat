@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
cd ..
set LIST=
for /r %%X in (*.lua) do set LIST=!LIST! %%X
..\intllib\tools\xgettext.bat %LIST%