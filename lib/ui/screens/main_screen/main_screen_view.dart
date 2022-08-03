import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/profile/profile_view.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/recent_chat/recent_chat_view.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/search/search_view.dart';
import 'package:socketchat/ui/screens/main_screen/main_screen_view_model.dart';
import 'package:stacked/stacked.dart';

class MainScreenView extends StatelessWidget {
  const MainScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelBuilder<MainScreenViewModel>.reactive(
        onModelReady: (MainScreenViewModel viewModel){
          viewModel.initializeSocket();
        },
        builder: (context, model, child) {
          return Scaffold(
            body: getViewForIndex(model.currentIndex,(){
              model.setIndex(1);
            }),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              // fixedColor: ColorConfig.accentColor,
              selectedItemColor: ColorConfig.accentColor,
              // type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: model.currentIndex,
              onTap: model.setIndex,
              items: [
                BottomNavigationBarItem(
                  activeIcon: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: SvgPicture.asset("assets/icons/chat_icon.svg",color: ColorConfig.accentColor,),
                  ),
                  icon: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: SvgPicture.asset("assets/icons/chat_icon.svg",),
                  ),
                  label:'Chat',
                ),
                BottomNavigationBarItem(
                  activeIcon: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: SvgPicture.asset("assets/icons/search_icon.svg",color: ColorConfig.accentColor,),
                  ),
                  icon: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: SvgPicture.asset("assets/icons/search_icon.svg"),
                  ),
                  label:'Search',
                ),
                BottomNavigationBarItem(
                  activeIcon: Container(
                    padding:const  EdgeInsets.only(top: 8, bottom: 4),
                    child: SvgPicture.asset("assets/icons/profile_icon.svg",color: ColorConfig.accentColor,),
                  ),
                  icon: Container(
                    padding:const  EdgeInsets.only(top: 8, bottom: 4),
                    child: SvgPicture.asset("assets/icons/profile_icon.svg"),
                  ),
                  label:'Profile',
                ),
              ],
            ),
          );
        },
        viewModelBuilder: () => MainScreenViewModel(),
      ),
    );
  }
}

Widget getViewForIndex(int index,Function gotoSearchScreen) {
  switch (index) {
    case 0:
      return  RecentChatView((){
        gotoSearchScreen();
      });
    case 1:
      return const SearchView();
    case 2:
      return const ProfileView();
    default:
      return  ProfileView();
  }
}
