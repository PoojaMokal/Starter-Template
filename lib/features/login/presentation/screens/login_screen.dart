import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/dependency/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends HookWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final userIdController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    void submit() {
      context.hideKeyboard();
      if (!formKey.currentState!.validate()) return;
      context.read<LoginBloc>().add(
        LoginEvent.submitted(
          userId: userIdController.text,
          password: passwordController.text,
        ),
      );
    }

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        switch (state) {
          case LoginSuccess():
            context.showSnackBar(AppStrings.loginSuccess);
          // TODO: navigate to the first post-login screen, e.g.
          // context.go(RoutePath.dashboard.path);
          case LoginFailure(:final message):
            context.showSnackBar(message, isError: true);
          case LoginInitial() || LoginLoading():
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return CustomScaffold(
          showAppBar: false,
          isLoading: isLoading,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.welcomeBack,
                    style: context.textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppStrings.loginSubtitle,
                    style: context.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 32.h),
                  AppTextField(
                    controller: userIdController,
                    label: AppStrings.userId,
                    prefixIcon: const Icon(Icons.person_outline),
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value.isNullOrEmpty ? AppStrings.userIdRequired : null,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: passwordController,
                    label: AppStrings.password,
                    obscureText: obscurePassword.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          obscurePassword.value = !obscurePassword.value,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => submit(),
                    validator: (value) => value.isNullOrEmpty
                        ? AppStrings.passwordRequired
                        : null,
                  ),
                  SizedBox(height: 32.h),
                  AppButton(
                    label: AppStrings.login,
                    isLoading: isLoading,
                    onPressed: submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
