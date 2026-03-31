import 'package:servi_pro/features/requests/data/models/type_services.dart';

abstract class TypeServicesRepository {
  Future<List<TypeServices>> getAll();
  Future<TypeServices?> getById(String id);
  Future<void> create(TypeServices typeServices);
  Future<void> update(TypeServices typeServices);
  Future<void> delete(String id);
}
