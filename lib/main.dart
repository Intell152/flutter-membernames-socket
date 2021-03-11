import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:work_partition_app/src/pages/home.dart';
import 'package:work_partition_app/src/pages/status.dart';
import 'package:work_partition_app/src/services/socket_service.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: ( _ ) => SocketService() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': ( _ ) => HomePage(),
          'status': ( _ ) => StatusPage()
        },
      ),
    );
  }
}