class TaskDone {
  int id;
  String audio;
  String image;
  String mp4;
  String pdf;
  String word;

  TaskDone({
    required this.id,
    this.audio = "",
    this.image = "",
    this.mp4 = "",
    this.pdf = "",
    this.word = "",
  });
}

class Student {
  String name;
  List<TaskDone> tasks;

  Student({
    required this.name,
    this.tasks = const [],
  });
}
