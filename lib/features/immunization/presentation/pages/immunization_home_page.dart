import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';
import 'package:healthyways/features/immunization/presentation/controllers/immunization_controller.dart';
import 'package:healthyways/features/immunization/presentation/widgets/immunization_card.dart';
import 'package:healthyways/features/immunization/presentation/widgets/immunization_entry_dialog.dart';

class ImmunizationHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => ImmunizationHomePage());
  const ImmunizationHomePage({super.key});

  @override
  State<ImmunizationHomePage> createState() => _ImmunizationHomePageState();
}

class _ImmunizationHomePageState extends State<ImmunizationHomePage> {
  final ImmunizationController _immunizationController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void _showAddImmunizationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => ImmunizationEntryDialog(
            onSubmit: (title, body) async {
              await _immunizationController.createImmunizationEntry(title: title, body: body);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Immunizations"),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.add_circled_solid),
            onPressed: () => _showAddImmunizationDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(() {
          if (_immunizationController.immunizationEntries.isLoading) {
            return Loader();
          }

          if (_immunizationController.immunizationEntries.hasError) {
            return Center(child: Text(_immunizationController.immunizationEntries.error!.message));
          }

          if (_immunizationController.immunizationEntries.hasData &&
              _immunizationController.immunizationEntries.data!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Immunization Entries yet, ", style: TextStyle(fontSize: 18)),
                  InkWell(
                    onTap: () async => await _immunizationController.getAllImmunizationEntries(),
                    child: Text("retry", style: TextStyle(fontSize: 18, color: AppPallete.gradient1)),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: _immunizationController.immunizationEntries.rxData.value!.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              Immunization immunization = _immunizationController.immunizationEntries.rxData.value![index];
              return ImmunizationCard(immunization: immunization);
            },
          );
        }),
      ),
    );
  }
}
