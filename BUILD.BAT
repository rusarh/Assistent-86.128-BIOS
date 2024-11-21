@rem echo off
@if exist bios.obj del bios.obj
@if exist bios.exe del bios.exe
@if exist mainbios.bin  del mainbios.bin
@if exist extbios.bin del extbios.bin

@echo Assembling BIOS ...
@echo -----------------------------
tasm /t abios.asm,bios.obj
@rem pause
@if errorlevel 1 goto errasm
@if not exist bios.obj goto errasm

@echo Linking ...
@echo -----------------------------
tlink /x bios.obj,bios.exe
@del bios.obj
@if not exist bios.exe goto errlink

@echo Building ROM.
@echo -----------------------------
@echo off
@if exist bios.bin del bios.bin
@chop bios.exe -T -Q -Z -B16897
@if exist bios.exe del bios.exe
@ren bios.1 bios.bin
@chop bios.bin -T -Q -Z -E8192
@ren bios.1 extbios.bin
@chop bios.bin -T -Q -Z -B40961
@ren bios.1 mainbios.bin
@if exist bios.bin del bios.bin
@if exist bios.1 del bios.1
@if exist bios.exe del bios.exe
@echo SUCCESS.
@echo           BIOS ROM MEMORY MAP
@echo +--------------+-----------+-------+
@echo ; EXTBIOS.BIN  : F400:0000 :  8 Kb ;
@echo ; BASIC.BIN    : F600:0000 : 32 Kb ;
@echo ; MAINBIOS.BIN : F000:E000 :  8 Kb ;
@echo +--------------+-----------+-------+
@goto end

:errasm
@echo ERROR while assembling.
@echo -----------------------------
goto end

:errlink
@echo ERROR while linking.
@echo -----------------------------
goto end


:end
pause



