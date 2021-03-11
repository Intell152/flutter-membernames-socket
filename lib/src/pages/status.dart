import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:work_partition_app/src/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('${socketService.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            final Map mensaje = {'nombre': 'Flutter', 'Mensaje': 'Hola desde Flutter'};
            // código mas limpio
            // socketService.socket.emit('emitir-mensaje', mensaje);
            socketService.emit('emitir-mensaje', mensaje);
          }),
    );
  }
}
