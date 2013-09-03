#!/bin/bash

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


#This appears to mimic "./waf build" well enough for most purposes.
#TODO: Warn if subdirectories exist, since waf doesn't pick them up
#TODO: Swap out $@ for targeted options?

emcc $@ -o ../build/www/compiled.js -I $DIR/../include -I ../build -I ../include/ $DIR/../include/emscripten.pebble_os.c $DIR/../include/emscripten.pebble_dict.c $DIR/../include/SDL_prims.c *.c -s EXPORTED_FUNCTIONS="['_create_dict', '_add_string_to_dict', '_add_uint8_to_dict', '_add_uint16_to_dict', '_add_uint32_to_dict', '_add_int8_to_dict', '_add_int16_to_dict', '_add_int32_to_dict', '_send_dict_to_pebble', '_main']"

# cc $@ -02 -I $DIR/../include -I ../build -I ../include/ $DIR/../include/emscripten.pebble_os.c $DIR/../include/SDL_prims.c  -o ../build/www/$APP.native *.c
