require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  # create a table here with the following column names and their types
  def self.create_table
    # execute the following SQL code in the database - - > this code creates the students table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)")
  end

  def self.drop_table
    DB[:conn].execute("drop table students")
  end

  # save is an instance method that saves the instance to the database
  def save
    if self.id
  self.update
else
    sql = <<-SQL
       INSERT INTO students (name, grade)
       VALUES (?, ?)
     SQL
     DB[:conn].execute(sql, self.name, self.grade)

     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end

  # the create method will automatically instantiate and save objects to the database
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    #student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql)
  end


  def self.new_from_db(row)
    new_student = Student.new(row[0], row[1], row[2])
    new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
# class end
end
