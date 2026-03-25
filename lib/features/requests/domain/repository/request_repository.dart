import 'package:servi_pro/features/requests/data/models/request_model.dart';

abstract class RequestRepository {
  Future<void> registerRequest(RequestModel request);

  Future<List<RequestModel>> allRequest();
}
