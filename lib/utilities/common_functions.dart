import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class internet_check {
  // determines whether it is safe or not to make a
  // request to the internet
  Future is_connected() async {
    var connectResult = await Connectivity().checkConnectivity(); // checks if
    // connected to a network
    if (connectResult == ConnectivityResult.mobile ||
        connectResult == ConnectivityResult.wifi) {
      // determines whether the connection is through mobile data or wifi/ethernet
      return await InternetConnection().hasInternetAccess;
    }
    return false;
  }
}
