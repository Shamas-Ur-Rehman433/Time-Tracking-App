import 'package:flutter/material.dart';
import 'package:timetrackingapp/Project.dart';  // Ensure this import exists

class TimeEntryProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];
  List<TimeEntry> _timeEntries = []; // Add a list to store time entries

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  List<TimeEntry> get timeEntries => _timeEntries; // Getter for time entries

  // Add Project
  void addProject(String name) {
    final newProject = Project(id: DateTime.now().toString(), name: name);
    _projects.add(newProject);
    _saveData();
    notifyListeners();
  }

  // Add Task
  void addTask(String name) {
    final newTask = Task(id: DateTime.now().toString(), name: name);
    _tasks.add(newTask);
    _saveData();
    notifyListeners();
  }

  // Add Time Entry
  void addTimeEntry(TimeEntry timeEntry) {
    _timeEntries.add(timeEntry);
    _saveData();
    notifyListeners();
  }
  void deleteTimeEntry(String id) {
    _timeEntries.removeWhere((entry) => entry.id == id);
    _saveData();
    notifyListeners();
  }

  // Delete Project
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveData();
    notifyListeners();
  }

  // Delete Task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveData();
    notifyListeners();
  }

  // Group Time Entries by Project
  List<ProjectGroup> groupEntriesByProject() {
    // Group time entries by projectId
    Map<String, List<TimeEntry>> grouped = {};
    for (var entry in _timeEntries) {
      if (!grouped.containsKey(entry.projectId)) {
        grouped[entry.projectId] = [];
      }
      grouped[entry.projectId]!.add(entry);
    }

    // Convert the map to a list of ProjectGroup objects
    return grouped.entries.map((entry) {
      return ProjectGroup(
        projectName: entry.key, // The project ID or name
        entries: entry.value,
      );
    }).toList();
  }

  // Save data method (if you want to persist data)
  void _saveData() {
    // Add your data saving logic here (e.g., saving to local storage or a database)
  }
}

// Helper class to represent a grouped project with its time entries
class ProjectGroup {
  final String projectName; // Project ID or name
  final List<TimeEntry> entries;

  ProjectGroup({required this.projectName, required this.entries});
}

