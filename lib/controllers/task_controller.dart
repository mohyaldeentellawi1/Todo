import 'package:get/get.dart';

import '../dp/dp_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DpHelper.insert(task);
  }

  Future<void> getTasks() async {
    final tasks = await DpHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTasks(Task task) async {
    await DpHelper.delete(task);
    getTasks();
  }

  void deleteAllTasks() async {
    await DpHelper.deleteAll();
    getTasks();
  }

  void markTasksCompleted(Task task) async {
    await DpHelper.update(task);
    getTasks();
  }
}
