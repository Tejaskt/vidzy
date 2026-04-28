import 'package:better_player_plus/better_player_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vidzy/core/component/shimmer_effect.dart';
import 'package:vidzy/core/constants.dart';
import 'package:vidzy/res/app_colors.dart';
import 'package:vidzy/res/app_strings.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../api/model/video_model.dart';
import '../../res/app_fonts.dart';
import '../../res/spaces.dart';
import '../bloc/comments/comment_bloc.dart';
import '../bloc/post/post_bloc.dart';

class TestItem extends StatefulWidget {
  final VideoModel video;
  final bool isActive;
  final int postIndex;
  final VoidCallback onVisible;

  const TestItem({
    super.key,
    required this.video,
    required this.isActive,
    required this.postIndex,
    required this.onVisible,
  });

  @override
  State<TestItem> createState() => _TestItemState();
}

class _TestItemState extends State<TestItem> {
  BetterPlayerController? _betterPlayerController;
  bool _isInitialized = false;

  void _setupPlayer() {
    if (_betterPlayerController != null) return;

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 9 / 20,
        autoPlay: true,
        looping: false,
        handleLifecycle: true,
        placeholder: CachedNetworkImage(
          imageUrl: widget.video.thumbnail,
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
          showControls: false,
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.video.videoUrl,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
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
  void didUpdateWidget(covariant TestItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.videoUrl != widget.video.videoUrl) {
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
      key: Key(widget.video.videoUrl),
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
              // ── Header ──────────────────────
              Row(
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(Constants.cornerRadius40),
                    child: CachedNetworkImage(
                      width: 25.sp,
                      height: 25.sp,
                      fit: .cover,
                      imageUrl: widget.video.thumbnail,
                      placeholder: (context, url) => CircleAvatar(child: _smallLoader()),
                      errorWidget: (context, url, error) => CircleAvatar(child: Icon(Icons.person)),
                    ),
                  ),

                  SpaceW3(),

                  SizedBox(
                    width: Constants.maxLength200.toDouble(),
                    child: Text(
                      softWrap: true,
                      widget.video.userName,
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
                    widget.video.quality ?? AppStrings.auto,
                    style: AppFonts.latoRegular.copyWith(
                      color: AppColors.blue,
                      fontSize: constants.fontSize18px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SpaceH10(),

              BlocBuilder<PostBloc, PostState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is PostError) {
                    debugPrint('error in post api : ${state.message}');
                    return Text(
                      '${AppStrings.postFetchError} Error ${state.message}',
                    );
                  }

                  if (state is PostLoading) {
                    //debugPrint('Post api is loading state : $state');
                    return _smallLoader();
                  }

                  if (state is PostLoaded) {
                    //debugPrint('post api is success : ${state.posts}');

                    final post = state.posts.length > widget.postIndex
                        ? state.posts[widget.postIndex]
                        : null;

                    if (post == null) {
                      return _smallLoader();
                    }

                    // --- Post Data ---\\
                    return Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          post.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.latoRegular.copyWith(
                            fontSize: constants.fontSize16px,
                            color: AppColors.purple,
                          ),
                        ),

                        SpaceH5(),

                        Text(
                          post.tags.map((tag) => '#$tag').join(' '),
                          style: AppFonts.latoRegular.copyWith(
                            fontSize: constants.fontSize16px,
                            color: AppColors.blue,
                            fontWeight: .bold,
                          ),
                        ),
                      ],
                    );
                  }

                  return _smallLoader();
                },
              ),

              SpaceH10(),

              // ── Video or Thumbnail ───────────
              AspectRatio(
                aspectRatio: 1 / 1,
                child: ClipRRect(
                  borderRadius: .circular(Constants.cornerRadius14),
                  child: _betterPlayerController != null && _isInitialized
                      ? BetterPlayer(controller: _betterPlayerController!)
                      : CachedNetworkImage(
                          imageUrl: widget.video.thumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => ShimmerEffect(),
                          errorWidget: (_, _, _) => Center(
                            child: Icon(Icons.broken_image),
                          ), //Text(AppStrings.somethingWentWrong,style: AppFonts.txtStyle.copyWith(color: AppColors.red),)),
                        ),
                ),
              ),

              SpaceH10(),

              // ── Footer ──────────────────────
              BlocBuilder<PostBloc, PostState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is PostError) {
                    //debugPrint('error in post api : ${state.message}');
                    return Text(
                      '${AppStrings.postFetchError} Error ${state.message}',
                    );
                  }

                  if (state is PostLoading) {
                    //debugPrint('Post api is loading state : $state');
                    return _smallLoader();
                  }

                  if (state is PostLoaded) {
                    //debugPrint('post api is success : ${state.posts}');

                    final post = state.posts.length > widget.postIndex
                        ? state.posts[widget.postIndex]
                        : null;

                    if (post == null) {
                      return _smallLoader();
                    }

                    // --- Post Data ---\\
                    return Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          post.body,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.latoRegular.copyWith(
                            color: AppColors.purple,
                          ),
                        ),

                        SpaceH10(),

                        Row(
                          spacing: Constants.spacingRow6,
                          children: [
                            reactionIcons(
                              icon: Icons.remove_red_eye,
                              value: post.views,
                              color: AppColors.blue,
                            ),
                            reactionIcons(
                              icon: Icons.favorite,
                              value: post.likes,
                              color: AppColors.red,
                            ),
                            reactionIcons(
                              icon: Icons.thumb_down,
                              value: post.dislikes,
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
                              icon: Icon(
                                Icons.comment,
                                size: Constants.size24px,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return _smallLoader();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallLoader() {
    return ShimmerEffect();

    //   SizedBox(
    //   height: 20,
    //   width: 20,
    //   child: CircularProgressIndicator(strokeWidth: 2),
    // );
  }

  Widget commentSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        spacing: Constants.padding6,
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
                                height: 25.sp,
                                width: 25.sp,
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
                                spacing: Constants.padding10,
                                children: [
                                  Text(
                                    comment.user,
                                    style: AppFonts.latoRegular.copyWith(
                                      color: AppColors.black,
                                      fontSize: constants.fontSize18px,
                                      fontWeight: .w500, // normal
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
        spacing: Constants.spacingRow6,
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
