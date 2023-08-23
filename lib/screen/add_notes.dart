import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sqlite/model/note.dart';
import 'package:provider_sqlite/screen/home.dart';

import '../provider/note_provider.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final data = ModalRoute.of(context)!.settings.arguments as List;

    String _title = data[0];
    String _subTitle = data[1];
    print("Send Data From home: ${_title} and ${_subTitle} ");

    // final noteProvider = Provider.of<NoteProvider>(context as BuildContext);
    return Scaffold(
        appBar: AppBar(title: Text("Add Note")),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLines: 15,
                    controller: _subTitleController,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "subTitle",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.toString() == null ||
                          _titleController.text.toString().isEmpty ||
                          _subTitleController.text.toString() == null ||
                          _subTitleController.text.toString().isEmpty) {
                        print("Please check");
                        _dialog(context);
                      } else {
                        NoteProvider().addNote(NoteModel(
                          id: 2,
                          title: _titleController.text.toString(),
                          subTitle: _subTitleController.text.toString(),
                          favourite: 0,
                        ));
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                        });
                        print(
                            "Sub Title is :${_subTitleController.text.toString()}");
                      }

                      _subTitleController.clear();
                      _titleController.clear();
                    },
                    child: Text("Summit"),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<String?> _dialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Please Check!'),
        content: const Text('Title and Sub Title'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
