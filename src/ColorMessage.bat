@REM Allows the use of colors in the Command Prompt.
@REM
@REM This file is a modification of a script created by jeb (see reference). It
@REM was modified further by dbenham, then by John Hammond and then by me.
@REM
@REM HOW TO USE THIS FILE:
@REM    From a file (like Main.bat) use it as follows:
@REM    CALL src\ColorMessage.bat C "Red Text"
@REM    CALL src\ColorMessage.bat 3A "TURTLE COLORS"
@REM
@REM REFERENCES:
@REM    Batch Tutorials
@REM    https://www.youtube.com/playlist?list=PL69BE3BF7D0BB69C4
@REM    How to have multiple colors in a Windows batch file?
@REM    https://stackoverflow.com/a/10407642/3768670

@ECHO OFF
SETLOCAL

    CALL :initColorPrint

    CALL :colorPrint %1 %2

    CALL :cleanupColorPrint

EXIT /B

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:colorPrint Color  Str  [/n]
    SETLOCAL

        SET "str=%~2"
        CALL :colorPrintVar %1 str %3

    EXIT /B

:colorPrintVar  Color  StrVar  [/n]
    IF NOT DEFINED %~2 EXIT /B

    SETLOCAL ENABLEDELAYEDEXPANSION

        SET "str=a%DEL%!%~2:\=a%DEL%\..\%DEL%%DEL%%DEL%!"
        SET "str=!str:/=a%DEL%/..\%DEL%%DEL%%DEL%!"
        SET "str=!str:"=\"!"
        PUSHD "%TEMP%"
        FINDSTR /p /A:%1 "." "!str!\..\x" NUL
        IF /i "%~3"=="/n" echo(

    EXIT /B

:initColorPrint
    FOR /F "tokens=1,2 delims=#" %%a IN ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') DO SET "DEL=%%a"
    <NUL >"%TEMP%\x" SET /p "=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%.%DEL%"

    EXIT /B

:cleanupColorPrint
    DEL "%TEMP%\x"

    EXIT /B