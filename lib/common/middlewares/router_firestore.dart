import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/rxdart.dart';

class RouteFirestoreMiddleware {
  static final db = FirebaseFirestore.instance;

  static Stream<Map<String, S?>> getCombinedStream<T, S>({
    required Stream<List<QueryDocumentSnapshot<T>>> Function() primaryStream,
    required Stream<List<DocumentSnapshot<S>>> Function(List<String>) secondaryStream,
    required String Function(T) getSecondaryId,
  }) {
    return primaryStream().switchMap((primaryDocs) {
      List<String> secondaryIds = primaryDocs.map((doc) => getSecondaryId(doc.data())).toSet().toList();

      if (secondaryIds.isEmpty) {
        return Stream.value(<String, S?>{});
      }

      return secondaryStream(secondaryIds).map((secondaryDocs) {
        return Map.fromEntries(secondaryDocs.map((doc) {
          return MapEntry(doc.id, doc.data());
        }));
      });
    });
  }
}

void refreshData(RefreshController controller, Future<void> Function() loadData) {
  loadData().then((_) {
    controller.refreshCompleted(resetFooterState: true);
  }).catchError((_) {
    controller.refreshFailed();
  });
}

void loadData(RefreshController controller, Future<void> Function() loadData) {
  loadData().then((_) {
    controller.loadComplete();
  }).catchError((_) {
    controller.loadFailed();
  });
}