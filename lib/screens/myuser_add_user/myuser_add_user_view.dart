import 'package:flutter/material.dart';

import '../home/myuser/myuser_models.dart';
import '../widgets/inputs.dart';

class MyUserAddUser extends StatefulWidget {
  const MyUserAddUser({super.key});

  @override
  State<MyUserAddUser> createState() => _MyUserAddUserState();
}

class _MyUserAddUserState extends State<MyUserAddUser> {
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

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
        title: const Text('New User'),
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
                  user.createDocument();
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
              child: const Text('Add User'))
        ],
      ),
    );
  }
}
