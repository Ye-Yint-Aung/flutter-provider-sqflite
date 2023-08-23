import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:provider_sqlite/helper/db_helper.dart';
import 'package:provider_sqlite/model/note.dart';
import 'package:provider_sqlite/provider/note_provider.dart';
import 'package:provider_sqlite/screen/add_notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*  final noteProvider = Provider.of<NoteProvider>(context as BuildContext,listen: false); */

  /* final List<NoteModel> notesList;
  final NoteProvider dataProvider;
  _HomeScreenState(this.notesList, this.dataProvider); */
  Color _favIconColor = Colors.blue;
  Future<List<NoteModel>>? noteList;
  List<NoteModel> dataList = [];
  List<NoteModel>? dl;
  @override
  void initState() {
    noteList = getNoteList();
    DatabaseHelper().getAllNote().whenComplete(
      () {
        setState(() {
          noteList!.then(
            (value) {
              dataList = value.map(
                (e) {
                  return NoteModel(
                      id: e.id ?? 0,
                      title: e.title,
                      subTitle: e.subTitle,
                      favourite: e.favourite);
                },
              ).toList();
              print("My : ${dataList}");
            },
          );
        });
      },
    );
  }

  Future<List<NoteModel>> getNoteList() async {
    return await DatabaseHelper().getAllNote();
  }

  @override
  Widget build(BuildContext context) {
    NoteProvider noteProvider =
        Provider.of<NoteProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Local DB"),
      ),
      body: Container(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddNoteScreen(),
                        settings: RouteSettings(arguments: [
                          dataList[index].title,
                          dataList[index].subTitle
                        ])));
                    print(
                        "Card Click ${dataList[index].title} and ${dataList[index].subTitle}");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dataList[index].title.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (dataList[index].favourite == 0) {
                                    await DatabaseHelper()
                                        .addFavpurite(1, dataList[index].id!);
                                  } else {
                                    await DatabaseHelper()
                                        .addFavpurite(0, dataList[index].id!);
                                  }
                                  print(
                                      "Data fav: ${dataList[index].favourite}");

                                  setState(() {
                                    initState();
                                    /*  if (dataList[index].favourite == 0) {
                                      _favIconColor = Colors.red;
                                    } else if (dataList[index].favourite == 1) {
                                      _favIconColor = Colors.blue;
                                    } */
                                  });
                                  print("Data: ${dataList}");
                                },
                                icon: Icon(
                                  dataList[index].favourite == 0
                                      ? Icons.favorite_outline
                                      : Icons.favorite,
                                  color: _favIconColor,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 300,
                                child: Text(
                                  overflow: TextOverflow.fade,
                                  dataList[index].subTitle.toString(),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await DatabaseHelper()
                                      .deleteNote(dataList[index].id!);
                                  setState(() {
                                    dataList.removeAt(index);
                                  });
                                  print("i Clicked: ${dataList[index].id}");
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNoteScreen(),
              settings: RouteSettings(arguments: ["Title", "SubTitle"])));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
