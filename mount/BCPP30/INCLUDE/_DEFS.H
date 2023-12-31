/*  _defs.h

    Common definitions for pointer size and calling conventions.

    Copyright (c) 1991 by Borland International
    All Rights Reserved.
*/

#if !defined( __DEFS_H )
#define __DEFS_H

#if __STDC__
#  define _Cdecl
#else
#  ifdef __OS2__
#    define _Cdecl  _stdcall
#  else
#    define _Cdecl  cdecl
#  endif
#endif

#ifndef __PAS__
#  define _CType _Cdecl
#else
#  define _CType pascal
#endif

#if defined(__OS2__)
#  define _FAR
#  define _FARFUNC
#  define _CLASSTYPE
#else
#  if defined(__STDC__)
#    define _FAR
#    define _FARFUNC
#    define _CLASSTYPE
#  else
#    if defined(_BUILDRTLDLL)
#      define _FARFUNC _export
#    elif defined(_RTLDLL)
#      define _FARFUNC far
#    else
#      define _FARFUNC
#    endif
#    if defined(__DLL__)
#      if defined(_RTLDLL) || defined(_CLASSDLL)
#        define _CLASSTYPE _export
#      else
#        define _CLASSTYPE far
#      endif
#      define _FAR far
#    elif defined(_RTLDLL) || defined(_CLASSDLL)
#      define _CLASSTYPE huge
#      define _FAR far
#    else
#      define _FAR
#      if   defined(__TINY__) || defined(__SMALL__) || defined(__MEDIUM__)
#        define _CLASSTYPE  near
#      elif defined(__COMPACT__) || defined(__LARGE__)
#        define _CLASSTYPE  far
#      else
#        define _CLASSTYPE  huge
#      endif
#    endif
#  endif    /* __STDC__ */
#endif      /* __OS2__  */

#if defined(_BUILDRTLDLL)
#  define _FARCALL _export
#else
#  define _FARCALL far
#endif

#if defined( __cplusplus )
#  define _PTRDEF(name) typedef name _FAR * P##name;
#  define _REFDEF(name) typedef name _FAR & R##name;
#  define _REFPTRDEF(name) typedef name _FAR * _FAR & RP##name;
#  define _PTRCONSTDEF(name) typedef const name _FAR * PC##name;
#  define _REFCONSTDEF(name) typedef const name _FAR & RC##name;
#  define _CLASSDEF(name) class _CLASSTYPE name; \
        _PTRDEF(name) \
    _REFDEF(name) \
    _REFPTRDEF(name) \
    _PTRCONSTDEF(name) \
    _REFCONSTDEF(name)
#endif

#endif  /* __DEFS_H */
