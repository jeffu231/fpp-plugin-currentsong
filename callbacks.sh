#!/bin/bash

#DEBUG=1
DEBUG_LOG=${DEBUG_LOG:-/home/fpp/media/logs/currentsong.log}

die()
{
	echo $1 >&2
	exit 1
}

usage()
{
	echo "TODO: Fill usage in!"
}

OPTS=$(getopt -n $0 --options lt:d: --longoptions list,type:,data: -- "$@")

if [ -n "$DEBUG" ]; then
	echo "Full args: $*" >> $DEBUG_LOG
fi

# Die if they fat finger arguments, this program will be run as root
[ $? = 0 ] || die "Error parsing arguments. Try $PROGRAM_NAME --help"

eval set -- "$OPTS"
while true; do
	case $1 in
		-l|--list)
			echo "media"; exit 0;
		;;
		-t|--type)
			shift
			case $1 in
				media)
					operation=$1
					;;
				*)
					die "Error: Unsupported type $1!"
					;;
			esac
			shift; continue
		;;
		-h|--help)
			usage
			exit 0
		;;
		-v|--version)
			printf "%s, version %s\n" "$PROGRAM_NAME" "$PROGRAM_VERSION"
			exit 0
		;;
		-d|--data)
			shift
			DATA=$(echo $1 | tr -dc '[:alnum:][:space:][:punct:]')
			shift; continue
		;;
		--)
			# no more arguments to parse
			break
		;;
		*)
			printf "Unknown option %s\n" "$1"
			exit 1
		;;
	esac
done


case $operation in
	media)
		
		if [ -n "$DEBUG" ]; then
			echo $DATA >&2

			# Log to a file as well
			date >> ${DEBUG_LOG}
			echo $DATA >> ${DEBUG_LOG}
			echo >> ${DEBUG_LOG}
		fi

                curl -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d "$DATA" "apoc.home.kb9kld.org/OutsideDataUpdater/api/song/Update"
                ;;
	*)
		die "You must specify a callback type!"
		;;
esac
