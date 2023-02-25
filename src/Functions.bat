@REM This script is used for storing functions in this example app.
@REM
@REM With SETLOCAL inside each function, any variable declared inside the caller
@REM function (probably :main) will be "visible" inside the called function.
@REM No variables created (SET) inside the called function will be "visible"
@REM inside the caller function.
@REM
@REM HOW TO USE THIS FILE:
@REM    This boilerplate app is meant to be run from the project root.
@REM
@REM    From the Main.bat file, inside the :main function, use it as follows:
@REM    CALL src\Functions.bat :function_name argument
@REM
@REM WARNING:
@REM    "Imported" files (like this one) should not have local global variables
@REM    because they are not accessible. Global variables should be placed
@REM    inside Main.bat or, better yet, inside the GlobalVariables.bat file.
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
        >&2 CALL src\Functions.bat :print_message "ERROR" "Function %~1 not found inside %~nx0."

    )

@REM If the function name was not given (like CALL Functions.bat):
) ELSE >&2 CALL src\Functions.bat :print_message "ERROR" "Missing the function name when calling %~nx0."


GOTO :EOF


:_DO_NOT_CALL_multiline_string_into_variable
    @REM Inserts a multiline string into a variable.
    @REM This function is only an example and it is not meant to be called.
    @REM It just shows how to do it.

    SETLOCAL

        CALL :header "Inserts a multiline string into a variable"
        @REM Two empty lines are required below this line.
        SET LF=^


        @REM Two empty lines are required above this line.
        SET multiLine=This is a;!LF!
        SET multiLine=!multiLine!text with 2 lines%%!LF!
        SET multiLine=!multiLine!!LF!
        SET multiLine=!multiLine!1 empty line and a 4 line^^!

        @REM Prints the line on the screen.
        ECHO !multiLine!

        @REM Sends the multiline to a file.
        ECHO !multiLine!> multiline_variable_into_file.txt

    ENDLOCAL
    GOTO :EOF


:_DO_NOT_CALL_read_file_content_into_variable
    @REM Reads the file content into a variable.
    @REM This function is only an example and it is not meant to be called.
    @REM It just shows how to do it.

    SETLOCAL

        CALL :header "Reads the file's content into a variable"

        @REM OPTION 1 (only one that really works!):
        @REM -------------------------------------------------------------------
        @REM Avoids problems with special characters like ; % !
        SET /P file_content=<multiline_variable_into_file.txt


        @REM @REM OPTION 2 (This is bad and should not be used!)
        @REM @REM -------------------------------------------------------------------
        @REM @REM It has problems with special characters like !
        @REM @REM It does not keep the empty lines.

        @REM @REM Two empty lines are required below this line.
        @REM SET LF=^


        @REM @REM Two empty lines are required above this line.
        @REM FOR /F "tokens=* delims=" %%i IN (multiline_variable_into_file.txt) DO (
        @REM     SET "file_content=!file_content!%%i!LF!"
        @REM )

        ECHO !file_content!

    ENDLOCAL
    GOTO :EOF


:add_one
    @REM Example function that shows how to return (change the argument passed
    @REM in) a value.
    @REM Adds one to the number given as argument.
    @REM
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
    @REM
    @REM How to use this function:
    @REM    CALL src\Functions.bat :clear_screen

    SETLOCAL

        CLS

    ENDLOCAL
    GOTO :EOF


:header
    @REM Prints a message that is easy to read.
    @REM
    @REM How to use this function:
    @REM    CALL src\Functions.bat :header "Header string"

    SETLOCAL

        ECHO.
        ECHO %~1
        ECHO ===================================================================

    ENDLOCAL
    GOTO :EOF


:print_message
    @REM Prints a message in CMD that is easy to read.
    @REM
    @REM How to use this function:
    @REM    CALL src\Functions.bat :print_message "tipe of message" "Message string"
    @REM
    @REM    CALL src\Functions.bat :print_message "ERROR" "This is an error."
    @REM    CALL src\Functions.bat :print_message "WARNING" "This is a warning."
    @REM    CALL src\Functions.bat :print_message "SUCCESS" "This is a success."

    SETLOCAL

        ECHO.
        ECHO ===================================================================
        ECHO.

        IF "%~1" EQU "ERROR" (
            CALL src\ColorMessage.bat 4 %~1:
            ECHO.
        )

        IF "%~1" EQU "WARNING" (
            CALL src\ColorMessage.bat 6 %~1:
            ECHO.
        )

        IF "%~1" EQU "SUCCESS" (
            CALL src\ColorMessage.bat 2 %~1:
            ECHO.
        )

        ECHO %~2
        ECHO.
        ECHO ===================================================================

    ENDLOCAL
    GOTO :EOF
