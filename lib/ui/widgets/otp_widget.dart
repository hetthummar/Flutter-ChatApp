import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:socketchat/config/color_config.dart';


class OtpWidget extends StatelessWidget {

  final Function(String otp) callback;
  const OtpWidget(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      length: 6,
      pinTheme: PinTheme(
        fieldOuterPadding: const EdgeInsets.all(4),
        activeColor: Colors.black54,
        shape: PinCodeFieldShape.underline,
        borderWidth: 2,
        fieldHeight: 50,
        fieldWidth: 40,
        selectedColor: ColorConfig.accentColor.withOpacity(0.5),
        inactiveColor: ColorConfig.accentColor.withOpacity(0.5),
        activeFillColor: ColorConfig.accentColor.withOpacity(0.5),
        // selectedColor: ColorConfig.accentColor.withOpacity(0.5),
        // inactiveColor: Colors.black38,
        disabledColor: Colors.black38,
      ),
      backgroundColor: Colors.transparent,
      onCompleted: (v) {},
      cursorColor: Colors.black38,
      onChanged: (value) {
        callback(value);
      },
      beforeTextPaste: (text) {
        return true;
      },
      appContext: context,
    );
  }
}
