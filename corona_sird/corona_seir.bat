@echo off

set modelarg=%1

set cwd=%CD%
set shellname=sshell
set vaccinepath[0]=\..\examples\corona_seir\novaccine
set vaccinepath[1]=\..\examples\corona_seir\olderfirstvaccine
set vaccinepath[2]=\..\examples\corona_seir\randvaccine
set vaccinepath[3]=\..\examples\corona_seir\youngerfirstvaccine
set sibname=corona.sib

CD %cwd%\..\..\bin

if [%modelarg%]==[novaccine] (
    CALL :subroutine 0
    goto exit
)

if [%modelarg%]==[olderfirst] (
    CALL :subroutine 1
    goto exit
)

if [%modelarg%]==[random] (
    CALL :subroutine 2
    goto exit
)

if [%modelarg%]==[youngerfirst] (
    CALL :subroutine 3
    goto exit
)

if [%modelarg%] NEQ [] (
    echo Strategia inesistente, inserire uno tra [novaccine, olderfirst, random, youngerfirst].
    echo Altrimenti lasciare vuoto per eseguirle tutte.
    goto exit
)

for /l %%p in (0,1,3) do ( 
    CALL echo run "%%vaccinepath[%%p]%%\%sibname%" | %shellname%
)
goto exit

:subroutine
echo run "%%vaccinepath[%1]%%\%sibname%" | %shellname%

:exit
CD %cwd%