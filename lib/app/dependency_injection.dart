import 'package:appwrite_incidence_supervisor/data/data_source/local_data_source.dart';
import 'package:appwrite_incidence_supervisor/data/data_source/remote_data_source.dart';
import 'package:appwrite_incidence_supervisor/data/network/app_api.dart';
import 'package:appwrite_incidence_supervisor/data/network/app_write_client_factory.dart';
import 'package:appwrite_incidence_supervisor/data/network/network_info.dart';
import 'package:appwrite_incidence_supervisor/data/repository/repository_impl.dart';
import 'package:appwrite_incidence_supervisor/domain/repository/repository.dart';
import 'package:appwrite_incidence_supervisor/domain/usecase/forgot_password_usecase.dart';
import 'package:appwrite_incidence_supervisor/domain/usecase/incidence_usecase.dart';
import 'package:appwrite_incidence_supervisor/domain/usecase/login_usecase.dart';
import 'package:appwrite_incidence_supervisor/domain/usecase/main_usecase.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/dialog_render/dialog_render.dart';
import 'package:appwrite_incidence_supervisor/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:appwrite_incidence_supervisor/presentation/incidence/incidence_viewmodel.dart';
import 'package:appwrite_incidence_supervisor/presentation/login/login_viewmodel.dart';
import 'package:appwrite_incidence_supervisor/presentation/main/main_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';
import 'encrypt_helper.dart';

final instance = GetIt.instance;

Future<void> initModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<EncryptHelper>(() => EncryptHelper());
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(instance(), instance()));
  if (!kIsWeb) {
    instance.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImple(InternetConnectionChecker()));
  }
  instance.registerLazySingleton<AppWriteClientFactory>(
      () => AppWriteClientFactory());
  final client = await instance<AppWriteClientFactory>().getClient();
  instance.registerLazySingleton<AppServiceClient>(
      () => AppServiceClient(client, instance()));
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), kIsWeb ? null : instance()));
  instance.registerLazySingleton<DialogRender>(() => DialogRenderImpl());
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
}

void initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance
        .registerLazySingleton<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerLazySingleton<LoginViewModel>(
        () => LoginViewModel(instance(), instance(), instance()));
  }
}

void initForgotModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerLazySingleton<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerLazySingleton<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

void initMainModule() {
  if (!GetIt.I.isRegistered<MainUseCase>()) {
    instance.registerLazySingleton<MainUseCase>(() => MainUseCase(instance()));
    instance.registerLazySingleton<MainViewModel>(
        () => MainViewModel(instance(), instance(), instance()));
  }
}

void initIncidenceModule() {
  if (!GetIt.I.isRegistered<IncidenceUseCase>()) {
    instance.registerLazySingleton<IncidenceUseCase>(
        () => IncidenceUseCase(instance()));
    instance.registerLazySingleton<IncidenceViewModel>(
        () => IncidenceViewModel(instance(),instance()));
  }
}
