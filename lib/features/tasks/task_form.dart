import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:project_novaflow/data/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_novaflow/state/task_provider.dart';
import 'package:project_novaflow/data/models/task_model.dart';

class TaskForm extends StatefulWidget {
  final Task? task;

  const TaskForm({super.key, this.task});

  bool get isEdit => task != null;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  @override
  void dispose() {
    titleController.dispose();

    descController.dispose();

    descFocusNode.dispose();

    descScrollController.dispose();

    super.dispose();
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("Add Task Category"),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            FilledButton(
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty) return;

                try {
                  await context.read<TaskProvider>().addCategory(text);

                  if (!context.mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Category added")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Add",
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ],
        );
      },
    );
  }

  final titleController = TextEditingController();

  final descController = QuillController.basic();

  final FocusNode descFocusNode = FocusNode();

  final ScrollController descScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      final task = widget.task!;

      titleController.text = task.title;
      descController.document = Document.fromJson(jsonDecode(task.description));

      selectedCategory = task.subject;
      selectedDate = task.deadline;
      selectedTime = TimeOfDay.fromDateTime(task.deadline);
    }
  }

  String? selectedCategory;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus(); 
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    FocusScope.of(context).unfocus(); 
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<TaskProvider>().categories;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.isEdit ? "Edit Task" : "New Task",
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            const Text(
              "Task Title",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1.5,
                  ),
                ),

                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Category
            const Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(categories.length, (index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  Material(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        _showAddDialog();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        child: Center(child: Icon(Icons.add)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Description
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            Column(
              children: [
                QuillSimpleToolbar(
                  controller: descController,
                  config: const QuillSimpleToolbarConfig(
                    axis: Axis.horizontal,
                    multiRowsDisplay: false,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: QuillEditor(
                      controller: descController,
                      focusNode: descFocusNode,
                      scrollController: descScrollController,
                      config: QuillEditorConfig(
                        scrollable: true,
                        autoFocus: false,
                        expands: false,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      label: Text(
                        selectedDate == null
                            ? "Due Date"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickTime,
                      icon: Icon(
                        Icons.access_time,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      label: Text(
                        selectedTime == null
                            ? "Due Time"
                            : selectedTime!.format(context),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Material(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  final auth = context.read<AuthProvider>();
                  final taskProvider = context.read<TaskProvider>();

                  if (titleController.text.isEmpty ||
                      selectedCategory == null ||
                      selectedDate == null ||
                      selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  try {
                    final dateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );

                    final task = Task(
                      id: widget.task?.id,
                      title: titleController.text.trim(),
                      description: jsonEncode(
                        descController.document.toDelta().toJson(),
                      ),
                      subject: selectedCategory!,
                      deadline: dateTime,

                      createdAt: widget.isEdit
                          ? widget.task!.createdAt
                          : DateTime.now(),

                      isDone: widget.isEdit ? widget.task!.isDone : false,

                      author: widget.isEdit
                          ? widget.task!.author
                          : auth.currentUser!,
                    );

                    if (widget.isEdit) {
                      await taskProvider.updateTask(task);
                    } else {
                      await taskProvider.addTask(task);
                    }

                    if (!mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.isEdit ? "Task updated" : "Task created",
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      widget.isEdit ? 'Update Task' : 'Save Task',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
