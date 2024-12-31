@echo off
rem 下载IP地址清单...
echo Downloading IP list files...
curl -s -o ip_official.txt "https://www.cloudflare.com/ips-v4"
curl -s -o ip_reverse.txt "https://www.baipiao.eu.org/cloudflare/ips-v4"
echo Downloading IP list files completed.

set args=-n 500 -t 10 -dn 100 -sl 5 -tl 300 -p 0 -url https://cdn.cloudflare.steamstatic.com/steam/apps/256843155/movie_max.mp4
rem 官方IP优选测速
echo Testing official IP...
.\CloudflareST.exe %args% -f ip_official.txt -o ip_official.csv
echo Testing official completed.

rem 反代IP优选测速
echo Testing reverse IP...
.\CloudflareST.exe %args% -f ip_reverse.txt -o ip_reverse.csv
echo Testing reverse completed.

rem csv转txt
setlocal enabledelayedexpansion
set skip_line=0
if exist "ip_official.csv" (
  for /f "usebackq tokens=*" %%a in ("ip_official.csv") do (
    if !skip_line! neq 0 (for /f "tokens=1 delims=," %%b in ("%%a") do (echo %%b>> cloudflare_official.txt))
    set /a "skip_line+=1"
  )
)

set skip_line=0
if exist "ip_reverse.csv" (
  for /f "usebackq tokens=*" %%a in ("ip_reverse.csv") do (
    if !skip_line! neq 0 (for /f "tokens=1 delims=," %%b in ("%%a") do (echo %%b>> cloudflare_reverse.txt))
    set /a "skip_line+=1"
  )
)