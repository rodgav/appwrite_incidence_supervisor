import 'package:appwrite_incidence_supervisor/app/constants.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/color_manager.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

class IncidenceItem extends StatelessWidget {
  final Incidence incidence;
  final VoidCallback openDialog;
  const IncidenceItem(this.incidence,this.openDialog,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        '${Constant.baseUrl}/storage/buckets/'
        '${Constant.buckedId}/files/${incidence.image}/view?'
        'project=${Constant.projectId}';
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius:
            BorderRadius.circular(AppSize.s8),
            boxShadow: [
              BoxShadow(
                  color: ColorManager.grey,
                  offset: const Offset(
                      AppSize.s2, AppSize.s2),
                  blurRadius: AppSize.s8)
            ]),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.s8),
                child: Center(
                  child: Image.network(imageUrl,
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s8),
              child: Text(incidence.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2),
            ),
            const SizedBox(height: AppSize.s5),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.s8),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  Text(incidence.area,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1),
                  Text(incidence.priority,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1),
                ],
              ),
            ),
            const SizedBox(height: AppSize.s8),
          ],
        ),
      ),
      onTap: openDialog,
    );
  }
}
