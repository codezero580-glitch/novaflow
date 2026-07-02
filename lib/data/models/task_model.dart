class Task {
  final int? id;
  final String title;
  final String description;
  final String subject;
  final DateTime deadline;
  final DateTime createdAt;
  final bool isDone;
  final String author;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.deadline,
    required this.createdAt,
    required this.isDone,
    required this.author,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'subject': subject,
        'deadline': deadline.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'isDone': isDone ? 1 : 0,
        'author': author,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        subject: map['subject'],
        deadline: DateTime.parse(map['deadline']),
        createdAt: DateTime.parse(map['createdAt']),
        isDone: map['isDone'] == 1,
        author: map['author'],
      );
}