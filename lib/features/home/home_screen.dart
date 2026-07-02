import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:intl/intl.dart';

import 'package:project_novaflow/features/tasks/task_detail.dart';
import 'package:project_novaflow/features/tasks/task_form.dart';
import 'package:project_novaflow/state/task_provider.dart';
import 'package:project_novaflow/data/auth/auth_provider.dart';
import 'package:project_novaflow/data/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  List<Task> _filterTasks(List<Task> tasks, {int? category}) {
    final now = DateTime.now();
    final selectedCategory = category ?? selected;

    List<Task> result;

    switch (selectedCategory) {
      case 1: // Today
        result = tasks.where((task) {
          return task.deadline.year == now.year &&
              task.deadline.month == now.month &&
              task.deadline.day == now.day;
        }).toList();
        break;

      case 2: // Upcoming
        final today = DateTime(now.year, now.month, now.day);

        result = tasks.where((task) {
          final taskDate = DateTime(
            task.deadline.year,
            task.deadline.month,
            task.deadline.day,
          );

          return taskDate.isAfter(today);
        }).toList();
        break;

      case 3: // Overdue
        final today = DateTime(now.year, now.month, now.day);

        result = tasks.where((task) {
          final taskDate = DateTime(
            task.deadline.year,
            task.deadline.month,
            task.deadline.day,
          );

          return taskDate.isBefore(today);
        }).toList();
        break;

      default:
        result = tasks;
    }

    if (searchQuery.isNotEmpty) {
      result = result.where((task) {
        final title = task.title.toLowerCase();
        final subject = task.subject.toLowerCase();

        return title.contains(searchQuery) || subject.contains(searchQuery);
      }).toList();
    }

    return result;
  }

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final auth = context.watch<AuthProvider>();

    final allTasks = taskProvider.tasks
        .where((t) => t.isDone == false)
        .toList();

    final filteredTasks = _filterTasks(allTasks);

    var tabs = [
      "All (${_filterTasks(allTasks, category: 0).length})",
      "Today Tasks (${_filterTasks(allTasks, category: 1).length})",
      "Upcoming Tasks (${_filterTasks(allTasks, category: 2).length})",
      "Overdue (${_filterTasks(allTasks, category: 3).length})",
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hello, ${(auth.currentUser ?? "User").titleCase}!'),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(child: Icon(Icons.person, size: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'You Have',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              '${allTasks.length} Active Tasks',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
              ),
            ),

            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = selected == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = index;
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
                              : Theme.of(context).colorScheme.surfaceContainer,

                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),

                        child: Text(
                          tabs[index],
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
              ),
            ),
            SizedBox(height: 20),

            // card task
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Theme.of(context).colorScheme.surfaceContainer,

                    child: ListTile(
                      title: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.subject,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Due: ${DateFormat('dd MMM yyyy | HH:mm').format(task.deadline)}",
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),

                      trailing: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetail(task: task),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskForm()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
