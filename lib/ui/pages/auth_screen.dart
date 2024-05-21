import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/services/cach_service.dart';
import 'package:todoapp/ui/pages/home_page.dart';
import 'package:todoapp/ui/size_config.dart';
import 'package:todoapp/ui/widgets/input_field.dart';

import '../../services/theme_services.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _userNameController, _occupationController;

  bool isLoading = false;

  Future<void> validateThenSave() async {
    if (_userNameController.text.isNotEmpty &&
        _occupationController.text.isNotEmpty) {
      CacheService.put(key: 'userName', value: _userNameController.text);
      CacheService.put(key: 'occupation', value: _occupationController.text);
    } else {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: blueGray,
          colorText: darkGreyClr);
    }
  }

  @override
  void initState() {
    _userNameController = TextEditingController();
    _occupationController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder(
        future: CacheService.getData(key: 'userName'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            isLoading = true;
          } else {
            isLoading = false;
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  ThemeServices().switchTheme();
                },
                icon: Icon(
                  Get.isDarkMode ? Icons.dark_mode_rounded : Icons.sunny,
                  size: 30,
                  color: Get.isDarkMode
                      ? Colors.white70
                      : const Color.fromRGBO(48, 25, 52, 1),
                ),
              ),
              backgroundColor: context.theme.colorScheme.surface,
            ),
            body: Container(
              height: double.infinity,
              color: context.theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Image.asset(
                      'images/icon.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '"Don\'t worry about the many tasks, ToDo is here"',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color:
                                      Get.isDarkMode ? primaryClr : darkGreyClr,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Image.asset(
                            'images/helllo.png',
                            width: 60,
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          InputField(
                              controller: _userNameController,
                              title: 'UserName',
                              hint: 'Enter your name'),
                          InputField(
                              controller: _occupationController,
                              title: 'Company',
                              hint: 'Enter your company name'),
                          const SizedBox(height: 30),
                          MaterialButton(
                            elevation: 0,
                            color: blueGray,
                            textColor: primaryClr,
                            onPressed: () async {
                              validateThenSave().then((value) {
                                setState(() {
                                  CacheService.isRegister = true;
                                });
                              });
                            },
                            child: Text(
                              isLoading ? 'Loading...' : 'Let\'s go!',
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenWidth * 0.55),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton.small(
                                shape: const BeveledRectangleBorder(),
                                backgroundColor: blueGray,
                                foregroundColor: primaryClr,
                                heroTag: 'about',
                                onPressed: () {
                                  Get.generalDialog(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return AlertDialog.adaptive(
                                        elevation: 0,
                                        backgroundColor: Get.isDarkMode
                                            ? blueGray
                                            : primaryClr,
                                        title: Row(
                                          children: [
                                            Image.asset('images/icon.png',
                                                width: 50, height: 50),
                                            const SizedBox(width: 10),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('ToDo App'),
                                                Text('v 1.0.0')
                                              ],
                                            ),
                                          ],
                                        ),
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.copyright),
                                                SizedBox(width: 10),
                                                Text('2023 ToDo App')
                                              ],
                                            ),
                                          ],
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                overlayColor:
                                                    Colors.transparent,
                                                foregroundColor: Get.isDarkMode
                                                    ? primaryClr
                                                    : darkGreyClr,
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(fontSize: 18),
                                              ))
                                        ],
                                      );
                                    },
                                  );
                                  // Get.to(() => const AboutPage());
                                },
                                child: const Icon(Icons.info_outlined),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
