/// Practical 1 – Dart Programming Concepts Demonstration
///
/// This file demonstrates the following Dart programming fundamentals:
/// 1. Variables and Data Types
/// 2. Constants (const and final)
/// 3. Operators (arithmetic, relational, logical, assignment)
/// 4. Conditional Statements (if-else, switch)
/// 5. Loops (for, while, do-while)
/// 6. Functions (named, arrow, optional parameters)
/// 7. Classes and Objects
/// 8. Constructors (default, parameterized, named)
/// 9. Inheritance
/// 10. Encapsulation and Polymorphism (OOP)

/// Practical 1 – Dart Programming Concepts Demonstration
library;

// ignore_for_file: avoid_print, unnecessary_getters_setters, unnecessary_type_check

/// ---- 9. Inheritance: Parent class ----
class Person {
  // 10. Encapsulation – private fields use underscore prefix
  String _name;
  int _age;

  /// 8. Constructors – parameterized constructor
  Person(this._name, this._age);

  /// Named constructor
  Person.guest() : _name = 'Guest', _age = 0;

  /// Getters and setters for encapsulated fields
  String get name => _name;
  set name(String value) => _name = value;
  int get age => _age;
  set age(int value) => _age = value;

  void display() {
    print('Person  -> Name: $_name, Age: $_age');
  }
}

/// ---- 9. Inheritance: Child class extends Person ----
class Student extends Person {
  String enrollmentNo;
  String department;
  double cgpa;

  /// 8. Constructor – calls super constructor using super params
  Student(super.name, super.age, this.enrollmentNo, this.department, this.cgpa);

  /// 10. Polymorphism – overriding parent method
  @override
  void display() {
    print(
      'Student -> Name: $name, Age: $age, '
      'Enrollment: $enrollmentNo, Dept: $department, CGPA: $cgpa',
    );
  }

  String result() {
    // 4. Conditional statement – if-else
    if (cgpa >= 8.0) {
      return 'Distinction';
    } else if (cgpa >= 6.0) {
      return 'First Class';
    } else if (cgpa >= 4.0) {
      return 'Pass';
    } else {
      return 'Fail';
    }
  }
}

/// ---- 6. Function with optional and default parameters ----
int add(int x, int y) => x + y; // arrow function
int multiply(int a, int b) => a * b;

/// Function with optional positional parameter
String greet(String name, [String? title]) {
  if (title != null) {
    return 'Hello $title $name';
  }
  return 'Hello $name';
}

/// Function with named parameters and default values
double calculateArea({double length = 1.0, double width = 1.0}) {
  return length * width;
}

