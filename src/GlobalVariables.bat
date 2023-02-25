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
CALL src\Array.bat :create_array upper_cased_letters "," "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
CALL src\Array.bat :create_array lower_cased_letters "," "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"