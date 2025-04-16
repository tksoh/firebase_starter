import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/myuser_model.dart';
import '../../../data/repositories/myuser_repo.dart';
import '../../core/ui/inputs/date.dart';
import '../../core/ui/inputs/controllers.dart';
import '../../core/ui/inputs/text.dart';
import '../../core/ui/inputs/numeric.dart';

class MyUserUserFormPage extends StatefulWidget {
  const MyUserUserFormPage({
    super.key,
    this.updateUser,
    this.updateId,
  }) : assert((updateId == null && updateUser == null) ||
            (updateId != null && updateUser != null));

  final MyUser? updateUser;
  final String? updateId;

  @override
  State<MyUserUserFormPage> createState() => _MyUserUserFormPageState();
}

class _MyUserUserFormPageState extends State<MyUserUserFormPage> {
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final dateCtrl = DateTimeEditingController(
    null,
    toText: (p0) => DateFormat('d/M/y hh:mm a').format(p0!),
  );

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.updateUser?.name ?? '';
    ageCtrl.text = widget.updateUser?.age.toString() ?? '';
    dateCtrl.data = widget.updateUser?.registered.toDate() ?? DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
    ageCtrl.dispose();
    dateCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.updateId == null ? 'New User' : 'Update User'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleTextInput(
              label: 'Name',
              controller: nameCtrl,
              hintText: 'enter name here',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NumbericInput(
              label: 'Age',
              controller: ageCtrl,
              integer: true,
              hintText: 'enter age here',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateInput(
              label: 'Date',
              controller: dateCtrl,
              hintText: 'pick a date',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
              onPressed: () {
                try {
                  if (widget.updateId == null) {
                    myUserRepo.addUserData(
                      name: nameCtrl.text,
                      age: int.parse(ageCtrl.text),
                      registered: Timestamp.fromDate(
                        dateCtrl.data ?? DateTime.now(),
                      ),
                    );
                  } else {
                    myUserRepo.updateUserData(
                      from: widget.updateUser!,
                      name: nameCtrl.text,
                      age: int.parse(ageCtrl.text),
                      registered: Timestamp.fromDate(
                        dateCtrl.data ?? DateTime.now(),
                      ),
                    );
                  }
                  Navigator.pop(context);
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text('Error: $error'),
                    ),
                  );
                }
              },
              child: Text(widget.updateId == null ? 'Add' : 'Update'))
        ],
      ),
    );
  }
}
