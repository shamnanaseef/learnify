// dummy_purchases.dart

class DummyPurchase {
  final String userId;
  final String courseId;

  const DummyPurchase({required this.userId, required this.courseId});
}

// Example dummy data
const List<DummyPurchase?> dummyPurchases = [
  DummyPurchase(userId: 'Aai4fEdPGeaelcd7weA1slSXHcH2', courseId: 'KrIVmbx8md0hWIjgta9T'),
  DummyPurchase(userId: 'Aai4fEdPGeaelcd7weA1slSXHcH2', courseId: 'Kt4cFchcO881JK8upRIi'),
  DummyPurchase(userId: 'user_002', courseId: 'course_101'),
  DummyPurchase(userId: 'user_003', courseId: 'course_105'),
];

List<String> getUserPurchasedCourseIds(String userId) {
  return dummyPurchases
      .where((purchase) => purchase!.userId == userId)
      .map((purchase) => purchase!.courseId)
      .toList();
}
