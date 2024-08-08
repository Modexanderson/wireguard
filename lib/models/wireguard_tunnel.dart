class WireGuardTunnel {
  final String name;
  final String privateKey;
  final String publicKey;
  final String address;
  final String endpoint;
  final int listenPort;
  final String dnsServer;
  final int mtu;
  String status;

  WireGuardTunnel({
    required this.name,
    required this.privateKey,
    required this.publicKey,
    required this.address,
    required this.endpoint,
    required this.listenPort,
    required this.dnsServer,
    required this.mtu,
    this.status = 'Inactive',
  });

  factory WireGuardTunnel.fromJson(Map<String, dynamic> json) {
    return WireGuardTunnel(
      name: json['name'] as String,
      privateKey: json['privateKey'] as String,
      publicKey: json['publicKey'] as String,
      address: json['address'],
      endpoint: json['endpoint'] as String,
      listenPort: json['listenPort'] as int,
      dnsServer: json['dnsServer'] as String,
      mtu: json['mtu'] as int,
      status: json['status'] as String? ?? 'Inactive',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'privateKey': privateKey,
      'publicKey': publicKey,
      'address': address,
      'endpoint': endpoint,
      'listenPort': listenPort,
      'dnsServer': dnsServer,
      'mtu': mtu,
      'status': status,
    };
  }

//   '''[Interface]
// PrivateKey = 0IZmHsxiNQ54TsUs0EQ71JNsa5f70zVf1LmDvON1CXc=
// Address = 10.8.0.4/32
// DNS = 1.1.1.1

// [Peer]
// PublicKey = 6uZg6T0J1bHuEmdqPx8OmxQ2ebBJ8TnVpnCdV8jHliQ=
// PresharedKey = As6JiXcYcqwjSHxSOrmQT13uGVlBG90uXZWmtaezZVs=
// AllowedIPs = 0.0.0.0/0, ::/0
// PersistentKeepalive = 0
// Endpoint = 38.180.13.85:51820''';

  String toConfig() {
    return '''[Interface]
      PrivateKey = $privateKey
      Address = $address
      DNS = $dnsServer

      [Peer]
      PublicKey = $publicKey
      PresharedKey = As6JiXcYcqwjSHxSOrmQT13uGVlBG90uXZWmtaezZVs=
      AllowedIPs = 0.0.0.0/0, ::/0
      Endpoint = $endpoint:$listenPort
      PersistentKeepalive = 0
      ''';
  }
}
