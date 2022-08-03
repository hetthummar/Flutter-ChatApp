import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socketchat/app/locator.dart';
import 'package:flutter/material.dart';
import 'package:socketchat/app/routes/style_config.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/ui/widgets/custom_button.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:socketchat/const/enums/bottom_sheet_enums.dart';

void setUpBototmSheet() {
  final bottomSheetService = locator<BottomSheetService>();
  final builders = {
    bottomSheetEnum.basic: (context, sheetRequest, completer) =>
        _BasicDialog(request: sheetRequest, completer: completer),
    bottomSheetEnum.error: (context, sheetRequest, completer) =>
        _ErrorDilog(request: sheetRequest, completer: completer),
    bottomSheetEnum.noInternet: (context, sheetRequest, completer) =>
        _NoInternetDilog(request: sheetRequest, completer: completer),
    bottomSheetEnum.editProfile: (context, sheetRequest, completer) =>
        _EditProfileBottomSheet(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class _EditProfileBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  // TextEditingController _nameController;
  // TextEditingController _statusController;

  const _EditProfileBottomSheet({
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController(text: request.data['name']);
    TextEditingController _statusController = TextEditingController(text: request.data['status']);
    var _formKey = request.data['form_key'];

    return Container(
      // margin: EdgeInsets.all(25),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
                    completer(SheetResponse(data: null));
                  },
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset("assets/icons/close.svg")),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Edit profile",
              style: h1Title.copyWith(
                  fontSize: 26, color: Colors.black87, letterSpacing: 0.8),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Enter new name and status for update in socket chat",
              style: h5Title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            validator: (text) {
                              if (text == null || text.length < 2) {
                                return "Name should contain more than 1 characters";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.person_outline),
                                fillColor: Color(0xffF2F2F2),
                                focusColor:  Color(0xffDEAC43),
                                hintText: 'Enter Your Name',
                                contentPadding: EdgeInsets.only(
                                    left: 26.0, bottom: 20.0, top: 20.0),
                                border: InputBorder.none),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _statusController,
                            validator: (text) {
                              if (text == null || text.length < 2) {
                                return "Status should contain more than 1 characters";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.remember_me),
                                fillColor: Color(0xffF2F2F2),
                                hintText: 'Enter Your status',
                                contentPadding: EdgeInsets.only(
                                    left: 26.0, bottom: 20.0, top: 20.0),
                                border: InputBorder.none),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              child: CustomButton(
                "SAVE",
                buttonPressed: () {

                  if(_formKey.currentState!.validate()){
                    String name = _nameController.value.text;
                    String status = _statusController.value.text;

                    Map<String, String> dialogResult = {};
                    dialogResult.putIfAbsent("name", () => name);
                    dialogResult.putIfAbsent("status", () => status);

                    completer(SheetResponse(data: dialogResult));
                  }
                },
              ),
            ),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicDialog extends StatelessWidget {
  final SheetRequest request;
  final Function(DialogResponse) completer;

  const _BasicDialog({required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      child: Text("Basic"),
    ));
  }
}

class _ErrorDilog extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const _ErrorDilog({
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            request.title ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 4),
          Text(
            request.description ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => completer(SheetResponse(confirmed: true)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                    child: Text(
                  request.mainButtonTitle ?? "OK",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _NoInternetDilog extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const _NoInternetDilog({
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            request.title ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 4),
          Text(
            request.description ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => completer(SheetResponse(confirmed: true)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    request.mainButtonTitle ?? "OK",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
