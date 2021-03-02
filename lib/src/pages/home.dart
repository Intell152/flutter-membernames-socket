import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:work_partition_app/src/models/team_member.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Member> members = [
    Member(id: '1', name: 'Diana', cuanProyects: 5),
    Member(id: '2', name: 'Dianis', cuanProyects: 6),
    Member(id: '3', name: 'Aranzazu', cuanProyects: 4),
    Member(id: '4', name: 'Dianita', cuanProyects: 1),
    Member(id: '5', name: 'Aranzazusita', cuanProyects: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MemberNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, i) => _memberTile(members[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: _addNewMember,
      ),
    );
  }

  Widget _memberTile(Member member) {
    return Dismissible(
      key: Key(member.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ) {
        print('direction: $direction');
        // ignore: todo
        // TODO: llamar el borrado en el server
      },
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
        onTap: () {
          print(member.name);
        },
      ),
    );
  }

  _addNewMember() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
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
            );
          });
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
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
          );
        });
  }

  void _addMemberToList(String name) {
    if (name.length > 1) {
      this.members.add(new Member(
          id: DateTime.now().toString(), name: name, cuanProyects: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
