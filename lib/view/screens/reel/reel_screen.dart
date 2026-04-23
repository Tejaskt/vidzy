import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidzy/res/spaces.dart';
import '../../../core/component/shimmer_effect.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_fonts.dart';
import '../../bloc/video/video_bloc.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.deepPurpleAccent,
        centerTitle: true,
        title: Text(
          widget.category.toUpperCase(),
          style: AppFonts.txtStyle.copyWith(color: AppColors.white),
        ),
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        buildWhen: (prev, curr) => prev != curr ,
        builder: (context, state) {

          if (state is VideoStateLoading) {
            return const ShimmerEffect();
          }

          // if(state is VideoStateError){
          //   return Center(child: Text(state.message));
          // }

          if (state is VideoStateLoaded) {
            return Stack(
              children: [

                PageView.builder(
                  itemCount: state.videos.length,
                  allowImplicitScrolling: true,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });

                    if (index >= state.videos.length - 3) {
                      context.read<VideoBloc>().add(LoadMoreVideos(category: widget.category));
                    }
                  },
                  itemBuilder: (context, index) {
                    return VideoItem(
                      video: state.videos[index],
                      isActive: index == currentIndex,
                      postIndex: currentIndex + 1,
                    );
                  },
                ),

                // ERROR OVERLAY (only when pagination fails)
                if (state.errorMessage != null)
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.black.withValues(alpha: 0.7),
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }

          return SpaceH0();
        },
      ),
    );


  }
}
