require_relative 'questionsdbconnection.rb'
require_relative 'user.rb'
require_relative 'reply.rb'
require 'byebug'
class Question_Follows
  
  def self.followers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
    SELECT users.id, fname, lname
    from Users 
    JOIN questions_follows ON users.id = questions_follows.user_id 
    WHERE question_id = ?
    SQL
    return nil if data.length == 0 
    data.map { |datum| User.new(datum) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
    SELECT 
      questions.id, questions.title, questions.body, questions.user_id
    FROM
      questions
    JOIN
      questions_follows ON questions.id = questions_follows.question_id
    WHERE
      questions_follows.user_id = ?
    SQL
    return nil if data.length == 0
    data.map { |datum| Question.new(datum) }
  end 
    
  def self.most_followed_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN 
        questions_follows ON questions.id = questions_follows.question_id
      GROUP BY 
        questions.id
      ORDER BY
        COUNT(questions.id) DESC
      LIMIT ?  
    SQL
    return nil if data.empty?
    data.map { |datum| Question.new(datum)}
  end
  
  attr_accessor :id, :user_id, :question_id
  def initialize (options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end 
  
  
end 
  
  