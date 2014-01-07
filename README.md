#Empebble for Pebble SDK 1.12

##Overview

Empebble converts unmodified watchfaces in to embeddable JS that produces a canvas element. That canvas element will attempt to faithfully duplicate the watchface.

##Prerequisites

1. Pebble SDK 1.12
2. Emscripten (Currently must be on PATH)

##Usage

1. `cd` to the directory of your watchapp
2. Build and compile watchface as normal
3. Invoke `$EMPEBBLE/tools/build_emcc.sh`, where `$EMPEBBLE` is the directory you cloned this repo
4. `build/www/` can now be deployed to any webserver.

##Tag Definition

`emscripten.pebble_os.c` is marked with various tags.

###Sprint planning

`#sprintX` - unimplemented; will be implemented during sprint X

###Implementation status

`#todo` - implementation missing or incomplete

`#verify` - implementation complete but may not be accurate

###Documentation

`#nosdk` - no sdk example/docs exist as of Pebble SDK v001

###Other

`#trivial` - trivial function


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/abl/empebble/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

