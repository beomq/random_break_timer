import 'dart:async';

class MainViewModel {
  bool isPause = false;
  bool isStudying = false;
  Timer? timer;
  Duration time = Duration(seconds: 1);
  Duration elapsedTime = Duration(seconds: 1);

  void start() {
    isPause = false;
    isStudying = true;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (time != Duration.zero) {
          time -= const Duration(seconds: 1);
          elapsedTime += const Duration(seconds: 1);
        }
      },
    );
  }
}
