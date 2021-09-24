require 'csv'

puts "Number of FYS courses / sections being offered: "
numCourses = gets.chomp
puts "Number of students in the incoming class: "
numStudents = gets.chomp
puts "Name of file containing the list of FYS courses being offered: "
courseFile = gets.chomp
puts "Name of file containing the list of students in the incoming class, and their course choices: "
studentFile = gets.chomp
 
courseInfo = []
CSV.foreach((courseFile), headers: true, col_sep: ",", header_converters: :symbol) do |row|
    headers ||= row.headers
    courseInfo << row
end

studentInfo = []
CSV.foreach((studentFile), headers: true, col_sep: ",", header_converters: :symbol) do |row|
    headers ||= row.headers
    studentInfo << row
end

puts "Please enter the desired name of the first output csv file: "
output1 = gets.chomp
puts "Please enter the desired name of the second output csv file: "
output2 = gets.chomp

headers1 = ["Course ID","Student ID"]
CSV.open(output1, "w") do |csv|
  csv << headers1
  for i in 0...courseInfo.length()-1
    for j in 0...studentInfo.length()-1
      next if courseInfo[i][0] != studentInfo[j][1]
      csv << [courseInfo[i][0],studentInfo[j][0]]
    end
  end
end

headers2 = ["Course ID","Course Number","Course Title"]
CSV.open(output2, "w") do |csv|
  csv << headers2
  courseInfo.each do |row|
    csv << row
    for i in 0...studentInfo.length()-1
      next if row[0] != studentInfo[i][1]
      csv << [studentInfo[i][0]]
    end
  end
end