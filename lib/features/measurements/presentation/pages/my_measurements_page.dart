import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/measurements/presentation/pages/add_measurement_page.dart';
import 'package:healthyways/features/measurements/presentation/widgets/my_measurement_card.dart';

class MyMeasurementsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => MyMeasurementsPage());
  const MyMeasurementsPage({super.key});

  @override
  State<MyMeasurementsPage> createState() => _MyMeasurementsPageState();
}

class _MyMeasurementsPageState extends State<MyMeasurementsPage> {
  final MeasurementController _measurementController = Get.find();

  @override
  void initState() {
    _measurementController.getMyMeasurements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor2,
        title: const Text("My Trackers"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddMeasurementPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: Obx(() {
        final state = _measurementController.myMeasurements;

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.hasError) {
          return Center(child: Text("Error: ${state.error!.message}"));
        } else if (state.data == null || state.data!.isEmpty) {
          return const Center(child: Text("No measurements found."));
        }

        final measurements = state.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: measurements.length,
            separatorBuilder: (context, index) => SizedBox(height: 5),
            itemBuilder: (context, index) {
              final measurement = measurements[index];
              return MyMeasurementCard(measurement: measurement);
            },
          ),
        );
      }),
    );
  }
}
