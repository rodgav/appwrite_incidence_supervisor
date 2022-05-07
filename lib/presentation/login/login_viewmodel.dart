import 'package:appwrite_incidence_supervisor/app/app_preferences.dart';
import 'package:appwrite_incidence_supervisor/intl/generated/l10n.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/dialog_render/dialog_render.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:appwrite_incidence_supervisor/app/functions.dart';
import 'package:appwrite_incidence_supervisor/domain/usecase/login_usecase.dart';
import 'package:appwrite_incidence_supervisor/presentation/base/base_viewmodel.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/freezed_data_classes.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/state_render/state_render.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/state_render/state_render_impl.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/strings_manager.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInput, LoginViewModelOutput {
  final LoginUseCase _loginUsecase;
  final AppPreferences _appPreferences;
  final DialogRender _dialogRender;

  LoginViewModel(this._loginUsecase, this._appPreferences, this._dialogRender);

  final _emailStreCtrl = BehaviorSubject<String>();
  final _passwordStreCtrl = BehaviorSubject<String>();
  final _inputsStreCtrl = BehaviorSubject<void>();

  LoginObject _loginObject = LoginObject('', '', '');

  @override
  Sink get inputInputsValid => _inputsStreCtrl.sink;

  @override
  Sink get inputPassword => _passwordStreCtrl.sink;

  @override
  Sink get inputEmail => _emailStreCtrl.sink;

  @override
  login(BuildContext context) async {
    final s = S.of(context);
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
        message: AppStrings.empty));
    (await _loginUsecase.execute(
            LoginUseCaseInput(_loginObject.username, _loginObject.password)))
        .fold((f) {
      inputState
          .add(ErrorState(StateRendererType.fullScreenErrorState, f.message));
    }, (r) async {
      (await _loginUsecase.user(r.userId)).fold(
          (f) => inputState.add(
              ErrorState(StateRendererType.fullScreenErrorState, f.message)),
          (user) async {
        if (user.active && user.typeUser == AppStrings.supervisor) {
          await _appPreferences.setSessionIds(
              r.$id, r.userId, user.name, user.typeUser, user.area);
          GoRouter.of(context).go(Routes.mainRoute);
        } else {
          _dialogRender.showPopUp(
              context,
              DialogRendererType.errorDialog,
              (s.error).toUpperCase(),
              '${s.notPermission}\n${user.typeUser}\nstatus:${user.active}',
              null,
              null,
              null);
          inputState.add(ContentState());
        }
      });
    });
  }

  @override
  Stream<bool> get outputEmailValid => _emailStreCtrl.stream.map(isEmailValid);

  @override
  Stream<String?> get outputErrorEmail => outputEmailValid
      .map((emailValid) => emailValid ? null : 'Invalidate email');

  @override
  Stream<bool> get outputInputValid =>
      _inputsStreCtrl.stream.map((_) => _inputsValid());

  @override
  Stream<bool> get outputPasswordValid =>
      _passwordStreCtrl.stream.map((password) => _passwordValid(password));

  @override
  Stream<String?> get outputErrorPassword => outputPasswordValid
      .map((passwordValid) => passwordValid ? null : 'Invalidate password');

  @override
  setEmail(String email) {
    inputEmail.add(email);
    _loginObject = _loginObject.copyWith(username: email);
    _validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    _loginObject = _loginObject.copyWith(password: password);
    _validate();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreCtrl.close();
    _passwordStreCtrl.close();
    _inputsStreCtrl.close();
    super.dispose();
  }

  _validate() {
    inputInputsValid.add(null);
  }

  bool _passwordValid(String password) {
    return password.length >= 8;
  }

  bool _inputsValid() {
    return _loginObject.username.isNotEmpty && _loginObject.password.isNotEmpty;
  }
}

abstract class LoginViewModelInput {
  setEmail(String email);

  setPassword(String password);

  login(BuildContext context);

  Sink get inputEmail;

  Sink get inputPassword;

  Sink get inputInputsValid;
}

abstract class LoginViewModelOutput {
  Stream<bool> get outputEmailValid;

  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputPasswordValid;

  Stream<String?> get outputErrorPassword;

  Stream<bool> get outputInputValid;
}
