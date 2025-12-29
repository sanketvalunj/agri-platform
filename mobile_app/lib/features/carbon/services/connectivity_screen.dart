import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> get isConnected async {
    final status = await Connectivity().checkConnectivity();
    return status != ConnectivityResult.none;
  }
}
