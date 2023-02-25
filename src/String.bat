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
@REM    Escape Characters
@REM    https://www.robvanderwoude.com/escapechars.php


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
    @REM    CALL src\String.bat :create_string variable "what are you talking about"
    @REM    CALL src\String.bat :capitalize "!variable!" return_name
    @REM    ECHO !return_name!

    SETLOCAL

        CALL src\Functions.bat :create_array uppers "," "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
        CALL src\Functions.bat :create_array lowers "," "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"

        CALL src\String.bat :create_string string "%~1"
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
    @REM    CALL src\String.bat :create_string sentence "A lot of stuff"
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


:count_check_character
    @REM Auxiliary function used by :count to avoid double expansion (one
    @REM inside another).
    @REM
    @REM To achieve that, it is necessary to work outside the local scope.
    @REM
    @REM %~1: The offset.
    @REM %~2: The iterator from the loop.
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :count_check_character !offset! %%j %~3

    SETLOCAL

    ( ENDLOCAL & REM

        IF "!haystack:~%~1,1!" EQU "!needle:~%~2,1!" (

            IF %~2 EQU !needle_limit! (

                SET /A %~3=!%~3!+1

            )

        )

    )
    GOTO :EOF


:count
    @REM Return the number of non-overlapping occurrences of a substring.
    @REM
    @REM To avoid double expansion (one inside another), it is necessary to work
    @REM outside the local scope and use another auxiliary function.
    @REM
    @REM %~1: The string (haystack).
    @REM %~2: The substring we are looking for (needle).
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :count "!haystack!" "!needle!" return_name
    @REM
    @REM    CALL src\String.bat :create_string variable "This is a joke!"
    @REM    CALL src\String.bat :count "!variable!" "is" total
    @REM    ECHO !total!

    SETLOCAL

    ( ENDLOCAL & REM

        CALL src\String.bat :create_string haystack "%~1"
        CALL src\String.bat :create_string needle "%~2"

        @REM Whe should not count the quotes.
        SET /A haystack_limit=!haystack.length!-1
        SET /A needle_limit=!needle.length!-1

        FOR /L %%i IN ( 0, 1, !haystack_limit! ) DO (

            SET character=!haystack:~%%i,1!

            IF "!character!" EQU "!needle:~0,1!" (

                FOR /L %%j IN ( 0, 1, !needle_limit! ) DO (

                    SET /A offset=%%i+%%j

                    CALL src\String.bat :count_check_character !offset! %%j %~3

                )

            )

        )

        IF "!%~3!" EQU "" (
            SET /A %~3=0
        )

    )
    GOTO :EOF


:create_string
    @REM Creates a string.
    @REM
    @REM %~1: Variable name.
    @REM %~2: String inside quotes.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :create_string variable_name "Everything INSIDE the quotation marks."
    @REM    ECHO !variable_name!
    @REM    ECHO !variable_name.length!

    SETLOCAL

        @REM Local variable to hold the string length.
        SET /A string.length=0

        @REM Removes from the count the extra bytes.
        SET /A takeaway=4

        @REM The string inside quotation marks.
        SET string=%~2

        @REM useback will remove the outside quotation marks, leaving any internal ones.
        FOR /F "useback tokens=*" %%i IN ('!string!') DO (

            @REM The variable is set with the string without quotes.
            SET string=%%~i

        )

        @REM Creates a temporary file and writes the string without quotations inside it.
        ECHO "%~2"> %TEMP%\tempfile.txt

        @REM %%j will be C:\Users\leonardo\AppData\Local\Temp\tempfile.txt.
        FOR %%j IN ( %TEMP%\tempfile.txt ) DO (

            IF !string! EQU %%j (
                SET /A takeaway=2
            )

            @REM %%~z means the file size (like 41 bytes).
            @REM %%~zj means the file size of C:\Users\leonardo\AppData\Local\Temp\tempfile.txt.
            SET /A string.length=%%~zj - !takeaway!

        )

        @REM Deletes the temporary file.
        DEL %TEMP%\tempfile.txt

    ( ENDLOCAL & REM
        IF "%~1" NEQ "" SET %~1=%string%
        IF "%~1.length" NEQ "" SET /A %~1.length=%string.length%
    )
    GOTO :EOF


:ends_with
    @REM Returns (the string) True if the string ends with the substring.
    @REM Otherwise, returns (the string) False.
    @REM
    @REM %~1: The string.
    @REM %~2: The substring we are looking for.
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :ends_with "!string!" "!start!" return_name
    @REM
    @REM    CALL src\String.bat :create_string variable "This is a joke."
    @REM    CALL src\String.bat :ends_with "!variable!" "ke." does_it
    @REM    ECHO !does_it!

    SETLOCAL

        CALL src\String.bat :create_string content "%~1"
        CALL src\String.bat :create_string ends_with "%~2"

        SET result=True

        FOR /L %%i IN ( 1, 1, !ends_with.length! ) DO (

            IF "!content:~-%%i,1!" NEQ "!ends_with:~-%%i,1!" (

                SET result=False
                GOTO :ends_with_end

            )

        )

        :ends_with_end

    ( ENDLOCAL & REM
        IF "%~3" NEQ "" SET %~3=%result%
    )
    GOTO :EOF


