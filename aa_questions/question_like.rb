require_relative 'questionsdbconnection.rb'
require_relative 'user.rb'
require_relative 'reply.rb'
require_relative 'question_follows.rb'
require_relative 'question.rb'

class QuestionLike
  def self.likers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        users
      JOIN 
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_id = ?
    SQL
    return nil if data.empty?
    data.map { |datum| User.new(datum) }
    
  end 
  
  def self.num_likes_for_question_id(question_id)
    #execution of select returns an array of hashes 
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(question_likes.user_id) as int_value 
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
    SQL
    return data[0]['int_value'] 
  end 
  
  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL
    return nil if data.empty?
    data.map { |datum| Question.new(datum) }
  end
  
  def self.most_liked_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(questions.id) DESC
      LIMIT ?
      SQL
    return nil if data.empty?
    data.map { |datum| Question.new(datum) }
  end
  
  
  
  
  
end 