import 'package:flutter_test/flutter_test.dart';

import 'package:deals/features/stores/domain/mapper/stores_mapper.dart';
import 'package:deals/features/stores/data/models/stores_data.dart';
import 'package:deals/features/stores/data/models/cashback.dart';

void main() {
  test('cashBackRate and popularityScore default to 0 when source values are null', () {
    final storeData = StoresData(
      id: '1',
      title: 'Store',
      cashback: Cashback(rate: null),
      popularityScore: null,
    );

    final entity = StoresMapper.mapToEntity(storeData);

    expect(entity.cashBackRate, 0);
    expect(entity.popularityScore, 0);
  });
}
