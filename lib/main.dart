import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vidzy/api/api_client.dart';
import 'package:vidzy/api/service/video_service.dart';
import 'package:vidzy/core/utils/private.dart';
import 'package:vidzy/view/bloc/video_bloc.dart';
import 'package:vidzy/view/screens/dashboard/dashboard.dart';

void main() {
  final dio = DioClient(Private.apiKey).dio;
  final apiService = VideoService(dio);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VideoBloc(apiService))
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
