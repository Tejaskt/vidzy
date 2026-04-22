import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:vidzy/core/component/shimmer_effect.dart';
import 'package:vidzy/core/constants.dart';
import 'package:vidzy/res/app_colors.dart';
import 'package:vidzy/res/app_fonts.dart';
import 'package:vidzy/res/app_strings.dart';
import 'package:vidzy/res/spaces.dart';
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
          child: Card(
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding8),
                  child: Text(
                    '@${widget.video.userName}',
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: .bold,
                      fontSize: constants.fontSize18px,
                      shadows: [Shadow(blurRadius: 4.sp, color: AppColors.black)],
                    ),
                  ),
                ),
              ),
        ),

        Positioned(
          bottom: 20.sp,
          right: 10.sp,
          child: IconButton(
                onPressed: (){
                  context.read<CommentBloc>().add(FetchComments(widget.postIndex));
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => BlocProvider.value(
                      value: context.read<CommentBloc>(),
                      child: bottomSheet(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.comment_rounded,
                  color: AppColors.white,
                  size: Constants.size24px,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.black,
                  padding: EdgeInsets.all(Constants.padding12),
                ),
              ),

        ),

      ],
    );
  }

  Widget bottomSheet(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Constants.cornerRadius20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: Constants.padding10),
              width: Constants.bottomSheetScrollerWidth,
              height: Constants.bottomSheetScrollerHeight,
              decoration: BoxDecoration(
                color: AppColors.listTileLabel,
                borderRadius: BorderRadius.circular(Constants.cornerRadius6),
              ),
            ),
          ),

          Text(
            AppStrings.comments,
            style: AppFonts.txtStyle,
          ),

          Divider(height: 1.sp),

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
                      style: const TextStyle(color: AppColors.red),
                    ),
                  );
                }
                if (state is CommentLoaded) {

                  if (state.comment.isEmpty) {
                    return const Center(child: Text(AppStrings.noComments));
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: Constants.padding16,
                      vertical: Constants.padding8,
                    ),
                    itemCount: state.comment.length,
                    separatorBuilder: (_, _) => Divider(height: 1.sp),

                    itemBuilder: (context, index) {
                      final c = state.comment[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: Constants.padding10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // AVATAR FOR FIRST LETTER OF FULL NAME
                            CircleAvatar(
                              radius: Constants.cornerRadius16,
                              child: Text(
                                c!.user[0].toUpperCase(),
                                style: AppFonts.latoRegular.copyWith(
                                  fontSize: 16.sp
                                )
                              ),
                            ),

                            SpaceW10(),

                            // COMMENT CONTENT
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '@${c.user}',
                                    style: TextStyle(
                                      color: AppColors.purple,
                                      fontSize: constants.fontSize12px,
                                    ),
                                  ),
                                  SpaceH8(),
                                  Text(
                                    c.body,
                                    style: AppFonts.latoRegular,
                                  ),
                                  SpaceH5(),

                                  // Likes count
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: Constants.size12px,
                                        color: AppColors.likeColor
                                      ),

                                      SpaceW3(),
                                      Text(
                                        '${c.likes}',
                                        style: AppFonts.latoRegular
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
                return SpaceH0();
              },
            ),
          ),
        ],
      ),
    );
  }
}

