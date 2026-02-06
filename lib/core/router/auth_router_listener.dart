import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

class AuthRouterListener extends ChangeNotifier{
  final BlocBase bloc;
  late StreamSubscription stream;
  AuthRouterListener({required this.bloc}){
    stream = bloc.stream.listen((event) => notifyListeners(),);
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }
}