import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/list_ItemTypes.dart';
import 'package:inventory_app/database/add_ItemType.dart';

class EditRoom extends StatelessWidget {
  final String name;
  final String buildingId;
  final String roomId;
  final String floorId;

  EditRoom({
    Key? key,
    required this.name,
    required this.buildingId,
    required this.roomId,
    required this.floorId,
  }) : super(key: key);

  final controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Edit room: $name'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddItemType(
                  buildingId: buildingId,
                  floorId: floorId,
                  roomId: roomId,
                ),
              ),
            );
          },
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 100,
                width: 240,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Name: $name \nID: $roomId',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () async {
                final docUser = FirebaseFirestore.instance
                    .collection('Building')
                    .doc(buildingId)
                    .collection('Floor')
                    .doc(floorId)
                    .collection('Rooms')
                    .doc('$roomId');
                // Update user
                docUser.update({
                  'name':
                      (controllerName.text == '' ? name : controllerName.text),
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
           
          ],
        ),
      );
}