:find_check_character
    @REM Auxiliary function used by :find to avoid double expansion (one
    @REM inside another).
    @REM
    @REM To achieve that, it is necessary to work outside the local scope.
    @REM
    @REM %~1: The offset.
    @REM %~2: The iterator from the loop.
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :find_check_character !offset! %%j %~3

    SETLOCAL

    ( ENDLOCAL & REM

        IF "!content:~%~1,1!" EQU "!find_substr:~%~2,1!" (

            IF %~2 EQU !find_substr_limit! (

                SET /A position=%~1-%~2
                SET /A %~3=!position!

                @REM This variable will not be used directly. It acts as a hook
                @REM by the :find function.
                SET found=True

            )

        )

    )
    GOTO :EOF


:find
    @REM Returns the lowest index in the given string where the substring was
    @REM found. Returns -1 if the substring was not found. Optional argument is
    @REM start. This argument tells this function from where to start.
    @REM
    @REM %~1: The string.
    @REM %~2: The substring we are looking for.
    @REM %~3: Return name.
    @REM %~4: Start index position.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :find "!string!" "!find!" return_name start_position
    @REM
    @REM    CALL src\String.bat :create_string variable "this is it, isn't it?"
    @REM    ECHO Given string: !variable!
    @REM    CALL src\String.bat :find "!variable!" "i" position
    @REM    ECHO In which position is the first "i" substring in the string: !position!
    @REM    CALL src\String.bat :find "!variable!" "i" position 3
    @REM    ECHO And starting from the position 3: !position!
    @REM    CALL src\String.bat :find "!variable!" "faS" position
    @REM    ECHO In which position is the first "faS" substring in the string: !position!


    SETLOCAL

    ( ENDLOCAL & REM

        CALL src\String.bat :create_string content "%~1"
        CALL src\String.bat :create_string find_substr "%~2"
        SET found=

        @REM By default, the return value is -1, that is, not found.
        SET /A %~3=-1

        @REM Sets the default value for the fourth parameter.
        SET start_position=%~4
        IF "!start_position!" EQU "" (
            SET /A start_position=0
        )

        @REM Sets the limits for the loops below.
        SET /A content_limit=!content.length!-1
        SET /A find_substr_limit=!find_substr.length!-1

        FOR /L %%i IN ( !start_position!, 1, !content_limit! ) DO (

            SET character=!content:~%%i,1!

            IF "!character!" EQU "!find_substr:~0,1!" (

                FOR /L %%j IN ( 0, 1, !find_substr_limit! ) DO (

                    SET /A offset=%%i+%%j
                    CALL src\String.bat :find_check_character !offset! %%j %~3

                    @REM Checks if the variable was defined.
                    @REM In practice, it serves as a way to break out of the loop.
                    IF DEFINED found (
                        GOTO :EOF
                    )
                )

            )

        )

    )
    GOTO :EOF


:is_alpha
    @REM Returns (the string) True if the string is alphabetical.
    @REM Otherwise, returns (the string) False.
    @REM
    @REM This function has limitations:
    @REM    ! % | < > & " SPACE could not be excluded as non alphabetical.
    @REM    Spaces are ignored. So, a string containing spaces is considered alphabetical.
    @REM
    @REM %~1: The string.
    @REM %~2: The substring we are looking for.
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :is_alpha "!content!" return_name
    @REM
    @REM    CALL src\String.bat :create_string string "this"
    @REM    ECHO Given string: !string!
    @REM    CALL src\String.bat :is_alpha "!string!" return_name
    @REM    ECHO Is the given string all alphabetical?
    @REM    ECHO !return_name!


    SETLOCAL

        @REM CALL src\Array.bat :create_array non_alpha "a" "~a`a{a}a[a]a!a%a^a*a-a=a+a_a|a\a/a@a:a;a<a>a?a.a,a#a&a$a(a)a'a1a2a3a4a5a6a7a8a9a0a "
        CALL src\Array.bat :create_array non_alpha "a" "~a`a{a}a[a]a^^a*a-a=a+a_a\a/a@a:a;a?a.a,a#a$a'a1a2a3a4a5a6a7a8a9a0"
        CALL src\String.bat :create_string content "%~1"

        SET return=True

        SET /A content_limit=!content.length!-1
        SET /A non_alpha_limit=!non_alpha.length!-1

        FOR /L %%i IN ( 0, 1, !content_limit! ) DO (

            SET character=!content:~%%i,1!

            FOR /L %%j IN ( 0, 1, !non_alpha_limit! ) DO (

                IF "!character!" EQU "!non_alpha[%%j]!" (
                    SET return=False
                    GOTO :is_alpha_end
                )

            )

        )

        :is_alpha_end

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%return%
    )
    GOTO :EOF


:starts_with
    @REM Returns (the string) True if the string starts with the substring.
    @REM Otherwise, returns (the string) False.
    @REM
    @REM %~1: The string.
    @REM %~2: The substring we are looking for.
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :starts_with "!string!" "!start!" return_name
    @REM
    @REM    CALL src\String.bat :create_string variable "This is a joke."
    @REM    CALL src\String.bat :starts_with "!variable!" "this" does_it
    @REM    ECHO !does_it!

    SETLOCAL

        CALL src\String.bat :create_string content "%~1"
        CALL src\String.bat :create_string starts_with "%~2"

        SET /A limit=!starts_with.length!-1
        SET result=True

        FOR /L %%i IN ( 0, 1, !limit! ) DO (

            IF "!content:~%%i,1!" NEQ "!starts_with:~%%i,1!" (

                SET result=False
                GOTO :starts_with_end

            )

        )

        :starts_with_end

    ( ENDLOCAL & REM
        IF "%~3" NEQ "" SET %~3=%result%
    )
    GOTO :EOF
