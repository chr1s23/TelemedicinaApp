import 'package:chatbot/service/connectivity_service.dart';
import 'package:chatbot/view/screens/offline_chat.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityListener extends StatelessWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
        stream: ConnectivityService.connectivityStream,
        builder: (context, snapshot) {
          final isConnected =
              !(snapshot.data?.contains(ConnectivityResult.none) ?? true);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!isConnected) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const OfflineChat()));
            } else {
              if (Navigator.canPop(context)) Navigator.pop(context);
            }
          });
          return child;
        });
  }
}
