import 'package:device_installed_apps/app_info.dart';
import 'package:device_installed_apps/device_installed_apps.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';

import 'home_page.dart';
import 'models/wireguard_tunnel.dart';
import 'settings_page.dart';

// class CreateTunnelScreen extends StatefulWidget {
//   final VoidCallback onTunnelCreated;

//   const CreateTunnelScreen({super.key, required this.onTunnelCreated});
//   @override
//   _CreateTunnelScreenState createState() => _CreateTunnelScreenState();
// }

// class _CreateTunnelScreenState extends State<CreateTunnelScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _privateKeyController = TextEditingController();
//   final _publicKeyController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _listenPortController = TextEditingController();
//   final _dnsServerController = TextEditingController();
//   final _mtuController = TextEditingController();
//   final _endpointController =
//       TextEditingController(); // New endpoint controller
//   List<String> _selectedApps = [];

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _privateKeyController.dispose();
//     _publicKeyController.dispose();
//     _addressController.dispose();
//     _listenPortController.dispose();
//     _dnsServerController.dispose();
//     _mtuController.dispose();
//     _endpointController.dispose(); // Dispose endpoint controller
//     super.dispose();
//   }

//   Future<void> _generateAndFillKeys() async {
//     try {
//       final keyPair = await _generateKeyPair();
//       final privateKey =
//           base64.encode(await keyPair.privateKey.extractPrivateKeyBytes());
//       final publicKey = base64.encode(keyPair.publicKey.bytes);

//       debugPrint("Generated Private Key: $privateKey");
//       debugPrint("Generated Public Key: $publicKey");

//       setState(() {
//         _privateKeyController.text = privateKey;
//         _publicKeyController.text = publicKey;
//       });
//     } catch (error) {
//       debugPrint("Failed to generate and fill keys: $error");
//     }
//   }

//   Future<KeyPair> _generateKeyPair() async {
//     final algorithm = X25519();
//     final keyPair = await algorithm.newKeyPair();
//     final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
//     final publicKey = await keyPair.extractPublicKey();

//     return KeyPair(
//       privateKey: SimpleKeyPairData(
//         privateKeyBytes,
//         publicKey: publicKey,
//         type: KeyPairType.x25519,
//       ),
//       publicKey: publicKey,
//     );
//   }

//   Future<void> _createFromScratch() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       // Example configuration data
//       final String conf = '''[Interface]
//         PrivateKey = ${_privateKeyController.text}
//         Address = ${_addressController.text}
//         DNS = ${_dnsServerController.text}

//         [Peer]
//         PublicKey = ${_publicKeyController.text}
//         AllowedIPs = 0.0.0.0/0, ::/0
//         Endpoint = ${_endpointController.text}:${_listenPortController.text}
//         PersistentKeepalive = 25
//         ''';

//       // Save the tunnel to shared preferences with default 'Inactive' status
//       final tunnel = WireGuardTunnel(
//         name: _nameController.text,
//         privateKey: _privateKeyController.text,
//         publicKey: _publicKeyController.text,
//         address: _addressController.text,
//         endpoint: _endpointController.text,
//         listenPort: int.tryParse(_listenPortController.text) ?? 0,
//         dnsServer: _dnsServerController.text,
//         mtu: int.tryParse(_mtuController.text) ?? 0,
//         status: 'Inactive', // Set default status to 'Inactive'
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final tunnels = prefs.getStringList('tunnels') ?? [];

//       // Convert the tunnel object to JSON and add it to the list
//       tunnels.add(jsonEncode(tunnel.toJson()));
//       await prefs.setStringList('tunnels', tunnels);

//       // Call the callback to refresh tunnels
//       widget.onTunnelCreated();

//       // Navigate back to the home page
//       Navigator.pop(context);
//     }
//   }

