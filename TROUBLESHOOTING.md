Troubleshooting
===============

This document covers some common issues with IKOS, and how to solve them.

Contact
-------

ikos@lists.nasa.gov

Installation issues
-------------------

### "Could NOT find LLVM" while running cmake

CMake could not find LLVM.

First, install LLVM. This can usually be done with your package manager.

If this message still shows up, it means cmake cannot find the `llvm-config` command.

You can either add the LLVM binary directory in your PATH, or give cmake the full path to llvm-config, using `-DLLVM_CONFIG_EXECUTABLE=/path/to/llvm-config`

For instance, if you installed LLVM using Homebrew on Mac OS X, you can add LLVM in your path using:

```
$ PATH="$(brew --prefix)/opt/llvm@7/bin:$PATH"
```

### "Could NOT find Clang" while running cmake

CMake could not find Clang.

First, install Clang. This can usually be done with your package manager.

If this message still shows up, it means cmake cannot find the `clang` command.

You can either add the clang binary directory in your PATH, or give cmake the full path to clang, using `-DCLANG_EXECUTABLE=/path/to/clang`

### "Could not find ikos python module" while running ikos

The ikos command could not import the ikos python module.

The module should be under `/path/to/ikos-install/lib/python*/site-packages`

If the ikos python module is in another directory, make sure it is in your PYTHONPATH:

```
export PYTHONPATH=/path/to/ikos-python-module
```

Analysis issues
---------------

### Exited with signal SIGKILL

IKOS probably ran out of memory.

We are currently working on this issue.

As a short-term solution, you could run IKOS on a machine with more memory.

Known issues
------------

### Source Code Fortification

Source code fortification aims at making your source code more robust. It replaces regular `memset()`, `memcpy()` and `memmove()` calls to `__memset_chk()`, `__memcpy_chk()` and `__memmove_chk()`. According to Linux Standard Base Core Specification 4.1, the interfaces `__memset_chk()`, `__memcpy_chk()` and `__memmove_chk()` shall function in the same way as the interface `memset()`, `memcpy()` and `memmove()`, respectively, except that `__memset_chk()`, `__memcpy_chk()` and `__memmove_chk()` shall check for buffer overflow before computing a result. If an overflow is anticipated, the function shall abort and the program calling it shall exit.

The Buffer Overflow Analysis (BOA) in IKOS handles `__memset_chk()`, `__memcpy_chk()` and `__memmove_chk()` as unknown library functions, and won't report any warning. Consider using `-D_FORTIFY_SOURCE=0` when you compile your source code to LLVM bitcode manually.
