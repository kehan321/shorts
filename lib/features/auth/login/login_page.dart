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

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,

        child: SafeArea(
          child: BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              state as LoginState;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24.w,
                  32.h,
                  24.w,
                  24.h + bottomInset,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        'Welcome back',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sign in to continue. DummyJSON demo: emilys / emilyspass',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      AppTextFormField(
                        controller: _usernameController,
                        labelText: 'Username',
                        hintText: 'e.g. emilys',
                        type: AppTextFieldType.standard,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter your username';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _passwordFocus.requestFocus();
                        },
                      ),
                      SizedBox(height: 16.h),
                      AppTextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        labelText: 'Password',
                        hintText: '••••••••',
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
                      SizedBox(height: 32.h),
                      AppButton.getButton(
                        context: context,
                        text: 'Sign in',
                        loading: state.isLoading,
                        onPressed: state.isLoading ? null : _submit,
                        height: 52,
                        radius: 16,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        backgroundColor: scheme.primary,
                        textColor: scheme.onPrimary,
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: Text(
                          'Shorts',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
