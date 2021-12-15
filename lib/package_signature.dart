import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
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
  /// converts input and return a sha1 hash string.(base64 format)
  static String sha1(Uint8List chars) {
    crypto.Digest shaChars = crypto.sha1.convert(chars);
    return Base64Encoder().convert(shaChars.bytes);
  }

  /// ## get sha1
  ///
  /// converts input and return a sha1 string.(hex format)
  static String sha1Hex(
    Uint8List chars, {
    bool rawString = false,
    bool upperCase = true,
  }) {
    //TODO migrate to single method
    crypto.Digest shaChars = crypto.sha1.convert(chars);
    final bytes = shaChars.bytes;
    var data = hex.encode(bytes);
    if (upperCase) {
      data = data.toUpperCase();
    }
    if (rawString) return data;
    // result with colon
    List<String> hexList = [];
    for (var i = 0; i < data.length; i += 2) {
      hexList.add('${data[i]}${data[i + 1]}');
    }
    return hexList.join(':');
  }

  /// ## get sha256
  ///
  /// converts input and return a sha256 hash string.(base64 format)
  static String sha256(Uint8List chars) {
    crypto.Digest sha256Chars = crypto.sha256.convert(chars);
    return Base64Encoder().convert(sha256Chars.bytes);
  }

  static String sha256Hex(
    Uint8List chars, {
    bool rawString = false,
    bool upperCase = true,
  }) {
    //TODO migrate to single method
    crypto.Digest sha256Chars = crypto.sha256.convert(chars);
    final bytes = sha256Chars.bytes;
    var data = hex.encode(bytes);
    if (upperCase) {
      data = data.toUpperCase();
    }
    if (rawString) return data;
    // result with colon
    List<String> hexList = [];
    for (var i = 0; i < data.length; i += 2) {
      hexList.add('${data[i]}${data[i + 1]}');
    }
    return hexList.join(':');
  }
}

class Signature {
  Uint8List _chars;
  Signature(this._chars);

  /// signature Uint8List
  Uint8List get chars => _chars;

  /// signature sha1 hash(base64 format)
  String get sha1 => PackageSignature.sha1(chars);

  /// signature sha1(hex format)
  String get sha1Hex => PackageSignature.sha1Hex(chars);

  /// signature sha256 hash(base64 format)
  String get sha256 => PackageSignature.sha256(chars);

  /// signature sha256 hash(hex format)
  String get sha256Hex => PackageSignature.sha256Hex(chars);
}
