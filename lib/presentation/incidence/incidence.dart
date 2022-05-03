import 'package:appwrite_incidence_supervisor/app/app_preferences.dart';
import 'package:appwrite_incidence_supervisor/app/constants.dart';
import 'package:appwrite_incidence_supervisor/app/dependency_injection.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_sel.dart';
import 'package:appwrite_incidence_supervisor/domain/model/name_model.dart';
import 'package:appwrite_incidence_supervisor/intl/generated/l10n.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/state_render/state_render_impl.dart';
import 'package:appwrite_incidence_supervisor/presentation/global_widgets/responsive.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/assets_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/color_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/language_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/routes_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:go_router/go_router.dart';

import 'incidence_viewmodel.dart';

class IncidenceView extends StatefulWidget {
  final String incidenceId;
  final Incidence? incidence;

  const IncidenceView(this.incidenceId, {this.incidence, Key? key})
      : super(key: key);

  @override
  State<IncidenceView> createState() => _IncidenceViewState();
}

class _IncidenceViewState extends State<IncidenceView> {
  final _viewModel = instance<IncidenceViewModel>();
  final _appPreferences = instance<AppPreferences>();

  final _nameTxtEditCtrl = TextEditingController();
  final _descrTxtEditCtrl = TextEditingController();
  final _dateCreateTxtEditCtrl = TextEditingController();
  final _employeTxtEditCtrl = TextEditingController();
  final _supervisorTxtEditCtrl = TextEditingController();
  final _solutionTxtEditCtrl = TextEditingController();
  final _dateSolutionTxtEditCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool active = false;

