/// Model class representing student academic and personal details.
class StudentModel {
  final String id;
  final String name;
  final String enrollmentNo;
  final String department;
  final String semester;
  final String email;
  final String phone;
  final double cgpa;
  final double attendancePercentage;
  final List<String> subjects;
  final List<String> notifications;

  const StudentModel({
    required this.id,
    required this.name,
    required this.enrollmentNo,
    required this.department,
    required this.semester,
    required this.email,
    required this.phone,
    required this.cgpa,
    required this.attendancePercentage,
    required this.subjects,
    required this.notifications,
  });

  /// Default student profile matching user requirements and academic syllabus data.
  static const StudentModel currentStudent = StudentModel(
    id: 'STU-2026-062',
    name: 'Parita Shah',
    enrollmentNo: '24AIML062',
    department: 'Artificial Intelligence & Machine Learning',
    semester: '5th Semester (Odd 2026-27)',
    email: '24aiml062@charusat.edu.in',
    phone: '+91 98765 43210',
    cgpa: 8.75,
    attendancePercentage: 91.0,
    subjects: [
      'Mobile Application Development (MAD)',
      'Database Management Systems (DBMS)',
      'Artificial Intelligence (AI)',
      'Computer Networks (CN)',
    ],
    notifications: [
      'Assignment submission deadline for MAD: Oct 28',
      'AI Workshop and Hackathon registration is open',
      'Mid-Semester Examination schedule published',
    ],
  );
}
