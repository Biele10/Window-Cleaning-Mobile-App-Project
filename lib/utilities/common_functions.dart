import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetCheck {
  // determines whether it is safe or not to make a
  // request to the internet
  Future<bool> isConnected() async {
    var connectivityListResult = await Connectivity()
        .checkConnectivity(); // checks if // connected to a network
    var connectResult = connectivityListResult.first;
    /* takes the first value
    as .checkConnectivity now returns a list rather than a value */
    if (connectResult == ConnectivityResult.mobile ||
        connectResult == ConnectivityResult.wifi ||
        connectResult == ConnectivityResult.ethernet ||
        connectResult == ConnectivityResult.vpn) {
      // determines whether the connection is through mobile data, wifi,
      // ethernet or vpn
      return await InternetConnection().hasInternetAccess;
    }
    return false;
  }
}
