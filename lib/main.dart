import 'package:flutter/material.dart';

import 'src/demo/whatamesh_demo_page.dart';

void main() {
  runApp(const WhatameshApp());
}

class WhatameshApp extends StatelessWidget {
  const WhatameshApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4C57F6),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Whatamesh Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFF090B14),
        useMaterial3: true,
      ),
      home: const WhatameshDemoPage(),
    );
  }
}