//   Future<void> _showAllApplicationsDialog() async {
//     var permissions = [
//       'android.permission.NFC',
//       'android.permission.ACCESS_FINE_LOCATION'
//     ];
//     List<AppInfo> apps = await DeviceInstalledApps.getApps(
//         includeSystemApps: true,
//         permissions: permissions,
//         bundleIdPrefix: 'com.hofinity',
//         shouldHasAllPermissions: false);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Select Apps'),
//         content: Container(
//           width: double.maxFinite,
//           height: 400,
//           child: ListView.builder(
//             itemCount: apps.length,
//             itemBuilder: (context, index) {
//               final app = apps[index];
//               return CheckboxListTile(
//                 title: Text(app.name!),
//                 value: _selectedApps.contains(app.bundleId),
//                 onChanged: (bool? value) {
//                   setState(() {
//                     if (value == true) {
//                       _selectedApps.add(app.bundleId!);
//                     } else {
//                       _selectedApps.remove(app.bundleId);
//                     }
//                   });
//                 },
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     // _generateAndFillKeys();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create VPN Tunnel'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _createFromScratch,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Card(
//             child: ListView(
//               children: [
//                 const Text('Interface'),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: 'Name'),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter a name' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _privateKeyController,
//                   decoration: InputDecoration(
//                     labelText: 'Private Key',
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.refresh),
//                       onPressed: _generateAndFillKeys,
//                     ),
//                   ),
//                   obscureText: true, // Hide the private key with dots
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter a private key' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _publicKeyController,
//                   decoration: const InputDecoration(
//                     labelText: 'Public Key',
//                     hintText: '(Generated)',
//                   ),
//                   // readOnly: true, // Public key should be read-only
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: _endpointController,
//                   decoration: const InputDecoration(
//                       labelText: 'Endpoint'), // New endpoint field
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter an endpoint' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _addressController,
//                         decoration: const InputDecoration(labelText: 'Address'),
//                         validator: (value) =>
//                             value!.isEmpty ? 'Please enter address' : null,
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _listenPortController,
//                         decoration:
//                             const InputDecoration(labelText: 'Listen Port'),
//                         validator: (value) => value!.isEmpty
//                             ? 'Please enter a listen port'
//                             : null,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _dnsServerController,
//                         decoration:
//                             const InputDecoration(labelText: 'DNS Server'),
//                         validator: (value) =>
//                             value!.isEmpty ? 'Please enter a DNS server' : null,
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _mtuController,
//                         decoration: const InputDecoration(labelText: 'MTU'),
//                         validator: (value) =>
//                             value!.isEmpty ? 'Please enter an MTU' : null,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: _showAllApplicationsDialog,
//                   child: const Text('All Applications'),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text('Add peer'),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class KeyPair {
//   final SimpleKeyPairData privateKey;
//   final SimplePublicKey publicKey;

//   KeyPair({
//     required this.privateKey,
//     required this.publicKey,
//   });
// }

class CreateTunnelPage extends StatefulWidget {
  final VoidCallback onTunnelCreated;
  final WireGuardTunnel? tunnel; // Add this optional parameter

  const CreateTunnelPage({
    super.key,
    required this.onTunnelCreated,
    this.tunnel,
  });

  @override
  _CreateTunnelPageState createState() => _CreateTunnelPageState();
}

