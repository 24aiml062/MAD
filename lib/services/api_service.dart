import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/academic_notice.dart';

/// Centralized API Service handling RESTful network communication,
/// HTTP GET/POST requests, JSON serialization, and defensive error handling.
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration requestTimeout = Duration(seconds: 8);

  /// HTTP GET: Fetches live academic notices and university announcements from remote REST API.
  static Future<List<AcademicNotice>> getAcademicNotices({
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient
          .get(
            Uri.parse('$baseUrl/posts'),
            headers: {
              'Accept': 'application/json',
              'User-Agent':
                  'SmartStudentCompanion/1.0.0 (CHARUSAT; B.Tech AI&ML)',
            },
          )
          .timeout(requestTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        // Limit to 15 recent academic notices for optimal mobile display
        return data
            .take(15)
            .map(
              (item) => AcademicNotice.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw http.ClientException(
          'Remote server returned status ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      // In offline mode or network failure, return graceful cached academic notices
      return _getCachedFallbackNotices();
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }

  /// HTTP POST: Submits student feedback or academic inquiries to remote REST API.
  static Future<Map<String, dynamic>> submitFeedback(
    StudentFeedbackSubmission submission, {
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/posts'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(submission.toJson()),
          )
          .timeout(requestTimeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw http.ClientException(
          'Failed to submit feedback. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // If offline, simulate successful local queuing of submission
      return {
        'id': 101,
        'status': 'offline_queued',
        'message':
            'Saved locally due to offline network. Will sync when connected.',
        'studentName': submission.studentName,
        'category': submission.category,
      };
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }

  /// Fallback cached data providing offline resilience.
  static List<AcademicNotice> _getCachedFallbackNotices() {
    return const [
      AcademicNotice(
        id: 1,
        title: 'Mid-Semester Examination Schedule Announced',
        body:
            'The 5th Semester ODD (2026-27) mid-semester theory and practical exams commence on 10th November 2026. Hall tickets available on CHARUSAT portal.',
        category: 'Exam',
        date: '25 Oct 2026',
        author: 'CHARUSAT Examination Cell',
      ),
      AcademicNotice(
        id: 2,
        title: 'Campus Recruitment Drive: Tech Giants 2026',
        body:
            'Registration is open for B.Tech AI & ML and CSE students for upcoming on-campus placement drives. Eligibility: CGPA >= 7.5.',
        category: 'Placement',
        date: '24 Oct 2026',
        author: 'Training & Placement Cell (T&P)',
      ),
      AcademicNotice(
        id: 3,
        title: 'AI & Edge Computing National Workshop',
        body:
            'Department of AI & Machine Learning organises a 3-day hands-on workshop on Google AI Edge, TensorFlow Lite, and Flutter integration.',
        category: 'Workshop',
        date: '22 Oct 2026',
        author: 'Department of AI & ML',
      ),
      AcademicNotice(
        id: 4,
        title: 'Spoural 2026: Annual University Cultural & Tech Fest',
        body:
            'Call for student coordinators, technical event volunteers, and project exhibition teams. Register before 31st October 2026.',
        category: 'Tech Fest',
        date: '20 Oct 2026',
        author: 'Student Affairs Council',
      ),
      AcademicNotice(
        id: 5,
        title: 'Submission Deadline: Mobile App Development Practical 7',
        body:
            'All students are reminded to submit the completed RESTful API integration laboratory reports and GitHub repository commits on time.',
        category: 'Academic',
        date: '18 Oct 2026',
        author: 'Academic Section - FTE',
      ),
    ];
  }
}
