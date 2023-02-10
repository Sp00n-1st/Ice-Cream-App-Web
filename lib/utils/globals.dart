library global;

import 'dart:async';

final userStreamController = StreamController<String>();
StreamSink<String> get userSink => userStreamController.sink;
Stream<String> get userStream => userStreamController.stream;
bool isLogin = false;
bool isUpload = false;
