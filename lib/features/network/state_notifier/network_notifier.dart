import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:starter_template_riverpod/route_config/route_config.dart';
import 'package:starter_template_riverpod/route_config/routes.dart';

final networkProvider = StateNotifierProvider<NetworkNotifier, NetworkState>((
  ref,
) {
  return NetworkNotifier();
});

class NetworkState {
  final bool isConnected;
  final String lastRoute;

  NetworkState({required this.isConnected, this.lastRoute = ''});

  NetworkState copyWith({bool? isConnected, String? lastRoute}) {
    return NetworkState(
      isConnected: isConnected ?? this.isConnected,
      lastRoute: lastRoute ?? this.lastRoute,
    );
  }
}

class NetworkNotifier extends StateNotifier<NetworkState> {
  NetworkNotifier() : super(NetworkState(isConnected: true));

  late final InternetConnection _connectionChecker;
  StreamSubscription<InternetStatus>? _subscription;

  void init(BuildContext context, WidgetRef ref) {
    _connectionChecker = InternetConnection();

    // _checkConnection(context, ref);

    _subscription = _connectionChecker.onStatusChange.listen((status) {
      final connected = status == InternetStatus.connected;
      if (context.mounted) {
        _updateConnectionStatus(connected, context, ref);
      }
    });
  }

  // Future<void> _checkConnection(BuildContext context, WidgetRef ref) async {
  //   final connected = await _connectionChecker.hasInternetAccess;
  //   if (context.mounted) {
  //     _updateConnectionStatus(connected, context, ref);
  //   }
  // }

  void _updateConnectionStatus(
    bool connected,
    BuildContext context,
    WidgetRef ref,
  ) {
    debugPrint('Current route: ${state.lastRoute}');
    debugPrint('Connected: $connected');

    state = state.copyWith(isConnected: connected);

    if (!connected) {
      if (state.lastRoute != Routes.network) {
        AppRouter.router.push(Routes.network);
      }
      state = state.copyWith(lastRoute: Routes.network);
    } else {
      bool result = AppRouter.router.canPop(); // checks if pop is possible

      if (result) {
        AppRouter.router.pop();
        debugPrint('Popped successfully');
      } else {
        if (state.lastRoute == Routes.network) {
          AppRouter.router.pushReplacement(Routes.splash);
          debugPrint('Cannot pop, already at root');
        }
      }
      state = state.copyWith(lastRoute: '');
    }
  }

  Future<void> retryConnection(BuildContext context, WidgetRef ref) async {
    final connected = await _connectionChecker.hasInternetAccess;
    if (context.mounted) {
      _updateConnectionStatus(connected, context, ref);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
