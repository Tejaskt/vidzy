import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidzy/core/constants.dart';
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

          if(state is VideoStateError){
             return Center(child: Text(state.message));
          }

          if (state is VideoStateLoaded) {
            return Stack(
              children: [

                PageView.builder(
                  itemCount: state.videos.length,
                  //allowImplicitScrolling: true,
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
                        padding: EdgeInsets.all(Constants.padding10),
                        color: AppColors.black.withValues(alpha: 0.7),
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: AppColors.white),
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

/*
*
* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_bloc_new_version/features/feed/presentation/widgets/video_item.dart';

import '../../bloc/feed_bloc.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  int _lastFetchedAtIndex = -1;
  int _activeIndex = -1;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          //it will display loading indicator until video gets loaded...
          if (state is FeedLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          //it will display error of it occurs.
          if (state is FeedErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          //it will display data
          if (state is FeedSuccessState) {
            return Stack(
              children: [
                ListView.separated(
                  itemCount: state.reels.length,

                  scrollDirection: Axis.vertical,
                 separatorBuilder: (context, index) => Divider(color: Colors.white,),
                  itemBuilder: (context, index) {
                    final reel = state.reels[index];

                    //this will fetch more data if available.
                    //it will check currentIndex != last index. and will load when currentIndex is data's list.length - 3
                    if (index >= state.reels.length - 3 &&
                        index != _lastFetchedAtIndex) {
                      _lastFetchedAtIndex = index;
                      context.read<FeedBloc>().add(FetchMoreReelEvent());
                    }

                    return VideoItem(
                      reel: reel,
                      reelIndex: index,
                      isActive: index == _activeIndex,
                      onVisible: () {
                        if(_activeIndex != index)
                          {
                            setState(() {
                              _activeIndex = index;
                            });
                          }
                      },
                    );
                  }
                ),

                if(state.isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

*
* */