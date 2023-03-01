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
@REM WARNING:
@REM    "Imported" files (like this one) should not have local global variables
@REM    because they are not accessible. Global variables should be placed
@REM    inside Main.bat or, better yet, inside the GlobalVariables.bat file.
@REM
@REM REFERENCES:
@REM    Batch Tutorials
@REM    https://www.youtube.com/playlist?list=PL69BE3BF7D0BB69C4
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

        CALL :create_string string "%~1"
        SET second_parameter=%~2

        SET first=!string:~0,1!

        SET /A for_upper_limit=!uppercase_letters.length!-1

        FOR /L %%i IN ( 0, 1, !for_upper_limit! ) DO (

            IF !lowercase_letters[%%i]! EQU !first! (

                SET second_parameter=!uppercase_letters[%%i]!
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

        CALL :create_string haystack "%~1"
        CALL :create_string needle "%~2"

        @REM Whe should not count the quotes.
        SET /A haystack_limit=!haystack.length!-1
        SET /A needle_limit=!needle.length!-1

        FOR /L %%i IN ( 0, 1, !haystack_limit! ) DO (

            SET character=!haystack:~%%i,1!

            IF "!character!" EQU "!needle:~0,1!" (

                FOR /L %%j IN ( 0, 1, !needle_limit! ) DO (

                    SET /A offset=%%i+%%j

                    CALL :count_check_character !offset! %%j %~3

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

        CALL :create_string content "%~1"
        CALL :create_string ends_with "%~2"

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

        CALL :create_string content "%~1"
        CALL :create_string find_substr "%~2"
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
                    CALL :find_check_character !offset! %%j %~3

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
    @REM    ! % | < > & " SPACE could not be excluded as non-alphabetic.
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

        CALL :create_string content "%~1"

        SET return=True

        SET /A content_limit=!content.length!-1
        SET /A non_alphabetic_limit=!non_alphabetic.length!-1

        FOR /L %%i IN ( 0, 1, !content_limit! ) DO (

            SET character=!content:~%%i,1!

            FOR /L %%j IN ( 0, 1, !non_alphabetic_limit! ) DO (

                IF "!character!" EQU "!non_alphabetic[%%j]!" (
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


:is_digit
    @REM Returns (the string) True if the string has only digits.
    @REM Otherwise, returns (the string) False.
    @REM
    @REM This function has limitations:
    @REM    ! % | < > & " SPACE could not be excluded as non-digits.
    @REM    Spaces are ignored. So, a string containing digits and spaces is
    @REM    considered only digits.
    @REM
    @REM %~1: The string.
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :is_digit "!string!" return_name
    @REM
    @REM    CALL src\String.bat :create_string string "5234"
    @REM    ECHO Given string: !string!
    @REM    CALL src\String.bat :is_digit "!string!" return_name
    @REM    ECHO Is the given string all digits?
    @REM    ECHO !return_name!

    SETLOCAL

        CALL :create_string content "%~1"

        SET return=True

        SET /A content_limit=!content.length!-1
        SET /A non_digits_limit=!non_digits.length!-1

        @REM Loops as many times as there are characters in the given string.
        FOR /L %%i IN ( 0, 1, !content_limit! ) DO (

            @REM Each character of the given string is temporarily stored.
            SET character=!content:~%%i,1!

            @REM Loops as many times as there are items in the digits array.
            FOR /L %%j IN ( 0, 1, !non_digits_limit! ) DO (

                IF "!character!" EQU "!non_digits[%%j]!" (
                    SET return=False
                    GOTO :is_digit_end
                )

            )

        )

        :is_digit_end

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%return%
    )
    GOTO :EOF


:is_lower
    @REM Return (the string) True if there are no uppercase characters, (the
    @REM string) False otherwise. Will return (the string) True if there is
    @REM only numbers or special characters on the string.
    @REM
    @REM %~1: The string.
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :is_lower "!string!" return_name
    @REM
    @REM    CALL src\String.bat :create_string string "this is a joke"
    @REM    ECHO Given string: !string!
    @REM    CALL src\String.bat :is_lower "!string!" return_name
    @REM    ECHO Is the given string all lowercased?
    @REM    ECHO !return_name!

    SETLOCAL

        CALL :create_string content "%~1"

        SET return=True

        SET /A content_limit=!content.length!-1
        SET /A uppercase_letters_limit=!uppercase_letters.length!-1

        FOR /L %%i IN ( 0, 1, !content_limit! ) DO (

            SET character=!content:~%%i,1!

            FOR /L %%j IN ( 0, 1, !uppercase_letters_limit! ) DO (

                IF "!character!" EQU "!uppercase_letters[%%j]!" (
                    SET return=False
                    GOTO :is_lower_end
                )

            )

        )

        :is_lower_end

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%return%
    )
    GOTO :EOF


:is_upper
    @REM Return (the string) True if there are no lowercase characters, (the
    @REM string) False otherwise. Will return (the string) True if there are
    @REM numbers or special characters on the string.
    @REM
    @REM %~1: The string.
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :is_upper "!string!" return_name
    @REM
    @REM    CALL src\String.bat :create_string string "WH"
    @REM    ECHO Given string: !string!
    @REM    CALL src\String.bat :is_upper "!string!" return_name
    @REM    ECHO Is the given string all uppercase?
    @REM    ECHO !return_name!

    SETLOCAL

        CALL :create_string content "%~1"

        SET return=True

        SET /A content_limit=!content.length!-1
        SET /A lowercase_letters_limit=!lowercase_letters.length!-1

        FOR /L %%i IN ( 0, 1, !content_limit! ) DO (

            SET character=!content:~%%i,1!

            FOR /L %%j IN ( 0, 1, !lowercase_letters_limit! ) DO (

                IF "!character!" EQU "!lowercase_letters[%%j]!" (
                    SET return=False
                    GOTO :is_upper_end
                )

            )

        )

        :is_upper_end

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%return%
    )
    GOTO :EOF


:join
    @REM Takes all items in an iterable and joins them into one string.
    @REM
    @REM %~1: The array.
    @REM %~2: The string character to join the items in the array.
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :join array_name "character_to_join" return_name
    @REM
    @REM    CALL src\Array.bat :create_array folder_list "," "C:,Program Files,Microsoft Office,root"
    @REM    ECHO Array: !folder_list!
    @REM    CALL src\String.bat :join folder_list "\" concatenated_path
    @REM    ECHO The concatenated path is: !concatenated_path!

    SETLOCAL

        SET array=%~1
        SET character=%~2
        SET return=

        SET /A array_limit=!array.length!-1

        @REM Loops as many times as there are array elements.
        FOR /L %%i IN ( 0, 1, !array_limit! ) DO (

            IF NOT %%i EQU !array_limit! (
                SET return=!return!!%array%[%%i]!!character!

            @REM If it is the last item in the array.
            ) ELSE (
                SET return=!return!!%array%[%%i]!
            )

        )

    ( ENDLOCAL & REM
        IF "%~3" NEQ "" SET %~3=%return%
    )
    GOTO :EOF


:lower
    @REM Return a copy of the string with all the cased characters converted to lowercase.
    @REM
    @REM %~1: The string.
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :lower "string" return_name
    @REM
    @REM    CALL src\String.bat :lower "WHAT NOO" return_name
    @REM    ECHO Given string: WHAT NOO
    @REM    ECHO The return is: !return_name!

    SETLOCAL

        CALL :create_string content "%~1"
        SET return=

        SET /A content_limit=!content.length!-1
        SET /A uppercase_letters_limit=!uppercase_letters.length!-1

        @REM Loops as many times as there are characters in the given string.
        FOR /L %%i IN ( 0, 1, !content_limit! ) DO (

            SET character=!content:~%%i,1!

            @REM Loops through the uppercase_letters (pseudo) array.
            FOR /L %%j IN ( 0, 1, !uppercase_letters_limit! ) DO (

                IF "!character!" EQU "!uppercase_letters[%%j]!" (

                    @REM Swaps the uppercase for the lowercase.
                    SET character=!lowercase_letters[%%j]!

                )

            )

            @REM Builds the return string.
            SET return=!return!!character!

        )

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%return%
    )
    GOTO :EOF


:split_double_expansion
    @REM Auxiliary function used by :split to avoid two variable expansions, one
    @REM inside another.
    @REM
    @REM %~1: Temporary variable name.
    @REM %~2: Content to expand again.
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :split_double_expansion new_expansion "content:~!content_offset!,!item_length!"

    SETLOCAL

    @REM To be able to return back the values passed, it was necessary to work
    @REM inside the block below.

    ( ENDLOCAL & REM
        CALL :create_string %~1 "!%~2!"
    )
    GOTO :EOF


:split
    @REM Return an (pseudo) array with the words in the string, using the given
    @REM character as the delimiter.
    @REM
    @REM %~1: The string.
    @REM %~2: The character to serve as the separator.
    @REM %~3: Return name.
    @REM %~4 (Optional):    The character to serve as the separator in the array.
    @REM                    Defaults to ",".
    @REM
    @REM How to use this function:
    @REM    CALL src\String.bat :split "string under quotes" "separator character" return_name "optional array separator"
    @REM
    @REM    CALL src\String.bat :split "E:\cloud\Backup\Libraries" "\" resulting_array ","
    @REM    ECHO The resulting array is: !resulting_array!
    @REM    ECHO Array length: !resulting_array.length!
    @REM    ECHO Index 0 of array: !resulting_array[0]!
    @REM    ECHO Index 1 of array: !resulting_array[1]!
    @REM    ECHO Index 2 of array: !resulting_array[2]!
    @REM    ECHO Index 3 of array: !resulting_array[3]!

    SETLOCAL

    @REM To be able to return back the values passed, it was necessary to work
    @REM inside the block below.

    ( ENDLOCAL & REM

        @REM The string creation must occur inside this function to be able to
        @REM access the .length "property".
        CALL :create_string content "%~1"
        SET content_separator=%~2

        @REM Sets the default value for the fourth parameter.
        IF "%~4" EQU "" (
            SET array_separator=","
        ) ELSE (
            SET array_separator=%~4
        )

        @REM content_offset marks the beggining of the (future) array element.
        SET /A content_offset=0
        SET array_content=
        SET /A content_limit=!content.length!-1

        @REM Loops as many times as there are characters in the string.
        FOR /L %%i IN ( 0, 1, !content_limit! ) DO (

            SET character=!content:~%%i,1!

            @REM Each character will be compared against the given separator.
            IF "!character!" EQU "!content_separator!" (

                SET /A item_length=%%i-!content_offset!

                @REM To avoid double expansion, it is necessary to call an auxiliary function.
                CALL :split_double_expansion new_expansion "content:~!content_offset!,!item_length!"

                @REM Builds the array content, except for the last item.
                SET array_content=!array_content!!new_expansion!!array_separator!

                @REM Addin one to the content_offset marks the beggining of the
                @REM new array element after the separator.
                SET /A content_offset=%%i+1

            )

        )

        @REM The last array item has no delimiter after it.
        CALL :split_double_expansion new_expansion "content:~!content_offset!,!content.length!"
        SET array_content=!array_content!!new_expansion!

        @REM Effectively creates the array.
        CALL src\Array.bat :create_array return "!array_separator!" "!array_content!"

        @REM Returns all the values.
        IF "%~3" NEQ "" SET %~3=!return!
        IF "%~3.length" NEQ "" SET %~3.length=!return.length!
        SET /A return_limit=!return.length!-1
        FOR /L %%i IN ( 0, 1, !return_limit! ) DO (
            IF "%~3[%%i]" NEQ "" SET %~3[%%i]=!return[%%i]!
        )

        @REM Clears the variables.
        SET content=
        SET content_separator=
        SET /A content_limit=0
        SET array_separator=
        SET character=
        SET array_content=
        SET /A item_length=0
        SET /A content_offset=0
        SET new_expansion=
        SET return=
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

        CALL :create_string content "%~1"
        CALL :create_string starts_with "%~2"

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
