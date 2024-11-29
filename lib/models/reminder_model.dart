class Reminder {
  String id;
  String title;
  String? description;
  DateTime reminderDate;
  bool isRepeating;
  String repeatFrequency; // "daily", "weekly", "monthly", etc.

  Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.reminderDate,
    this.isRepeating = false,
    this.repeatFrequency = 'none',
  });

  // Método para converter o objeto Reminder em um mapa (para banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reminderDate': reminderDate.toIso8601String(),
      'isRepeating': isRepeating,
      'repeatFrequency': repeatFrequency,
    };
  }

  // Método para criar um objeto Reminder a partir de um mapa (para banco de dados)
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      reminderDate: DateTime.parse(map['reminderDate']),
      isRepeating: map['isRepeating'],
      repeatFrequency: map['repeatFrequency'],
    );
  }

  // Método para duplicar o lembrete com valores modificados
  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? reminderDate,
    bool? isRepeating,
    String? repeatFrequency,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderDate: reminderDate ?? this.reminderDate,
      isRepeating: isRepeating ?? this.isRepeating,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
    );
  }
}
