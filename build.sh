#!/bin/bash
#set -x

ROOT_DIR=$PWD
TOOLS_DIR=$ROOT_DIR/../dev_tools

. "${TOOLS_DIR}/toolset_$1$2"

BUILD_DIR=$ROOT_DIR/build/$FOLDER_SUFFIX
REDIST_DIR=$ROOT_DIR/../x264/$FOLDER_SUFFIX
SOURCE_DIR=$ROOT_DIR/x264

rm -fR $BUILD_DIR
rm -fR $REDIST_DIR
mkdir -p $BUILD_DIR
mkdir -p $REDIST_DIR

cd $BUILD_DIR
${ROOT_DIR}/x264/configure --enable-shared --host=$TOOLSET
make -j8
cd $ROOT_DIR


if [ $1 = msvc ]; then
   . "${TOOLS_DIR}/make_def_and_lib_from_dll.sh"
   make_def_and_lib_from_dll libx264-155.dll libx264.lib
fi

cp $BUILD_DIR/x264.pc     $REDIST_DIR

cp $SOURCE_DIR/x264.h          $REDIST_DIR
cp $BUILD_DIR/x264_config.h    $REDIST_DIR
cp $BUILD_DIR/*.dll            $REDIST_DIR

if [ "$1" == "msvc" ]
then
    cp $BUILD_DIR/libx264.dll.lib $REDIST_DIR/x264.lib
    cp $BUILD_DIR/libx264.dll.lib $REDIST_DIR/libx264.lib
else
    cp $BUILD_DIR/libx264.dll.a $REDIST_DIR/x264.a
    cp $BUILD_DIR/libx264.dll.a $REDIST_DIR/libx264.a
fi

