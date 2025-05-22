import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionChangeController = StreamController<bool>.broadcast();

  NetworkService() {
    _connectivity.onConnectivityChanged.listen((result) async {
      _connectionChangeController.add(await hasInternetConnection());
    });
  }

  Stream<bool> get onConnectivityChanged => _connectionChangeController.stream;

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _connectionChangeController.close();
  }
}
