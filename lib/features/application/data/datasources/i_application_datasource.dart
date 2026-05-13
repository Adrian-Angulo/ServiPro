import 'package:servi_pro/features/application/domain/entities/application_entity.dart';

abstract class IApplicationDatasource {
  Future<void> addAplication(ApplicationEntity application);
  Future<List<ApplicationEntity>> getAppliForWorker(String idWorker);
  Future<List<ApplicationEntity>> getAppliForRequest(String idRequest);
  Future<void> cancelApplication(String id, String idRequest);
  Future<void> acceptApplication(String applicationId, String requestId);
  Future<void> completeRequest(String applicationId, String requestId);
}
