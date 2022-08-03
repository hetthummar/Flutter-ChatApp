import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/models/user/user_basic_data_model.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/recent_chat/recent_chat_view_model.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/recent_chat/widgets/empty_chat_screen.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/search/widgets/no_search_result_found_widget.dart';
import 'package:socketchat/ui/widgets/single_chat_widget.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:socketchat/utils/date_time_util.dart';
import 'package:stacked/stacked.dart';

class RecentChatView extends StatelessWidget {
  Function gotoSearchCallback;

  RecentChatView(this.gotoSearchCallback);

  @override
  Widget build(BuildContext context) {
    // return EmptyChatScreen(buttonPressedCallBack:(){
    //
    // });

    return ViewModelBuilder<RecentChatViewModel>.nonReactive(
      onModelReady: (RecentChatViewModel viewModel) async {
        await viewModel.getUserId();
      },
      viewModelBuilder: () => RecentChatViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: SearchAppBarWidget(
              onChange: (String val) {
                print("HET :- " + val.toString());
              },
              onDone: (String val) {
                print("HET 1:- " + val.toString());
              },
              onClose: () {},
              onCleared: () {},
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: allRecentChatDisplayWidget(() {
                gotoSearchCallback();
              })),
        );
      },
    );

    // return Column(
    //   children: [
    //     SingleChatWidget().
    //   ]
    // );
  }
}

class allRecentChatDisplayWidget extends ViewModelWidget<RecentChatViewModel> {
  Function gotoSearchCallback;

  allRecentChatDisplayWidget(this.gotoSearchCallback);

  @override
  Widget build(BuildContext context, RecentChatViewModel viewModel) {
    return StreamBuilder(
      stream: viewModel.getRecentChats(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {

          if (snapshot.hasData) {

            if(snapshot.data!.length == 0){
              return EmptyChatScreen(
                buttonPressedCallBack: () {
                  gotoSearchCallback();
                },
              );
            }

            print("HEt :- " + snapshot.data!.length.toString());

            return ListView.separated(
              key: const PageStorageKey(
                  'listview-recent-chat-maintain-state-key'),
              itemCount: snapshot.data!.length,
              // controller: _msgScrollController,
              itemBuilder: (BuildContext context, int index) {
                RecentChatTableData _recentChatTableData =
                    snapshot.data![index];

                String name = "";
                String? compressedProfileImage;

                int indexOfUserId = _recentChatTableData.participants
                    .indexWhere((element) => element == viewModel.userId);

                String lastMsg = _recentChatTableData.last_msg_text ?? "";

                name = _recentChatTableData.user_name;
                compressedProfileImage =
                    _recentChatTableData.user_compressed_image;

                List<String> participants =
                    List.from(_recentChatTableData.participants);

                print("participants 0:- " + participants.toString());

                participants
                    .removeWhere((element) => element == viewModel.userId);

                print("participants 1 :- " + participants.toString());

                return SingleChatWidget(
                  chatClickCallback: () {
                    UserDataBasicModel _userDataBasicModel = UserDataBasicModel(
                        name: name,
                        id: participants[0],
                        statusLine: "",
                        compressedProfileImage: compressedProfileImage);
                    viewModel.gotoChatScreen(_userDataBasicModel);
                  },
                  name: name,
                  description: lastMsg,
                  compressedProfileImage: compressedProfileImage,
                  time: DateTimeUtil()
                      .getTimeAgo(_recentChatTableData.last_msg_time),
                  unreadMessage: _recentChatTableData.unread_msg,
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0,
                color: ColorConfig.greyColor5,
              ),
            );
          } else {
            return EmptyChatScreen(
              buttonPressedCallBack: () {
                gotoSearchCallback();
              },
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

//
// class searchAppBarWidget extends StatefulWidget {
//    late SearchBar searchBar;
//
//    @override
//   _searchAppBarWidgetState createState() => _searchAppBarWidgetState();
// }
//
// class _searchAppBarWidgetState extends State<searchAppBarWidget> {
//
//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//         title: const Text('My Home Page'),
//         actions: [widget.searchBar.getSearchAction(context)]);
//   }
//
//   _searchAppBarWidgetState(){
//     widget.searchBar =  SearchBar(
//         inBar: true,
//         buildDefaultAppBar: buildAppBar,
//         setState: setState,
//         onCleared: () {
//           print("cleared");
//         },
//         onClosed: () {
//           print("closed");
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("HET");
//
//
//
//
//     return widget.searchBar.build(context);
//   }
// }

class SearchAppBarWidget extends StatefulWidget {
  Function(String val) onChange;
  Function(String val) onDone;
  Function() onCleared;
  Function() onClose;

  SearchAppBarWidget(
      {Key? key,
      required this.onChange,
      required this.onDone,
      required this.onCleared,
      required this.onClose})
      : super(key: key);

  @override
  State createState() {
    return _SearchBarDemoHomeState();
  }
}

class _SearchBarDemoHomeState extends State<SearchAppBarWidget> {
  late SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: ColorConfig.accentColor,
        title: const Text(
          "Chat App",
          style: TextStyle(
              fontSize: 16, letterSpacing: 0.8, fontWeight: FontWeight.w600),
        ),
        actions: [searchBar.getSearchAction(context)]);
  }

  _SearchBarDemoHomeState() {
    searchBar = SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: (String val) {
          widget.onChange(val);
        },
        onSubmitted: (String val) {
          widget.onDone(val);
        },
        onCleared: () {
          widget.onCleared();
        },
        onClosed: () {
          widget.onClose();
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return searchBar.build(context);
  }
}
