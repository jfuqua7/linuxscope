import 'package:dartssh2/dartssh2.dart';

class LinuxSystemService{

  static Future<void> GetHostInstalledPackages(String ipAddress, String userName, String password) async {
  int port=22;
  try {
    // Establish an SSH client connection
    var client = await SSHClient(await SSHSocket.connect(ipAddress, port),
      username: userName,
      onPasswordRequest: () => password, // Or use a key file with onIdentityRequest
    );

    print('Connected to SSH');

    // Execute command to list installed packages on Debian/Ubuntu systems
    var result = await client.run('dpkg --get-selections');
    

    client.close();
    print('Disconnected');
  } catch (e) {
    print('Error: $e');
  }
}
}