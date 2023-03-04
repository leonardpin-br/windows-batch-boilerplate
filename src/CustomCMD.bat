@REM Customizes the Command Prompt termminal.
@REM
@REM %1 (Optional): Command Prompt's title.
@REM
@REM HOW TO USE THIS FILE:
@REM    Simply double click it or run it in CMD (type its name).
@REM    This script can also be called.
@REM
@REM WARNING:
@REM    This script should be in the same directory as the ColorMessage.bat.
@REM
@REM REFERENCES:
@REM    Batch Tutorials
@REM    https://www.youtube.com/playlist?list=PL69BE3BF7D0BB69C4
@REM    Is there windows equivalent to the .bashrc file in linux?
@REM    https://superuser.com/a/916478/346546

@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

@REM Stores the location of the script being called.
@REM %~dp0 is a system variable that stores the full directory path of this file.
SET colormsg=%~dp0ColorMessage.bat

@REM If this script is called, uses the first argument as the title.
SET title=%1
IF "!title!" EQU "" (
    SET title=Custom Terminal
)

TITLE !title!

:run
    @REM These are the colors that can be used inside a Batch script (color /?):
    @REM 0 = Black       8 = Gray
    @REM 1 = Blue        9 = Light Blue
    @REM 2 = Green       A = Light Green
    @REM 3 = Aqua        B = Light Aqua
    @REM 4 = Red         C = Light Red
    @REM 5 = Purple      D = Light Purple
    @REM 6 = Yellow      E = Light Yellow
    @REM 7 = White       F = Bright White

    @REM Starts the terminal with a blank line.
    ECHO.

    @REM Clears the variable in case it was used earlier.
    SET input=

    @REM Username and computer name.
    CALL !colormsg! A "(!USERNAME!@!COMPUTERNAME!)" &

    @REM Identifies this terminal as the CMD.
    CALL !colormsg! 9 " CMD " &

    @REM Second terminal information.
    CALL !colormsg! E "!CD!" &

    @REM Creates a line break.
    ECHO. &

    @REM The user will type in the next line (just like Cygwin and Git Bash).
    CALL !colormsg! 9 "> "

    @REM Captures the user input command.
    SET /P input=

    @REM Shows the output of the command typed by the user.
    @REM Works in conjuction with the code block below the IF.
    @REM From the help:
    @REM /C     Carries out the command specified by string and then terminates
    CMD /C !input!

    @REM If the user command is equal to nothing, simply go back and starts over.
    IF "!input!" EQU "" (
        ECHO.
        GOTO :run
    )

    @REM Executes the string typed by the user as a command. The output comes from the line above the IF.
    @REM This is not a duplicate. It is necessary to access what was done before (like setting a variable).
    @REM "> NUL" removes the unnecessary standard output (like when setting a variable).
    @REM "2>&1" avoids printing the standard error message twice, redirecting it to the first (NUL).
    !input! > NUL 2>&1

    ECHO.
    GOTO :run
