library entity_bag_test;

import 'package:dartemis/dartemis.dart';
import 'package:test/test.dart';

void main() {
  group('EntityBag tests', () {
    late EntityBag bag;
    final world = World();
    final e1 = world.createEntity();
    final e2 = world.createEntity();
    setUp(() {
      bag = EntityBag()
        ..add(e1)
        ..add(e2);
    });
    test('removing an element', () {
      bag.remove(e1);
      expect(bag.contains(e1), equals(false));
      expect(bag.contains(e2), equals(true));
      expect(bag.length, equals(1));
    });
    test('iterating', () {
      var iter = bag.iterator;
      expect(iter.moveNext(), equals(true));
      expect(iter.current, equals(e1));
      expect(iter.moveNext(), equals(true));
      expect(iter.current, equals(e2));

      bag.remove(e1);
      iter = bag.iterator;
      expect(iter.moveNext(), equals(true));
      expect(iter.current, equals(e2));
      expect(iter.moveNext(), equals(false));
    });
    test('clear', () {
      bag.clear();
      expect(bag.length, equals(0));
    });
  });
}
