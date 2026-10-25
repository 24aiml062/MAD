import 'package:flutter/material.dart';

/// Model representing subject-wise attendance.
class AttendanceItem {
  final String subjectCode;
  final String subjectName;
  final double percentage;
  final int attendedLectures;
  final int totalLectures;
  final Color color;

  const AttendanceItem({
    required this.subjectCode,
    required this.subjectName,
    required this.percentage,
    required this.attendedLectures,
    required this.totalLectures,
    required this.color,
  });

  static const List<AttendanceItem> sampleAttendance = [
    AttendanceItem(
      subjectCode: 'AIUE302',
      subjectName: 'Mobile Application Development (MAD)',
      percentage: 88.0,
      attendedLectures: 30,
      totalLectures: 34,
      color: Color(0xFF1E88E5), // Blue
    ),
    AttendanceItem(
      subjectCode: 'AIUE303',
      subjectName: 'Database Management Systems (DBMS)',
      percentage: 92.0,
      attendedLectures: 35,
      totalLectures: 38,
      color: Color(0xFF00897B), // Teal
    ),
    AttendanceItem(
      subjectCode: 'AIUE304',
      subjectName: 'Artificial Intelligence (AI)',
      percentage: 95.0,
      attendedLectures: 38,
      totalLectures: 40,
      color: Color(0xFF7CB342), // Green
    ),
    AttendanceItem(
      subjectCode: 'AIUE305',
      subjectName: 'Computer Networks (CN)',
      percentage: 90.0,
      attendedLectures: 36,
      totalLectures: 40,
      color: Color(0xFF8E24AA), // Purple
    ),
  ];
}

/// Model representing a daily lecture slot in the timetable.
class TimetableSlot {
  final String time;
  final String subject;
  final String faculty;
  final String room;
  final String type; // Lecture, Lab, Tutorial
  final Color color;

  const TimetableSlot({
    required this.time,
    required this.subject,
    required this.faculty,
    required this.room,
    required this.type,
    required this.color,
  });

  static const Map<String, List<TimetableSlot>> weeklySchedule = {
    'Monday': [
      TimetableSlot(
        time: '09:00 - 10:00 AM',
        subject: 'Mobile Application Development (MAD)',
        faculty: 'Prof. J. Sharma',
        room: 'Room 301 (FTE Block A)',
        type: 'Theory Lecture',
        color: Color(0xFF1E88E5),
      ),
      TimetableSlot(
        time: '10:15 - 11:15 AM',
        subject: 'Database Management Systems (DBMS)',
        faculty: 'Dr. P. Joshi',
        room: 'Room 304 (FTE Block A)',
        type: 'Theory Lecture',
        color: Color(0xFF00897B),
      ),
      TimetableSlot(
        time: '11:30 AM - 01:30 PM',
        subject: 'Artificial Intelligence Lab',
        faculty: 'Prof. R. Dave',
        room: 'AI Computing Lab 2',
        type: 'Practical Lab',
        color: Color(0xFFE53935),
      ),
      TimetableSlot(
        time: '02:15 - 03:15 PM',
        subject: 'Computer Networks (CN)',
        faculty: 'Dr. A. Trivedi',
        room: 'Room 205 (FTE Block B)',
        type: 'Theory Lecture',
        color: Color(0xFF8E24AA),
      ),
    ],
    'Tuesday': [
      TimetableSlot(
        time: '09:00 - 11:00 AM',
        subject: 'MAD Flutter Hands-on Lab',
        faculty: 'Prof. J. Sharma',
        room: 'Mobile App Lab 1',
        type: 'Practical Lab',
        color: Color(0xFF1E88E5),
      ),
      TimetableSlot(
        time: '11:15 - 12:15 PM',
        subject: 'Artificial Intelligence (AI)',
        faculty: 'Prof. R. Dave',
        room: 'Room 302 (FTE Block A)',
        type: 'Theory Lecture',
        color: Color(0xFF7CB342),
      ),
      TimetableSlot(
        time: '01:15 - 02:15 PM',
        subject: 'Database Management Systems (DBMS)',
        faculty: 'Dr. P. Joshi',
        room: 'Room 304 (FTE Block A)',
        type: 'Theory Lecture',
        color: Color(0xFF00897B),
      ),
    ],
  };
}

