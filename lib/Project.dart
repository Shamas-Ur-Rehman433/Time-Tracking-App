class Project {
  final String id;
  final String name;

  Project({required this.id, required this.name});

  // Convert a Map to a Project
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
    );
  }

  // Convert a Project to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Task {
  final String id;
  final String name;

  Task({required this.id, required this.name});

  // Convert a Map to a Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
    );
  }

  // Convert a Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final double totalTime;
  final DateTime date;
  final String notes;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.totalTime,
    required this.date,
    required this.notes,
  });

  // Convert a Map to a TimeEntry
  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      id: map['id'],
      projectId: map['projectId'],
      taskId: map['taskId'],
      totalTime: map['totalTime'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }

  // Convert a TimeEntry to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'taskId': taskId,
      'totalTime': totalTime,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'TimeEntry{id: $id, projectId: $projectId, taskId: $taskId, totalTime: $totalTime, date: $date, notes: $notes}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeEntry &&
        other.id == id &&
        other.projectId == projectId &&
        other.taskId == taskId &&
        other.totalTime == totalTime &&
        other.date == date &&
        other.notes == notes;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      projectId.hashCode ^
      taskId.hashCode ^
      totalTime.hashCode ^
      date.hashCode ^
      notes.hashCode;
}
