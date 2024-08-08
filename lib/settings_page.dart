import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Image.asset('assets/images/logo.png'),
              title: const Text('WireGuard for Android v1.0.20231018'),
              subtitle: const Text('Go userspace backend 216320'),
            ),
            const ListTile(
              title: Text('Export tunnels to zip file'),
              subtitle: Text('Zip file will be saved to downloads folder'),
            ),
            const ListTile(
              title: Text('View application logs'),
              subtitle: Text('Logs may assist with debugging'),
            ),
            ExpansionTile(
              title: const Text('Advanced'),
              children: <Widget>[
                ListTile(
                  title: const Text('Allow remote control apps'),
                  subtitle: const Text(
                      'External apps may not toggle tunnels (recommended)'),
                  onTap: () {
                    // Add your onTap logic here
                  },
                ),
                ListTile(
                  title: const Text('Donate to WireGuard Project'),
                  subtitle: const Text('Every contribution helps'),
                  onTap: () {
                    // Add your onTap logic here
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
