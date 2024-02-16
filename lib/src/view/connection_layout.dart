import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:no_internet_found_widget/src/game/dino_game.dart';

class NoInternetConnectionWidget extends StatefulWidget {
  final Widget child;

  const NoInternetConnectionWidget({super.key, required this.child});

  @override
  State<NoInternetConnectionWidget> createState() =>
      _NoInternetConnectionWidgetState();
}

class _NoInternetConnectionWidgetState
    extends State<NoInternetConnectionWidget> {
  bool _hasInternet = true;
  late StreamSubscription _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _hasInternet = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const DinoGame();
    // return _hasInternet ? widget.child : const Center(child: DinoGame());
  }
}
