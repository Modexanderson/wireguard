import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wireguard/create_tunnel_page.dart';
import 'package:wireguard/models/constants.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'models/wireguard_tunnel.dart';
import 'qr_code_scanner_page.dart';
import 'settings_page.dart';
import 'tunnel_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final wireguard = WireGuardFlutter.instance;
  List<WireGuardTunnel> _tunnels = [];
  late String interfaceName;
  late StreamSubscription<VpnStage> vpnStageSubscription;

  @override
  void initState() {
    super.initState();
    interfaceName = 'wg0';
    vpnStageSubscription = wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("VPN status changed: $event");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('VPN status changed: $event'),
        ));
      }
    });
    _loadTunnels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTunnels();
  }

  @override
  void dispose() {
    vpnStageSubscription.cancel();
    super.dispose();
  }

  void _refreshTunnels() {
    _loadTunnels();
  }

  Future<void> _loadTunnels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tunnelStrings = prefs.getStringList('tunnels');
    if (tunnelStrings != null) {
      debugPrint('Loaded tunnel strings: $tunnelStrings');
      try {
        List<Map<String, dynamic>> tunnelsJson = tunnelStrings.map((str) {
          debugPrint('Decoding JSON: $str');
          return jsonDecode(str) as Map<String, dynamic>;
        }).toList();
        setState(() {
          _tunnels = tunnelsJson
              .map((json) => WireGuardTunnel.fromJson(json))
              .toList();
        });
      } catch (e) {
        debugPrint('Error decoding JSON: $e');
      }
    }
  }

  Future<void> _initializeWireGuard() async {
    try {
      await wireguard.initialize(interfaceName: interfaceName);
      debugPrint(
          "WireGuard initialized successfully with interface: $interfaceName");
    } catch (error, stack) {
      debugPrint("Failed to initialize WireGuard: $error\n$stack");
    }
  }

//   static const String conf = '''[Interface]
// PrivateKey = 0IZmHsxiNQ54TsUs0EQ71JNsa5f70zVf1LmDvON1CXc=
// Address = 10.8.0.4/32
// DNS = 1.1.1.1

