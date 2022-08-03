import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/config/size_config.dart';
import 'package:socketchat/models/user/user_basic_data_model.dart';
import 'package:socketchat/models/user/user_search_model.dart';
import 'package:socketchat/models/user/user_search_result_list.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/search/search_view_model.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/search/widgets/no_search_result_found_widget.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/search/widgets/start_searching_widget.dart';
import 'package:socketchat/ui/widgets/single_chat_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late PagingController<int, UserDataBasicModel> _pagingController;

    return Scaffold(
      body: ViewModelBuilder<SearchViewModel>.nonReactive(
        disposeViewModel: false,
        onModelReady: (SearchViewModel viewModel) {
          _pagingController = viewModel.getPagingController();
        },
        builder: (context, model, child) {
          TextEditingController searchController =
              TextEditingController(text: model.textForSearch);
          searchController.addListener(
            () {
              String inputText = searchController.text;
              model.textChange(inputText);
            },
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100.horizontal(),
                color: ColorConfig.accentColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 22, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Search",
                        style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        "Find amazing people to chat",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: ColorConfig.greyColor6,
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search here...',
                          contentPadding: const EdgeInsets.only(
                              left: 26.0, bottom: 16.0, top: 18.0),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Flexible(child: SearchResultDisplayList(_pagingController))
            ],
          );
        },
        viewModelBuilder: () => locator<SearchViewModel>(),
      ),
    );
  }
}

class SearchResultDisplayList extends ViewModelWidget<SearchViewModel> {
  static const _pageSize = 14; //We declared this in server

  PagingController<int, UserDataBasicModel> _pagingController;

  SearchResultDisplayList(this._pagingController, {Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, SearchViewModel viewModel) {
    // if (viewModel.anyObjectsBusy) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // PagingController<int, UserDataBasicModel> _pagingController = PagingController(firstPageKey: 0);

    print("CALLIG 123" + viewModel.reInitializePagingController.toString());

    if (viewModel.reInitializePagingController) {
      _pagingController.removeListener(() {});
      _pagingController.removePageRequestListener((pageKey) {});
      _pagingController.removeStatusListener((status) {});
      _pagingController.refresh();

      _pagingController = PagingController(firstPageKey: 0);
      _pagingController.addPageRequestListener(
        (pageKey) async {
          List<UserDataBasicModel> searchResultData =
              await viewModel.loadSearchUserData();

          final isLastPage = searchResultData.length < _pageSize;
          if (isLastPage) {
            _pagingController.appendLastPage(searchResultData);
          } else {
            final nextPageKey = pageKey + searchResultData.length;
            _pagingController.appendPage(searchResultData, nextPageKey);
          }
          viewModel.setPagingController(_pagingController);
        },
      );
    }

    // if (viewModel.loadInitialDataComplete) {
    //   int pageKey = 0;
    //   final nextPageKey = pageKey + viewModel.searchResultList.length;
    //   _pagingController.appendPage(viewModel.searchResultList,nextPageKey);
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding:
        //       const EdgeInsets.only(left: 26, top: 6, right: 18, bottom: 14),
        //   child: ResultCountWidget(2),
        // ),
        Flexible(
          child: viewModel.textForSearch == "" ||
                  viewModel.textForSearch.length < 2
              ? const SingleChildScrollView(child: StartSearchingWidget())
              : PagedListView<int, UserDataBasicModel>.separated(
                  pagingController: _pagingController,
                  key: const PageStorageKey('listview-maintain-state-key'),
                  // itemCount: viewModel.searchResultList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 0,
                  ),
                  builderDelegate:
                      PagedChildBuilderDelegate<UserDataBasicModel>(
                    itemBuilder:
                        (context, UserDataBasicModel _userBasicModel, index) {
                      return SingleChatWidget(
                        chatClickCallback: () {
                          viewModel.gotoChatScreen(_userBasicModel);
                        },
                        name: _userBasicModel.name,
                        description: _userBasicModel.statusLine,
                        compressedProfileImage:
                            _userBasicModel.compressedProfileImage,
                      );
                    },
                    noItemsFoundIndicatorBuilder: (_) =>
                        const SingleChildScrollView(
                      child: NoSearchResultFoundWidget(),
                    ),
                  ),
                ),
        ),
      ],
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding:
    //           const EdgeInsets.only(left: 26, top: 6, right: 18, bottom: 14),
    //       child: ResultCountWidget(2),
    //     ),
    //   ],
    // );
  }
}

class ResultCountWidget extends StatelessWidget {
  int totalResultCount = 20;

  ResultCountWidget(this.totalResultCount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: totalResultCount.toString(),
              style: TextStyle(
                  color: ColorConfig.accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: " RESULTS",
              style: TextStyle(
                  color: ColorConfig.accentColor,
                  letterSpacing: 0.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 1,
            color: Colors.black38,
            width: 38,
          ),
        )
      ],
    );
  }
}
