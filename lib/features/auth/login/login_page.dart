import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shorts/features/auth/login/login_state.dart';

import '/config/theme/app_text_styles.dart';
import '/core/utils/extensions.dart';
import '/core/widgets/app_button.dart';
import '/core/widgets/app_text_form_field.dart';
import 'login_cubit.dart';

class LoginPage extends StatefulWidget {
  final LoginCubit cubit;

  const LoginPage({super.key, required this.cubit});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: "emilys");
  final _passwordController = TextEditingController(text: "emilyspass");
  final _passwordFocus = FocusNode();

  LoginCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    cubit.postLogin(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  AppTextFieldConfig _youtubeFieldConfig(ColorScheme scheme) {
    return AppTextFieldConfig(
      borderStyle: AppTextFieldBorderStyle.underline,
      borderWidth: 1,
      borderRadius: 0,
      filled: false,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: EdgeInsets.only(top: 4.h, bottom: 12.h, right: 4.w),
      borderColor: scheme.outline.withValues(alpha: 0.42),
      focusedBorderColor: scheme.onSurface.withValues(alpha: 0.88),
      errorBorderColor: scheme.error,
      labelColor: scheme.onSurfaceVariant,
      hintColor: scheme.onSurfaceVariant.withValues(alpha: 0.55),
      textColor: scheme.onSurface,
      cursorColor: scheme.primary,
      textStyle: AppTextStyles.bodyLarge.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: scheme.onSurfaceVariant.withValues(alpha: 0.45),
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: scheme.error,
        height: 1.3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white54,
      body: SafeArea(
        child: BlocBuilder(
          bloc: cubit,
          builder: (context, state) {
            state as LoginState;
            final fieldCfg = _youtubeFieldConfig(scheme);
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24.w,
                  8.h,
                  24.w,
                  28.h + bottomInset,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 12.h),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: scheme.primary,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: scheme.onPrimary,
                                    size: 22.r,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Shorts',
                                style: AppTextStyles.headlineSmall.copyWith(
                                  letterSpacing: -0.6,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 36.h),
                        Container(
                          padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 20.h),
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: scheme.outline.withValues(alpha: 0.14),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: scheme.shadow.withValues(alpha: 0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Sign in',
                                style: AppTextStyles.titleLarge.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  color: scheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'to continue to Shorts',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  height: 1.35,
                                ),
                              ),
                              SizedBox(height: 26.h),
                              AppTextFormField(
                                controller: _usernameController,
                                config: fieldCfg,
                                labelText: 'Email or username',
                                hintText: 'emilys',
                                type: AppTextFieldType.standard,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.username],
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Enter your username';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) =>
                                    _passwordFocus.requestFocus(),
                              ),
                              SizedBox(height: 20.h),
                              AppTextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                config: fieldCfg,
                                labelText: 'Password',
                                hintText: '',
                                type: AppTextFieldType.password,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Enter your password';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => _submit(),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.h,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    foregroundColor: scheme.primary,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot password?',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: scheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              AppButton.getButton(
                                context: context,
                                text: 'Sign in',
                                loading: state.isLoading,
                                onPressed: state.isLoading ? null : _submit,

                                elevation: 0,
                                backgroundColor: scheme.primary,
                                textColor: scheme.onPrimary,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          'Demo account: emilys / emilyspass',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant.withValues(
                              alpha: 0.85,
                            ),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
