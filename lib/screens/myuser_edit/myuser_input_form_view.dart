import 'package:flutter/material.dart';

import '../home/myuser/myuser_models.dart';
import '../widgets/inputs.dart';

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

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.updateUser?.name ?? '';
    ageCtrl.text = widget.updateUser?.age.toString() ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
    ageCtrl.dispose();
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleTextInput(
              label: 'Age',
              controller: ageCtrl,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
              onPressed: () {
                try {
                  final user = MyUser(
                    name: nameCtrl.text,
                    age: int.parse(ageCtrl.text),
                  );
                  if (widget.updateId == null) {
                    user.createDocument();
                  } else {
                    user.updateDocument(widget.updateId!);
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
