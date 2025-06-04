class Job {
  final String id;
  final String title;
  final String type;

  Job({required this.id, required this.title, required this.type});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(id: json['id'], title: json['title'], type: json['type']);
  }
}
