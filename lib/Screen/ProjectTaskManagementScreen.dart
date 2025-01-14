import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp/TimeEntryProvider.dart';

class ProjectTaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Projects and Tasks'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Projects'),
              Tab(text: 'Tasks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Projects Tab
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.projects.length,
                  itemBuilder: (context, index) {
                    final project = provider.projects[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(project.name), // Access 'name' field
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            provider.deleteProject(project.id); // Use deleteProject method
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Tasks Tab
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
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
                        title: Text(task.name), // Access 'name' field
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddDialog(context);
          },
          child: Icon(Icons.add),
          tooltip: 'Add Project/Task',
        ),
      ),
    );
  }

  // Add Project/Task Dialog
  void _showAddDialog(BuildContext context) {
    final TextEditingController inputController = TextEditingController();
    final provider = Provider.of<TimeEntryProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Project or Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: inputController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final input = inputController.text.trim();
                      if (input.isNotEmpty) {
                        provider.addProject(input);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add Project'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final input = inputController.text.trim();
                      if (input.isNotEmpty) {
                        provider.addTask(input);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add Task'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
