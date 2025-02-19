import 'package:flutter/material.dart';
import 'dart:async';

import 'package:package_signature/package_signature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _signatureSha256 = 'Unknown';
  String _signatureSha256Hex = 'Unknown';
  String _signatureSha1 = 'Unknown';
  String _signatureSha1Hex = 'Unknown';
  int _cost = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final sw = Stopwatch()..start();
    Signature? signature = await PackageSignature().signature;
    sw.stop();
    if (!mounted) return;

    setState(() {
      _cost = sw.elapsedMilliseconds;
      _signatureSha256 = signature?.sha256base64 ?? '';
      _signatureSha256Hex = signature?.sha256hex ?? '';
      _signatureSha1 = signature?.sha1base64 ?? '';
      _signatureSha1Hex = signature?.sha1hex ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("App Signature"),
          actions: [
            IconButton(
              onPressed: initPlatformState,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(label: Text("cost: $_cost ms")),
              const Chip(label: Text("SHA256")),
              Text(_signatureSha256),
              const SizedBox(height: 12),
              const Chip(label: Text("SHA256Hex")),
              Text(_signatureSha256Hex),
              const SizedBox(height: 12),
              const Chip(label: Text("SHA1")),
              Text(_signatureSha1),
              const SizedBox(height: 12),
              const Chip(label: Text("SHA1 Hex")),
              Text(_signatureSha1Hex),
            ],
          ),
        ),
      ),
    );
  }
}
