import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidzy/api/api_client.dart';
import 'package:vidzy/api/service/video_service.dart';
import 'package:vidzy/core/utils/constants.dart';
import 'package:vidzy/view/bloc/video_bloc.dart';
import 'package:vidzy/view/screens/dashboard/dashboard.dart';

void main() {
  final dio = DioClient(Constants.apiKey).dio;
  final apiService = VideoService(dio);

  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => VideoBloc(apiService))
        ],
        child: MyApp() //videoBloc: VideoBloc(apiService))
      )
  );
}

class MyApp extends StatelessWidget {
  //final VideoBloc videoBloc;

  const MyApp({super.key,});  //required this.videoBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Dashboard()
    );
  }
}
