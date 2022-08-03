import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/config/size_config.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/profile/profile_view_model.dart';
import 'package:socketchat/ui/widgets/custom_circular_image.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (ProfileViewModel model) async {
        model.getUserData();
      },
      // fireOnModelReadyOnce: true,
      initialiseSpecialViewModelsOnce: true,
        disposeViewModel:false,
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorConfig.lightGreyBackground,
          body: Stack(
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  color: ColorConfig.accentColor,
                  width: 100.horizontal(),
                  height: 60.vertical(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                        const Flexible(
                          flex: 1,
                          child: Text(
                            "PROFILE",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4.vertical(),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CustomCircularImage(height: 130,width: 130,imageUri: model.profileImage,shouldShowWhiteBorder: true,),
                              Positioned(
                                bottom: 0,
                                right: -25,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    model.changeProfilePicture();
                                  },
                                  elevation: 2.0,
                                  fillColor: const Color(0xff455E6C),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  shape: const CircleBorder(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.vertical(),
                          ),
                          Text(
                            model.userName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.6),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.horizontal()),
                            child: Text(
                              model.userStatus,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(child: ProfileActionHolderWidget()),
                          const SizedBox(
                            height: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => locator<ProfileViewModel>(),
    );
  }
}

class ProfileActionHolderWidget extends ViewModelWidget<ProfileViewModel> {
  const ProfileActionHolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(
        top: 14.0,
        left: 8.horizontal(),
        right: 8.horizontal(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 12, left: 26, right: 12),
          //symmetric(vertical: 10, horizontal: 24),
          child: Column(
            children: [
              ProfileActionHolderSingleWidget(
                backgroundColor: Color(0xff47AA5A),
                imagePath: "assets/icons/edit_profile.svg",
                title: "Edit Profile",
                onTap: () {
                  viewModel.openEditProfileBottomSheet();
                },
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: Color(0xffDEAC43),
                imagePath: "assets/icons/share_app.svg",
                title: "Share App",
                onTap: () {},
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: Color(0xff0075FF),
                imagePath: "assets/icons/terms_and_condition.svg",
                title: "Terms and condition",
                onTap: () {},
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: Color(0xff54D0CB),
                imagePath: "assets/icons/help_support.svg",
                title: "Help and support",
                onTap: () {},
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: Color(0xff5EAA47),
                imagePath: "assets/icons/about_us.svg",
                title: "About US",
                onTap: () {},
              ),
              ProfileActionHolderSingleWidget(
                backgroundColor: Color(0xffE32929),
                imagePath: "assets/icons/logout.svg",
                title: "Logout",
                onTap: () {
                  viewModel.logoutUser();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileActionHolderSingleWidget extends StatelessWidget {
  Color backgroundColor = Color(0xff47AA5A);
  String imagePath = "";
  String title = "";
  Function() onTap;

  ProfileActionHolderSingleWidget(
      {required this.backgroundColor,
      required this.imagePath,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(imagePath),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8),
            )
          ],
        ),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
