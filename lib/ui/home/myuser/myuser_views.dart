import 'package:flutter/material.dart';

import 'myuser_input_form_view.dart';
import '../../core/ui/dialogs.dart';
import '../../core/ui/firestore_ui/action_gridview.dart';
import '../../core/ui/firestore_ui/action_listview.dart';
import '../../../domain/repositories/myuser_models.dart';

class MyUserListView extends StatelessWidget {
  const MyUserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreActionListView(
      query: MyUser.query,
      itemBuilder: (context, snapshot) {
        final user = snapshot.data();
        final created = user.docTime.createTime?.toDate();
        final updated = user.docTime.updateTime?.toDate();
        final name = user.name;
        final age = user.age;
        return ListTile(
          title: Text('$name @ $age'),
          subtitle: Text(
            'Added: $created\nUpdated: $updated',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
      deleteAction: (id, data) async {
        debugPrint('deleting user: id=$id');
        final resp = await showDialog(
          context: context,
          builder: (context) => const SimpleConfirmDialog(
            title: 'Delete User',
            content: 'Confirm?',
            actionTextList: ['Cancel', 'Yes'],
          ),
        );

        if (resp == 'Yes') {
          data.deleteDocument();
        }
      },
      editAction: (id, data) {
        debugPrint('updating user: id=$id');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              MyUserUserFormPage(updateId: id, updateUser: data),
        ));
      },
      debug: true,
    );
  }
}

class MyUserGridView extends StatelessWidget {
  const MyUserGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreActionGridView(
      query: MyUser.query,
      itemBuilder: (context, index, data) {
        final user = data;
        final created = user.docTime.createTime?.toDate();
        final updated = user.docTime.updateTime?.toDate();
        final name = user.name;
        final age = user.age;
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name),
            Text('$age'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  'Added: $created\nUpdated: $updated',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        );
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      deleteAction: (id, data) async {
        debugPrint('deleting user: id=$id');
        final resp = await showDialog(
          context: context,
          builder: (context) => const SimpleConfirmDialog(
            title: 'Delete User',
            content: 'Confirm?',
            actionTextList: ['Cancel', 'Yes'],
          ),
        );

        if (resp == 'Yes') {
          data.deleteDocument();
        }
      },
      editAction: (id, data) {
        debugPrint('updating user: id=$id');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              MyUserUserFormPage(updateId: id, updateUser: data),
        ));
      },
      debug: true,
    );
  }
}
