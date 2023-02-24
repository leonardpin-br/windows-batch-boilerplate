@REM This script is used for storing (Python inspired) string related functions.
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
@REM    CALL src\String.bat :function_name argument
@REM
@REM REFERENCES:
@REM    How to package all my functions in a batch file as a seperate file?
@REM    https://stackoverflow.com/a/18743342
@REM    Udemy - Windows Command Line - Hands-On (CMD, Batch, MS-DOS), Section 2: Redirectors & Applications, 4. Redirectors.
@REM    https://www.udemy.com/course/the-complete-windows-command-line-course/learn/lecture/16599236#overview


@REM Checks if this file was called with the function name, and the name exists.
@REM If the name of the function was given (like CALL String.bat :center):
IF "%~1" NEQ "" (

    2>NUL >NUL FINDSTR /rc:"^ *%~1\>" "%~f0" && (

        SHIFT /1
        GOTO %1

    ) || (

        @REM Only runs this command if the first one fails.
        >&2 CALL src\Functions.bat :print_message "ERROR" "Function %~1 not found inside %~nx0."

    )

@REM If the function name was not given (like CALL String.bat):
) ELSE >&2 CALL src\Functions.bat :print_message "ERROR" "Missing the function name when calling %~nx0."


GOTO :EOF


:center
    @REM Return centered in a string of length width. Padding is done using the
    @REM specified fillchar (default is an ASCII space). The original string is
    @REM returned if width is less than or equal to len(s).
    @REM
    @REM %~1: Existing string name.
    @REM %~2: Width.
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :center existing_string width return_name
    @REM
    @REM    CALL src\Functions.bat :create_string sentence "A lot of stuff"
    @REM    CALL src\String.bat :center sentence 40 fill
    @REM    ECHO !fill!
    @REM    CALL src\ColorMessage.bat 3a "!fill!"

    SETLOCAL

        SET content=
        SET /A middle=( %~2-!%~1.length! )/2
        SET /A original_string_length=!%~1.length!-2

        @REM If the width is less than the string length:
        IF %~2 LSS !original_string_length! (
            CALL src\Functions.bat :print_message "WARNING" "The width is less than the given string length."
            SET content=!%~1!
            SET %~3=!content!
            GOTO :the_end
        )

        FOR /L %%i IN ( 0, 1, %~2 ) DO (

            SET "content=!content! "

            IF %%i EQU !middle! (
                SET content=!content!!%~1!!content!
                GOTO :the_end
            )

        )

        :the_end

    ( ENDLOCAL & REM
        IF "%~3" NEQ "" SET %~3=%content%
    )
    GOTO :EOF
