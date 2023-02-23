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

        @REM ECHO Escaping the character ^"^^!^" on the string below. It is only necessary for testing when using SETLOCAL ENABLEDELAYEDEXPANSION globally.
        @REM ECHO Hello World^^!
        @REM ECHO.
        @REM ECHO.

        @REM ECHO Argument passed to this script:
        @REM ECHO !argument_passed_to_this_script!
        @REM ECHO.

        @REM ECHO Global variable inside GlobalVariables.bat:
        @REM ECHO !global_var!
        @REM ECHO.
        @REM ECHO.

        @REM SET /A x=1
        @REM SET /A y=50

        @REM ECHO The value of x before calling Functions.bat :add_one is !x!.
        @REM ECHO The value of y before calling Functions.bat :add_one is !y!.
        @REM ECHO.

        @REM CALL src\Functions.bat :add_one x
        @REM CALL src\Functions.bat :add_one y

        @REM ECHO The value of x after calling Functions.bat :add_one is !x!.
        @REM ECHO The value of y after calling Functions.bat :add_one is !y!.

        @REM CALL src\Functions.bat :create_string variable_name "One"
        @REM ECHO !variable_name!
        @REM ECHO !variable_name.length!

        @REM CALL src\Functions.bat :create_array grocery_list "," "Apples, Bananas, Meat, Soap, Tomato"
        @REM ECHO Array content: !grocery_list!
        @REM ECHO Array length: !grocery_list.length!
        @REM ECHO Index 0 from array: !grocery_list[0]!
        @REM ECHO Index 1 from array: !grocery_list[1]!
        @REM ECHO Index 2 from array: !grocery_list[2]!
        @REM ECHO Index 3 from array: !grocery_list[3]!
        @REM ECHO Index 4 from array: !grocery_list[4]!

        @REM CALL src\Functions.bat :create_array list_of_numbers "," "45,534,2,65,-2,-34,1,^0"
        @REM ECHO !list_of_numbers!
        @REM ECHO !list_of_numbers[0]!
        @REM ECHO !list_of_numbers[1]!
        @REM ECHO !list_of_numbers[2]!
        @REM ECHO !list_of_numbers[3]!
        @REM ECHO !list_of_numbers[4]!
        @REM ECHO !list_of_numbers[5]!
        @REM ECHO !list_of_numbers[6]!
        @REM ECHO !list_of_numbers[7]!
        @REM CALL src\Math.bat :min list_of_numbers minimum_value
        @REM ECHO Minimum value: !minimum_value!

        @REM CALL src\Functions.bat :create_array list_of_numbers "," "45, 534, 2, 65, -2, -34, 1, ^0"
        @REM CALL src\Math.bat :max list_of_numbers maximum_value
        @REM ECHO Maximum value: !maximum_value!

        @REM CALL src\Math.bat :pow 2 1 power_result
        @REM ECHO Power result: !power_result!

        CALL src\Math.bat :abs 420218 absolute_value
        ECHO Absolute value: !absolute_value!

        ECHO.
        ECHO.
        @REM PAUSE

    ENDLOCAL
    GOTO :EOF