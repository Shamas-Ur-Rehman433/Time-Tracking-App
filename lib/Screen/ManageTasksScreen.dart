import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp/TimeEntryProvider.dart';

class ManageTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          if (provider.tasks.isEmpty) {
            return Center(
              child: Text('No tasks available. Add a new one!'),
            );
          }
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(task.name), // Access 'name' field of task
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      provider.deleteTask(task.id); // Use deleteTask method
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }

  // Add Task Dialog
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();
    final provider = Provider.of<TimeEntryProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final taskName = taskController.text.trim();
                if (taskName.isNotEmpty) {
                  provider.addTask(taskName); // Add task to provider
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
