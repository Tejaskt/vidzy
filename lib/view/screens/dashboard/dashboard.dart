import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/video_bloc.dart';
import '../../widgets/video_item.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoBloc, VideoState>(
        buildWhen: (prev, curr) => prev != curr ,
        builder: (context, state) {

          if (state is VideoStateInitial) {
            context.read<VideoBloc>().add(FetchVideos());
          }

          if (state is VideoStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VideoStateLoaded) {
            return PageView.builder(
              allowImplicitScrolling: true,
              scrollDirection: Axis.vertical,
              itemCount: state.videos.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });

                if (index == state.videos.length - 2) {
                  context.read<VideoBloc>().add(LoadMoreVideos());
                }
              },
              itemBuilder: (context, index) {
                return VideoItem(video: state.videos[index], isActive : index == currentIndex);
              },
            );
          }

          if(state is VideoStateError){
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );


  }
}