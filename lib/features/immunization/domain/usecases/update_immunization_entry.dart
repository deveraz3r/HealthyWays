import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/immunization/domain/repositories/immunization_repository.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';

class UpdateImmunizationEntry
    implements UseCase<Immunization, UpdateImmunizationEntryParams> {
  final ImmunizationRepository repository;
  UpdateImmunizationEntry(this.repository);

  @override
  Future<Either<Failure, Immunization>> call(params) async {
    return await repository.updateImmunizationEntry(
      id: params.id,
      title: params.title,
      body: params.body,
      providerId: params.providerId,
    );
  }
}

class UpdateImmunizationEntryParams {
  String id;
  String title;
  String body;
  String? providerId;

  UpdateImmunizationEntryParams({
    required this.id,
    required this.title,
    required this.body,
    this.providerId,
  });
}
