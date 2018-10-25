#!/bin/bash

version="1.0"
scriptDir=$(dirname $0)
versionStr="Solr Migration version ${version}"

function usage {
	echo -e "${versionStr}\n"
	echo -e "Usage:\n"
	echo -e "${scriptDir}/$(basename $0) indexDir [-v|--verbose] [-n|--dry-run]\n"
	echo -e "  * migrate an existing solr index"
	echo -e "  * -v or --verbose enable some more logging"
	echo -e "  * -n or --dry-run do not perform the migration\n"
	echo -e "${scriptDir}/$(basename $0) -h|--help\n"
	echo -e "  * show the usage information\n"
	echo -e "${scriptDir}/$(basename $0) --version\n"
	echo -e "  * show the current version\n"
	echo -e "Make sure you make a copy of the indexes before upgrading which is an unreversible operation."
	echo -e "The index will be migrated from 4.x to 5.x than from 5.x to 6.x and finally from 6.x to 7.x\n"
	exit 1
}

function version {
	echo "${versionStr}"
	exit 0
}

if [[ "$#" -lt 1 ]]; then
	echo -e "*** Missing index directory\n"
	usage
fi

OPTIONS=""
INDEXSET=0
VERBOSE=0
DRYRUN=0
ARGS="$@"
for flag in $ARGS; do
    case "$flag" in
		-h)
			usage
            ;;
        --help)
			usage
            ;;
        --version)
			version
            ;;
        -v)
			VERBOSE=1
            ;;
        --verbose)
			VERBOSE=1
            ;;
        -n)
			DRYRUN=1
            ;;
        --dry-run)
			DRYRUN=1
            ;;
        *)
			if [[ $INDEXSET -eq 0 ]]; then
				indexDir="$flag"
				INDEXSET=1
			else
				OPTIONS="$OPTIONS $flag"
			fi
            ;;
    esac
done

if [[ $VERBOSE -eq 1 ]]; then
	OPTIONS="$OPTIONS -verbose"
fi

function migrateIndex {
	version=$1
	indexDir=$2
	shift
	shift

	classPath="${scriptDir}/lucene-${version}/lucene-core-${version}.jar:${scriptDir}/lucene-${version}/lucene-backward-codecs-${version}.jar"

	echo "upgrading to ${version} for ${indexDir}"
	java -cp ${classPath} org.apache.lucene.index.IndexUpgrader -delete-prior-commits ${indexDir} $@ || exit
}

if [[ $DRYRUN -eq 1 ]]; then
	if [ ! -d "${indexDir}" ]; then
		echo -e "*** The given directory \"${indexDir}\" does not exists!"
		exit 1
	else
		echo "This is a dry-run, \"${indexDir}\" is an existing directory, nothing will be done"
		exit 0
	fi
else
	migrateIndex "5.5.5" ${indexDir} ${OPTIONS}
	migrateIndex "6.6.5" ${indexDir} ${OPTIONS}
	migrateIndex "7.5.0" ${indexDir} ${OPTIONS}
fi
