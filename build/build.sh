#!/bin/bash
#set -x

ROOT_DIR=$PWD
TOOLS_DIR=$ROOT_DIR/../../common_scripts

. "${TOOLS_DIR}/toolset/$1"

BUILD_DIR=$ROOT_DIR/_build-$1
REDIST_DIR=$ROOT_DIR/../../x264_redist/$1
SOURCE_DIR=$ROOT_DIR/../../x264

rm -fR $BUILD_DIR
rm -fR $REDIST_DIR
mkdir -p $BUILD_DIR
mkdir -p $REDIST_DIR
mkdir -p $REDIST_DIR/bin
mkdir -p $REDIST_DIR/include
mkdir -p $REDIST_DIR/lib

cd $BUILD_DIR

if [ "$COMPILER" == "msvc" ]
then
	export CC='cl.exe'
	# this option can be used in single thread compilation (make withot -jX option)
	# --extra-cflags="-Zi"
	${SOURCE_DIR}/configure --enable-shared --host=$HOST_DEF --cross-prefix=$CROSS_PREFIX --prefix="./../../../x264_redist/$1"
else
	${SOURCE_DIR}/configure --enable-shared --host=$HOST_DEF --cross-prefix=$CROSS_PREFIX --sysroot=$CROSSBUILDTREE --extra-ldflags=-static-libgcc --prefix="./../../../x264_redist/$1"
fi

make -j8

if [ "$COMPILER" == "msvc" ]; then
   . "${TOOLS_DIR}/make_def_and_lib_from_dll.sh"
   make_def_and_lib_from_dll libx264-155.dll libx264.lib
fi

cd $ROOT_DIR

cp -v $BUILD_DIR/x264.pc     $REDIST_DIR

cp -v $SOURCE_DIR/x264.h          $REDIST_DIR/include
cp -v $BUILD_DIR/x264_config.h    $REDIST_DIR/include
cp -v $BUILD_DIR/*.dll            $REDIST_DIR/bin
cp -v $BUILD_DIR/*.exe            $REDIST_DIR/bin

if [ "$COMPILER" == "msvc" ]
then
    cp -v $BUILD_DIR/libx264.dll.lib $REDIST_DIR/lib/x264.lib
    cp -v $BUILD_DIR/libx264.dll.lib $REDIST_DIR/lib/libx264.lib
else
    cp -v $BUILD_DIR/libx264.dll.a $REDIST_DIR/lib/x264.a
    cp -v $BUILD_DIR/libx264.dll.a $REDIST_DIR/lib/libx264.a
fi

