# Gregory Yezhov
# CSC 415-02
# Assignment 1 Revision
require 'csv'

# Definition for Student class
class Student
  # Initialize Student object with unique ID
  def init(studentID)
    @studentID = studentID
  end
  # Class method to return student's ID
  def get_ID
    @studentID
  end
end
# Definition for Course class
class Course
  # Initialize a Course object
  def set_Course(courseID, courseNumber, courseTitle)
    @id = courseID
    @num = courseNumber
    @name = courseTitle
    @students = []
  end
  # Returns number of students in that course
  def get_Student_Count
    @students.length - 1
  end
  # Returns Course ID
  def get_ID
    @id
  end
  # Returns Course Number
  def get_courseNum
    @num
  end
  # Returns Course Name
  def get_courseName
    @name
  end
  # Returns Course Students
  def get_Students
    @students
  end
  # Add a student to the course  
  def addStudent(student)
    @students << student
  end
end
# Scheduling Function Declaration and Definition
def course_scheduler(courseTable, studentTable)
  puts 'Please enter the desired name of the first output csv file: '
  output1 = gets.chomp
  puts 'Please enter the desired name of the second output csv file: '
  output2 = gets.chomp
  # Declare and initialize a blank array 
  courseList = []

  # First output file handler
  headers1 = ['Course ID', 'Student ID']
  CSV.open(output1, 'w') do |csv|
    # Write the headers into the file
    csv << headers1
    # Loop that iterates through each course in the course list file by 
    # line, and creates and initializes an object for each course
    courseTable.each do |row1|
      course = Course.new
      course.set_Course(row1[0], row1[1], row1[2])
      # Loop that iterates through each student in the Selections file
      studentTable.each do |row2|
        # Jump to next course if the current course is full
        break if course.get_Student_Count > 18
        # Jump to next line in selections file if the student's choice
        # does not match with the current course ID
        next if row1[0] != row2[1]
        # Create and intialize new Student object, add it to the course, 
        # and write that student and course ID to the output file
        student = Student.new
        student.init(row2[0])
        course.addStudent(student)
        csv << [row1[0], row2[0]]
      end
      # Push the course to the aforementioned array
      courseList.push(course)
    end
  end

  # Second output file handler
  headers2 = ['Course ID', 'Course Number', 'Course Title']
  CSV.open(output2, 'w') do |csv|
    # Write headers into the second output file
    csv << headers2
    # Iterate through each course in the courseList array, print that 
    # course's attributes to the output file, and print its subsequent 
    # students
    courseList.each do |course|
      csv << [course.get_ID, course.get_courseNum, course.get_courseName]
      courseStudents = course.get_Students
      # Iterate through the students of each course and print their ID's
      courseStudents.each do |student|
        csv << [student.get_ID]
      end
    end
  end
end

# Prompts for user input
puts 'Number of FYS courses / sections being offered: '
numCourses = gets.chomp
# Handles if negative number of courses are entered
if numCourses.to_i < 0
  puts 'Cannot have negative number of courses, please try again: '
  numCourses = gets.chomp
end
puts 'Number of students in the incoming class: '
numStudents = gets.chomp
# Handles if user enters negative number of students
if numStudents.to_i < 0
  puts 'Cannot have negative number of students, please try again: '
  numStudents = gets.chomp
end
puts 'Name of file containing the list of FYS courses being offered: '
courseFile = gets.chomp
puts 'Name of file containing the list of students in the incoming class, and their course choices: '
studentFile = gets.chomp
# Parse each CSV file into respective array of CSV objects
courseInfo = CSV.parse(File.read(courseFile), headers: true)
studentInfo = CSV.parse(File.read(studentFile), headers: true)

course_scheduler(courseInfo, studentInfo)