/// Model representing course assignments.
class AssignmentItem {
  final String title;
  final String subject;
  final String dueDate;
  final String status;
  final String priority;
  final double progress;

  const AssignmentItem({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.status,
    required this.priority,
    required this.progress,
  });

  static const List<AssignmentItem> sampleAssignments = [
    AssignmentItem(
      title: 'Practical 3: Responsive UI & Layout Design',
      subject: 'Mobile Application Development (MAD)',
      dueDate: 'Oct 28, 2026',
      status: 'In Progress',
      priority: 'High',
      progress: 0.85,
    ),
    AssignmentItem(
      title: 'Database CRUD & Normalization Queries',
      subject: 'Database Management Systems (DBMS)',
      dueDate: 'Nov 02, 2026',
      status: 'Pending',
      priority: 'Medium',
      progress: 0.40,
    ),
    AssignmentItem(
      title: 'A* & Heuristic Search Space Implementation',
      subject: 'Artificial Intelligence (AI)',
      dueDate: 'Nov 06, 2026',
      status: 'Submitted',
      priority: 'Low',
      progress: 1.0,
    ),
    AssignmentItem(
      title: 'REST API Integration and Client Serialization',
      subject: 'Mobile Application Development (MAD)',
      dueDate: 'Nov 12, 2026',
      status: 'Upcoming',
      priority: 'Medium',
      progress: 0.10,
    ),
  ];
}

/// Model representing academic notifications.
class NotificationItem {
  final String title;
  final String message;
  final String time;
  final String category;
  final bool isUnread;
  final IconData icon;
  final Color color;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    required this.isUnread,
    required this.icon,
    required this.color,
  });

  static const List<NotificationItem> sampleNotifications = [
    NotificationItem(
      title: 'Mid-Semester Internal Exam Schedule',
      message:
          'The odd-semester examination dates for 5th semester have been announced. Exams begin Dec 10.',
      time: '2 hours ago',
      category: 'Examination',
      isUnread: true,
      icon: Icons.event_note,
      color: Colors.redAccent,
    ),
    NotificationItem(
      title: 'MAD Assignment 3 Submission Deadline',
      message:
          'Reminder: Submit your responsive UI design reports before Oct 28 on the student portal.',
      time: 'Yesterday',
      category: 'Assignment',
      isUnread: true,
      icon: Icons.assignment_late,
      color: Colors.orange,
    ),
    NotificationItem(
      title: 'Technical Event & Hackathon Registration',
      message:
          'Registrations are open for the National AI & Mobile App Hackathon 2026 organized by CHARUSAT.',
      time: '3 days ago',
      category: 'Events',
      isUnread: false,
      icon: Icons.celebration,
      color: Colors.purple,
    ),
    NotificationItem(
      title: 'Library Book Due Reminder',
      message:
          'You have 2 books borrowed from the FTE central library due for renewal on Oct 30.',
      time: '4 days ago',
      category: 'Library',
      isUnread: false,
      icon: Icons.local_library,
      color: Colors.teal,
    ),
  ];
}

/// Model representing university faculty details.
class FacultyMember {
  final String name;
  final String designation;
  final String department;
  final String subjects;
  final String email;
  final String office;
  final String initials;

  const FacultyMember({
    required this.name,
    required this.designation,
    required this.department,
    required this.subjects,
    required this.email,
    required this.office,
    required this.initials,
  });

