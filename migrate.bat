@echo off
echo off

SET SCRIPT_DIR=%~dp0
SET INDEX_DIR=%1
SHIFT

IF NOT EXIST "%INDEX_DIR%" (
    echo Missing directory %INDEX_DIR%
    exit
)

SET OPTIONS=%*

SET VERSION="5.5.5"
call :migrateIndex

SET VERSION="6.6.5"
call :migrateIndex

SET VERSION="7.5.0"
call :migrateIndex

goto :eof

:migrateIndex
CLASSPATH="%SCRIPT_DIR%\lucene-%VERSION%\lucene-core-%VERSION%.jar:%SCRIPT_DIR%\lucene-%VERSION%\lucene-backward-codecs-%VERSION%.jar"
echo "upgrading to %VERSION% for %INDEX_DIR%"
java -cp %CLASSPATH% org.apache.lucene.index.IndexUpgrader -delete-prior-commits %OPTIONS% %INDEX_DIR%
goto :eof
