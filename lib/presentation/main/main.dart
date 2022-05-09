import 'package:appwrite_incidence_supervisor/app/app_preferences.dart';
import 'package:appwrite_incidence_supervisor/app/dependency_injection.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_sel.dart';
import 'package:appwrite_incidence_supervisor/domain/model/name_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/user_model.dart';
import 'package:appwrite_incidence_supervisor/intl/generated/l10n.dart';
import 'package:appwrite_incidence_supervisor/presentation/common/state_render/state_render_impl.dart';
import 'package:appwrite_incidence_supervisor/presentation/global_widgets/incidence.dart';
import 'package:appwrite_incidence_supervisor/presentation/global_widgets/responsive.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/assets_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/color_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/language_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/routes_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:go_router/go_router.dart';

import 'main_viewmodel.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _viewModel = instance<MainViewModel>();
  final _appPreferences = instance<AppPreferences>();

  _bind() {
    _viewModel.start();
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
    return Scaffold(
      backgroundColor: ColorManager.primary.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        title: GestureDetector(
          child: SizedBox(
              height: AppSize.s60,
              child: Image.asset(
                ImageAssets.logo,
                fit: BoxFit.contain,
              )),
          onTap: () => GoRouter.of(context).go(Routes.mainRoute),
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
          StreamBuilder<UsersModel>(
              stream: _viewModel.outputUser,
              builder: (_, snapshot) {
                final user = snapshot.data;
                return SizedBox(
                  width: AppSize.s60,
                  child: PopupMenuButton<String>(
                      tooltip: user?.name ?? s.user,
                      itemBuilder: (_) => [
                            PopupMenuItem(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p10, horizontal: 40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${s.user}: ${user?.name ?? s.user}'),
                                  Text(
                                      '${s.typeUser}: ${user?.typeUser ?? s.typeUser}'),
                                  Text(
                                      '${s.active}: ${user?.active ?? s.active}'),
                                  Text('${s.area}: ${user?.area ?? s.area}'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(Icons.close),
                                title: Text(s.close),
                                onTap: () {
                                  _viewModel.deleteSession(context);
                                },
                              ),
                            )
                          ],
                      icon: Icon(Icons.person, color: ColorManager.black)),
                );
              }),
          const SizedBox(width: AppSize.s10)
        ],
      ),
      body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) =>
              snapshot.data
                  ?.getScreenWidget(context, _getContentWidget(size, s), () {
                _viewModel.inputState.add(ContentState());
              }, () {}) ??
              _getContentWidget(size, s)),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () =>
              GoRouter.of(context).go(Routes.incidenceRoute + '/new')),
    );
  }

  Widget _getContentWidget(Size size, S s) {
    return ResponsiveWid(
        smallScreen: _data(size.width, s),
        largeScreen: _data(size.width * 0.5, s));
  }

  Widget _data(double width, S s) {
    return Center(
      child: Container(
        color: ColorManager.white,
        width: width,
        child: StreamBuilder<IncidenceSel>(
            stream: _viewModel.outputIncidenceSel,
            builder: (_, snapshot) {
              final incidenceSel = snapshot.data;
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.maxScrollExtent ==
                      scrollInfo.metrics.pixels) {
                    if (incidenceSel?.priority != null &&
                        incidenceSel?.priority != '') {
                      if (incidenceSel?.active != null) {
                        _viewModel.incidencesPriorityActive(
                            incidenceSel?.priority ?? '',
                            incidenceSel?.active ?? false);
                      } else {
                        _viewModel
                            .incidencesPriority(incidenceSel?.priority ?? '');
                      }
                    } else {
                      _viewModel.incidences(false);
                    }
                  }
                  return true;
                },
                child: Column(
                  children: [
                    _filter(s),
                    const Divider(),
                    StreamBuilder<List<Incidence>>(
                        stream: _viewModel.outputIncidences,
                        builder: (_, snapshot) {
                          final incidences = snapshot.data;
                          return incidences != null && incidences.isNotEmpty
                              ? Expanded(child:
                                  LayoutBuilder(builder: (context, constaints) {
                                  final count =
                                      constaints.maxWidth ~/ AppSize.s200;
                                  return GridView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppMargin.m6,
                                        horizontal: AppMargin.m12),
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: count,
                                            childAspectRatio:
                                                AppSize.s200 / AppSize.s200,
                                            crossAxisSpacing: AppSize.s10,
                                            mainAxisSpacing: AppSize.s10),
                                    itemBuilder: (_, index) {
                                      final incidence = incidences[index];
                                      return IncidenceItem(incidence, () {
                                        GoRouter.of(context).go(
                                            Routes.incidenceRoute +
                                                '/${incidence.id}',
                                            extra: incidence);
                                      });
                                    },
                                    itemCount: incidences.length,
                                  );
                                }))
                              : Center(
                                  child: Text(s.noData),
                                );
                        }),
                    StreamBuilder<bool>(
                        stream: _viewModel.outputIsLoading,
                        builder: (_, snapshot) {
                          final loading = snapshot.data;
                          return loading != null && loading
                              ? const CircularProgressIndicator()
                              : const SizedBox();
                        })
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _filter(S s) {
    return StreamBuilder<IncidenceSel>(
        stream: _viewModel.outputIncidenceSel,
        builder: (_, snapshot) {
          final incidenceSel = snapshot.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSize.s20),
              SizedBox(
                height: AppSize.s40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: AppSize.s20),
                    SizedBox(
                      width: AppSize.s140,
                      child: StreamBuilder<List<Name>?>(
                          stream: _viewModel.outputPrioritys,
                          builder: (_, snapshot) {
                            final prioritys = snapshot.data;
                            return prioritys != null && prioritys.isNotEmpty
                                ? DropdownButtonFormField<String?>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                        label: Text(s.priority)),
                                    hint: Text(s.priority),
                                    items: prioritys
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e.name),
                                              value: e.name,
                                            ))
                                        .toList(),
                                    value: incidenceSel?.priority == ''
                                        ? null
                                        : incidenceSel?.priority,
                                    onChanged: (value) {
                                      _viewModel.changeIncidenceSel(
                                          IncidenceSel(priority: value));
                                    })
                                : const SizedBox();
                          }),
                    ),
                    const SizedBox(width: AppSize.s10),
                    incidenceSel?.priority != null &&
                            incidenceSel?.priority != ''
                        ? SizedBox(
                            width: AppSize.s140,
                            child: StreamBuilder<List<bool>?>(
                                stream: _viewModel.outputActives,
                                builder: (_, snapshot) {
                                  final actives = snapshot.data;
                                  return actives != null && actives.isNotEmpty
                                      ? DropdownButtonFormField<bool?>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                              label: Text(s.active)),
                                          hint: Text(s.active),
                                          items: actives
                                              .map((e) => DropdownMenuItem(
                                                    child: Text(e.toString()),
                                                    value: e,
                                                  ))
                                              .toList(),
                                          value: incidenceSel?.active,
                                          onChanged: (value) {
                                            _viewModel.changeIncidenceSel(
                                                IncidenceSel(
                                                    priority:
                                                        incidenceSel?.priority,
                                                    active: value));
                                          })
                                      : const SizedBox();
                                }),
                          )
                        : const SizedBox(),
                    const SizedBox(width: AppSize.s20),
                  ],
                ),
              ),
              const SizedBox(height: AppSize.s20),
            ],
          );
        });
  }
}
