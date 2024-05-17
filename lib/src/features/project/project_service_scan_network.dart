import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pool/pool.dart';
import 'package:network_tools/network_tools.dart';

void main() async {
  final String baseIp = "192.168.1.0";
  final String subnetMask = "255.255.255.0";
  final int maxConcurrentScans = 10;  // Maximum number of concurrent scans

  List<String> ips = generateSubnetIPs(baseIp, subnetMask);
  var pool = Pool(maxConcurrentScans);  // Create a new pool with a specified level of concurrency

  // Wait for all scans to complete
  await pool.forEach<String, void>(ips, (ip) => pool.withResource(() => scanIP(ip)));
  pool.close();
}

Future<void> scanIP(String ip) async {
  try {
    final url = Uri.http(ip, '/');
    final response = await http.get(url).timeout(Duration(seconds: 2));

    String? serverHeader = response.headers['server'];
    if (serverHeader != null && serverHeader.toLowerCase().contains('linux')) {
      String osDetails = parseOSDetails(serverHeader);
      print('Linux machine found at IP: $ip - OS Details: $osDetails');
    }
  } on SocketException {}
    // Handle network errors
  // } 
  //
  //
   catch (e) {
    // Handle other types of exceptions
    print('Error scanning IP $ip: $e');
  }
}

Future<void> scanSubnet(String subnet) async{
  final stream = HostScannerService.instance.getAllPingableDevices(subnet, firstHostId: 1, lastHostId: 50,
      progressCallback: (progress) {
    print('Progress for host discovery : $progress');
  });

  stream.listen((host) {
    //Same host can be emitted multiple times
    //Use Set<ActiveHost> instead of List<ActiveHost>
    print('Found device: $host');
  }, onDone: () {
    print('Scan completed');
  }); 
}

List<String> generateSubnetIPs(String baseIp, String subnetMask) {
  var ip = InternetAddress(baseIp);
  var mask = InternetAddress(subnetMask);
  var subnet = baseIp.substring(0,baseIp.lastIndexOf('.'));

  List<String> ips = [];
  // for (var addr in subnet.addresses()) {
  //   ips.add(addr.toString());
  // }
  return ips;
}

String parseOSDetails(String serverHeader) {
  RegExp regex = RegExp(r'(unix|linux|ubuntu|centos|debian|fedora)[/\s]?([^\s,;]*)', caseSensitive: false);
  var match = regex.firstMatch(serverHeader);
  if (match != null) {
    return '${match.group(1)} ${match.group(2)}'.trim();
  }
  return 'Unknown Linux OS';
}