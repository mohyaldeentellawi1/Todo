import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/cach_service.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';
import 'package:intl/intl.dart';

import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  late TaskController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = Get.put(TaskController());
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        height: double.infinity,
        color: context.theme.colorScheme.surface,
        child: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(height: 6),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Hello ${CacheService.sharedPreferences.getString('occupation')}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
          },
          icon: Icon(
            Get.isDarkMode ? Icons.dark_mode_rounded : Icons.sunny,
            color: Get.isDarkMode
                ? Colors.white70
                : const Color.fromRGBO(48, 25, 52, 1),
          ),
        ),
        IconButton(
            onPressed: () {
              CacheService.removeData(key: 'userName');
              CacheService.removeData(key: 'occupation');
              CacheService.isRegister = false;
              Get.to(() => const AuthScreen());
            },
            icon: const Icon(Icons.logout, size: 24)),
      ],
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 50,
        ),
      ),
      backgroundColor: context.theme.colorScheme.surface,
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                style: subheadingStyle,
              ),
              Text('Today', style: headingStyle),
            ],
          ),
          MaterialButton(
              elevation: 0,
              textColor: primaryClr,
              color: blueGray,
              child: const Text('+ Add Task'),
              onPressed: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 100,
        initialSelectedDate: _selectedDate,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? primaryClr : darkGreyClr),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? primaryClr : darkGreyClr),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? primaryClr : darkGreyClr),
        ),
        selectedTextColor: primaryClr,
        selectionColor: blueGray,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                Task task = _taskController.taskList[index];
                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    (task.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(task.date))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(task.date).day ==
                            _selectedDate.day)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1000),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            // showBottonSheet(context, task);
                            showModalBottomSheet(
                              showDragHandle: true,
                              useSafeArea: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              elevation: 0,
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: const EdgeInsets.only(top: 4),
                                  width: SizeConfig.screenWidth,
                                  height: (SizeConfig.orientation ==
                                          Orientation.landscape)
                                      ? (task.isCompleted == 1
                                          ? SizeConfig.screenHeight * 0.6
                                          : SizeConfig.screenHeight * 0.8)
                                      : (task.isCompleted == 1
                                          ? SizeConfig.screenHeight * 0.2
                                          : SizeConfig.screenHeight * 0.28),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        task.isCompleted == 1
                                            ? const SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: MaterialButton(
                                                  height: 50,
                                                  elevation: 0,
                                                  color: tealClr,
                                                  onPressed: () {
                                                    // notifyHelper.cancelNotification(task);
                                                    _taskController
                                                        .markTasksCompleted(
                                                            task);
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    'Task Completed',
                                                    style: titleStyle.copyWith(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                        _buildBottonSheet(
                                            lable: 'Delete Task',
                                            onTap: () {
                                              // notifyHelper.cancelNotification(task);
                                              _taskController.deleteTasks(task);
                                              Get.back();
                                            },
                                            clr: redLClr),
                                        const Divider(
                                            thickness: 2,
                                            indent: 20,
                                            endIndent: 20),
                                        _buildBottonSheet(
                                            lable: 'Cancel',
                                            onTap: () {
                                              Get.back();
                                            },
                                            clr: blueGray),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: _taskController.taskList.length,
            ),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 1000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 80,
                    width: 80,
                    semanticsLabel: 'Task',
                    colorFilter: ColorFilter.mode(
                        Get.isDarkMode ? primaryClr : darkGreyClr,
                        BlendMode.srcIn),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any tasks yet! \nAdd any tasks to make your days productive',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 120)
                      : const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // showBottonSheet(BuildContext context, Task task) {
  //   Get.bottomSheet(SingleChildScrollView(
  //     child: Container(
  //       decoration: BoxDecoration(
  //           color: Get.isDarkMode ? primaryClr : darkGreyClr,
  //           borderRadius: BorderRadius.circular(35)),
  //       padding: const EdgeInsets.only(top: 4),
  //       width: SizeConfig.screenWidth,
  //       height: (SizeConfig.orientation == Orientation.landscape)
  //           ? (task.isCompleted == 1
  //               ? SizeConfig.screenHeight * 0.6
  //               : SizeConfig.screenHeight * 0.8)
  //           : (task.isCompleted == 1
  //               ? SizeConfig.screenHeight * 0.30
  //               : SizeConfig.screenHeight * 0.39),
  //       child: Column(
  //         children: [
  //           Flexible(
  //             child: Container(
  //               height: 6,
  //               width: 120,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: Get.isDarkMode ? primaryClr : darkGreyClr),
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           task.isCompleted == 1
  //               ? Container()
  //               : _buildBottonSheet(
  //                   lable: 'Task Completed',
  //                   onTap: () {
  //                     // notifyHelper.cancelNotification(task);
  //                     _taskController.markTasksCompleted(task);
  //                     Get.back();
  //                   },
  //                   clr: tealClr),
  //           // _buildBottonSheet(
  //           //     lable: 'Update Task',
  //           //     onTap: () {
  //           //       _taskController.updateTasks(task);
  //           //     },
  //           //     clr: blueGray),
  //           _buildBottonSheet(
  //               lable: 'Delete Task',
  //               onTap: () {
  //                 // notifyHelper.cancelNotification(task);
  //                 _taskController.deleteTasks(task);
  //                 Get.back();
  //               },
  //               clr: redLClr),
  //           Divider(color: Get.isDarkMode ? primaryClr : darkGreyClr),
  //           _buildBottonSheet(
  //               lable: 'Cancel',
  //               onTap: () {
  //                 Get.back();
  //               },
  //               clr: Get.isDarkMode ? darkGreyClr : primaryClr),
  //           const SizedBox(height: 20),
  //         ],
  //       ),
  //     ),
  //   ));
  // }

  _buildBottonSheet(
      {required String lable, required Function() onTap, required Color clr}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        height: 50,
        elevation: 0,
        color: clr,
        onPressed: onTap,
        child: Text(
          lable,
          style: titleStyle.copyWith(color: primaryClr),
        ),
      ),
    );
  }
}
