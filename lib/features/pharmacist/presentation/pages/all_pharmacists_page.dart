import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';
import 'package:healthyways/features/pharmacist/presentation/pages/pharmacist_details_page.dart';
import 'package:healthyways/features/pharmacist/presentation/widgets/pharmacist_card.dart';

class AllPharmacistsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const AllPharmacistsPage());

  const AllPharmacistsPage({super.key});

  @override
  State<AllPharmacistsPage> createState() => _AllPharmacistsPageState();
}

class _AllPharmacistsPageState extends State<AllPharmacistsPage> {
  final PharmacistController _pharmacistController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pharmacistController.getAllPharmacists();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Pharmacists'),
        backgroundColor: AppPallete.backgroundColor2,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search pharmacists...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Pharmacists List
          Expanded(
            child: Obx(() {
              if (_pharmacistController.allPharmacists.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_pharmacistController.allPharmacists.hasError) {
                return Center(
                  child: Text(
                    'Error: ${_pharmacistController.allPharmacists.error?.message}',
                  ),
                );
              }

              final pharmacists =
                  _pharmacistController.allPharmacists.data!.where((
                    pharmacist,
                  ) {
                    final searchLower = _searchQuery.toLowerCase();
                    return pharmacist.fName.toLowerCase().contains(
                          searchLower,
                        ) ||
                        pharmacist.lName.toLowerCase().contains(searchLower) ||
                        (pharmacist.address?.toLowerCase().contains(
                              searchLower,
                            ) ??
                            false);
                  }).toList();

              if (pharmacists.isEmpty) {
                return const Center(child: Text('No pharmacists found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pharmacists.length,
                itemBuilder: (context, index) {
                  final pharmacist = pharmacists[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PharmacistCard(
                      pharmacist: pharmacist,
                      onTap: () {
                        Navigator.push(
                          context,
                          PharmacistDetailsPage.route(pharmacist.uid),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
