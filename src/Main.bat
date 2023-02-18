@REM Main file of this example app. This is the file to be executed.
@REM
@REM HOW TO USE THIS FILE:
@REM    If this file is called from the CMD terminal, type the following:
@REM    Main.bat argument_name
@REM
@REM REFERENCES:
@REM    Batch Tutorials
@REM    https://www.youtube.com/playlist?list=PL69BE3BF7D0BB69C4
@REM    Batch file include external file for variables
@REM    https://stackoverflow.com/a/2763907
@REM    How to package all my functions in a batch file as a seperate file?
@REM    https://stackoverflow.com/a/18746066

@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

@REM Arguments passed for this script.
SET argument_passed_to_this_script=%~1

@REM "Including" another BATCH file containing global variables.
CALL src\GlobalVariables.bat

GOTO :main

:main
    @REM Main function of this script/application.

    SETLOCAL

        @REM Calling functions in another BATCH file:
        CALL src\Functions.bat :clear_screen

        ECHO Escaping the character ^"^^!^" on the string below. It is only necessary for testing when using SETLOCAL ENABLEDELAYEDEXPANSION globally.
        ECHO Hello World^^!
        ECHO.
        ECHO.

        ECHO Argument passed to this script:
        ECHO !argument_passed_to_this_script!
        ECHO.

        ECHO Global variable inside GlobalVariables.bat:
        ECHO !global_var!
        ECHO.
        ECHO.

        SET /A x=1
        SET /A y=50

        ECHO The value of x before calling Functions.bat :add_one is !x!.
        ECHO The value of y before calling Functions.bat :add_one is !y!.
        ECHO.

        CALL src\Functions.bat :add_one x
        CALL src\Functions.bat :add_one y

        ECHO The value of x after calling Functions.bat :add_one is !x!.
        ECHO The value of y after calling Functions.bat :add_one is !y!.

        ECHO.
        ECHO.
        PAUSE

    ENDLOCAL
    GOTO :EOF