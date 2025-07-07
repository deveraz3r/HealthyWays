import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/allergies/domain/entities/allergy.dart';
import 'package:healthyways/features/allergies/presentation/controllers/allergie_controller.dart';
import 'package:healthyways/features/allergies/presentation/widgets/allergy_card.dart';
import 'package:healthyways/features/allergies/presentation/widgets/allergy_entry_dialog.dart';

class AllergyHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => AllergyHomePage());
  const AllergyHomePage({super.key});

  @override
  State<AllergyHomePage> createState() => _AllergyHomePageState();
}

class _AllergyHomePageState extends State<AllergyHomePage> {
  final AllergiesController _allergyController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void _showAddAllergyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AllergyEntryDialog(
            onSubmit: (title, body) async {
              await _allergyController.createAllergieEntry(title: title, body: body);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allergies"),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          IconButton(icon: Icon(CupertinoIcons.add_circled_solid), onPressed: () => _showAddAllergyDialog(context)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(() {
          if (_allergyController.allergieEntries.isLoading) {
            return Loader();
          }

          if (_allergyController.allergieEntries.hasError) {
            return Center(child: Text(_allergyController.allergieEntries.error!.message));
          }

          if (_allergyController.allergieEntries.hasData && _allergyController.allergieEntries.data!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Allergy Entries yet, ", style: TextStyle(fontSize: 18)),
                  InkWell(
                    onTap: () async => await _allergyController.getAllAllergieEntries(),
                    child: Text("retry", style: TextStyle(fontSize: 18, color: AppPallete.gradient1)),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: _allergyController.allergieEntries.rxData.value!.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              Allergy allergy = _allergyController.allergieEntries.rxData.value![index];
              return AllergyCard(allergy: allergy);
            },
          );
        }),
      ),
    );
  }
}
