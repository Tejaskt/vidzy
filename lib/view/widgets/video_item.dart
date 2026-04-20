import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:vidzy/core/component/shimmer_effect.dart';
import 'package:vidzy/core/constants.dart';
import 'package:vidzy/res/app_colors.dart';
import 'package:vidzy/res/app_strings.dart';
import '../../api/model/video_model.dart';

class VideoItem extends StatefulWidget {
  final VideoModel video;
  final bool isActive;

  const VideoItem({super.key, required this.video, required this.isActive});

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
      ],
    );
  }
}
