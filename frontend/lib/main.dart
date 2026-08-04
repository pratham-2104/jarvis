import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modules/workspace/workspace_provider.dart';
import 'modules/workspace/workspace_list_screen.dart';
import 'modules/chat/chat_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkspaceProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const JarvisApp(),
    ),
  );
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis Frontend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const WorkspaceListScreen(),
    );
  }
}
