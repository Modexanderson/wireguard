import 'package:flutter/material.dart';

import 'create_tunnel_page.dart';
import 'models/wireguard_tunnel.dart';

class TunnelDetailPage extends StatefulWidget {
  final WireGuardTunnel tunnel;
  final int index; // Add index here
  final Function(int) onToggleStatus; // Callback expecting int
  final VoidCallback onTunnelUpdated;

  const TunnelDetailPage({
    super.key,
    required this.tunnel,
    required this.index, // Receive index
    required this.onToggleStatus,
    required this.onTunnelUpdated,
  });

  @override
  _TunnelDetailPageState createState() => _TunnelDetailPageState();
}

class _TunnelDetailPageState extends State<TunnelDetailPage> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.tunnel.status == 'Active';
  }

  void _toggleSwitch(bool value) {
    setState(() {
      isActive = value;
    });
    widget.onToggleStatus(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.tunnel.name} Details'),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTunnelPage(
                      onTunnelCreated: () {
                        widget.onTunnelUpdated();
                      },
                      tunnel: widget.tunnel,
                    ),
                  ),
                );
              }),
        ],
      ),
      body: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Interface',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Switch(
                    value: isActive,
                    onChanged: _toggleSwitch,
                  ),
                ],
              ),
              _buildDetailRow('Name', widget.tunnel.name),
              _buildDetailRow('Private Key', widget.tunnel.privateKey,
                  obscureText: true),
              _buildDetailRow('Public Key', widget.tunnel.publicKey),
              _buildDetailRow('Address', widget.tunnel.address),
              _buildDetailRow(
                  'Listen Port', widget.tunnel.listenPort.toString()),
              _buildDetailRow('DNS Server', widget.tunnel.dnsServer),
              _buildDetailRow('MTU', widget.tunnel.mtu.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              obscureText ? '•' * value.length : value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'create_tunnel_page.dart';
// import 'models/wireguard_tunnel.dart';

// class TunnelDetailPage extends StatefulWidget {
//   final WireGuardTunnel tunnel;
//   final int index;
//   final Future<void> Function(int index) onToggleStatus;
//   final VoidCallback onTunnelUpdated;

//   const TunnelDetailPage({
//     Key? key,
//     required this.tunnel,
//     required this.index,
//     required this.onToggleStatus,
//     required this.onTunnelUpdated,
//   }) : super(key: key);

//   @override
//   _TunnelDetailPageState createState() => _TunnelDetailPageState();
// }

// class _TunnelDetailPageState extends State<TunnelDetailPage> {
//   late WireGuardTunnel _tunnel;

//   @override
//   void initState() {
//     super.initState();
//     _tunnel = widget.tunnel;
//   }

//   void _handleResult() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateTunnelPage(
//           onTunnelCreated: () {
//             _refreshTunnel(); // Refresh the tunnel data
//             widget.onTunnelUpdated();
//           },
//           tunnel: _tunnel,
//         ),
//       ),
//     );
//     if (result == true) {
//       _refreshTunnel(); // Refresh if the result indicates an update
//     }
//   }

//   void _refreshTunnel() async {
//     final prefs = await SharedPreferences.getInstance();
//     final tunnels = prefs.getStringList('tunnels') ?? [];
//     print('Loaded tunnels: $tunnels'); // Debug print
//     final index =
//         tunnels.indexWhere((t) => jsonDecode(t)['name'] == widget.tunnel.name);
//     if (index != -1) {
//       setState(() {
//         _tunnel = WireGuardTunnel.fromJson(jsonDecode(tunnels[index]));
//       });
//       print('Refreshed tunnel: ${_tunnel.toJson()}'); // Debug print
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_tunnel.name),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: _handleResult,
//           ),
//         ],
//       ),
//       body: Card(
//         elevation: 8,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Interface',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   Switch(
//                     value: _tunnel.status == 'Active',
//                     onChanged: (value) async {
//                       await widget.onToggleStatus(widget.index);
//                       _refreshTunnel(); // Refresh the tunnel data
//                     },
//                   ),
//                 ],
//               ),
//               _buildDetailRow('Name', _tunnel.name),
//               _buildDetailRow('Private Key', _tunnel.privateKey,
//                   obscureText: true),
//               _buildDetailRow('Public Key', _tunnel.publicKey),
//               _buildDetailRow('Address', _tunnel.address),
//               _buildDetailRow('Listen Port', _tunnel.listenPort.toString()),
//               _buildDetailRow('DNS Server', _tunnel.dnsServer),
//               _buildDetailRow('MTU', _tunnel.mtu.toString()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildDetailRow(String label, String value, {bool obscureText = false}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '$label: ',
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         Expanded(
//           child: Text(
//             obscureText ? '•' * value.length : value,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     ),
//   );
// }
