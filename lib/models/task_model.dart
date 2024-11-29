class Task {
  String id;
  String title;
  String? description;
  DateTime? dueDate;
  bool isCompleted;
  String? category;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.category,
  });

  // Converte o objeto Task para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
    };
  }

  // Converte um Map para o objeto Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: map['isCompleted'] == 1, // Conversão aqui
      category: map['category'],
    );
  }
}
