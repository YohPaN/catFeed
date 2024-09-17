class FeedItem {
  final String type;
  final DateTime created;

  const FeedItem({
    required this.type,
    required this.created,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      type: json['type'],
      created: DateTime.parse(json['created']),
    );
  }
}

class Feed {
  final Map<String, FeedItem> feeds;

  const Feed({
    required this.feeds,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      feeds: {
        for (var key in json.keys)
          key: FeedItem.fromJson(json[key]),
      },
    );
  }
}
