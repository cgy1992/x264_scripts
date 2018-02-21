## x264 build scripts

## reference links:

#### x264 page:
http://www.videolan.org/developers/x264.html
#### common scripts 
https://github.com/amfdev/common_scripts

## Instructions:

### prepare your environment
https://github.com/amfdev/common_scripts/blob/master/README.md

### dependencies download

#### common_scripts must be downloaded to the directory `common_scripts` on the same level:
```
https://github.com/amfdev/common_scripts.git
```

#### x264 sources must be downloaded to child `x264` folder
```
http://git.videolan.org/git/x264.git
```

### execute build scripts
```
./build/
      build.sh
      build_all.bat
      build_all_gcc.bat
      build_all_msvs.bat
```

### results
```
../x264/
    mingw_gcc_x64
    mingw_gcc_x86
    mingw_msvc_x64
    mingw_msvc_x86
```
