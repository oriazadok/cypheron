import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Typedefs for FFI functions
typedef CypherFunc = Pointer<Utf8> Function(Pointer<Utf8> input, Uint8 flag, Pointer<Utf8> key);
typedef Cypher = Pointer<Utf8> Function(Pointer<Utf8> input, int flag, Pointer<Utf8> key);

class CypherFFI {
  // final DynamicLibrary _myLibrary;
  final Cypher _cypher;

  CypherFFI()
      :  _cypher = DynamicLibrary.open('libcypher.so')
            .lookup<NativeFunction<CypherFunc>>('cypher')
            .asFunction<Cypher>();

  String runCypher(String input, String key, String flag) {
    final inputPtr = input.toNativeUtf8();
    final keyPtr = key.toNativeUtf8();
    final flagPtr = flag.codeUnitAt(0); // Convert the flag character to its ASCII value
    final resultPtr = _cypher(inputPtr, flagPtr, keyPtr);

    String result = '';
    if (resultPtr.address != 0) {
      result = resultPtr.toDartString();
      calloc.free(resultPtr);
    } else {
      result = 'Error in cypher function';
    }

    malloc.free(inputPtr);
    malloc.free(keyPtr);

    return result;
  }
}
