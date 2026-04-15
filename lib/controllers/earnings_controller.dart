import 'package:flutter_mekitakizi/service/database_service.dart';

class EarningsController {
  Future<Map<String, dynamic>> getEarnings({
    required int driverId,
    String period = 'today',
  }) async {
    return DatabaseService.getEarnings(
      driverId: driverId,
      period: period,
    );
  }

  int calculateTotal(List<Map<String, dynamic>> earnings) {
    return earnings.fold(0, (sum, e) => sum + (e['amount'] as int));
  }

  int calculateTips(List<Map<String, dynamic>> earnings) {
    return earnings.fold(0, (sum, e) => sum + (e['tip'] as int));
  }
}
