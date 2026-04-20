import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/component/shimmer_effect.dart';
import '../../bloc/video_bloc.dart';
import '../../widgets/video_item.dart';

class ReelScreen extends StatefulWidget {

  final String category;
  const ReelScreen({super.key, required this.category });

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {

  @override
  void initState() {
    super.initState();
    context.read<VideoBloc>().add(FetchVideos(category: widget.category));
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoBloc, VideoState>(
        buildWhen: (prev, curr) => prev != curr ,
        builder: (context, state) {

          // if (state is VideoStateInitial) {
             //context.read<VideoBloc>().add(FetchVideos(category: ));
          // }

          if (state is VideoStateLoading) {
            return const ShimmerEffect();
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
                  context.read<VideoBloc>().add(LoadMoreVideos(category: widget.category));
                }
              },
              itemBuilder: (context, index) {
                return VideoItem(
                  video: state.videos[index],
                  isActive: index == currentIndex,
                );
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
