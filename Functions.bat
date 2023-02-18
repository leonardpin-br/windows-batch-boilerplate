@REM This script is used for storing functions in this example app.
@REM
@REM HOW TO USE THIS FILE:
@REM    From the Main.bat file, inside the :main function, use as follows:
@REM    CALL Functions.bat :function_name argument_name
@REM
@REM REFERENCES:
@REM    How to package all my functions in a batch file as a seperate file?
@REM    https://stackoverflow.com/a/18743342
@REM    Udemy - Windows Command Line - Hands-On (CMD, Batch, MS-DOS), Section 2: Redirectors & Applications, 4. Redirectors.
@REM    https://www.udemy.com/course/the-complete-windows-command-line-course/learn/lecture/16599236#overview


@REM Checks if this file was called with the function name, and the name exists.
@REM If the name of the function was given (like CALL Functions.bat :add_one):
IF "%~1" NEQ "" (

    2>NUL >NUL FINDSTR /rc:"^ *%~1\>" "%~f0" && (

        SHIFT /1
        GOTO %1

    ) || (

        @REM Only runs this command if the first one fails.
        >&2 CALL :print_message "ERROR: Function %~1 not found inside %~nx0."

    )

@REM If the function name was not given (like CALL Functions.bat):
) ELSE >&2 CALL :print_message "ERROR: Missing the function name when calling %~nx0."


GOTO :EOF


@REM With SETLOCAL inside the function, any variable declared inside :main
@REM will be "visible" inside :add_one.
@REM No variables created (SET) inside :add_one will be "visible" inside :main.
:add_one
    @REM Adds one to the number given as argument.
    @REM %~1: Number to add one.

    SETLOCAL

        @REM The local_var receives a copy of the first parameter.
        SET /A local_var=%~1
        SET /A local_var=!local_var!+1

    @REM The grouping "()" is necessary to treat the lines inside as one command.
    @REM The & means: Runs the second command regardless if the first command returns an error or not.
    @REM The REM is necessary to deal with the line break.
    ( ENDLOCAL & REM
        IF "%~1" NEQ "" SET %~1=%local_var%
    )
    GOTO :EOF


:clear_screen
    @REM Clears the screen.

    SETLOCAL

        CLS
        ECHO.

    ENDLOCAL
    GOTO :EOF


:print_message
    @REM Prints a message that is easy to read.

    SETLOCAL

        ECHO.
        ECHO ===================================================================
        ECHO.
        ECHO %~1
        ECHO.
        ECHO ===================================================================

    ENDLOCAL
    GOTO :EOF