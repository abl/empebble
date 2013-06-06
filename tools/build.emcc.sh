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

cd src
#TODO: This needs work
mkdir -p ../build/www/
cp -r ../include/www/* ../build/www/


#This appears to mimic "./waf build" well enough for most purposes.
#TODO: Warn if subdirectories exist, since waf doesn't pick them up
#TODO: Swap out $@ for targeted options?

emcc $@ $EMCC_OPTIMIZE --shell-file ../include/www/template/shell.html -I ../include -I ../build ../include/emscripten.pebble_os.c ../include/SDL_prims.c ../include/strftime.c -o ../build/www/$EMCC_TARGET *.c