/// ---- Main function demonstrating all concepts ----
void demonstrateDartConcepts() {
  print('\n========================================');
  print('  DART PROGRAMMING CONCEPTS DEMONSTRATION');
  print('========================================\n');

  // 1. Variables and Data Types
  print('--- 1. Variables and Data Types ---');
  String studentName = 'Rahul Patel';
  String enrollment = '24CE001';
  int age = 20;
  double cgpa = 8.75;
  bool isStudent = true;
  List<String> subjects = ['MAD', 'DBMS', 'AI', 'CN'];
  Set<String> skills = {'Flutter', 'Dart', 'OOP', 'Mobile UI'};
  Map<String, double> attendance = {
    'MAD': 88.0,
    'DBMS': 92.0,
    'AI': 95.0,
    'CN': 90.0,
  };

  print('Name       : $studentName');
  print('Enrollment : $enrollment');
  print('Age        : $age');
  print('CGPA       : $cgpa');
  print('Is Student : $isStudent');
  print('Subjects   : $subjects');
  print('Skills     : $skills');
  print('Attendance : $attendance');

  // 2. Constants
  print('\n--- 2. Constants (const and final) ---');
  const double pi = 3.14159; // compile-time constant
  final String currentTime = DateTime.now().toString(); // runtime constant
  print('Pi (const)           : $pi');
  print('Current Time (final) : $currentTime');

  // 3. Operators
  print('\n--- 3. Operators ---');
  int a = 10, b = 3;
  print('a = $a, b = $b');
  print('Addition (a + b)         : ${a + b}');
  print('Subtraction (a - b)      : ${a - b}');
  print('Multiplication (a * b)   : ${a * b}');
  print('Division (a / b)         : ${a / b}');
  print('Integer Division (a ~/ b): ${a ~/ b}');
  print('Modulus (a % b)          : ${a % b}');
  print('Relational (a > b)       : ${a > b}');
  print('Relational (a == b)      : ${a == b}');
  print('Relational (a != b)      : ${a != b}');
  print('Logical (a > 5 && b < 5) : ${a > 5 && b < 5}');
  print('Logical (a > 15 || b < 5): ${a > 15 || b < 5}');
  print('Logical (!(a > b))       : ${!(a > b)}');
  print('Ternary (a > b ? a : b)  : ${a > b ? a : b}');

  // 4. Conditional Statements
  print('\n--- 4. Conditional Statements ---');
  double marks = 75.5;
  if (marks >= 90) {
    print('Grade: A+');
  } else if (marks >= 80) {
    print('Grade: A');
  } else if (marks >= 70) {
    print('Grade: B+');
  } else if (marks >= 60) {
    print('Grade: B');
  } else if (marks >= 40) {
    print('Grade: C');
  } else {
    print('Grade: F');
  }

  // Switch statement
  String day = 'Monday';
  switch (day) {
    case 'Monday':
      print('Today is Monday - DBMS lecture');
      break;
    case 'Tuesday':
      print('Today is Tuesday - MAD lecture');
      break;
    case 'Wednesday':
      print('Today is Wednesday - AI lecture');
      break;
    default:
      print('No lecture scheduled');
  }

  // 5. Loops
  print('\n--- 5. Loops ---');
  // For loop
  String forRes = '';
  for (int i = 1; i <= 5; i++) {
    forRes += '$i ';
  }
  print('For loop (1-5)     : $forRes');

  // While loop
  String whileRes = '';
  int j = 1;
  while (j <= 3) {
    whileRes += '$j ';
    j++;
  }
  print('While loop (1-3)   : $whileRes');

  // Do-while loop
  String doWhileRes = '';
  int k = 1;
  do {
    doWhileRes += '$k ';
    k++;
  } while (k <= 4);
  print('Do-while loop (1-4): $doWhileRes');

  // For-in loop
  String forInRes = '';
  for (String subject in subjects) {
    forInRes += '$subject ';
  }
  print('For-in (subjects)  : $forInRes');

  // 6. Functions
  print('\n--- 6. Functions ---');
  print('add(10, 20)            = ${add(10, 20)}');
  print('multiply(5, 4)         = ${multiply(5, 4)}');
  print('greet("Rahul")         = ${greet("Rahul")}');
  print('greet("Rahul", "Mr.")  = ${greet("Rahul", "Mr.")}');
  print('calculateArea(l:5,w:3) = ${calculateArea(length: 5.0, width: 3.0)}');
  print('calculateArea() default= ${calculateArea()}');

  // 7 & 8. Classes, Objects, Constructors
  print('\n--- 7. Classes, Objects, Constructors ---');
  Student student = Student(
    'Rahul Patel',
    20,
    '24CE001',
    'Computer Engineering',
    8.75,
  );
  student.display();
  print('Result: ${student.result()}');

  Person guest = Person.guest();
  guest.display();

  // 9. Inheritance
  print('\n--- 9. Inheritance ---');
  print('Student is a Person (inheritance): ${student is Person}');
  student.name = 'Rahul P.';
  student.display();

  // 10. Encapsulation
  print('\n--- 10. Encapsulation ---');
  student.age = 21;
  print('Updated age via setter: ${student.age}');
  print('Accessing name via getter: ${student.name}');

  print('\n========================================');
  print('  END OF DART CONCEPTS DEMONSTRATION');
  print('========================================\n');
}

/// Helper to avoid importing dart:io in web builds.
/// Uses print to output to console instead.
void stdoutWrite(String text) {
  // In Flutter web, stdout may not be available, so we use print.
  print(text);
}