  static const List<FacultyMember> facultyList = [
    FacultyMember(
      name: 'Prof. Jayesh Sharma',
      designation: 'Assistant Professor & Course Coordinator',
      department: 'Dept. of Artificial Intelligence & Machine Learning',
      subjects: 'Mobile Application Development (MAD), Flutter',
      email: 'jayesh.sharma@charusat.edu.in',
      office: 'FTE Block A, Room 302',
      initials: 'JS',
    ),
    FacultyMember(
      name: 'Dr. Priya Joshi',
      designation: 'Associate Professor',
      department: 'Dept. of Computer Science and Engineering',
      subjects: 'Database Management Systems (DBMS), Big Data',
      email: 'priya.joshi@charusat.edu.in',
      office: 'FTE Block A, Room 308',
      initials: 'PJ',
    ),
    FacultyMember(
      name: 'Prof. Rakesh Dave',
      designation: 'Assistant Professor',
      department: 'Dept. of Artificial Intelligence & Machine Learning',
      subjects: 'Artificial Intelligence (AI), Machine Learning',
      email: 'rakesh.dave@charusat.edu.in',
      office: 'FTE Block B, Room 204',
      initials: 'RD',
    ),
    FacultyMember(
      name: 'Dr. Ankit Trivedi',
      designation: 'Professor & Head of Department',
      department: 'Dept. of Computer Engineering',
      subjects: 'Computer Networks (CN), Cloud Infrastructure',
      email: 'ankit.trivedi@charusat.edu.in',
      office: 'FTE Block A, HOD Office',
      initials: 'AT',
    ),
  ];
}

/// Model representing campus event gallery cards.
class EventItem {
  final String title;
  final String date;
  final String location;
  final String description;
  final String category;
  final IconData icon;
  final Color color;

  const EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
  });

  static const List<EventItem> eventList = [
    EventItem(
      title: 'National AI & Mobile Hackathon',
      date: 'Nov 15-16, 2026',
      location: 'CHARUSAT Innovation Hub',
      description:
          '36-hour hackathon solving real-world challenges with Flutter, AI models, and cloud APIs.',
      category: 'Hackathon',
      icon: Icons.code,
      color: Color(0xFF1E88E5),
    ),
    EventItem(
      title: 'AI & Edge Computing Summit',
      date: 'Nov 20, 2026',
      location: 'Central Auditorium',
      description:
          'Keynote sessions by industry leaders on On-Device Gemini Nano and AI Edge inference.',
      category: 'Conference',
      icon: Icons.psychology,
      color: Color(0xFF00897B),
    ),
    EventItem(
      title: 'Tech Fest "Cognizance 2026"',
      date: 'Nov 28-29, 2026',
      location: 'FTE Campus Grounds',
      description:
          'Annual technical fest featuring coding competitions, robotics, and design sprints.',
      category: 'Tech Fest',
      icon: Icons.rocket_launch,
      color: Color(0xFFD81B60),
    ),
    EventItem(
      title: 'Cloud & DevOps Workshop',
      date: 'Dec 02, 2026',
      location: 'Computer Lab 3',
      description:
          'Hands-on practical training on Docker, Kubernetes, CI/CD pipelines, and cloud deployment.',
      category: 'Workshop',
      icon: Icons.cloud_done,
      color: Color(0xFFFB8C00),
    ),
    EventItem(
      title: 'Annual Cultural Fiesta "Spandan"',
      date: 'Dec 18-19, 2026',
      location: 'University Amphitheatre',
      description:
          'Music, drama, literary arts, and cultural celebration across CHARUSAT departments.',
      category: 'Cultural',
      icon: Icons.music_note,
      color: Color(0xFF8E24AA),
    ),
    EventItem(
      title: 'Alumni Mentorship Conclave',
      date: 'Jan 08, 2027',
      location: 'Seminar Hall 1',
      description:
          'Networking and career guidance session with alumni working at Google, Microsoft, and Amazon.',
      category: 'Career',
      icon: Icons.people_alt,
      color: Color(0xFF43A047),
    ),
  ];
}
