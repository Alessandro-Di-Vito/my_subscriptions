import 'package:flutter/foundation.dart';

class LoadingService extends ChangeNotifier {
  int _activeRequests = 0;

  bool get isLoading => _activeRequests > 0;

  void start() {
    _activeRequests++;
    notifyListeners();
  }

  void stop() {
    if (_activeRequests > 0) {
      _activeRequests--;
    }
    notifyListeners();
  }
}
