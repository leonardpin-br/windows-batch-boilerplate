@REM This script is used as a CMD profile to be autoexecuted when the Command
@REM Prompt window loads.
@REM See the first reference to learn how to add a key to the Windows Registry.
@REM
@REM REFERENCES:
@REM    Is there windows equivalent to the .bashrc file in linux?
@REM    https://superuser.com/a/916478/346546
@REM    Batch Tutorials
@REM    https://www.youtube.com/playlist?list=PL69BE3BF7D0BB69C4

@ECHO OFF

GOTO :main

:main
    @REM Main function of this script/application.

    @REM 0 = Black       8 = Gray
    @REM 1 = Blue        9 = Light Blue
    @REM 2 = Green       A = Light Green
    @REM 3 = Aqua        B = Light Aqua
    @REM 4 = Red         C = Light Red
    @REM 5 = Purple      D = Light Purple
    @REM 6 = Yellow      E = Light Yellow
    @REM 7 = White       F = Bright White

    @REM $A   & (Ampersand)
    @REM $B   | (pipe)
    @REM $C   ( (Left parenthesis)
    @REM $D   Current date
    @REM $E   Escape code (ASCII code 27)
    @REM $F   ) (Right parenthesis)
    @REM $G   > (greater-than sign)
    @REM $H   Backspace (erases previous character)
    @REM $L   < (less-than sign)
    @REM $N   Current drive
    @REM $P   Current drive and path
    @REM $Q   = (equal sign)
    @REM $S     (space)
    @REM $T   Current time
    @REM $V   Windows version number
    @REM $_   Carriage return and linefeed
    @REM $$   $ (dollar sign)

    @REM @REM Sets the background and foreground colors for the entire terminal window.
    @REM Warning: Looks bad on the integrated VSCODE CMD terminal.
    @REM COLOR 17

    @REM To customize the prompt
    PROMPT $_$C%USERNAME%@%COMPUTERNAME%$F$S$S$P$_$G$S

    GOTO :EOF
