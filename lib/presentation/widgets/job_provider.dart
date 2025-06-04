import 'package:flutter/material.dart';
import 'package:talento_flutter/data/models/job_model.dart';
import 'package:talento_flutter/domain/repositories/job_repository.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class JobProvider extends ChangeNotifier {
  final JobRepository _repository;

  List<Job> _jobs = [];
  bool _isLoading = false;

  List<Job> get jobs => _jobs;

  bool get isLoading => _isLoading;

  JobProvider(this._repository);

  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();
    try {
      _jobs = await _repository.fetchJobs();
    } catch (e) {
      printInDebugMode('Error fetching jobs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
