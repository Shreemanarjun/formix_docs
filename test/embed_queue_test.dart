import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';

// ── replicated logic from combined_embed.dart (_EmbedQueue) ──────────────────
//
// We copy the class here so the test can run without Jaspr/Flutter context.

class EmbedQueue {
  int _next = 0;
  final _completers = <int, Completer<void>>{};

  void notifyReady(int slot) {
    _completers[slot + 1]?.complete();
  }

  Future<void> waitForSlot(int slot) {
    if (slot == 0) return Future.value();
    final c = _completers.putIfAbsent(slot, () => Completer<void>());
    return c.future;
  }

  int reserveSlot() => _next++;

  void reset() {
    _next = 0;
    _completers.clear();
  }
}

// ── helper ────────────────────────────────────────────────────────────────────

Future<void> tick() => Future<void>.delayed(Duration.zero);

// ── tests ─────────────────────────────────────────────────────────────────────

void main() {
  late EmbedQueue queue;

  setUp(() => queue = EmbedQueue());

  // ── slot reservation ──────────────────────────────────────────────────────

  group('EmbedQueue – slot reservation', () {
    test('first slot is 0', () {
      expect(queue.reserveSlot(), equals(0));
    });

    test('slots increment sequentially', () {
      expect(queue.reserveSlot(), 0);
      expect(queue.reserveSlot(), 1);
      expect(queue.reserveSlot(), 2);
    });
  });

  // ── slot 0 never blocks ────────────────────────────────────────────────────

  group('EmbedQueue – slot 0', () {
    test('waitForSlot(0) completes without external signal', () async {
      bool done = false;
      await queue.waitForSlot(0).then((_) => done = true);
      expect(done, isTrue);
    });
  });

  // ── serialisation ──────────────────────────────────────────────────────────

  group('EmbedQueue – serialisation', () {
    test('slot 1 blocks until slot 0 calls notifyReady', () async {
      final s0 = queue.reserveSlot(); // 0
      final s1 = queue.reserveSlot(); // 1

      bool s1Ready = false;
      queue.waitForSlot(s1).then((_) => s1Ready = true);

      await tick();
      expect(s1Ready, isFalse, reason: 'slot 1 must not proceed before slot 0 signals');

      queue.notifyReady(s0);
      await tick();
      expect(s1Ready, isTrue, reason: 'slot 1 must proceed after slot 0 signals');
    });

    test('three embeds execute in registration order: 0 → 1 → 2', () async {
      final log = <int>[];

      final s0 = queue.reserveSlot();
      final s1 = queue.reserveSlot();
      final s2 = queue.reserveSlot();

      // Simulates each embed: wait for its slot, record it, notify next.
      Future<void> simulate(int slot) async {
        await queue.waitForSlot(slot);
        log.add(slot);
        queue.notifyReady(slot);
      }

      // All three start "simultaneously" (as they do on page load).
      await Future.wait([simulate(s0), simulate(s1), simulate(s2)]);

      expect(log, orderedEquals([0, 1, 2]), reason: 'Flutter addView calls must be serialised in order');
    });

    test('slot 2 stays blocked if slot 1 has not fired', () async {
      final s0 = queue.reserveSlot();
      final s1 = queue.reserveSlot();
      final s2 = queue.reserveSlot();

      bool s2Ready = false;
      queue.waitForSlot(s2).then((_) => s2Ready = true);

      queue.notifyReady(s0); // unblocks s1, but NOT s2
      await tick();
      expect(s2Ready, isFalse, reason: 'slot 2 must not jump the queue');

      queue.notifyReady(s1); // unblocks s2
      await tick();
      expect(s2Ready, isTrue);
    });

    test('notifyReady for an unregistered next slot is a no-op', () {
      final s0 = queue.reserveSlot();
      // s1 does NOT call waitForSlot — notifyReady should not throw.
      expect(() => queue.notifyReady(s0), returnsNormally);
    });
  });

  // ── run_flutter_app.dart patch verification ────────────────────────────────
  //
  // Structural / static-content tests that confirm the patched local copy of
  // jaspr_flutter_embed contains the four key lines that fix the race.

  group('run_flutter_app.dart patch', () {
    late String src;

    setUpAll(() {
      final path = 'local_packages/jaspr_flutter_embed/lib/src/run_flutter_app.dart';
      src = File(path).readAsStringSync();
    });

    test('declares _nextViewWidget', () {
      expect(
        src,
        contains('flt.Widget? _nextViewWidget'),
        reason: 'patch must expose the pre-registration slot',
      );
    });

    test('assigns _nextViewWidget BEFORE app.addView()', () {
      final setIdx = src.indexOf('_nextViewWidget = widget');
      final addIdx = src.indexOf('final id = app.addView(');
      expect(setIdx, greaterThan(-1), reason: '_nextViewWidget = widget must exist');
      expect(addIdx, greaterThan(-1), reason: 'final id = app.addView call must exist');
      expect(setIdx, lessThan(addIdx), reason: 'must pre-register widget before addView fires didChangeMetrics');
    });

    test('viewBuilder falls back to _nextViewWidget', () {
      expect(
        src,
        contains('_viewWidgets[viewId] ?? _nextViewWidget'),
        reason: 'viewBuilder must use fallback during the race window',
      );
    });

    test('clears _nextViewWidget after addView to avoid stale references', () {
      expect(
        src,
        contains('_nextViewWidget = null'),
        reason: 'must reset to null after addView so old widget is not reused',
      );
    });

    test('adds _nextViewWidget AFTER _viewWidgets lookup in viewBuilder', () {
      // Ensures the fallback order is correct: real map first, pending second.
      final line = src.split('\n').firstWhere((l) => l.contains('viewBuilder:'), orElse: () => '');
      expect(
        line,
        contains('_viewWidgets[viewId] ?? _nextViewWidget'),
        reason: 'pre-registered map must be checked first, pending second',
      );
    });
  });
}
