import 'dart:async';
import 'dart:convert' as cvt;
import 'dart:io';
import 'package:crypto/crypto.dart' as crypto;
import 'package:convert/convert.dart' as convert;
import 'package:flutter/foundation.dart';

import 'package:package_signature/src/package_portal.g.dart';

/// PackageSignature
class PackageSignature {
  PackageSignature._();

  /// get a [PackageSignature] instance
  factory PackageSignature() => instance;

  static PackageSignature? _instance;

  /// get a [PackageSignature] instance
  static PackageSignature get instance => _instance ??= PackageSignature._();

  final _api = PackagePortal();

  /// get signature [Signature]
  Future<Signature?> get signature async {
    final bytes = await _api.appSignature();
    if (bytes == null) return null;
    return Signature(bytes);
  }

  // check android Sha1Hex valid
  FutureOr<bool> check({required String androidSha1Hex}) async {
    if (kIsWeb) return true;
    if (!Platform.isAndroid) return true;
    final sign = await signature;
    if (sign == null) return false;
    return sign.sha1hex == androidSha1Hex;
  }
}

/// app signature result
class Signature {
  /// app signature result
  const Signature(this._data);
  final Uint8List _data;

  /// get bytes
  Uint8List get bytes => _data;

  /// sha1 bytes
  Uint8List get sha1bytes =>
      Uint8List.fromList(crypto.sha1.convert(bytes).bytes);

  /// sha1 result using base64
  String get sha1base64 => cvt.base64.encode(sha1bytes);

  /// sha1 hex result
  String get sha1hex => _toHexWithColon(sha1bytes);

  /// sha1 bytes
  Uint8List get sha256bytes =>
      Uint8List.fromList(crypto.sha256.convert(bytes).bytes);

  /// sha1 result using base64
  String get sha256base64 => cvt.base64.encode(sha256bytes);

  /// sha1 hex result
  String get sha256hex => _toHexWithColon(sha256bytes);

  /// convert a bytes to hex colon
  String _toHexWithColon(Uint8List d) {
    String data = convert.hex.encode(d);
    List<String> hexList = [];
    for (var i = 0; i < data.length; i += 2) {
      hexList.add('${data[i]}${data[i + 1]}');
    }
    return hexList.join(':');
  }
}
