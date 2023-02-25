@REM This script is used for storing array related functions in this example app.
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
@REM    CALL src\Array.bat :function_name argument
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
@REM If the name of the function was given (like CALL Array.bat :create_array):
IF "%~1" NEQ "" (

    2>NUL >NUL FINDSTR /rc:"^ *%~1\>" "%~f0" && (

        SHIFT /1
        GOTO %1

    ) || (

        @REM Only runs this command if the first one fails.
        >&2 CALL src\Functions.bat :print_message "ERROR" "Function %~1 not found inside %~nx0."

    )

@REM If the function name was not given (like CALL Array.bat):
) ELSE >&2 CALL src\Functions.bat :print_message "ERROR" "Missing the function name when calling %~nx0."


GOTO :EOF


:create_array_set_index
    @REM Auxiliary function used by :create_array to avoid two variable
    @REM expansions, one inside another.
    @REM
    @REM %~1: Array name.
    @REM %~2: Array index.
    @REM %~3: Index content inside quotes in the form of a substring with
    @REM      two variable expansions.
    @REM
    @REM How to use this function:
    @REM    CALL src\Array.bat :create_array_set_index %~1 !array_index! "string_content:~!string_offset!,!item_length!"

    SETLOCAL

    @REM To be able to return back the values passed, it was necessary to work
    @REM inside the block below.

    ( ENDLOCAL & REM

        CALL src\String.bat :create_string %~1[%~2] "!%~3!"

    )
    GOTO :EOF


:create_array
    @REM Creates an array.
    @REM
    @REM When this function is called, the array is given in the form of a
    @REM string. As such, the given array is treated as a string. The procedures
    @REM are based on string manipulation.
    @REM
    @REM Warning:
    @REM    Spaces SHOULD NOT be used in the string given to create the array.
    @REM
    @REM    Spaces MUST NOT be used after the delimiter like ", ".
    @REM    As this function is used by other functions, the spaces create a
    @REM    hard to track bug.
    @REM
    @REM    It is advisable to use "," as delimiters. But, it will work with
    @REM    other characters like "=".
    @REM
    @REM %~1: Array name.
    @REM %~2: Delimiter.
    @REM %~3: Array content inside quotes separated by delimiter.
    @REM
    @REM How to use this function:
    @REM    CALL src\Array.bat :create_array array_name "<delimiter>" "List inside quotes separeted by delimiter"
    @REM    CALL src\Array.bat :create_array grocery_list "," "Apples, Bananas, Meat, Soap, Tomato"
    @REM    ECHO Array content: !grocery_list!
    @REM    ECHO Array length: !grocery_list.length!
    @REM    ECHO Index 1 from array: !grocery_list[1]!

    SETLOCAL

        @REM To be able to set the array indexes, it was necessary to work this
        @REM function in the block below.

    ( ENDLOCAL & REM

        @REM Sets the indexes of each item in the array.
        @REM -------------------------------------------------------------------

        CALL src\String.bat :create_string string_delimiter "%~2"
        CALL src\String.bat :create_string string_content "%~3"

        @REM Index position, in the string given to create the array, immediately after the delimiter.
        SET /A string_offset=0

        @REM Array index, that has to be incremented for each item.
        SET /A array_index=0

        @REM Loops through all characters of the string given to create the array.
        FOR /L %%i IN ( 0, 1, !string_content.length!-1 ) DO (

            @REM The variable character is a substring of only one character.
            SET character=!string_content:~%%i,1!

            @REM The quotes are necessary to work with the string form of variables.
            IF "!character!" EQU "!string_delimiter!" (

                @REM length of each item in the array.
                @REM It is calculated subtracting the string_offset from the current value of the iterator.
                SET /A item_length=%%i-!string_offset!

                @REM In order to avoid two variable expansions, one inside
                @REM another, we call :set_index.
                @REM The third argument below is the string form of the substring.
                CALL src\Array.bat :create_array_set_index %~1 !array_index! "string_content:~!string_offset!,!item_length!"

                @REM Adds one to the string_offset to start (on the string) after the delimiter.
                SET /A string_offset=%%i+1

                @REM Increments the array index.
                SET /A array_index=!array_index!+1

            )

        )

        @REM The last array item has no delimiter after it.
        CALL src\Array.bat :create_array_set_index %~1 !array_index! "string_content:~!string_offset!,!string_content.length!"

        @REM The sum below adjusts the index to the total number of items in the array.
        SET /A array.length=!array_index!+1

        @REM Array_name receives the value (the entire array as a string).
        @REM -------------------------------------------------------------------

        IF "%~1" NEQ "" SET %~1=!string_content!

        @REM Sets the array.length property.
        @REM -------------------------------------------------------------------

        IF "%~1.length" NEQ "" SET /A %~1.length=!array.length!

        @REM Clears the values of those variables.
        SET string_content=
        SET /A item_length=0
        SET /A string_offset=0
        SET character=
        SET string_delimiter=
        SET /A array_index=0

    )
    GOTO :EOF


:range
    @REM Creates an array containing a range of elements from the first given
    @REM to the last. The last is included.
    @REM
    @REM %~1: Array name.
    @REM %~2: Delimiter.
    @REM %~3 (Optional): Range start. Defaults to 0.
    @REM %~4 (Optional): Range stop. Defaults to the start given value.
    @REM %~5 (Optional): Range step. Defaults to 1.
    @REM
    @REM How to use this function:
    @REM    CALL src\Array.bat :range array_name "delimiter" start stop step

    SETLOCAL

        CALL src\String.bat :create_string delimiter "%~2"
        SET start=%~3
        SET stop=%~4
        SET step=%~5

        IF "!stop!" EQU "" (

            SET /A stop=!start!
            SET /A start=0

        )

        IF "!step!" EQU "" (

            SET /A step=1

        )

        SET content=
        FOR /L %%i IN ( !start!, !step!, !stop! ) DO (

            SET content=!content!%%i

            IF NOT %%i EQU !stop! (

                SET content=!content!!delimiter!

            )

        )

    ( ENDLOCAL & REM

        CALL src\Array.bat :create_array %~1 "%delimiter%" "%content%"
    )
    GOTO :EOF


:sort
    @REM Sorts, in ascending order, the elements of a given array.
    @REM
    @REM %~1: Array name.
    @REM %~2: Delimiter.
    @REM
    @REM How to use this function:
    @REM    CALL src\Array.bat :sort array_name "delimiter"

    SETLOCAL

        SET array_name=%~1
        CALL src\String.bat :create_string delimiter "%~2"

        SET /A for_upper_limit=!%~1.length!-1

        FOR /L %%i IN ( 0, 1, !for_upper_limit! ) DO (

            FOR /L %%j IN ( %%i, 1, !for_upper_limit! ) DO (

                IF !%~1[%%i]! GTR !%~1[%%j]! (

                    SET /A temporary=!%~1[%%i]!
                    CALL src\String.bat :create_string !array_name![%%i] "!%~1[%%j]!"
                    CALL src\String.bat :create_string !array_name![%%j] "!temporary!"

                )

            )

        )

        FOR /L %%i IN ( 0, 1, !for_upper_limit! ) DO (

            SET content=!content!!%~1[%%i]!

            @REM If not in the end of the loop.
            IF NOT %%i EQU !for_upper_limit! (

                SET content=!content!!delimiter!

            )

        )

    ( ENDLOCAL & REM

        CALL src\Array.bat :create_array %array_name% "%delimiter%" "%content%"

    )
    GOTO :EOF
