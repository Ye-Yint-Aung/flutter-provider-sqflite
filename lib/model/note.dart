class NoteModel {
  int? id;
  String? title;
  String? subTitle;
  int? favourite;
  NoteModel(
      {required this.id,
      required this.title,
      required this.subTitle,
      required this.favourite});

  Map<String, Object?> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['title'] = title;
    data['subTitle'] = subTitle;
    data['favourite'] = favourite;
    return data;
  }

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['subTitle'];
    favourite = json['favourite'];
  }

  @override
  String toString() {
    return 'notes{id: $id, title: $title, subTitle: $subTitle, favourite:$favourite}';
  }
}