  _bind() {
    _viewModel.start();
    if (widget.incidenceId != 'new') {
      if (widget.incidence != null) {
        //send data to form
        final incidence = widget.incidence!;
        _nameTxtEditCtrl.text = incidence.name;
        _descrTxtEditCtrl.text = incidence.description;
        _dateCreateTxtEditCtrl.text = incidence.dateCreate.toString();
        _employeTxtEditCtrl.text = incidence.employe;
        _supervisorTxtEditCtrl.text = incidence.supervisor;
        _solutionTxtEditCtrl.text = incidence.solution;
        _dateSolutionTxtEditCtrl.text = incidence.dateSolution.toString();
        _viewModel.changeIncidenceSel(IncidenceSel(
            priority: incidence.priority,
            image: incidence.image,
            active: incidence.active));
      } else {
        //call api and send data to form
        WidgetsBinding.instance?.addPostFrameCallback((_) async {
          final incidence =
              await _viewModel.incidence(context, widget.incidenceId);
          if (incidence != null) {
            _nameTxtEditCtrl.text = incidence.name;
            _descrTxtEditCtrl.text = incidence.description;
            _dateCreateTxtEditCtrl.text = incidence.dateCreate.toString();
            _employeTxtEditCtrl.text = incidence.employe;
            _supervisorTxtEditCtrl.text = incidence.supervisor;
            _solutionTxtEditCtrl.text = incidence.solution;
            _dateSolutionTxtEditCtrl.text = incidence.dateSolution.toString();
            _viewModel.changeIncidenceSel(IncidenceSel(
                priority: incidence.priority,
                image: incidence.image,
                active: incidence.active));
          }
        });
      }
    } else {
      _dateCreateTxtEditCtrl.text = (DateTime.now()).toString();
      _employeTxtEditCtrl.text = _appPreferences.getName();
    }
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final s = S.of(context);
    return Scaffold(   appBar: AppBar(
      backgroundColor: ColorManager.white,
      title: GestureDetector(
        child: SizedBox(
            height: AppSize.s60,
            child: Image.asset(
              ImageAssets.logo,
              fit: BoxFit.contain,
            )),onTap: (){ GoRouter.of(context).go(Routes.mainRoute);},
      ),
      centerTitle: false,
      actions: [
        SizedBox(
          width: AppSize.s60,
          child: PopupMenuButton<String>(
            tooltip: s.changeLanguage,
            itemBuilder: (_) => LanguageType.values
                .map((e) =>
                PopupMenuItem(child: Text(e.name), value: e.getValue()))
                .toList(),
            child: Center(
                child: Text(
                  _appPreferences.getAppLanguage(),
                  style: Theme.of(context).textTheme.bodyText2,
                )),
            onSelected: (value) {
              _appPreferences.setAppLanguage(value);
              Phoenix.rebirth(context);
            },
          ),
        ),
        const SizedBox(width: AppSize.s10),
        SizedBox(
          width: AppSize.s60,
          child: PopupMenuButton<String>(
              tooltip: _appPreferences.getName(),
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: SizedBox(
                      height: AppSize.s200,
                      child: Center(child: Text(_appPreferences.getName())),
                    ))
              ],
              icon: Icon(Icons.person, color: ColorManager.black)),
        ),
        const SizedBox(width: AppSize.s10)
      ],
    ),
        body: StreamBuilder<FlowState>(
            stream: _viewModel.outputState,
            builder: (context, snapshot) =>
                snapshot.data
                    ?.getScreenWidget(context, _getContentWidget(size, s), () {
                  GoRouter.of(context).go(Routes.mainRoute);
                }, () {
                  _bind();
                }) ??
                _getContentWidget(size, s)));
  }

  Widget _getContentWidget(Size size, S s) {
    return ResponsiveWid(
        smallScreen: _data(size.width * 0.8, s),
        largeScreen: _data(size.width * 0.5, s));
  }

  Widget _data(double width, S s) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p14),
              child: Column(
                children: [
                  const SizedBox(height: AppSize.s10),
                  Text(
                      '${widget.incidence != null ? s.details : s.add} ${s.incidence}'),
                  const Divider(),
                  TextFormField(
                    controller: _nameTxtEditCtrl,
                    decoration: InputDecoration(
                        labelText: s.nameIncidence, hintText: s.nameIncidence),
                    validator: (value) =>
                        (value?.isNotEmpty ?? false) ? null : s.nameError,
                    enabled: widget.incidenceId == 'new',
                  ),
                  const SizedBox(height: AppSize.s10),
                  TextFormField(
                    controller: _descrTxtEditCtrl,
                    decoration: InputDecoration(
                        labelText: s.descriptionIncidence,
                        hintText: s.descriptionIncidence),
                    validator: (value) =>
                        (value?.isNotEmpty ?? false) ? null : s.descrError,
                    enabled: widget.incidenceId == 'new',
                  ),
                  const SizedBox(height: AppSize.s10),
                  TextFormField(
                    controller: _dateCreateTxtEditCtrl,
                    decoration: InputDecoration(
                        labelText: s.dateCreate, hintText: s.dateCreate),
                    enabled: false,
                  ),
                  const SizedBox(height: AppSize.s10),
                  TextFormField(
                    controller: _employeTxtEditCtrl,
                    decoration: InputDecoration(
                        labelText: s.employe, hintText: s.employe),
                    enabled: false,
                    validator: (value) =>
                        (value?.isNotEmpty ?? false) ? null : s.employeError,
                  ),
                  const SizedBox(height: AppSize.s10),
                  _incidenceSelWid(s),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _incidenceSelWid(S s) {
    return StreamBuilder<IncidenceSel>(
        stream: _viewModel.outputIncidenceSel,
        builder: (_, snapshot) {
          final incidenceSel = snapshot.data;
          final imageUrl = '${Constant.baseUrl}/storage/buckets/'
              '${Constant.buckedId}/files/${incidenceSel?.image ?? ''}/view?'
              'project=${Constant.projectId}';
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  child: Container(
                    width: AppSize.s100,
                    height: AppSize.s100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: incidenceSel?.image != null
                                ? NetworkImage(imageUrl)
                                : const AssetImage(ImageAssets.jpg)
                                    as ImageProvider,
                            fit: BoxFit.cover)),
                  ),
                  onTap: () {
                    if (widget.incidenceId == 'new') {
                      _viewModel.pickImage(IncidenceSel(
                          area: incidenceSel?.area,
                          priority: incidenceSel?.priority,
                          active: incidenceSel?.active));
                    }
                  }),
              Text(incidenceSel?.image != null ? '' : s.pickImage),
              const SizedBox(height: AppSize.s10),
              StreamBuilder<List<Name>>(
                  stream: _viewModel.outputPrioritys,
                  builder: (_, snapshot) {
                    final prioritys = snapshot.data;
                    return prioritys != null && prioritys.isNotEmpty
                        ? DropdownButtonFormField<String?>(
                            isExpanded: true,
                            decoration:
                                InputDecoration(label: Text(s.priority)),
                            hint: Text(s.priority),
                            items: prioritys
                                .map((e) => DropdownMenuItem(
                                      child: Text(e.name),
                                      value: e.name,
                                    ))
                                .toList(),
                            value: incidenceSel?.priority != ''
                                ? incidenceSel?.priority
                                : null,
                            onChanged:widget.incidenceId == 'new'? (value) {
                              _viewModel.changeIncidenceSel(IncidenceSel(
                                  area: incidenceSel?.area,
                                  priority: value,
                                  active: incidenceSel?.active,
                                  image: incidenceSel?.image));
                            }:null,
                            validator: (value) => (value?.isNotEmpty ?? false)
                                ? null
                                : s.priorityError,
                          )
                        : const SizedBox();
                  }),
              const SizedBox(height: AppSize.s10),
              widget.incidenceId != 'new' ? _dataView(s) : const SizedBox(),
              SizedBox(
                  width: double.infinity,
                  height: AppSize.s40,
                  child: ElevatedButton(
                      onPressed: () {
                        if (widget.incidenceId == 'new') {
                          if (_formKey.currentState!.validate()) {
                            if (incidenceSel?.image != null) {
                              final incidence = Incidence(
                                  name: _nameTxtEditCtrl.text.trim(),
                                  description: _descrTxtEditCtrl.text.trim(),
                                  dateCreate: DateTime.parse(
                                      _dateCreateTxtEditCtrl.text),
                                  image: incidenceSel?.image ?? '',
                                  priority: incidenceSel?.priority ?? '',
                                  area: _appPreferences.getTypeUser(),
                                  employe: _employeTxtEditCtrl.text.trim(),
                                  supervisor: '',
                                  solution: '',
                                  dateSolution: DateTime.now(),
                                  active: incidenceSel?.active ?? true,
                                  read: [],
                                  write: [],
                                  id: widget.incidence?.id ?? '',
                                  collection: '');
                              _viewModel.createIncidence(incidence, context);
                            }
                          }
                        } else {
                          GoRouter.of(context).go(Routes.mainRoute);
                        }
                      },
                      child: Text(
                          widget.incidenceId == 'new' ? s.save : s.close))),
            ],
          );
        });
  }

  _dataView(S s) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      TextFormField(
        controller: _supervisorTxtEditCtrl,
        decoration:
            InputDecoration(labelText: s.supervisor, hintText: s.supervisor),
        enabled: false,
      ),
      const SizedBox(height: AppSize.s10),
      TextFormField(
        controller: _solutionTxtEditCtrl,
        decoration:
            InputDecoration(labelText: s.solution, hintText: s.solution),
        enabled: false,
      ),
      const SizedBox(height: AppSize.s10),
      TextFormField(
        controller: _dateSolutionTxtEditCtrl,
        decoration: InputDecoration(
            labelText: s.dateSolution, hintText: s.dateSolution),
        enabled: false,
      ),
      const SizedBox(height: AppSize.s10),
    ]);
  }
}
