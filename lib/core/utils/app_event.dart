import 'dart:async';

class AppEvents {
  // قناة بث للأحداث
  static final _controller = StreamController<String>.broadcast();

  // مخرجات القناة (التي سنستمع إليها)
  static Stream<String> get events => _controller.stream;

  // مدخلات القناة (التي سنرسل منها)
  static void fire(String eventName) {
    _controller.add(eventName);
  }
}
