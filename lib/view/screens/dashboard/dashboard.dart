import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vidzy/res/app_fonts.dart';
import 'package:vidzy/res/app_strings.dart';
import 'package:vidzy/view/screens/reel/reel_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(AppStrings.appName, style: AppFonts.txtStyle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: .infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.deepPurpleAccent.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: .center,
                      'Choose Category of videos',
                      style: AppFonts.txtStyle.copyWith(
                        color: Colors.lightGreenAccent,
                        fontSize: 20.sp
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: AppStrings.categoryList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = AppStrings.categoryList[index];
                  return GestureDetector(
                    onTap: (){
                      //context.read<VideoBloc>().add(FetchVideos(category: item));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReelScreen(category: item),));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      child: Center(
                        child: Text(
                          item.toUpperCase(),
                          style: AppFonts.txtStyle.copyWith(
                            color: Colors.lightGreenAccent,
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
    );
  }
}
