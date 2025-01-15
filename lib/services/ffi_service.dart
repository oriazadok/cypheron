import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Typedefs for FFI functions to define the expected function signatures

// Typedef for the native function signature in the shared library
typedef CypherFunc = Pointer<Utf8> Function(Pointer<Utf8> input, Uint8 flag, Pointer<Utf8> key);

// Typedef for the Dart function signature that will call the FFI function
typedef Cypher = Pointer<Utf8> Function(Pointer<Utf8> input, int flag, Pointer<Utf8> key);

/// Class to handle FFI (Foreign Function Interface) interactions with the shared library `libcypher.so`
class CypherFFI {
  // Field to hold the reference to the FFI cypher function
  final Cypher _cypher;

  /// Constructor that loads the shared library and initializes the `_cypher` function
  CypherFFI()
      : _cypher = DynamicLibrary.open('libcypher.so')  // Load the shared library file
            .lookup<NativeFunction<CypherFunc>>('cypher')  // Look up the 'cypher' function by name
            .asFunction<Cypher>();  // Cast it to the defined Dart function type

  /// Method to execute the FFI cypher function with provided input, key, and flag for encryption/decryption
  String runCypher(String input, String key, String flag) {
    // Convert Dart strings to C-style strings (pointers to UTF8)
    final inputPtr = input.toNativeUtf8();
    final keyPtr = key.toNativeUtf8();
    final flagPtr = flag.codeUnitAt(0);  // Convert the flag character to its ASCII value (Uint8)

    // Call the native cypher function with input, flag, and key pointers
    final resultPtr = _cypher(inputPtr, flagPtr, keyPtr);

    // Initialize the result as an empty string
    String result = '';
    if (resultPtr.address != 0) {
      // Convert result pointer to a Dart string if it's valid
      result = resultPtr.toDartString();
      calloc.free(resultPtr);  // Free the allocated memory for the result
    } else {
      result = 'Cypher failed';  // Handle any function failure
    }

    // Free allocated memory for input and key pointers
    malloc.free(inputPtr);
    malloc.free(keyPtr);

    // Return the resulting encrypted or decrypted string
    return result;
  }
}