// [Peer]
// PublicKey = 6uZg6T0J1bHuEmdqPx8OmxQ2ebBJ8TnVpnCdV8jHliQ=
// PresharedKey = As6JiXcYcqwjSHxSOrmQT13uGVlBG90uXZWmtaezZVs=
// AllowedIPs = 0.0.0.0/0, ::/0
// PersistentKeepalive = 0
// Endpoint = 38.180.13.85:51820''';

  Future<void> _startVpn(WireGuardTunnel tunnel) async {
    try {
      await wireguard.startVpn(
        serverAddress: tunnel.endpoint ??
            'demo.wireguard.com:51820', // Use tunnel endpoint
        // wgQuickConfig: conf,
        wgQuickConfig: tunnel.toConfig(),
        providerBundleIdentifier: 'com.example.wireguard',
      );
      print(tunnel.toConfig());
      setState(() {
        tunnel.status = 'Active';
      });
    } catch (error, stack) {
      print(tunnel.toConfig());
      debugPrint("Failed to start VPN: $error\n$stack");
    }
  }

  Future<void> _disconnectVpn() async {
    try {
      await wireguard.stopVpn();
    } catch (e, str) {
      debugPrint('Failed to disconnect VPN: $e\n$str');
    }
  }

  Future<void> _toggleTunnelStatus(int index) async {
    final tunnel = _tunnels[index];
    final isActive = tunnel.status == 'Active';

    if (isActive) {
      await _disconnectVpn();
      setState(() {
        tunnel.status = 'Inactive';
      });
    } else {
      await _initializeWireGuard();
      await _startVpn(tunnel);
    }

    final prefs = await SharedPreferences.getInstance();
    final tunnelsJson = _tunnels.map((tunnel) => tunnel.toJson()).toList();
    List<String> tunnelsStrings =
        tunnelsJson.map((json) => jsonEncode(json)).toList();
    await prefs.setStringList('tunnels', tunnelsStrings);
  }

  Future<void> _deleteTunnel(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _tunnels.removeAt(index);
    final tunnelsJson = _tunnels.map((tunnel) => tunnel.toJson()).toList();
    List<String> tunnelsStrings =
        tunnelsJson.map((json) => jsonEncode(json)).toList();
    await prefs.setStringList('tunnels', tunnelsStrings);
    _loadTunnels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WireGuard'),
        actions: [
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
      body: _tunnels.isEmpty ? _buildEmptyState() : _buildTunnelList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: _showAddTunnelOptions,
        tooltip: 'Add Tunnel',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            'Add a tunnel using the button below',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTunnelList() {
    return ListView.builder(
      itemCount: _tunnels.length,
      itemBuilder: (context, index) {
        final tunnel = _tunnels[index];
        final isActive = tunnel.status == 'Active';
        return ListTile(
            title: Text(tunnel.name),
            subtitle: Text(tunnel.status),
            trailing: Switch(
              value: isActive,
              onChanged: (value) {
                _toggleTunnelStatus(index);
              },
            ),
            // leading: IconButton(
            //   icon: const Icon(Icons.delete),
            //   onPressed: () => _deleteTunnel(index),
            // ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TunnelDetailPage(
                    tunnel: _tunnels[index],
                    index: index, // Pass the index here
                    onToggleStatus: (index) async {
                      await _toggleTunnelStatus(
                          index); // Toggle the tunnel using index
                      setState(() {});
                    },
                    onTunnelUpdated: () {
                      setState(() {
                        _refreshTunnels();
                        // You might want to refresh the list or do something when the tunnel is updated
                      });
                    },
                  ),
                ),
              );
            });
      },
    );
  }

  void _showAddTunnelOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Import from file or archive'),
              onTap: () {
                Navigator.pop(context);
                _importFromFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan from QR code'),
              onTap: () {
                Navigator.pop(context);
                _scanFromQrCode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Create from scratch'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateTunnelPage(
                      onTunnelCreated: _refreshTunnels,
                    ),
                  ),
                );
                // Refresh the tunnel list when coming back from the CreateTunnelPage
                _refreshTunnels();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _importFromFile() async {
    // Pick the .conf file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['conf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileContent = await file.readAsString();

      // Parse the .conf file
      Map<String, String> parsedTunnel = _parseConfFile(fileContent);

      // Create a WireGuardTunnel object
      final tunnel = WireGuardTunnel(
        name: parsedTunnel['name'] ?? 'Imported Tunnel',
        privateKey: parsedTunnel['privateKey']!,
        publicKey: parsedTunnel['publicKey']!,
        address: parsedTunnel['address']!,
        endpoint: parsedTunnel['endpoint']!,
        listenPort: int.tryParse(parsedTunnel['listenPort']!) ?? 0,
        dnsServer: parsedTunnel['dnsServer']!,
        mtu: int.tryParse(parsedTunnel['mtu']!) ?? 0,
        status: 'Inactive',
      );

      // Add the tunnel to shared preferences
      final prefs = await SharedPreferences.getInstance();
      final tunnels = prefs.getStringList('tunnels') ?? [];
      tunnels.add(jsonEncode(tunnel.toJson())); // Encode to JSON string
      await prefs.setStringList('tunnels', tunnels);

      // Update the UI or do any additional tasks
      setState(() {});
    }
  }

  Map<String, String> _parseConfFile(String fileContent) {
    final Map<String, String> parsedData = {};
    final lines = fileContent.split('\n');

    for (String line in lines) {
      line = line.trim();
      if (line.startsWith('PrivateKey = ')) {
        parsedData['privateKey'] =
            line.substring('PrivateKey = '.length).trim();
      } else if (line.startsWith('Address = ')) {
        parsedData['address'] = line.substring('Address = '.length).trim();
      } else if (line.startsWith('DNS = ')) {
        parsedData['dnsServer'] = line.substring('DNS = '.length).trim();
      } else if (line.startsWith('PublicKey = ')) {
        parsedData['publicKey'] = line.substring('PublicKey = '.length).trim();
      } else if (line.startsWith('Endpoint = ')) {
        final endpointData =
            line.substring('Endpoint = '.length).trim().split(':');
        parsedData['endpoint'] = endpointData[0].trim();
        parsedData['listenPort'] =
            endpointData.length > 1 ? endpointData[1].trim() : '0';
      } else if (line.startsWith('MTU = ')) {
        parsedData['mtu'] = line.substring('MTU = '.length).trim();
      }
    }

    return parsedData;
  }

  Future<void> _scanFromQrCode() async {
    // Navigate to QR Code Scanner Screen
    final Map<String, String>? scanResult =
        await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => QrCodeScannerScreen(
          onScanResult: (data) {
            return data;
          },
        ),
      ),
    );

    if (scanResult != null) {
      // Create a WireGuardTunnel object from the scanned data
      final tunnel = WireGuardTunnel(
        name: scanResult['name'] ?? 'Scanned Tunnel',
        privateKey: scanResult['privateKey']!,
        publicKey: scanResult['publicKey']!,
        address: scanResult['address']!,
        endpoint: scanResult['endpoint']!,
        listenPort: int.tryParse(scanResult['listenPort']!) ?? 0,
        dnsServer: scanResult['dnsServer']!,
        mtu: int.tryParse(scanResult['mtu']!) ?? 0,
        status: 'Inactive',
      );

      // Add the tunnel to shared preferences
      final prefs = await SharedPreferences.getInstance();
      final tunnels = prefs.getStringList('tunnels') ?? [];
      tunnels.add(jsonEncode(tunnel.toJson()));
      await prefs.setStringList('tunnels', tunnels);

      // Update the UI or do any additional tasks
      setState(() {});
    }
  }
}
