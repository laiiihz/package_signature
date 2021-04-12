import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/services.dart';

/// ## PackageSignature
///
/// get android package signature.
///
/// *only working on `Android Devices`.*
class PackageSignature {
  static const MethodChannel _channel =
      const MethodChannel('package_signature');

  /// ## get Signature
  static Future<Signature> get signature async {
    Uint8List chars = await _channel.invokeMethod('getSignature');
    return Signature(chars);
  }

  /// ## get sha1
  ///
  /// converts input and return a sha1 hash string.
  static String sha1(Uint8List chars) {
    crypto.Digest shaChars = crypto.sha1.convert(chars);
    return Base64Encoder().convert(shaChars.bytes);
  }

  /// ## get sha256
  ///
  /// converts input and return a sha256 hash string.
  static String sha256(Uint8List chars) {
    crypto.Digest sha256Chars = crypto.sha256.convert(chars);
    return Base64Encoder().convert(sha256Chars.bytes);
  }
}

class Signature {
  Uint8List _chars;
  Signature(this._chars);

  /// signature Uint8List
  Uint8List get chars => _chars;

  /// signature sha1
  String get sha1 => PackageSignature.sha1(chars);

  /// signature sha256
  String get sha256 => PackageSignature.sha256(chars);
}
