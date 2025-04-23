class SlackMetadata {
  final String slackBotToken;
  final String slackWorkspace;

  SlackMetadata({required this.slackBotToken, required this.slackWorkspace});

  factory SlackMetadata.fromJson(Map<String, dynamic> json) => SlackMetadata(
    slackBotToken: json['slack_bot_token'],
    slackWorkspace: json['slack_workspace'],
  );
}

class FileMetadata {
  final String name;
  final String mimetype;

  FileMetadata({required this.name, required this.mimetype});

  factory FileMetadata.fromJson(Map<String, dynamic> json) => FileMetadata(
    name: json['name'],
    mimetype: json['mimetype'],
  );
}