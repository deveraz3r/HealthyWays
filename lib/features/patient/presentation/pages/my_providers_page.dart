import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/features/patient/presentation/pages/add_provider_page.dart';
import 'package:healthyways/features/patient/presentation/widgets/provider_card.dart';

class MyProvidersPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const MyProvidersPage());

  const MyProvidersPage({super.key});

  @override
  State<MyProvidersPage> createState() => _MyProvidersPageState();
}

class _MyProvidersPageState extends State<MyProvidersPage> {
  final PatientController _patientController = Get.find();

  @override
  void initState() {
    super.initState();
    _patientController.getMyProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Healthcare Providers'),
        backgroundColor: AppPallete.backgroundColor2,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(context, AddProviderPage.route());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_patientController.myProviders.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_patientController.myProviders.hasError) {
          return Center(child: Text('Error: ${_patientController.myProviders.error?.message}'));
        }

        final providers = _patientController.myProviders.data!;

        if (providers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No providers added yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, AddProviderPage.route());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Providers'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppPallete.gradient1, foregroundColor: Colors.white),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: providers.length,
          itemBuilder: (context, index) {
            return ProviderCard(
              providerId: providers[index],
              onRemove: () {
                _patientController.removeMyProvider(providers[index]);
              },
            );
          },
        );
      }),
    );
  }
}
