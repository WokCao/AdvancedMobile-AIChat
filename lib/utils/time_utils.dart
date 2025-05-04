String formatRelativeTime(dynamic createdAt) {
  if (createdAt == null) return "Unknown time";

  DateTime? createdTime;

  // Try parsing as int (timestamp in seconds)
  final timestamp = int.tryParse(createdAt.toString());
  if (timestamp != null) {
    createdTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  } else {
    // Try parsing as ISO 8601 string
    try {
      createdTime = DateTime.parse(createdAt.toString()).toLocal();
    } catch (_) {
      return "Invalid time";
    }
  }

  final now = DateTime.now();
  final diff = now.difference(createdTime);

  if (diff.inSeconds < 60) {
    return "just now";
  } else if (diff.inMinutes < 60) {
    return "${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago";
  } else if (diff.inHours < 24) {
    return "${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago";
  } else if (diff.inDays < 7) {
    return "${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago";
  } else {
    final weeks = (diff.inDays / 7).floor();
    return "$weeks week${weeks == 1 ? '' : 's'} ago";
  }
}
