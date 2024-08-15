import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';

// Define the path to the shared library
final DynamicLibrary myLibrary = DynamicLibrary.open('libcypher.so');

// Bindings to the C++ `cypher` function
typedef CypherFunc = Pointer<Utf8> Function(Pointer<Utf8> input, Uint8 flag, Pointer<Utf8> key);
typedef Cypher = Pointer<Utf8> Function(Pointer<Utf8> input, int flag, Pointer<Utf8> key);

// Load the `cypher` function from the shared library
final Cypher cypher = myLibrary
    .lookup<NativeFunction<CypherFunc>>('cypher')
    .asFunction<Cypher>();

// Dart wrapper function for the `cypher` function
String cypherWrapper(String input, String key, String flag) {
  final inputPtr = input.toNativeUtf8();
  final keyPtr = key.toNativeUtf8();
  final flagPtr = flag.codeUnitAt(0); // Convert the flag character to its ASCII value
  final resultPtr = cypher(inputPtr, flagPtr, keyPtr);
  
  // Convert the result to Dart string
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FFI Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String cypherResult = '';

  void _runCypher() {
    setState(() {
      // Example usage of cypherWrapper: Encrypting the string "Hello, World!" with the key "mySecretKey"
      cypherResult = cypherWrapper('Hello, World!', 'mySecretKey', 'e'); // 'e' for encrypt
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter FFI Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cypher Result:',
            ),
            Text(
              cypherResult,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runCypher,
              child: Text('Run Cypher'),
            ),
          ],
        ),
      ),
    );
  }
}
