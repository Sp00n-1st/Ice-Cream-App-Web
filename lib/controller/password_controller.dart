import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as enc;

class PasswordController extends GetxController {
  encryptPass(String password) {
    final key = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  decryptedPass(String passwordEncrypt) {
    final key = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final decrypted =
        encrypter.decrypt(enc.Encrypted.fromBase64(passwordEncrypt), iv: iv);
    return decrypted;
  }
}
