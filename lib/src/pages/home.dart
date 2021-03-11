import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:work_partition_app/src/models/team_member.dart';
import 'package:work_partition_app/src/services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Member> members = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('proyect-members', _handleMember);
    super.initState();
  }

  _handleMember(dynamic payload) {
    this.members =
        (payload as List).map((member) => Member.fromMap(member)).toList();

    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('proyect-members');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MemberNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(Icons.check_circle, color: Colors.blue[300])
                  : Icon(Icons.check_circle, color: Colors.red))
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(this.members),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, i) => _memberTile(members[i]),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: _addNewMember,
      ),
    );
  }

  Widget _memberTile(Member member) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(member.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => member.id.length > 1
          ? socketService.emit('delete-member', {'id': member.id})
          : null,
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Member',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(member.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(member.name),
        trailing: Text(
          '${member.cuanProyects}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () =>
            socketService.socket.emit('count-proyect', {'id': member.id}),
      ),
    );
  }

  void _addNewMember() {
    final textController = new TextEditingController();

    Platform.isAndroid
        ? showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('New Member'),
              content: TextField(
                controller: textController,
              ),
              actions: <Widget>[
                MaterialButton(
                    child: Text('Add'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => _addMemberToList(textController.text))
              ],
            ),
          )
        : showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
                  title: Text('New Member'),
                  content: CupertinoTextField(
                    controller: textController,
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text('Add'),
                      onPressed: () => _addMemberToList(textController.text),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: Text('Dismiss'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ));
  }

  void _addMemberToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    if (name.length > 1) {
      socketService.emit('add-member', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph(dynamic members) {
    Map<String, double> data = new Map();

    members.forEach((member) {
      data.putIfAbsent(member.name, () => member.cuanProyects.toDouble());
    });

    // final List<Color> colorList = [
    //   Colors.blue,
    //   Colors.pink,
    //   Colors.orange,
    //   Colors.green,
    //   Colors.blue[100]
    // ];

    if (data.length != 0) {
      return PieChart(dataMap: data);
    }
    return SizedBox();
    // return Padding(
    //   padding: const EdgeInsets.only(top: 20),
    //   child: PieChart(
    //     dataMap: dataMap,
    //     animationDuration: Duration(milliseconds: 800),
    //     chartLegendSpacing: 32,
    //     chartRadius: MediaQuery.of(context).size.width / 3.2,
    //     // colorList: colorList,
    //     initialAngleInDegree: 0,
    //     chartType: ChartType.ring,
    //     ringStrokeWidth: 32,
    //     centerText: "Proyects",
    //     legendOptions: LegendOptions(
    //       showLegendsInRow: false,
    //       legendPosition: LegendPosition.right,
    //       showLegends: true,
    //       // legendShape: _BoxShape.circle,
    //       legendTextStyle: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     chartValuesOptions: ChartValuesOptions(
    //       showChartValueBackground: true,
    //       showChartValues: true,
    //       showChartValuesInPercentage: false,
    //       showChartValuesOutside: false,
    //       decimalPlaces: 1,
    //     ),
    //   ),
    // );
  }
}
