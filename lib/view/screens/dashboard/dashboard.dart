import 'package:flutter/material.dart';
import 'package:vidzy/core/constants.dart';
import 'package:vidzy/res/app_colors.dart';
import 'package:vidzy/res/app_fonts.dart';
import 'package:vidzy/res/app_strings.dart';
import 'package:vidzy/res/spaces.dart';
import 'package:vidzy/view/screens/reel/feed_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});


  @override
  Widget build(BuildContext context) {

    TextEditingController txtController = TextEditingController();

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

              SizedBox(
                width: .infinity,
                child: Card(
                  color: AppColors.deepPurpleAccent,
                  child: Text(
                    textAlign: .center,
                    AppStrings.chooseCategory,
                    style: AppFonts.txtStyle.copyWith(
                      color: AppColors.lightGreenAccent,
                      fontSize: constants.fontSize20px,
                    ),
                  ),
                ),
              ),
              spaceH10,

              TextField(
                controller: txtController,
                style: AppFonts.latoRegular.copyWith(color: AppColors.purple),
                decoration: InputDecoration(
                  hintText: AppStrings.enterCategoryHint,
                  hintStyle: AppFonts.latoRegular.copyWith(
                    color: AppColors.purple,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (txtController.text.isNotEmpty &&
                          txtController.text != '') {
                        _navigationToVideoScreen(
                          videoCategory: txtController.text,
                          context: context,
                        );
                      }
                    },
                    icon: Icon(Icons.search_rounded),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Constants.cornerRadius40,
                    ),
                  ),
                ),
              ),

              spaceH10,

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
                      onTap: () {
                        _navigationToVideoScreen(
                          videoCategory: item,
                          context: context,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.deepPurpleAccent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Constants.cornerRadius16),
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

  void _navigationToVideoScreen({
    required String videoCategory,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedScreen(category: videoCategory),
      ),
    );
  }
}
