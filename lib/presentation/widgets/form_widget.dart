// ignore_for_file: must_be_immutable

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../core/themes/app_theme.dart';
import '../features/auth/bloc/auth_bloc.dart';
import 'text_field_widget.dart';

enum Inputs {
  username,
  email,
  phone,
  password,
  image,
  code,
  promoCode,
  gender,
  dob,
  confirmPassword,
}

class FormWidget extends StatelessWidget {
  TextEditingController? usernameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? phoneController;
  TextEditingController? codeController;
  TextEditingController? promoCodeController;
  TextEditingController? dobController;
  TextEditingController? confirmPasswordController;
  BuildContext? context;
  final String route;
  bool isShow = false;

  FormWidget({
    Key? key,
    this.emailController,
    this.phoneController,
    this.passwordController,
    this.usernameController,
    this.codeController,
    this.promoCodeController,
    this.dobController,
    this.context,
    this.confirmPasswordController,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _forms(),
    );
  }

  List<Widget> _forms() {
    if (route == Routes.loginPage) {
      return [
        textFields(Inputs.email),
        const SizedBox(height: MySizes.verticalPadding),
        textFields(Inputs.password),
      ];
    }
    if (route == Routes.registerPage) {
      return [
        textFields(Inputs.image),
        const SizedBox(height: MySizes.verticalPadding),
        textFields(Inputs.username),
        const SizedBox(height: MySizes.verticalPadding),
        textFields(Inputs.dob),
        const SizedBox(height: MySizes.verticalPadding),
        textFields(Inputs.phone),
        const SizedBox(height: MySizes.verticalPadding),
        textFields(Inputs.email),
        const SizedBox(height: MySizes.verticalPadding),
        textFields(Inputs.password),
        const SizedBox(height: MySizes.verticalPadding),
        textFields(Inputs.confirmPassword),
      ];
    }
    if (route == Routes.verifyEmailPage) {
      return [
        textFields(Inputs.email),
      ];
    }
    if (route == Routes.verifyCodePage) {
      return [
        textFields(Inputs.code),
      ];
    }
    if (route == Routes.resetPasswordPage) {
      return [
        textFields(Inputs.password),
      ];
    }
    return [
      textFields(Inputs.username),
    ];
  }

  Widget textFields(Inputs e) {
    switch (e) {
      case Inputs.username:
        return TextFieldWidget(
          controller: usernameController!,
          hint: 'Enter name',
          keyboard: TextInputType.text,
          prefixIcon: Icons.person,
          validator: () {},
          onTap: () {},
        );
      case Inputs.email:
        return TextFieldWidget(
          controller: emailController!,
          hint: 'Enter email',
          keyboard: TextInputType.emailAddress,
          prefixIcon: Icons.email,
          validator: () {},
          onTap: () {},
        );
      case Inputs.phone:
        return IntlPhoneField(
          initialCountryCode: 'IN',
          controller: phoneController,
          disableLengthCheck: true,
          pickerDialogStyle: PickerDialogStyle(
            countryNameStyle: Theme.of(context!).textTheme.bodySmall,
            countryCodeStyle: Theme.of(context!).textTheme.bodySmall,
            listTileDivider: Container(),
            searchFieldInputDecoration: const InputDecoration(
              hintText: 'search',
              border: OutlineInputBorder(),
            ),
          ),
          showCountryFlag: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (phone) {},
          onCountryChanged: (country) {},
        );
      case Inputs.password:
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.showPassword) {
              isShow = !isShow;
            }
          },
          builder: (context, state) {
            return TextFieldWidget(
              controller: passwordController!,
              hint: 'Enter password',
              keyboard: TextInputType.text,
              prefixIcon: Icons.lock,
              isPassword: !isShow,
              suffixIcon: state.showPassword == true
                  ? state.icon
                  : Icons.visibility_off_sharp,
              suffixIconPressed: () {
                context.read<AuthBloc>().add(
                      ChangeIconSuffixEvent(showPassword: !isShow),
                    );
              },
              validator: () {},
              onTap: () {},
            );
          },
        );
      case Inputs.confirmPassword:
        return TextFieldWidget(
          controller: confirmPasswordController!,
          hint: 'Confirm password',
          keyboard: TextInputType.text,
          prefixIcon: Icons.lock,
          isPassword: true,
          validator: () {},
          onTap: () {},
        );
      case Inputs.dob:
        return TextFieldWidget(
          controller: dobController!,
          hint: 'Enter date of birth',
          keyboard: TextInputType.datetime,
          prefixIcon: Icons.date_range_rounded,
          validator: () {},
          onTap: () {
            showDatePicker(
              context: context!,
              initialDate: DateTime.now(),
              firstDate: DateTime.parse('1900-01-01'),
              lastDate: DateTime.now(),
            ).then((value) {
              dobController!.text = DateFormat().add_yMd().format(value!);
            });
          },
        );
      case Inputs.gender:
        return Container();
      case Inputs.image:
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: MySizes.imageHeight,
                  width: MySizes.imageWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MySizes.imageRadius),
                      image: state.file != null
                          ? DecorationImage(
                              image: FileImage(state.file!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                "assets/images/defaultImage.jpg",
                              ),
                              fit: BoxFit.cover,
                            )),
                ),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(MySizes.verticalPadding),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(MySizes.imageRadius),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                  onTap: () => context.read<AuthBloc>().add(
                        PickUserImageEvent(),
                      ),
                ),
              ],
            );
          },
        );
      case Inputs.code:
        return SizedBox(
          height: 55,
          child: PinCodeTextField(
            length: 6,
            obscureText: false,
            enablePinAutofill: false,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(MySizes.radius),
                fieldHeight: 55,
                fieldWidth: 55,
                borderWidth: .3,
                activeColor: MyColors.borderColor,
                selectedColor: MyColors.primaryColor,
                inactiveColor: MyColors.borderColor),
            backgroundColor: MyColors.backgroundColor,
            animationDuration: const Duration(milliseconds: 300),
            controller: codeController,
            onCompleted: (v) {},
            onChanged: (value) {},
            beforeTextPaste: (text) {
              return true;
            },
            appContext: context!,
          ),
        );
      case Inputs.promoCode:
        return Container();
      default:
        return Container();
    }
  }
}
