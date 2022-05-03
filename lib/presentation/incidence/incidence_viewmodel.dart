import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_sel.dart';
import 'package:appwrite_incidence_supervisor/domain/model/name_model.dart';
import 'package:appwrite_incidence_supervisor/domain/usecase/incidence_usecase.dart';
import 'package:appwrite_incidence_supervisor/intl/generated/l10n.dart';
import 'package:appwrite_incidence_supervisor/presentation/base/base_viewmodel.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/dialog_render/dialog_render.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/state_render/state_render.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/state_render/state_render_impl.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/routes_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class IncidenceViewModel extends BaseViewModel
    with IncidenceViewModelInputs, IncidenceViewModelOutputs {
  final IncidenceUseCase _incidenceUseCase;
  final DialogRender _dialogRender;

  IncidenceViewModel(this._incidenceUseCase,this._dialogRender);

  final _prioritysStrCtrl = BehaviorSubject<List<Name>>();
  final _incidenceSelStrCtrl = BehaviorSubject<IncidenceSel>();
  final ImagePicker _picker = ImagePicker();

  @override
  void start() {
    prioritys();
    super.start();
  }

  @override
  void dispose() async {
    await _prioritysStrCtrl.drain();
    _prioritysStrCtrl.close();
    await _incidenceSelStrCtrl.drain();
    _incidenceSelStrCtrl.close();
    super.dispose();
  }

  @override
  Sink get inputPrioritys => _prioritysStrCtrl.sink;

  @override
  Sink get inputIncidenceSel => _incidenceSelStrCtrl.sink;

  @override
  Stream<List<Name>> get outputPrioritys =>
      _prioritysStrCtrl.stream.map((prioritys) => prioritys);

  @override
  Stream<IncidenceSel> get outputIncidenceSel =>
      _incidenceSelStrCtrl.stream.map((incidenceSel) => incidenceSel);

  @override
  Future<Incidence?> incidence(BuildContext context, String incidenceId) async {
    final s = S.of(context);
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
        message: s.loading));
    return (await _incidenceUseCase.incidence(incidenceId)).fold((failure) {
      inputState.add(
          ErrorState(StateRendererType.fullScreenErrorState, failure.message));
      return null;
    }, (r) {
      inputState.add(ContentState());
      return r;
    });
  }

  @override
  changeIncidenceSel(IncidenceSel incidenceSel) {
    inputIncidenceSel.add(incidenceSel);
  }

  @override
  pickImage(IncidenceSel incidenceSel) async {
    XFile? xFile;
    if (kIsWeb) {
      xFile = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      xFile = await _picker.pickImage(source: ImageSource.camera);
    }
    if (xFile != null) {
      final uint8list = await xFile.readAsBytes();
      final name = xFile.name;
      (await _incidenceUseCase
              .createFile(IncidenceUseCaseFile(uint8list, name)))
          .fold((l) => null, (file) {
        inputIncidenceSel.add(IncidenceSel(
            area: incidenceSel.area,
            priority: incidenceSel.priority,
            active: incidenceSel.active,
            image: file.$id));
      });
    }
  }

  @override
  prioritys() async {
    (await _incidenceUseCase.prioritys(null)).fold((l) {}, (prioritys) {
      inputPrioritys.add(prioritys);
    });
  }
  @override
  createIncidence(Incidence incidence, BuildContext context) async {
    final s = S.of(context);
    (await _incidenceUseCase.incidenceCreate(incidence)).fold(
            (l) => _dialogRender.showPopUp(context, DialogRendererType.errorDialog,
            (s.error).toUpperCase(), l.message, null, null, null), (r) {
      inputIncidenceSel.add(IncidenceSel());
      GoRouter.of(context).go(Routes.mainRoute);
    });
  }
}

abstract class IncidenceViewModelInputs {
  Sink get inputPrioritys;

  Sink get inputIncidenceSel;

  Future<Incidence?> incidence(BuildContext context, String incidenceId);

  changeIncidenceSel(IncidenceSel incidenceSel);

  pickImage(IncidenceSel incidenceSel);

  prioritys(); createIncidence(Incidence incidence, BuildContext context);
}

abstract class IncidenceViewModelOutputs {
  Stream<List<Name>> get outputPrioritys;

  Stream<IncidenceSel> get outputIncidenceSel;
}
