import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/widgets/loader.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';

class AddMeasurementPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddMeasurementPage());
  const AddMeasurementPage({super.key});

  @override
  State<AddMeasurementPage> createState() => _AddMeasurementPageState();
}

class _AddMeasurementPageState extends State<AddMeasurementPage> {
  final MeasurementController _controller = Get.find();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Trackers"), backgroundColor: AppPallete.backgroundColor2),
      body: Obx(() {
        if (_controller.allMeasurements.isLoading) {
          return const Loader();
        }

        if (_controller.allMeasurements.hasError) {
          return Center(child: Text(_controller.allMeasurements.error!.message));
        }

        final List<PresetMeasurement> all = _controller.allMeasurements.data!;

        // Filter list based on search query
        final filtered =
            all.where((m) {
              return m.title.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();

        // Group filtered list by category
        final Map<String, List<PresetMeasurement>> grouped = {};
        for (final m in filtered) {
          grouped.putIfAbsent(m.category, () => []).add(m);
        }

        return Column(
          children: [
            // 🔍 Search Field
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search trackers...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),

            // 🗂 Grouped List
            Expanded(
              child:
                  grouped.isEmpty
                      ? const Center(child: Text("No measurements found."))
                      : ListView.builder(
                        itemCount: grouped.keys.length,
                        itemBuilder: (context, index) {
                          final category = grouped.keys.elementAt(index);
                          final items = grouped[category]!;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: AppPallete.backgroundColor2,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    category,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ...items.map(
                                  (measurement) => ListTile(
                                    title: Text(measurement.title),
                                    trailing: Obx(
                                      () => IconButton(
                                        icon: Icon(
                                          _controller.isInMyMeasurements(measurement.id).value
                                              ? Icons.check_circle
                                              : Icons.add_circle_outline,
                                          color:
                                              _controller.isInMyMeasurements(measurement.id).value
                                                  ? Colors.green
                                                  : null,
                                        ),
                                        onPressed: () {
                                          _controller.toggleMyMeasurementStatus(id: measurement.id);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        );
      }),
    );
  }
}
