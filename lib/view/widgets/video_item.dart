import 'package:better_player_plus/better_player_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidzy/api/api_end_point.dart';
import 'package:vidzy/api/common_model/feed_model.dart';
import 'package:vidzy/core/component/shimmer_effect.dart';
import 'package:vidzy/core/constants.dart';
import 'package:vidzy/res/app_colors.dart';
import 'package:vidzy/res/app_strings.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../res/app_fonts.dart';
import '../../res/spaces.dart';
import '../bloc/comments/comment_bloc.dart';

class VideoItem extends StatefulWidget {
  final FeedModel feedItem;
  final bool isActive;
  final int postIndex;
  final VoidCallback onVisible;

  const VideoItem({
    super.key,
    required this.feedItem,
    required this.isActive,
    required this.postIndex,

    required this.onVisible,
  });

  final String imageNotAvailable = ApiEndPoint.baseUrlImageNotAvailable;
  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem>{
  BetterPlayerController? _betterPlayerController;
  bool _isInitialized = false;

  void _setupPlayer() {
    if (_betterPlayerController != null) return;

    final videoUrl = widget.feedItem.video?.videoUrl;

    if(videoUrl == null || videoUrl.isEmpty) return;

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 9 / 20,
        autoPlay: true,
        looping: false,
        handleLifecycle: true,
        placeholder: CachedNetworkImage(
          imageUrl: widget.feedItem.video?.thumbnail ?? widget.imageNotAvailable,
          fit: .cover,
          placeholder: (_, _) => ShimmerEffect(),
          errorWidget: (_, _, _) => Center(
            child: Text(
              AppStrings.somethingWentWrong,
              style: AppFonts.txtStyle.copyWith(color: AppColors.red),
            ),
          ),
        ),
        fit: .cover,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: true,
          enableOverflowMenu: false,
          enableFullscreen: false,
          showControlsOnInitialize: false
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.feedItem.video?.videoUrl ?? widget.imageNotAvailable,
        cacheConfiguration: BetterPlayerCacheConfiguration(
          useCache: true,
          key: videoUrl,
          preCacheSize: 5 * 1024 * 1024, // 5MB
          maxCacheSize: 100 * 1024 * 1024, // 100MB
          maxCacheFileSize: 15 * 1024 * 1024, // 15MB
        ),
      ),
    );

