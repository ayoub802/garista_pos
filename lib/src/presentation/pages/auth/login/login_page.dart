import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garista_pos/src/presentation/pages/main/main_page.dart';
import 'package:garista_pos/src/presentation/theme/app_colors.dart';
import '../../../components/components.dart';
import '../../../../core/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:garista_pos/src/presentation/components/custom_checkbox.dart';
import 'package:garista_pos/src/presentation/pages/auth/login/widgets/custom_passwords.dart';
import '../../../../../generated/assets.dart';
import '../../../../core/utils/utils.dart';
import '../../../components/text_fields/custom_textformfield.dart';
import '../../../theme/theme.dart';
import 'riverpod/provider/login_provider.dart';
import '../../pages.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(loginProvider.notifier);
    final state = ref.watch(loginProvider);
    return KeyboardDismisser(
        child: AbsorbPointer(
      absorbing: state.isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.mainBack,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              SafeArea(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500.r),
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.r, right: 50.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        42.verticalSpace,
                        Row(
                          children: [
                            SvgPicture.asset(
                              Assets.svgLogo,
                              height: 40,
                              width: 40,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Text(
                                AppHelpers.getAppName() ?? "foodyman",
                                style: GoogleFonts.inter(
                                    fontSize: 32.sp,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        56.verticalSpace,
                        Text(
                          AppHelpers.getTranslation(TrKeys.login),
                          style: GoogleFonts.inter(
                              fontSize: 32.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        36.verticalSpace,
                        Text(
                          AppHelpers.getTranslation(TrKeys.email),
                          style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        CustomTextField(
                          hintText:
                              AppHelpers.getTranslation(TrKeys.typeSomething),
                          onChanged: notifier.setEmail,
                          textController: login,
                          inputType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          isError: state.isLoginError || state.isEmailNotValid,
                          descriptionText: state.isEmailNotValid
                              ? AppHelpers.getTranslation(
                                  TrKeys.emailIsNotValid)
                              : (state.isLoginError
                                  ? AppHelpers.getTranslation(
                                      TrKeys.loginCredentialsAreNotValid)
                                  : null),
                          onFieldSubmitted: (value) => notifier.login(
                            context: context,
                            goToMain: () {
                              // context.replaceRoute(const MainRoute());
                              const MainPage();
                              print("Success");
                            },
                          ),
                        ),
                        50.verticalSpace,
                        Text(
                          AppHelpers.getTranslation(TrKeys.password),
                          style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        CustomTextField(
                          textController: password,
                          hintText:
                              AppHelpers.getTranslation(TrKeys.typeSomething),
                          obscure: state.showPassword,
                          // label: AppHelpers.getTranslation(TrKeys.password),
                          onChanged: notifier.setPassword,
                          textCapitalization: TextCapitalization.none,
                          isError:
                              state.isLoginError || state.isPasswordNotValid,
                          descriptionText: state.isPasswordNotValid
                              ? AppHelpers.getTranslation(TrKeys
                                  .passwordShouldContainMinimum8Characters)
                              : (state.isLoginError
                                  ? AppHelpers.getTranslation(
                                      TrKeys.loginCredentialsAreNotValid)
                                  : null),
                          suffixIcon: IconButton(
                            splashRadius: 25.r,
                            icon: Icon(
                              state.showPassword
                                  ? FlutterRemix.eye_line
                                  : FlutterRemix.eye_close_line,
                              color: AppColors.black,
                              size: 20.r,
                            ),
                            onPressed: () =>
                                notifier.setShowPassword(!state.showPassword),
                          ),
                          onFieldSubmitted: (value) => notifier.login(
                            context: context,
                            goToMain: () {
                              bool checkPin = LocalStorage.getPinCode().isEmpty;
                              // context.replaceRoute(
                              //     PinCodeRoute(isNewPassword: checkPin));
                            },
                          ),
                        ),
                        42.verticalSpace,
                        Row(
                          children: [
                            CustomCheckbox(isActive: true, onTap: () {}),
                            14.horizontalSpace,
                            Text(
                              AppHelpers.getTranslation(TrKeys.keepMe),
                              style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        56.verticalSpace,
                        LoginButton(
                          isLoading: state.isLoading,
                          title: AppHelpers.getTranslation(TrKeys.login),
                          onPressed: () => notifier.login(
                            context: context,
                            goToMain: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()),
                              );
                            },
                          ),
                        ),
                        if (AppConstants.isDemo)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomPasswords(
                                  type: TrKeys.seller,
                                  onTap: () {
                                    login.text = AppConstants.demoSellerLogin;
                                    password.text =
                                        AppConstants.demoSellerPassword;
                                    notifier
                                        .setEmail(AppConstants.demoSellerLogin);
                                    notifier.setPassword(
                                        AppConstants.demoSellerPassword);
                                  },
                                ),
                                8.verticalSpace,
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Image.asset(
                Assets.pngGaristaBanner,
                height: double.infinity,
                fit: BoxFit.cover,
              )),
            ],
          ),
        ),
      ),
    ));
  }
}