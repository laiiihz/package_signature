# package_signature

a easy way to get android package signature on flutter app.

## USAGE

* get a platform signature object.

```dart
Signature signature = await PackageSignature.signature;
```

* get sha1 or sha256 signature.

```dart
    String  _signatureSha256 = signature.sha256;
    String  _signatureSha1 = signature.sha1;
```

## CONTRIBUTORS

[@laiiihz](https://github.com/laiiihz)

[@ibrahim-mubarak](https://github.com/ibrahim-mubarak)
