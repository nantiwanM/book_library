import 'package:flutter/material.dart';
import 'pages/book_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
scaffoldBackgroundColor: const Color(0xFFF5F5F5), // เทาอ่อนพาสเทล

        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 245, 172, 104),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
  fillColor: Colors.white, // พื้นหลังสีขาวคงที่
  hoverColor: Colors.white, // สีเวลา hover
  focusColor: Colors.white, // สีเวลา focus
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey), // กรอบ textfield
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange), // เวลา focus
          ),
          prefixIconColor: Colors.orange,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD6B0), // ส้มพาสเทลอ่อน
            foregroundColor: const Color(0xFF5C4033),
            shadowColor: Colors.orange.shade100,
            elevation: 4,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const BookList(),
    );
  }
}
