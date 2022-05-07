import 'package:appwrite/appwrite.dart';
import 'package:appwrite_incidence_supervisor/app/app_preferences.dart';
import 'package:appwrite_incidence_supervisor/data/data_source/local_data_source.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_sel.dart';
import 'package:appwrite_incidence_supervisor/domain/model/name_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/user_model.dart';
import 'package:appwrite_incidence_supervisor/domain/usecase/main_usecase.dart';
import 'package:appwrite_incidence_supervisor/intl/generated/l10n.dart';
import 'package:appwrite_incidence_supervisor/presentation/base/base_viewmodel.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/state_render/state_render.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/state_render/state_render_impl.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

class MainViewModel extends BaseViewModel
    with MainViewModelInputs, MainViewModelOutputs {
  final MainUseCase _mainUseCase;
  final AppPreferences _appPreferences;
  final LocalDataSource _localDataSource;

  MainViewModel(this._mainUseCase, this._appPreferences, this._localDataSource);

  final _incidencesStrCtrl = BehaviorSubject<List<Incidence>>();
  final _activesStrCtrl = BehaviorSubject<List<bool>?>();
  final _incidenceSelStrCtrl = BehaviorSubject<IncidenceSel>();
  final _isLoading = BehaviorSubject<bool>();
  final _userStrCtrl = BehaviorSubject<UsersModel>();
  final _prioritysStrCtrl = BehaviorSubject<List<Name>>();
  final List<Incidence> _incidences = [];
  int total = 0;

  @override
  void start() {
    prioritys();
    incidences(true);
    super.start();
  }

  @override
  void dispose() async {
    _incidences.clear();
    await _incidencesStrCtrl.drain();
    _incidencesStrCtrl.close();
    await _activesStrCtrl.drain();
    _activesStrCtrl.close();
    await _incidenceSelStrCtrl.drain();
    _incidenceSelStrCtrl.close();
    await _isLoading.drain();
    _isLoading.close();
    await _userStrCtrl.drain();
    _userStrCtrl.close();
    await _prioritysStrCtrl.drain();
    _prioritysStrCtrl.close();
    super.dispose();
  }

  @override
  Sink get inputIncidences => _incidencesStrCtrl.sink;

  @override
  Sink get inputActives => _activesStrCtrl.sink;

  @override
  Sink get inputIncidenceSel => _incidenceSelStrCtrl.sink;

  @override
  Sink get inputIsLoading => _isLoading.sink;

  @override
  Sink get inputUser => _userStrCtrl.sink;

  @override
  Sink get inputPrioritys => _prioritysStrCtrl.sink;

  @override
  Stream<List<Incidence>> get outputIncidences =>
      _incidencesStrCtrl.stream.map((incidences) => incidences);

  @override
  Stream<List<bool>?> get outputActives =>
      _activesStrCtrl.stream.map((boleans) => boleans);

  @override
  Stream<IncidenceSel> get outputIncidenceSel =>
      _incidenceSelStrCtrl.stream.map((incidenceSel) => incidenceSel);

  @override
  Stream<bool> get outputIsLoading =>
      _isLoading.stream.map((isLoading) => isLoading);

  @override
  Stream<UsersModel> get outputUser => _userStrCtrl.stream.map((user) => user);

  @override
  Stream<List<Name>> get outputPrioritys =>
      _prioritysStrCtrl.stream.map((prioritys) => prioritys);

  @override
  incidences(bool firstQuery) async {
    if (_incidences.isEmpty) {
      _incidences.clear();
      (await _mainUseCase.execute(MainUseCaseInput(
              [Query.equal('area', _appPreferences.getArea())], 25, 0)))
          .fold((l) {}, (incidences) {
        total = incidences.total;
        _incidences.addAll(incidences.incidences);
        inputIncidences.add(_incidences);
      });
    } else {
      (await _mainUseCase.execute(MainUseCaseInput(
              [Query.equal('area', _appPreferences.getArea())],
              25,
              _incidences.length < total
                  ? _incidences.length - 1
                  : _incidences.length)))
          .fold((l) {}, (incidences) {
        total = incidences.total;
        _incidences.addAll(incidences.incidences);
        inputIncidences.add(_incidences);
      });
      changeIsLoading(false);
    }
    account();
  }

  @override
  incidencesPriority(String priority) async {
    _incidences.clear();
    if (_incidences.isEmpty) {
      _incidences.clear();
      (await _mainUseCase.execute(MainUseCaseInput([
        Query.equal('area', _appPreferences.getArea()),
        Query.equal('priority', priority)
      ], 25, 0)))
          .fold((l) {}, (incidences) {
        total = incidences.total;
        _incidences.addAll(incidences.incidences);
        inputIncidences.add(_incidences);
      });
    } else {
      (await _mainUseCase.execute(MainUseCaseInput(
              [
            Query.equal('area', _appPreferences.getArea()),
            Query.equal('priority', priority)
          ],
              25,
              _incidences.length > 1
                  ? _incidences.length - 1
                  : _incidences.length)))
          .fold((l) {}, (incidences) {
        total = incidences.total;
        _incidences.addAll(incidences.incidences);
        inputIncidences.add(_incidences);
      });
      changeIsLoading(false);
    }
  }

  @override
  incidencesPriorityActive(String priority, bool active) async {
    _incidences.clear();
    if (_incidences.isEmpty) {
      _incidences.clear();
      (await _mainUseCase.execute(MainUseCaseInput([
        Query.equal('area', _appPreferences.getArea()),
        Query.equal('priority', priority),
        Query.equal('active', active)
      ], 25, 0)))
          .fold((l) {}, (incidences) {
        total = incidences.total;
        _incidences.addAll(incidences.incidences);
        inputIncidences.add(_incidences);
      });
    } else {
      (await _mainUseCase.execute(MainUseCaseInput(
              [
            Query.equal('area', _appPreferences.getArea()),
            Query.equal('priority', priority),
            Query.equal('active', active)
          ],
              25,
              _incidences.length > 1
                  ? _incidences.length - 1
                  : _incidences.length)))
          .fold((l) {}, (incidences) {
        total = incidences.total;
        _incidences.addAll(incidences.incidences);
        inputIncidences.add(_incidences);
      });
      changeIsLoading(false);
    }
  }

  @override
  changeIsLoading(bool isLoading) {
    inputIsLoading.add(isLoading);
  }

  @override
  changeIncidenceSel(IncidenceSel incidenceSel) async {
    inputIncidenceSel.add(incidenceSel);
    _incidences.clear();
    if (incidenceSel.priority != '') {
      inputActives.add([true, false]);
      if (incidenceSel.active == null) {
        await incidencesPriority(incidenceSel.priority);
      } else {
        await incidencesPriorityActive(
            incidenceSel.priority, incidenceSel.active ?? false);
      }
    }
  }

  @override
  deleteSession(BuildContext context) async {
    final s = S.of(context);
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
        message: s.loading));
    final sessionId = _appPreferences.getSessionId();
    (await _mainUseCase.deleteSession(sessionId)).fold((f) {
      inputState
          .add(ErrorState(StateRendererType.fullScreenErrorState, f.message));
    }, (r) async {
      inputState.add(ContentState());
      await _appPreferences.logout();
      _localDataSource.clearCache();
      GoRouter.of(context).go(Routes.splashRoute);
    });
  }

  @override
  account() async {
    (await _mainUseCase.user(_appPreferences.getUserId())).fold((f) => null,
        (user) async {
      inputUser.add(user);
    });
  }

  @override
  prioritys() async {
    (await _mainUseCase.prioritys(null)).fold((l) {}, (prioritys) {
      inputPrioritys.add(prioritys);
    });
  }
}

abstract class MainViewModelInputs {
  Sink get inputIncidences;

  Sink get inputActives;

  Sink get inputIncidenceSel;

  Sink get inputIsLoading;

  Sink get inputUser;

  Sink get inputPrioritys;

  incidences(bool firstQuery);

  incidencesPriority(String priority);

  incidencesPriorityActive(String priority, bool active);

  changeIsLoading(bool isLoading);

  changeIncidenceSel(IncidenceSel incidenceSel);

  deleteSession(BuildContext context);

  account();

  prioritys();
}

abstract class MainViewModelOutputs {
  Stream<List<Incidence>> get outputIncidences;

  Stream<List<bool>?> get outputActives;

  Stream<IncidenceSel> get outputIncidenceSel;

  Stream<bool> get outputIsLoading;

  Stream<UsersModel> get outputUser;

  Stream<List<Name>> get outputPrioritys;
}
