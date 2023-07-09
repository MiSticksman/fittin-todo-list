import 'package:fittin_1/bloc/todo/todo_bloc.dart';
import 'package:fittin_1/bloc/todo/todo_event.dart';
import 'package:fittin_1/pages/todo_list_pages/todo_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosBloc()
            ..add(
              LoadTodosEvent(),
            ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF9900),
            primary: const Color(0xFFFF9900),
            background: const Color(0xFFEDEDED),
            surface: Colors.white,
            secondary: const Color(0xff45b443),
            
          ),
          textTheme: TextTheme(
            headlineLarge: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 32 / 24,
            ),
          ),
        ),
        home: TodoListPage(),
      ),
    );
  }
}
