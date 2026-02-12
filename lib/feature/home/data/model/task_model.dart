class TaskModel {
  static const String collection = 'Tasks';
  String? id;
  String? title;
  String? description;
  int? priority;
  DateTime? data;
  bool? isDone;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.data,
    this.priority,
    this.isDone,
  });

  Map<String, dynamic> toJson() {
    final normailzedDate = DateTime(data!.year, data!.month, data!.day);
    return {
      'id': id,
      'title': title,
      'description': description,
      'data': normailzedDate.millisecondsSinceEpoch,
      'priority': priority,
      'isDone': false,
    };
  }

  TaskModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        data: json['data'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['data'])
            : null,
        priority: json['priority'],
        isDone: json['isDone'],
      );
}