class _CreateTunnelPageState extends State<CreateTunnelPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _addressController = TextEditingController();
  final _listenPortController = TextEditingController();
  final _dnsServerController = TextEditingController();
  final _mtuController = TextEditingController();
  final _endpointController = TextEditingController();
  List<String> _selectedApps = [];

  @override
  void initState() {
    super.initState();
    if (widget.tunnel != null) {
      _nameController.text = widget.tunnel!.name;
      _privateKeyController.text = widget.tunnel!.privateKey;
      _publicKeyController.text = widget.tunnel!.publicKey;
      _addressController.text = widget.tunnel!.address;
      _listenPortController.text = widget.tunnel!.listenPort.toString();
      _dnsServerController.text = widget.tunnel!.dnsServer;
      _mtuController.text = widget.tunnel!.mtu.toString();
      _endpointController.text = widget.tunnel!.endpoint;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _privateKeyController.dispose();
    _publicKeyController.dispose();
    _addressController.dispose();
    _listenPortController.dispose();
    _dnsServerController.dispose();
    _mtuController.dispose();
    _endpointController.dispose();
    super.dispose();
  }

  Future<void> _generateAndFillKeys() async {
    try {
      final keyPair = await _generateKeyPair();
      final privateKey =
          base64.encode(await keyPair.privateKey.extractPrivateKeyBytes());
      final publicKey = base64.encode(keyPair.publicKey.bytes);

      debugPrint("Generated Private Key: $privateKey");
      debugPrint("Generated Public Key: $publicKey");

      setState(() {
        _privateKeyController.text = privateKey;
        _publicKeyController.text = publicKey;
      });
    } catch (error) {
      debugPrint("Failed to generate and fill keys: $error");
    }
  }

  Future<KeyPair> _generateKeyPair() async {
    final algorithm = X25519();
    final keyPair = await algorithm.newKeyPair();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();

    return KeyPair(
      privateKey: SimpleKeyPairData(
        privateKeyBytes,
        publicKey: publicKey,
        type: KeyPairType.x25519,
      ),
      publicKey: publicKey,
    );
  }

  Future<void> _createOrUpdateTunnel() async {
    if (_formKey.currentState?.validate() ?? false) {
      final tunnel = WireGuardTunnel(
        name: _nameController.text,
        privateKey: _privateKeyController.text,
        publicKey: _publicKeyController.text,
        address: _addressController.text,
        endpoint: _endpointController.text,
        listenPort: int.tryParse(_listenPortController.text) ?? 0,
        dnsServer: _dnsServerController.text,
        mtu: int.tryParse(_mtuController.text) ?? 0,
        status: widget.tunnel?.status ?? 'Inactive',
      );

      final prefs = await SharedPreferences.getInstance();
      final tunnels = prefs.getStringList('tunnels') ?? [];

      print('Existing tunnels: $tunnels'); // Debug print

      if (widget.tunnel != null) {
        // Update existing tunnel
        final int index = tunnels
            .indexWhere((t) => jsonDecode(t)['name'] == widget.tunnel!.name);
        if (index != -1) {
          tunnels[index] = jsonEncode(tunnel.toJson());
          print(
              'Updated tunnel at index $index: ${tunnels[index]}'); // Debug print
        }
      } else {
        // Add new tunnel
        tunnels.add(jsonEncode(tunnel.toJson()));
        print('Added new tunnel: ${tunnels.last}'); // Debug print
      }

      await prefs.setStringList('tunnels', tunnels);

      widget.onTunnelCreated();

      // Navigate back to the home page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _showAllApplicationsDialog() async {
    var permissions = [
      'android.permission.NFC',
      'android.permission.ACCESS_FINE_LOCATION'
    ];
    List<AppInfo> apps = await DeviceInstalledApps.getApps(
        includeSystemApps: true,
        permissions: permissions,
        bundleIdPrefix: 'com.hofinity',
        shouldHasAllPermissions: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Apps'),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return CheckboxListTile(
                title: Text(app.name!),
                value: _selectedApps.contains(app.bundleId),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedApps.add(app.bundleId!);
                    } else {
                      _selectedApps.remove(app.bundleId);
                    }
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.tunnel != null ? 'Edit VPN Tunnel' : 'Create VPN Tunnel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _createOrUpdateTunnel,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 8,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text('Interface'),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a name' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _privateKeyController,
                        decoration: InputDecoration(
                          labelText: 'Private Key',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _generateAndFillKeys,
                          ),
                        ),
                        obscureText: true, // Hide the private key with dots
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a private key'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _publicKeyController,
                        decoration: const InputDecoration(
                          labelText: 'Public Key',
                          hintText: '(Generated)',
                        ),
                        // readOnly: true, // Public key should be read-only
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _endpointController,
                        decoration: const InputDecoration(
                            labelText: 'Endpoint'), // New endpoint field
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter an endpoint' : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _addressController,
                              decoration:
                                  const InputDecoration(labelText: 'Address'),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter address'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _listenPortController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Listen Port'),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter a listen port'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dnsServerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'DNS Server'),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter a DNS server'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _mtuController,
                              decoration:
                                  const InputDecoration(labelText: 'MTU'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter an MTU' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: _showAllApplicationsDialog,
                        child: const Text('All Applications'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Add peer'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class KeyPair {
  final SimpleKeyPairData privateKey;
  final SimplePublicKey publicKey;

  KeyPair({
    required this.privateKey,
    required this.publicKey,
  });
}
