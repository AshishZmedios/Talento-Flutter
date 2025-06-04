import 'package:get/get.dart';
import 'package:talento_flutter/data/models/job_model.dart';
import 'package:talento_flutter/data/services/api_client.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class JobRepository extends GetxController {
  // Apis end point
  static const String jobs = "jobs";
  static const String jobsFilter = "jobs/filter";
  static const String getJobDetail = "jobs/{jobId}";
  static const String getJobApplication = "application";
  static const String deleteApplication = "application/{id}";
  var isLoading = false.obs;

  final ApiClient _apiClient;

  JobRepository(this._apiClient);

  Future<List<Job>> fetchJobs() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.dio.get(jobs);
      final data = response.data as List;
      return data.map((json) => Job.fromJson(json)).toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Job>> filterJobs(
    int page,
    int size,
    String sortBy,
    String sortOrder,
  ) async {
    final response = await _apiClient.dio.post(
      jobsFilter,
      data: '''{
          "page": "$page",
          "size": "$size",
          "sortBy": "$sortBy",
          "SortOrder": "$sortOrder"
          }''',
    );
    final data = response.data as List;
    return data.map((json) => Job.fromJson(json)).toList();
  }

  Future<Job> getJobDetails(String jobId) async {
    final response = await _apiClient.dio.get(
      getJobDetail.replaceAll("{jobId}", jobId),
    );
    return Job.fromJson(response.data);
  }

  Future<List<Job>> getJobApplications(String jobId) async {
    final response = await _apiClient.dio.get(getJobApplication);
    final data = response.data as List;
    return data.map((json) => Job.fromJson(json)).toList();
  }

  Future<void> deleteApplications(String id) async {
    final response = await _apiClient.dio.delete(
      deleteApplication.replaceAll("{id}", id),
    );
    if (response.statusCode == 200 && response.data != null) {
      printInDebugMode(response.data['message']);
    } else {
      printInDebugMode("Error in delete job.");
    }
  }
}
