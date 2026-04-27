import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vidzy/view/bloc/comments/comment_bloc.dart';
import 'package:vidzy/view/bloc/post/post_bloc.dart';
import 'package:vidzy/view/bloc/video/video_bloc.dart';
import 'package:vidzy/view/screens/dashboard/dashboard.dart';

void main() {


  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VideoBloc()),
        BlocProvider(create: (_) => CommentBloc()),
        BlocProvider(create: (_) => PostBloc())
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, screenType, orientation) {
        return MaterialApp(
          //showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          home: const Dashboard(),
        );
      },
    );
  }
}
