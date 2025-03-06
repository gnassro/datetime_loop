/// A simple class to represent a unique key, mimicking Flutter's UniqueKey.
class UniqueKey {
  final int _id = DateTime.now().millisecondsSinceEpoch;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UniqueKey && _id == other._id;
  @override
  int get hashCode => _id.hashCode;
}
