import 'package:flutter/material.dart';
import 'package:vidzy/core/constants.dart';
import 'package:vidzy/res/app_colors.dart';
import 'package:vidzy/res/app_fonts.dart';
import 'package:vidzy/res/app_strings.dart';
import 'package:vidzy/res/spaces.dart';
import 'package:vidzy/view/screens/reel/feed_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    debugPrint('controller disposed');
    _controller.dispose();
    super.dispose();
  }

  // central search handler
  void _onSearch() {
    FocusScope.of(context).unfocus();
    final query = _controller.text.trim();

    if (query.isEmpty) {
      _showError(AppStrings.chooseCategory);
      return;
    }

    _navigateToFeed(query);
    _controller.clear();
  }

  void _navigateToFeed(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeedScreen(category: category),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.deepPurpleAccent,
        centerTitle: true,
        title: Text(
          AppStrings.appName.toUpperCase(),
          style: AppFonts.txtStyle.copyWith(color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Constants.padding16),
          child: Column(
            children: [

              spaceH10,

              // SEARCH FIELD
              TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _onSearch(),
                style: AppFonts.latoRegular.copyWith(color: AppColors.purple),
                decoration: InputDecoration(
                  hintText: AppStrings.enterCategoryHint,
                  hintStyle: AppFonts.latoRegular.copyWith(
                    color: AppColors.purple,
                  ),
                  suffixIcon: IconButton(
                    onPressed: _onSearch,
                    icon: const Icon(Icons.search_rounded),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Constants.cornerRadius40,
                    ),
                  ),
                ),
              ),

              spaceH10,

              // TITLE
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: AppColors.deepPurpleAccent,
                  child: Padding(
                    padding: EdgeInsets.all(Constants.padding10),
                    child: Text(
                      AppStrings.chooseCategory,
                      textAlign: TextAlign.center,
                      style: AppFonts.txtStyle.copyWith(
                        color: AppColors.lightGreenAccent,
                        fontSize: constants.fontSize20px,
                      ),
                    ),
                  ),
                ),
              ),

              spaceH10,

              // GRID
              Expanded(
                child: GridView.builder(
                  itemCount: AppStrings.categoryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: Constants.gridSpacing,
                    crossAxisSpacing: Constants.gridSpacing,
                  ),
                  itemBuilder: (context, index) {
                    final item = AppStrings.categoryList[index];

                    return GestureDetector(
                      onTap: () => _navigateToFeed(item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(
                            Constants.cornerRadius16,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            item.toUpperCase(),
                            style: AppFonts.txtStyle.copyWith(
                              color: AppColors.lightGreenAccent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}