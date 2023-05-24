# package_signature

a easy way to get android package signature on flutter app.

## USAGE

* get a platform signature object.

```dart
Signature? signature = await PackageSignature().signature;
```

* get sha1 or sha256 signature.

```dart
    String sha256base64 = signature.sha256base64;
    String sha256hex = signature.sha256hex;
    Uint8List sha256bytes = signature.sha256byte;
    String sha1base64 = signature.sha1base64;
    String sha1hex = signature.sha1hex;
    Uint8List sha1bytes = signature.sha1bytes;
```

## CONTRIBUTORS

[@laiiihz](https://github.com/laiiihz)

[@ibrahim-mubarak](https://github.com/ibrahim-mubarak)
