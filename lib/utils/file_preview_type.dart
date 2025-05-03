enum FilePreviewType { image, pdf, doc, other }

FilePreviewType getFileType(String url) {
  final ext = url.toLowerCase().split('.').last;

  if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) return FilePreviewType.image;
  if (['pdf'].contains(ext)) return FilePreviewType.pdf;
  if (['doc', 'docx', 'txt', 'rtf'].contains(ext)) return FilePreviewType.doc;

  return FilePreviewType.other;
}