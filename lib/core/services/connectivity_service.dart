import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

// >>> ConnectivityService =======================
// Wraps connectivity_plus to provide network status checks and a reactive stream
@lazySingleton
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Check if the device has any network connection
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  // Check if the device is connected via Wi-Fi
  Future<bool> isWifi() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  // Reactive stream of connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}
// <<< ConnectivityService =======================
