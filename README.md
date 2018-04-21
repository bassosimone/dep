# Measurement Kit dependencies

## Windows

In the x64 command prompt, enter into the package directory
and then type the following command:

```
cmake.exe -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=MK_DIST/windows/amd64 .
```

## msys

From inside the MSYS x64 command prompt, enter into the package
directory and then type the following command:

```
cmake -G"MSYS Makefiles" -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=MK_DIST/msys/amd64
```
