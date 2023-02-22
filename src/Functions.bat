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
        ECHO.

    ENDLOCAL
    GOTO :EOF


:create_array
    @REM Creates an array.
    @REM
    @REM When this function is called, the array is given in the form of a
    @REM string. As such, the given array is treated as a string. The procedures
    @REM are based on string manipulation.
    @REM
    @REM This function DOES NOT WORK WITH SPACE as a delimiter. It is advisable
    @REM to use "," as delimiters. But, it will work with other characters like
    @REM "=". Spaces can be used after the delimiter like ", ".
    @REM
    @REM %~1: Array name.
    @REM %~2: Delimiter.
    @REM %~3: Array content inside quotes separated by delimiter.
    @REM
    @REM How to use this function:
    @REM    CALL src\Functions.bat :create_array array_name "<delimiter>" "List inside quotes separeted by delimiter"
    @REM    CALL src\Functions.bat :create_array grocery_list "," "Apples, Bananas, Meat, Soap, Tomato"
    @REM    ECHO Array content: !grocery_list!
    @REM    ECHO Array length: !grocery_list.length!
    @REM    ECHO Index 1 from array: !grocery_list[1]!

    SETLOCAL

        @REM To be able to set the array indexes, it was necessary to work this
        @REM function in the block below.

    ( ENDLOCAL & REM

        @REM Sets the indexes of each item in the array.
        @REM -------------------------------------------------------------------

        CALL src\Functions.bat :create_string string_delimiter "%~2"
        CALL src\Functions.bat :create_string string_content "%~3"

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
                CALL src\Functions.bat :set_index %~1 !array_index! "string_content:~!string_offset!,!item_length!"

                @REM Adds one to the string_offset to start (on the string) after the delimiter.
                SET /A string_offset=%%i+1

                @REM Increments the array index.
                SET /A array_index=!array_index!+1

            )

        )

        @REM The last array item has no delimiter after it.
        CALL src\Functions.bat :set_index %~1 !array_index! "string_content:~!string_offset!,!string_content.length!"

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


:create_string
    @REM Creates a string.
    @REM
    @REM %~1: Variable name.
    @REM %~2: String inside quotes.
    @REM
    @REM How to use this function:
    @REM    CALL src\Functions.bat :create_string variable_name "Everything INSIDE the quotation marks."
    @REM    ECHO !variable_name!
    @REM    ECHO !variable_name.length!

    SETLOCAL

        @REM Local variable to hold the string length.
        SET /A string.length=0

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
        IF "%~1.length" NEQ "" SET /A %~1.length=%string.length%
    )
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
    @REM    CALL src\Functions.bat :print_message "Message string"

    SETLOCAL

        ECHO.
        ECHO ===================================================================
        ECHO.
        ECHO %~1
        ECHO.
        ECHO ===================================================================

    ENDLOCAL
    GOTO :EOF


:set_index
    @REM Auxiliary function used by :create_array to avoid two variable
    @REM expansions, one inside another.
    @REM
    @REM %~1: Array name.
    @REM %~2: Array index.
    @REM %~3: Index content inside quotes in the form of a substring with
    @REM      two variable expansions.
    @REM
    @REM How to use this function:
    @REM    CALL src\Functions.bat :set_index %~1 !array_index! "string_content:~!string_offset!,!item_length!"

    SETLOCAL

    @REM To be able to return back the values passed, it was necessary to work
    @REM inside the block below.

    ( ENDLOCAL & REM

        CALL src\Functions.bat :create_string %~1[%~2] "!%~3!"

    )
    GOTO :EOF
