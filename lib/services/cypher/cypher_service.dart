import 'package:cypheron/services/ffi/cypher_ffi.dart';

class CypherService {
  final CypherFFI _cypherFFI = CypherFFI();

  String encrypt(String input, String key) {
    print("enc: $input");
    return _cypherFFI.runCypher(input, key, 'e');
  }

  String decrypt(String input, String key) {
    print("dec: $input");
    return _cypherFFI.runCypher(input, key, 'd');
  }

}
