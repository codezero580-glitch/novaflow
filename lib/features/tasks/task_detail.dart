import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

import 'package:project_novaflow/state/task_provider.dart';
import 'package:project_novaflow/data/models/task_model.dart';
import 'package:project_novaflow/features/tasks/task_form.dart';

class TaskDetail extends StatefulWidget {
  final Task task;

  const TaskDetail({super.key, required this.task});
  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late final QuillController _controller;

  @override
  void initState() {
    super.initState();

    _controller = QuillController(
      document: Document.fromJson(jsonDecode(widget.task.description)),
      selection: const TextSelection.collapsed(offset: 0),
    );

    _controller.readOnly = true;
  }

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TaskProvider>().tasks.firstWhere(
      (e) => e.id == widget.task.id,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Detail',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Task',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: const Text("Delete Task"),
                    content: const Text(
                      "Are you sure you want to delete this task?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (confirm != true) return;

              if (task.id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task ID not found.")),
                );
                return;
              }

              try {
                await context.read<TaskProvider>().deleteTask(task.id!);

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task deleted successfully.")),
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Error: $e")));
              }
            },
          ),
        ],

        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      child: Center(
                        child: Text(
                          task.subject,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                task.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 5),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: QuillEditor(
                  controller: _controller,
                  focusNode: FocusNode(),
                  scrollController: ScrollController(),
                  config: const QuillEditorConfig(showCursor: false),
                ),
              ),
            ),

            Divider(thickness: 2),

            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 12),
                    const Text("Deadline", style: TextStyle(fontSize: 14)),
                    const Spacer(),
                    Text(
                      DateFormat("dd MMM yyyy | HH:mm").format(task.deadline),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(width: 12),
                    const Text("Created", style: TextStyle(fontSize: 14)),
                    const Spacer(),
                    Text(
                      DateFormat("dd MMM yyyy | HH:mm").format(task.createdAt),
                    ),
                  ],
                ),
              ],
            ),

            Divider(thickness: 2),

            SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Material(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskForm(task: task),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Material(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              title: Text(
                                task.isDone
                                    ? "Mark As Undone"
                                    : "Complete Task",
                              ),

                              content: Text(
                                task.isDone
                                    ? "Are you sure you want to mark this task as active again?"
                                    : "Are you sure you want to mark this task as completed?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext, false);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext, true);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    task.isDone ? "Undone" : "Done",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed != true) return;

                        try {
                          final updatedTask = Task(
                            id: task.id,
                            title: task.title,
                            description: task.description,
                            subject: task.subject,
                            deadline: task.deadline,
                            createdAt: task.createdAt,
                            author: task.author,
                            isDone: !task.isDone,
                          );

                          await context.read<TaskProvider>().updateTask(
                            updatedTask,
                          );

                          if (!mounted) return;

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                updatedTask.isDone
                                    ? "Task marked as done."
                                    : "Task marked as active.",
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            task.isDone ? 'Mark as Undone' : 'Mark as Done',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
