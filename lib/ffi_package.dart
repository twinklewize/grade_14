import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'duktape_bindings_generated.dart';

const String _libName = 'ffi_package';

/// The dynamic library in which the symbols for [FfiPackageBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FfiPackageBindings _bindings = FfiPackageBindings(_dylib);

class Duktape {
  late Pointer<duk_context> _context;

  Duktape() {
    _context = _bindings.duk_create_heap(nullptr, nullptr, nullptr, nullptr, nullptr);
  }

  void evalString(String jsCode) {
    final utf8 = jsCode.toNativeUtf8();
    _bindings.duk_eval_raw(
      _context,
      utf8.cast<Char>(),
      0,
      0 | DUK_COMPILE_EVAL | DUK_COMPILE_SAFE | DUK_COMPILE_NOFILENAME | DUK_COMPILE_NOSOURCE | DUK_COMPILE_STRLEN,
    );
  }

  int getInt(int index) {
    return _bindings.duk_get_int(_context, index);
  }

  void dispose() {
    _bindings.duk_destroy_heap(_context);
    _context = nullptr;
  }
}
