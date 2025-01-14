import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp/Project.dart';
import 'package:timetrackingapp/Screen/ManageProjectsScreen.dart';
import 'package:timetrackingapp/Screen/ManageTasksScreen.dart';
import 'package:timetrackingapp/TimeEntryProvider.dart';
import 'package:timetrackingapp/Screen/AddTimeEntryScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Entries'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All Entries'),
            Tab(text: 'Group By Entries'),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Projects'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageProjectsScreen())); // Close the drawer
                // Navigate to Manage Projects Screen
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tasks'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageTasksScreen())); // Close the drawer
                // Navigate to Manage Tasks Screen
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Entries Tab
          Consumer<TimeEntryProvider>(
            builder: (context, provider, child) {
              if (provider.timeEntries.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 100, // Increased size
                      color: Colors.grey.shade300, // Shaded grey color
                    ),
                    SizedBox(height: 10,),
                    Text('No Time Entier Yet',style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10),
                    Text('Tab the + button to add your first entrie',style: TextStyle(color: Colors.grey.shade300),),
                ],);
              }
              return ListView.builder(
                itemCount: provider.timeEntries.length,
                itemBuilder: (context, index) {
                  final entry = provider.timeEntries[index];

                  // Find the project and task names
                  final project = provider.projects.firstWhere((project) => project.id == entry.projectId, orElse: () => Project(id: '', name: 'Unknown Project'));
                  final task = provider.tasks.firstWhere((task) => task.id == entry.taskId, orElse: () => Task(id: '', name: 'Unknown Task'));

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Column: Text data
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Project name - Task name
                                Text(
                                  'Project: ${project.name} - Task: ${task.name}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 4),

                                // Total Time
                                Text(
                                  'Total Time: ${entry.totalTime} hours',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),

                                // Date
                                Text(
                                  'Date: ${entry.date.toString()}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),

                                // Notes
                                Text(
                                  'Notes: ${entry.notes}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          // Second Column: Delete icon
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  provider.deleteTimeEntry(entry.id);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );


                },
              );


            },
          ),
          // Group By Entries Tab
          Consumer<TimeEntryProvider>(
            builder: (context, provider, child) {
              final groupedEntries = provider.groupEntriesByProject();
              if (groupedEntries.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 100, // Increased size
                      color: Colors.grey.shade300, // Shaded grey color
                    ),
                    SizedBox(height: 10,),
                    Text('No Time Entier Yet',style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10),
                    Text('Tab the + button to add your first entrie',style: TextStyle(color: Colors.grey.shade300),),
                  ],);
              }
              return ListView.builder(
                itemCount: groupedEntries.length,
                itemBuilder: (context, index) {
                  final projectGroup = groupedEntries[index];

                  // Find the project name from the project ID
                  final project = provider.projects.firstWhere(
                        (project) => project.id == projectGroup.projectName,
                    orElse: () => Project(id: '', name: 'Unknown Project'),
                  );

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    elevation: 4,
                    child: ExpansionTile(
                      title: Text(project.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),), // Display project name here
                      children: projectGroup.entries.map((entry) {
                        // Find the task name
                        final task = provider.tasks.firstWhere(
                              (task) => task.id == entry.taskId,
                          orElse: () => Task(id: '', name: 'Unknown Task'),
                        );

                        return Text(
                          '-${task.name}: ${entry.totalTime} hours - (${DateFormat('MMM-d-yyyy').format(entry.date)})',
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,),
                        );
                      }).toList(),
                    ),
                  );
                },
              );


            },
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Time Entry',
      ),
    );
  }
}
