import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDKX7A-Ixua4Xzq7vENdmKrr9l4t1SET_s",
        projectId: "animated-memory-377205",
        appId: '1:842448987777:android:b3913a3e6bd1525ded4f80',
        messagingSenderId: '',
        storageBucket: "animated-memory-377205.appspot.com",
      ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirestoreCRUDPage(),
    );
  }
}

class FirestoreCRUDPage extends StatefulWidget {
  @override
  _FirestoreCRUDPageState createState() => _FirestoreCRUDPageState();
}

class _FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late CollectionReference _usersCollection;

  @override
  void initState() {
    super.initState();
    _usersCollection = FirebaseFirestore.instance.collection('users');
  }

  // Function to add user data
  Future<void> addUser() {
    return _usersCollection
        .add({'name': _nameController.text, 'email': _emailController.text})
        .then((value) {
      print('User added successfully!');
      _nameController.clear();
      _emailController.clear();
    }).catchError((error) {
      print('Failed to add user: $error');
    });
  }

  // Function to fetch all users
  Stream<QuerySnapshot> getUsers() {
    return _usersCollection.snapshots();
  }

  // Function to update user data
  Future<void> updateUser(String id, String newName, String newEmail) {
    return _usersCollection
        .doc(id)
        .update({'name': newName, 'email': newEmail})
        .then((value) {
      print('User updated successfully!');
    }).catchError((error) {
      print('Failed to update user: $error');
    });
  }

  // Function to delete user
  Future<void> deleteUser(String id) {
    return _usersCollection.doc(id).delete().then((value) {
      print('User deleted successfully!');
    }).catchError((error) {
      print('Failed to delete user: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore CRUD Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                addUser();
              },
              child: Text('Add User'),
            ),
            SizedBox(height: 20.0),
            StreamBuilder<QuerySnapshot>(
              stream: getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final users = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final userId = user.id;
                      final userName = user['name'];
                      final userEmail = user['email'];

                      return ListTile(
                        title: Text('$userName - $userEmail'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final newNameController = TextEditingController(text: userName);
                                    final newEmailController = TextEditingController(text: userEmail);

                                    return AlertDialog(
                                      title: Text('Update User'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: newNameController,
                                            decoration: InputDecoration(labelText: 'New Name'),
                                          ),
                                          TextField(
                                            controller: newEmailController,
                                            decoration: InputDecoration(labelText: 'New Email'),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            updateUser(userId, newNameController.text, newEmailController.text)
                                                .then((_) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text('Update'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteUser(userId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
