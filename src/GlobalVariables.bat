@REM This script is used for storing global variables in this example app.
@REM
@REM HOW TO USE THIS FILE:
@REM    From the Main.bat file, inside the :main function, use as follows:
@REM    CALL src\GlobalVariables.bat
@REM
@REM REFERENCES:
@REM    Batch file include external file for variables
@REM    https://stackoverflow.com/a/2763907

SET global_var=Inside the global variable
CALL src\Array.bat :create_array uppercase_letters "," "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
CALL src\Array.bat :create_array lowercase_letters "," "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
CALL src\Array.bat :create_array digits "," "1,2,3,4,5,6,7,8,9,0"
CALL src\Array.bat :create_array special_characters "a" "~a`a{a}a[a]a^^a*a-a=a+a_a\a/a@a:a;a?a.a,a#a$a'"

@REM Below is an array creation of non-alphabetic and non-digit characters.
@REM But, there are limtations:
@REM    ! % | < > & " SPACE could not be included in the array as non-alphabetic and non-digit.
@REM    Spaces are ignored. So, a string containing spaces is considered alphabetical.
@REM CALL src\Array.bat :create_array non_alphabetic "a" "~a`a{a}a[a]a!a%a^a*a-a=a+a_a|a\a/a@a:a;a<a>a?a.a,a#a&a$a(a)a'a1a2a3a4a5a6a7a8a9a0a "
CALL src\Array.bat :create_array non_alphabetic "a" "~a`a{a}a[a]a^^a*a-a=a+a_a\a/a@a:a;a?a.a,a#a$a'a1a2a3a4a5a6a7a8a9a0"
CALL src\Array.bat :create_array non_digits "0" "~0`0{0}0[0]0^^0*0-0=0+0_0\0/0@0:0;0?0.0,0#0$0'0a0b0c0d0e0f0g0h0i0j0k0l0m0n0o0p0q0r0s0t0u0v0w0x0y0z0A0B0C0D0E0F0G0H0I0J0K0L0M0N0O0P0Q0R0S0T0U0V0W0X0Y0Z"