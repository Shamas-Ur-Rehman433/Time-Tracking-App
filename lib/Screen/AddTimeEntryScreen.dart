import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp/Project.dart';
import 'package:timetrackingapp/TimeEntryProvider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId; // Nullable to handle initial state
  String? taskId; // Nullable to handle initial state
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now(); // Added TimeOfDay for time selection
  String notes = '';

  Future<void> _selectDateTime(BuildContext context) async {
    // Select date
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null) return;

    // Select time
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (selectedTime == null) return;

    setState(() {
      date = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      time = selectedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Project Dropdown
              DropdownButtonFormField<String>(
                value: projectId,
                onChanged: (value) => setState(() => projectId = value),
                decoration: InputDecoration(labelText: 'Project'),
                items: provider.projects.map((project) {
                  return DropdownMenuItem<String>(
                    value: project.id,
                    child: Text(project.name),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Select a project' : null,
              ),
              SizedBox(height: 16),

              // Task Dropdown
              DropdownButtonFormField<String>(
                value: taskId,
                onChanged: (value) => setState(() => taskId = value),
                decoration: InputDecoration(labelText: 'Task'),
                items: provider.tasks.map((task) {
                  return DropdownMenuItem<String>(
                    value: task.id,
                    child: Text(task.name),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Select a task' : null,
              ),
              SizedBox(height: 16),

              // Total Time Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter total time';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
              ),
              SizedBox(height: 16),

              // Date and Time Picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date and Time'),
                subtitle: Text(
                  '${date.year}-${date.month}-${date.day} ${time.format(context)}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context),
              ),
              SizedBox(height: 16),

              // Notes Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (value) => value == null || value.isEmpty ? 'Enter notes' : null,
                onSaved: (value) => notes = value!,
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Ensure projectId and taskId are not null before saving
                    if (projectId != null && taskId != null) {
                      provider.addTimeEntry(
                        TimeEntry(
                          id: DateTime.now().toString(),
                          projectId: projectId!,
                          taskId: taskId!,
                          totalTime: totalTime,
                          date: date,
                          notes: notes,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select both project and task')),
                      );
                    }
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
