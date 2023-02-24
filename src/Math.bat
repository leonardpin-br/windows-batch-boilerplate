@REM This file is used for storing mathematical functions in this example app.
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
@REM    CALL src\Math.bat :function_name argument
@REM
@REM REFERENCES:
@REM    How to package all my functions in a batch file as a seperate file?
@REM    https://stackoverflow.com/a/18743342
@REM    Udemy - Windows Command Line - Hands-On (CMD, Batch, MS-DOS), Section 2: Redirectors & Applications, 4. Redirectors.
@REM    https://www.udemy.com/course/the-complete-windows-command-line-course/learn/lecture/16599236#overview


@REM Checks if this file was called with the function name, and the name exists.
@REM If the name of the function was given (like CALL Math.bat :max):
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


:abs
    @REM Absolute value refers to the positive value corresponding to the number
    @REM passed in as argument.
    @REM
    @REM %~1: Number (positive or negative).
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\Math.bat :abs number return_name

    SETLOCAL

        SET /A absolute_value=%~1

        IF %~1 LSS 0 (

            SET /A absolute_value=%~1*-1

        ) ELSE (

            SET /A absolute_value=%~1

        )

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%absolute_value%
    )
    GOTO :EOF


:min
    @REM The :min function returns the lowest value in an array.
    @REM
    @REM If 0 is part of the array, it must be scaped like (534,-2,^0).
    @REM
    @REM %~1: Array name.
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\Functions.bat :min array_name return_name

    SETLOCAL

        SET /A for_upper_limit=!%~1.length!-1

        FOR /L %%i IN ( 0, 1, !for_upper_limit! ) DO (

            @REM If it is the first item in the array, sets the minimum as the first.
            IF %%i EQU 0 (

                SET /A minimum=!%~1[%%i]!

            ) ELSE (

                IF !%~1[%%i]! LSS !minimum! (

                    SET /A minimum=!%~1[%%i]!

                )

            )

        )

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%minimum%
    )
    GOTO :EOF


:max
    @REM The :max function returns the highest value in an array.
    @REM
    @REM If 0 is part of the array, it must be scaped like (534,-2,^0).
    @REM
    @REM %~1: Array name.
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\Math.bat :max array_name return_name

    SETLOCAL

        SET /A for_upper_limit=!%~1.length!-1

        FOR /L %%i IN ( 0, 1, !for_upper_limit! ) DO (

            @REM If it is the first item in the array, sets the minimum as the first.
            IF %%i EQU 0 (

                SET /A maximum=!%~1[%%i]!

            ) ELSE (

                IF !%~1[%%i]! GTR !maximum! (

                    SET /A maximum=!%~1[%%i]!

                )

            )

        )

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%maximum%
    )
    GOTO :EOF


:pow
    @REM The :pow is used to calculate a number raise to the power of the second number.
    @REM
    @REM %~1: Base number.
    @REM %~2: Power number.
    @REM %~3: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\Math.bat :pow base power return_name

    SETLOCAL

        IF %~2 EQU 0 (

            SET /A product=1

        ) ELSE (

            SET /A product=%~1
            SET /A for_upper_limit=%~2-1

            FOR /L %%i IN ( 1, 1, !for_upper_limit! ) DO (

                SET /A product=!product!*%~1

            )

        )

    ( ENDLOCAL & REM
        IF "%~3" NEQ "" SET %~3=%product%
    )
    GOTO :EOF


:sum
    @REM Sums the values of the elements of a given array.
    @REM
    @REM %~1: Array name.
    @REM %~2: Return name.
    @REM
    @REM How to use this function:
    @REM    CALL src\Math.bat :sum array_name return_name

    SETLOCAL

        SET /A sum=0
        SET /A for_upper_limit=!%~1.length!-1

        FOR /L %%i IN ( 0, 1, !for_upper_limit! ) DO (

            SET /A sum=!sum!+!%~1[%%i]!

        )

    ( ENDLOCAL & REM
        IF "%~2" NEQ "" SET %~2=%sum%
    )
    GOTO :EOF
