import 'package:attendence_management_app/controllers/auth_controller.dart';
import 'package:attendence_management_app/view/admin/admin_dashboard.dart';
import 'package:attendence_management_app/view/auth/login_screen.dart';
import 'package:attendence_management_app/view/auth/selection_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: '1:373315789850:android:69ebbbe895c1bb555e5da3',
      apiKey: 'AIzaSyBk4Rh6Y57mRFuspgZN-LdX-jKQjCKB0t0',
      projectId: 'attendencesystem-3c82b',
      storageBucket: 'attendencesystem-3c82b.appspot.com',
      messagingSenderId: '373315789850',
    ),
  );
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: const SelectionScreen(),
    );
  }
}
