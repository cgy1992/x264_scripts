#!/bin/bash
#set -x

ROOT_DIR=$PWD
TOOLS_DIR=$ROOT_DIR/../../common_scripts

. "${TOOLS_DIR}/toolset/$1"

BUILD_DIR=$ROOT_DIR/_build-$1
REDIST_DIR=$ROOT_DIR/../../x264/$1
SOURCE_DIR=$ROOT_DIR/../x264

rm -fR $BUILD_DIR
rm -fR $REDIST_DIR
mkdir -p $BUILD_DIR
mkdir -p $REDIST_DIR

cd $BUILD_DIR

if [ "$COMPILER" == "msvc" ]
then
	export CC='cl.exe'
	${SOURCE_DIR}/configure --enable-shared --host=$HOST_DEF --cross-prefix=$CROSS_PREFIX --sysroot=$CROSSBUILDTREE
else
	${SOURCE_DIR}/configure --enable-shared --host=$HOST_DEF --cross-prefix=$CROSS_PREFIX --sysroot=$CROSSBUILDTREE
fi

make -j8

if [ "$COMPILER" = "msvc" ]; then
   . "${TOOLS_DIR}/make_def_and_lib_from_dll.sh"
   make_def_and_lib_from_dll libx264-155.dll libx264.lib
fi

cd $ROOT_DIR

cp -v $BUILD_DIR/x264.pc     $REDIST_DIR

cp -v $SOURCE_DIR/x264.h          $REDIST_DIR
cp -v $BUILD_DIR/x264_config.h    $REDIST_DIR
cp -v $BUILD_DIR/*.dll            $REDIST_DIR

if [ "$COMPILER" == "msvc" ]
then
    cp -v $BUILD_DIR/libx264.dll.lib $REDIST_DIR/x264.lib
    cp -v $BUILD_DIR/libx264.dll.lib $REDIST_DIR/libx264.lib
else
    cp -v $BUILD_DIR/libx264.dll.a $REDIST_DIR/x264.a
    cp -v $BUILD_DIR/libx264.dll.a $REDIST_DIR/libx264.a
fi

