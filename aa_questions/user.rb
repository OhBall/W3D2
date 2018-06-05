require_relative 'questionsdbconnection.rb'
require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'question_follows.rb'

class User
  
  def self.all
    data = QuestionsDBConnection.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
    SQL
    return nil if data.empty?
    data.map { |datum| User.new(datum) }
  end 
  
  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil if data.empty?
    User.new(data.first)
  end
  
  def self.find_by_name(fname, lname)
    data = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil if data.empty? 
    data.map { |datum| User.new(datum) }
  end
  
  attr_accessor :fname, :lname, :id
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions
    data = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    return nil if data.empty?
    data.map { |datum| Question.new(datum) }
  end
  
  def average_karma #Avg number of likes for a User's questions.
    data = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
      SELECT
        CAST(COUNT(question_likes.user_id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS avg_likes
      FROM
        questions
      LEFT OUTER JOIN 
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.user_id = ?
    SQL
  data[0]['avg_likes']
    
  end 
  
  def followed_questions
    Question_Follows.followed_questions_for_user_id(self.id)
  end 
  
  def authored_replies
    data = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil if data.empty?
    data.map { |datum| Reply.new(datum) }
  end
  
end