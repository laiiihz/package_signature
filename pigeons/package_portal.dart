import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/package_portal.g.dart',
  kotlinOut:
      'android/src/main/kotlin/tech/laihz/package_signature/package_portal.g.kt',
))
@HostApi()
abstract class PackagePortal {
  Uint8List? appSignature();
}
