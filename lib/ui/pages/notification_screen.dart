import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/cach_service.dart';
import '../../services/theme_services.dart';
import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.payload});

  final String payload;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';

  @override
  void initState() {
    _payload = widget.payload;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ThemeServices().switchTheme();
            },
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                size: 24, color: Get.isDarkMode ? primaryClr : darkGreyClr),
          ),
        ],
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,
              size: 24, color: Get.isDarkMode ? primaryClr : darkGreyClr),
        ),
        backgroundColor: context.theme.colorScheme.surface,
        title: Text(
          _payload.toString().split('|')[0],
          style: TextStyle(
              color: Get.isDarkMode ? primaryClr : darkGreyClr, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  'Hello ${CacheService.sharedPreferences.getString('userName')}',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode ? primaryClr : darkGreyClr),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You have a new Reminder!',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 21,
                          color: Get.isDarkMode ? primaryClr : darkGreyClr),
                    ),
                    Image.asset(
                      'images/newremind.webp',
                      width: 75,
                      height: 75,
                      color: Get.isDarkMode ? primaryClr : darkGreyClr,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.zero, color: blueGray),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.title, size: 35, color: primaryClr),
                          const SizedBox(width: 20),
                          Text(
                            'Title',
                            style: TextStyle(fontSize: 30, color: primaryClr),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        _payload.toString().split('|')[0],
                        style: TextStyle(
                            color: primaryClr, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.description, size: 35, color: primaryClr),
                          const SizedBox(width: 20),
                          Text(
                            'description',
                            style: TextStyle(fontSize: 30, color: primaryClr),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        _payload.toString().split('|')[1],
                        style: TextStyle(
                            color: primaryClr,
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 35, color: primaryClr),
                          const SizedBox(width: 20),
                          Text(
                            'Date',
                            style: TextStyle(fontSize: 30, color: primaryClr),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _payload.toString().split('|')[2],
                        style: TextStyle(
                            color: primaryClr,
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
