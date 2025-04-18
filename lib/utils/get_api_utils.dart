import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../services/knowledge_api_service.dart';

ApiService getApiService(BuildContext context) {
  final token = Provider.of<AuthProvider>(context, listen: false).user?.accessToken;
  if (token == null) throw Exception("No token available");
  return ApiService(authToken: token);
}

KnowledgeApiService getKBApiService(BuildContext context) {
  final token = Provider.of<AuthProvider>(context, listen: false).user?.accessToken;
  if (token == null) throw Exception("No token available");
  return KnowledgeApiService(authToken: token);
}