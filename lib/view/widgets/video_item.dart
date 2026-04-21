import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:vidzy/core/component/shimmer_effect.dart';
import 'package:vidzy/core/constants.dart';
import 'package:vidzy/res/app_colors.dart';
import 'package:vidzy/res/app_strings.dart';
import 'package:vidzy/view/bloc/comments/comment_bloc.dart';
import '../../api/model/video_model.dart';

class VideoItem extends StatefulWidget {
  final VideoModel video;
  final bool isActive;
  final int postIndex;

  const VideoItem({super.key, required this.video, required this.isActive, required this.postIndex});
  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    );
    _initialize();
  }

  void commentClicked(){
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.deepPurpleAccent,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
          value: context.read<CommentBloc>(),
        child: bottomSheet(),
      ),
    );
  }

  Future<void> _initialize() async {
    await _controller.initialize();

    setState(() {
      isInitialized = true;
    });

    if (widget.isActive) {
      _controller.play();
    }

    _controller.setLooping(true);
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      _controller.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        isInitialized
            ? FittedBox(
          fit: .cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        )
            : CachedNetworkImage(
          imageUrl: widget.video.thumbnail,
          fit: .cover,
          placeholder: (_, _) => ShimmerEffect(),
        ),

        Positioned(
          top: 20.sp,
          right: 10.sp,
          child: Card(
            color: AppColors.green300,
            child: Padding(
              padding: EdgeInsets.all(Constants.padding8),
              child: Text(widget.video.quality ?? AppStrings.notAvailable),
            ),
          ),
        ),

        Positioned(
          bottom: 20.sp,
          left: 10.sp,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding8),
                  child: Text(
                    '@${widget.video.userName}',
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: .bold,
                      fontSize: constants.fontSize18px,
                      shadows: [Shadow(blurRadius: 4, color: AppColors.black)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 80,
          right: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: commentClicked,
                icon: const Icon(
                  Icons.comment_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black38,
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget bottomSheet(){
    context.read<CommentBloc>().add(FetchComments(widget.postIndex));

    debugPrint('----------------------------------------------here is your id ${widget.postIndex} -----------------------------------------------------');
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              BlocBuilder<CommentBloc, CommentState>(
                buildWhen: (p, c) => c is CommentLoaded || c is CommentLoading,
                builder: (context, state) {
                  final count = state is CommentLoaded
                      ? state.comment.length
                      : null;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Comments',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (count != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '($count)',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.black),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              // Body
              Expanded(
                child: BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, state) {
                    if (state is CommentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is CommentError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (state is CommentLoaded) {
                      if (state.comment.isEmpty) {
                        return const Center(child: Text('No comments yet.'));
                      }
                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: state.comment.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),

                        // Inside _CommentBottomSheetState, replace the itemBuilder content:
                        itemBuilder: (context, index) {
                          final c = state.comment[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar from first letter of fullName
                                CircleAvatar(
                                  radius: 18,
                                  // backgroundColor:
                                  // Colors.primaries[c?.user.codeUnitAt(
                                  //   0,
                                  // ) % Colors.primaries.length],
                                  child: Text(
                                    c!.user[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '@${c.user}',
                                        style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        c.body,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      // Likes count
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 12,
                                            color: Colors.red.shade300,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${c.likes}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

