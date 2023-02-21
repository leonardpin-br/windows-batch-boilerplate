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


:create_string
    @REM Creates a string.
    @REM
    @REM %~1: Variable name.
    @REM %~2: String inside quotes.
    @REM
    @REM How to use this function:
    @REM    CALL :create_string variable_name "Everything INSIDE the quotation marks."
    @REM    ECHO !variable_name!
    @REM    ECHO !variable_name.length!

    SETLOCAL

        @REM Local variable to hold the string length.
        SET string.length=0

        @REM Removes from the count the extra bytes.
        SET /A takeaway=2

        @REM The string inside quotation marks.
        SET string=%~2

        @REM useback will remove the outside quotation marks, leaving any internal ones.
        FOR /F "useback tokens=*" %%i IN ('!string!') DO (

            @REM The variable is set with the string without quotes.
            SET string=%%~i

        )

        @REM Creates a temporary file and writes the string without quotations inside it.
        ECHO %~2> %TEMP%\tempfile.txt

        @REM %%j will be C:\Users\leonardo\AppData\Local\Temp\tempfile.txt.
        FOR %%j IN ( %TEMP%\tempfile.txt ) DO (

            IF !string! EQU %%j (
                SET /A takeaway=0
            )

            @REM %%~z means the file size (like 41 bytes).
            @REM %%~zj means the file size of C:\Users\leonardo\AppData\Local\Temp\tempfile.txt.
            SET /A string.length=%%~zj - !takeaway!

        )

        @REM Deletes the temporary file.
        DEL %TEMP%\tempfile.txt

    ( ENDLOCAL & REM
        IF "%~1" NEQ "" SET %~1=%string%
        IF "%~1.length" NEQ "" SET %~1.length=%string.length%
    )
    GOTO :EOF


:header
    @REM Prints a message that is easy to read.

    SETLOCAL

        ECHO.
        ECHO %~1
        ECHO ===================================================================

    ENDLOCAL
    GOTO :EOF


:multiline_string_into_variable
    @REM Inserts a multiline string into a variable

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


:read_file_content_into_variable
    @REM Reads the file content into a variable.

    SETLOCAL

        CALL :header "Reads the file's content into a variable"

        @REM OPTION 1 (only one that really works!):
        @REM -------------------------------------------------------------------
        @REM Avoids problems with special characters like ; % !
        SET /P file_content=<multiline_variable_into_file.txt


        @REM @REM OPTION 2 (This is bad and should not be used!)
        @REM @REM -------------------------------------------------------------------
        @REM @REM Has problems with special characters like !
        @REM @REM Does not keep the empty lines.

        @REM @REM Two empty lines are required below this line.
        @REM SET LF=^


        @REM @REM Two empty lines are required above this line.
        @REM FOR /F "tokens=* delims=" %%i IN (multiline_variable_into_file.txt) DO (
        @REM     SET "file_content=!file_content!%%i!LF!"
        @REM )



        ECHO !file_content!

    ENDLOCAL
    GOTO :EOF