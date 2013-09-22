#!/bin/bash

include=""

_usage() {
cat <<EOF
 build.emcc.sh $Options
$*
        Usage: build.emcc.sh <[options]>
        Options:
                -h   --help              Show this message
                     --include-js=...    Include a js file in compiled HTML

EOF
}

if [ $# = 0 ]; then _usage ; fi

while getopts ':h-:' OPTION ; do
  case "$OPTION" in
    h  ) _usage             ;;
    -  ) [ $OPTIND -ge 1 ] && optind=$(expr $OPTIND - 1 ) || optind=$OPTIND
         eval OPTION="\$$optind"
         OPTARG=$(echo $OPTION | cut -d'=' -f2)
         OPTION=$(echo $OPTION | cut -d'=' -f1)
         case $OPTION in
             --help       ) _usage             ;;
             --include-js ) include="$OPTARG"  ;; 
             * )  _usage ;;
         esac
       OPTIND=1
       shift
      ;;
    ? )  _usage ;;
  esac
done


while [ ! -e "pebble_app.ld" ]
do
	if [ `pwd` == '/' ]
	then
		echo "[FAIL] Could not find 'pebble_app.ld' in this directory or any parent" 1>&2
		exit 1
	fi
	cd ..
done

CWD=`pwd`
APP=`basename $CWD`

#TODO: Expand this
EMCC_TARGET=${EMCC_TARGET:-$APP.html}
EMCC_OPTIMIZE=${EMCC_OPTIMIZE:- -O2}
# current script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd src
rm -rf ../build/www/*
mkdir -p ../build/www/
cp -r $DIR/../include/www/* ../build/www/

# Insert the include script if one exists
if [ "$include" != "" ]
then
    cat ../$include >> ../build/www/main.js
fi

#This appears to mimic "./waf build" well enough for most purposes.
#TODO: Warn if subdirectories exist, since waf doesn't pick them up
#TODO: Swap out $@ for targeted options?

#NOTE: ../build/app_resources.pbpack@ will embed the pbpack at the root of the virtual FS. This is what we would want.
#NOTE: ...however, this causes emscripten to fail. See https://github.com/kripken/emscripten/issues/1644
#cp ../build/app_resources.pbpack .
emcc $@ -O0 -o ../build/www/compiled.js \
	-I $DIR/../include -I ../build -I ../include/ \
	$DIR/../include/emscripten.pebble_os.c $DIR/../include/emscripten.pebble_dict.c $DIR/../include/SDL_prims.c *.c \
	-s EXPORTED_FUNCTIONS="['_create_dict', '_add_bytes_to_dict', '_add_string_to_dict', '_add_uint8_to_dict', '_add_uint16_to_dict', '_add_uint32_to_dict', '_add_int8_to_dict', '_add_int16_to_dict', '_add_int32_to_dict', '_send_dict_to_pebble', '_main']" \
	--preload-file ../build/app_resources.pbpack@/app_resources.pbpack
#rm app_resources.pbpack
