import 'dart:async';
import 'dart:io';

import 'logger.dart';

enum NetworkStatus { connected, disconnected, unknown }

class NetworkUtils {
  static NetworkStatus _currentStatus = NetworkStatus.unknown;
  static final StreamController<NetworkStatus> _statusController = StreamController<NetworkStatus>.broadcast();

  static Stream<NetworkStatus> get statusStream => _statusController.stream;
  static NetworkStatus get currentStatus => _currentStatus;

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      final hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      _updateStatus(hasConnection ? NetworkStatus.connected : NetworkStatus.disconnected);
      return hasConnection;
    } on SocketException catch (e) {
      AppLogger.warning('No internet connection: ${e.message}', 'NetworkUtils');
      _updateStatus(NetworkStatus.disconnected);
      return false;
    } catch (e) {
      AppLogger.error('Error checking internet connection: $e', 'NetworkUtils');
      _updateStatus(NetworkStatus.unknown);
      return false;
    }
  }

  static Future<bool> isReachable(String host, {int port = 80}) async {
    try {
      final socket = await Socket.connect(host, port, timeout: const Duration(seconds: 5));
      await socket.close();
      return true;
    } catch (e) {
      AppLogger.warning('Host $host:$port is not reachable: $e', 'NetworkUtils');
      return false;
    }
  }

  static Future<Duration> measureLatency(String host, {int port = 80}) async {
    final stopwatch = Stopwatch()..start();

    try {
      final socket = await Socket.connect(host, port, timeout: const Duration(seconds: 10));
      await socket.close();
      stopwatch.stop();

      final latency = stopwatch.elapsed;
      AppLogger.performance('Latency to $host:$port: ${latency.inMilliseconds}ms', 'NetworkUtils');

      return latency;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error('Failed to measure latency to $host:$port: $e', 'NetworkUtils');
      return Duration.zero;
    }
  }

  static Future<Map<String, dynamic>> getNetworkInfo() async {
    try {
      final hasInternet = await hasInternetConnection();
      final latency = hasInternet ? await measureLatency('google.com') : Duration.zero;

      return {
        'hasInternet': hasInternet,
        'status': _currentStatus.name,
        'latency': latency.inMilliseconds,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      AppLogger.error('Error getting network info: $e', 'NetworkUtils');
      return {'hasInternet': false, 'status': 'error', 'latency': 0, 'timestamp': DateTime.now().toIso8601String()};
    }
  }

  static void _updateStatus(NetworkStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _statusController.add(status);

      AppLogger.info('Network status changed to: ${status.name}', 'NetworkUtils');
    }
  }

  static void dispose() {
    _statusController.close();
  }

  static String getStatusDescription(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.connected:
        return 'Connected to internet';
      case NetworkStatus.disconnected:
        return 'No internet connection';
      case NetworkStatus.unknown:
        return 'Connection status unknown';
    }
  }
}
