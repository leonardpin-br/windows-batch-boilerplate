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


:capitalize
    @REM Return a copy of the string with its first character capitalized and
    @REM the rest lowercased.
    @REM
    @REM %~1: Existing string or the expansion of a variable.
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :capitalize "!string!" return_name
    @REM
    @REM    CALL src\Functions.bat :create_string variable "what are you talking about"
    @REM    CALL src\String.bat :capitalize "!variable!" return_name
    @REM    ECHO !return_name!

    SETLOCAL

        CALL src\Functions.bat :create_array uppers "," "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
        CALL src\Functions.bat :create_array lowers "," "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"

        CALL src\Functions.bat :create_string string "%~1"
        SET second_parameter=%~2

        SET first=!string:~0,1!

        SET /A for_upper_limit=!uppers.length!-1

        FOR /L %%i IN ( 0, 1, !for_upper_limit! ) DO (

            IF !lowers[%%i]! EQU !first! (

                SET second_parameter=!uppers[%%i]!
                GOTO :capitalize_end
            )

        )

        SET second_parameter=!first!

        :capitalize_end
            SET second_parameter=!second_parameter!!string:~1!

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%second_parameter%
    )
    GOTO :EOF


:center
    @REM The given string is returned centered in the given width. Padding is
    @REM done using spaces. The original string is returned if width is less
    @REM than or equal to len(s).
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

            @REM Adds a space to the variable.
            SET "content=!content! "

            IF %%i EQU !middle! (
                SET content=!content!!%~1!!content!
                GOTO :center_end
            )

        )

        :center_end

    ( ENDLOCAL & REM
        IF "%~3" NEQ "" SET %~3=%content%
    )
    GOTO :EOF
