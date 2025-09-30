import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class internet_check {
  // determines whether it is safe or not to make a
  // request to the internet
  Future is_connected() async {
    var connect_result = await Connectivity().checkConnectivity();
    if (connect_result == ConnectivityResult.mobile ||
        connect_result == ConnectivityResult.wifi) {
      return await InternetConnectionChecker().hasConnection;
    }
    return false;
  }
}