    _betterPlayerController!.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }


  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.feedItem.video?.videoUrl != widget.feedItem.video?.videoUrl) {
      _isInitialized = false;
    }

    if (widget.isActive && _betterPlayerController == null) {
      setState(() {
        _setupPlayer();
      });
    }

    if (!widget.isActive && _betterPlayerController != null) {
      setState(() {
        _disposePlayer();
      });
    }
  }

  void _disposePlayer() {
    _betterPlayerController?.dispose();
    _betterPlayerController = null;
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(
        widget.feedItem.video?.videoUrl ??
            widget.feedItem.post?.title ??
            UniqueKey().toString(),
      ),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.7) {
          widget.onVisible();
        }
      },
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(color: AppColors.deepPurpleAccent!),
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.cornerRadius16),
            ),
          ),
          margin: EdgeInsets.all(Constants.padding16),
          padding: EdgeInsets.all(Constants.padding16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header --- \\
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Constants.cornerRadius40,
                    ),
                    child: CachedNetworkImage(
                      width: Constants.imageWidth25,
                      height: Constants.imageHeight25,
                      fit: .cover,
                      imageUrl:
                          widget.feedItem.video?.thumbnail ??
                          widget.imageNotAvailable,
                      placeholder: (context, url) =>
                          CircleAvatar(child: _smallLoader()),
                      errorWidget: (context, url, error) =>
                          CircleAvatar(child: Icon(Icons.person)),
                    ),
                  ),

                  SpaceW3(),

                  SizedBox(
                    width: Constants.maxLength200.toDouble(),
                    child: Text(
                      softWrap: true,
                      widget.feedItem.video?.userName ?? AppStrings.unknownUser,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.latoRegular.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: constants.fontSize18px,
                      ),
                    ),
                  ),

                  Spacer(),

                  Text(
                    widget.feedItem.video?.quality ?? AppStrings.qualityAuto,
                    style: AppFonts.latoRegular.copyWith(
                      color: AppColors.blue,
                      fontSize: constants.fontSize18px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SpaceH10(),

              Text(
                widget.feedItem.post?.title ?? AppStrings.titleNA,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.latoRegular.copyWith(
                  fontSize: constants.fontSize16px,
                  color: AppColors.purple,
                ),
              ),

              SpaceH5(),

              Text(
                widget.feedItem.post?.tags.map((tag) => '#$tag').join(' ') ??
                    AppStrings.tagsNA,
                style: AppFonts.latoRegular.copyWith(
                  fontSize: constants.fontSize16px,
                  color: AppColors.blue,
                  fontWeight: .bold,
                ),
              ),

              SpaceH10(),

              // --- Video or Thumbnail --- \\
              AspectRatio(
                aspectRatio: 1/1,
                child: ClipRRect(
                  borderRadius: .circular(Constants.cornerRadius14),
                  child: _betterPlayerController != null && _isInitialized
                      ? BetterPlayer(controller: _betterPlayerController!)
                      : CachedNetworkImage(
                          imageUrl:
                              widget.feedItem.video?.thumbnail ??
                              widget.imageNotAvailable,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => ShimmerEffect(),
                          errorWidget: (_, _, _) =>
                              Center(child: Icon(Icons.broken_image)),
                        ),
                ),
              ),

              SpaceH10(),

              // --- Footer --- \\
              Text(
                widget.feedItem.post?.body ?? AppStrings.bodyNA,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.latoRegular.copyWith(color: AppColors.purple),
              ),

              SpaceH10(),

              Row(
                spacing: Constants.spacingRow10,
                children: [
                  reactionIcons(
                    icon: Icons.remove_red_eye,
                    value: widget.feedItem.post?.views ?? 0,
                    color: AppColors.blue,
                  ),
                  reactionIcons(
                    icon: Icons.favorite,
                    value: widget.feedItem.post?.likes ?? 0,
                    color: AppColors.red,
                  ),
                  reactionIcons(
                    icon: Icons.thumb_down,
                    value: widget.feedItem.post?.dislikes ?? 0,
                    color: AppColors.grey,
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      context.read<CommentBloc>().add(
                        FetchComments(widget.postIndex + 1),
                      );
                      showModalBottomSheet(
                        backgroundColor: AppColors.white,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => commentSheet(),
                      );
                    },
                    icon: Icon(Icons.comment, size: Constants.size24px),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallLoader() {
    return ShimmerEffect();
  }

  Widget commentSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        spacing: Constants.spacingColumn6,
        children: [
          SpaceH10(),

          Text(
            AppStrings.comments,
            style: AppFonts.latoRegular.copyWith(
              fontWeight: .bold,
              fontSize: constants.fontSize18px,
            ),
          ),

          const Divider(),

          BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoading) {
                return const CircularProgressIndicator(color: AppColors.blue);
              }
              if (state is CommentError) {
                return Center(
                  child: Text(
                    state.message,
                    style: AppFonts.latoRegular.copyWith(
                      fontWeight: .bold,
                      fontSize: constants.fontSize15px,
                      color: AppColors.red,
                    ),
                  ),
                );
              }

              if (state is CommentLoaded) {
                return state.comment.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.noComments,
                          style: AppFonts.latoRegular.copyWith(
                            color: AppColors.blue,
                            fontSize: constants.fontSize20px,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: state.comment.length,
                          itemBuilder: (context, index) {
                            final comment = state.comment[index];
                            return ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.blueShade100,
                                  shape: .circle,
                                ),
                                height: Constants.imageHeight25,
                                width: Constants.imageWidth25,
                                child: Center(
                                  child: Text(
                                    comment!.user[0].toUpperCase(),
                                    style: AppFonts.latoRegular.copyWith(
                                      fontSize: constants.fontSize16px,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                ),
                              ),

                              title: Row(
                                spacing: Constants.spacingRow10,
                                children: [
                                  Text(
                                    comment.user,
                                    style: AppFonts.latoRegular.copyWith(
                                      color: AppColors.black,
                                      fontSize: constants.fontSize18px,
                                      fontWeight: .w500, // normal weight
                                    ),
                                  ),
                                  Text(
                                    '@${comment.user}',
                                    style: AppFonts.latoRegular.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                comment.body,
                                style: AppFonts.latoRegular.copyWith(
                                  color: AppColors.blue,
                                  fontSize: constants.fontSize15px,
                                  fontWeight: .bold,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      );
              }

              return SpaceH0();
            },
          ),
        ],
      ),
    );
  }

  Widget reactionIcons({
    required IconData icon,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(Constants.padding8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(Constants.cornerRadius10),
        ),
        border: BoxBorder.all(color: AppColors.purple),
      ),
      child: Row(
        spacing: Constants.spacingRow10,
        children: [
          Icon(icon, color: color),
          Text(
            value.toString(),
            style: AppFonts.latoRegular.copyWith(
              color: color,
              fontWeight: .bold,
              fontSize: constants.fontSize15px,
            ),
          ),
        ],
      ),
    );
  }
}
