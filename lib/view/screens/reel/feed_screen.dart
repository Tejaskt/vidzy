import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidzy/core/constants.dart';
import 'package:vidzy/res/app_strings.dart';
import 'package:vidzy/res/spaces.dart';
import 'package:vidzy/view/bloc/feed/feed_bloc.dart';
import 'package:vidzy/view/widgets/video_item.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_fonts.dart';

class FeedScreen extends StatefulWidget {
  final String category;

  const FeedScreen({super.key, required this.category});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _activeIndex = -1;
  int _lastTriggeredIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(FetchFeedItem(videoCategory: widget.category));
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
      body: BlocBuilder<FeedBloc, FeedState>(
        buildWhen: (prev, curr) => prev != curr,
        builder: (context, state) {
          if (state is FeedLoading) {
            return Center(child: const CircularProgressIndicator());
          }

          if (state is FeedError) {
            return Center(
              child: Column(
                spacing: Constants.spacingColumn6,
                mainAxisAlignment: .center,
                children: [
                  Text(
                    state.message,
                    style: AppFonts.latoRegular.copyWith(
                      color: AppColors.blue,
                      fontSize: constants.fontSize16px,
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () => context.read<FeedBloc>().add(
                      FetchFeedItem(videoCategory: widget.category),
                    ),
                    child: Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          if (state is FeedLoaded) {
            return Stack(
              children: [
                ListView.builder(
                  itemCount: state.feedItem.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (index >= state.feedItem.length - 3 && index != _lastTriggeredIndex) {
                      _lastTriggeredIndex = index;
                      context.read<FeedBloc>().add(
                        LoadMoreFeedItem(videoCategory: widget.category),
                      );
                    }

                    return VideoItem(
                      feedItem: state.feedItem[index],
                      isActive: index == _activeIndex,
                      postIndex: index,
                      onVisible: () {
                        if (_activeIndex != index) {
                          setState(() {
                            _activeIndex = index;
                          });
                        }
                      },
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
