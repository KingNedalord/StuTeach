class Task {
  String description;
  String task_name;
  String time;
  int id;
  String? image;
  String? pdf;
  String? mp4;
  String? word;
  String? audio;
  Task({
    required this.description,
    required this.task_name,
    required this.time,
    required this.id,
    required this.image,
    required this.pdf,
    required this.mp4,
    required this.word,
    required this.audio,
  });
}
