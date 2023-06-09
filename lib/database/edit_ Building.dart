import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/database/add_Floor.dart';
import 'package:inventory_app/database/list_Floors.dart';

class EditBuilding extends StatelessWidget {
  final String name;
  final String buildingId;

  EditBuilding({
    Key? key,
    required this.name,
    required this.buildingId,
  }) : super(key: key);

  final controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Edit building: $name'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddFloor(
                  buildingId: buildingId,
                ),
              ),
            );
          },
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 80,
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
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Name: $name \nID: $buildingId',
                      style: const TextStyle(fontSize: 20),
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
              child: const Text('Update'),
              onPressed: () async {
                final docBuilding = FirebaseFirestore.instance
                    .collection('Building')
                    .doc(buildingId);
                docBuilding.update({
                  'name':
                      (controllerName.text == '' ? name : controllerName.text),
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
            DisplayFloors(buildingId: buildingId),
          ],
        ),
      );
}
