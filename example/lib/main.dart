import 'package:flutter/material.dart';
import 'package:wear_os_rotary_plugin/wear_os_rotary_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wear OS Rotary Plugin Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wear OS Rotary Plugin'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Basic Example'),
            subtitle: const Text('Simple scrollable list with rotary input'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () async {
              await Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const BasicExampleScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Customized Example'),
            subtitle: const Text('Custom scrollbar appearance and behavior'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () async {
              await Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const CustomizedExampleScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('No Auto-Hide Example'),
            subtitle: const Text('Scrollbar always visible'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () async {
              await Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const NoAutoHideExampleScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BasicExampleScreen extends StatelessWidget {
  const BasicExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Example'),
      ),
      body: WearOsScrollbar(
        builder: (
          BuildContext context,
          RotaryScrollController rotaryScrollController,
        ) =>
            ListView.builder(
          controller: rotaryScrollController,
          padding: const EdgeInsets.all(16),
          itemCount: 50,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('$index'),
                ),
                title: Text('Item #$index'),
                subtitle: Text('This is item number $index'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomizedExampleScreen extends StatelessWidget {
  const CustomizedExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customized Example'),
      ),
      body: WearOsScrollbar(
        autoHideDuration: const Duration(seconds: 2),
        padding: 12,
        width: 3,
        speed: 60,
        opacityAnimationCurve: Curves.easeOut,
        opacityAnimationDuration: const Duration(milliseconds: 300),
        builder: (
          BuildContext context,
          RotaryScrollController rotaryScrollController,
        ) =>
            ListView.builder(
          controller: rotaryScrollController,
          padding: const EdgeInsets.all(16),
          itemCount: 100,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(
                Icons.star,
                color: Colors.amber.shade700,
              ),
              title: Text('Custom Item $index'),
              subtitle: Text('Subtitle for item $index'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      ),
    );
  }
}

class NoAutoHideExampleScreen extends StatelessWidget {
  const NoAutoHideExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Auto-Hide Example'),
      ),
      body: WearOsScrollbar(
        autoHide: false,
        builder: (
          BuildContext context,
          RotaryScrollController rotaryScrollController,
        ) =>
            ListView.builder(
          controller: rotaryScrollController,
          padding: const EdgeInsets.all(16),
          itemCount: 30,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.shade200,
                ),
              ),
              child: Text(
                'Item $index - Scrollbar always visible',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
