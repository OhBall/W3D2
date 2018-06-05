require_relative 'questionsdbconnection.rb'
require_relative 'user.rb'
require_relative 'question.rb'
class Reply 
  
  def self.all
    data = QuestionsDBConnection.instance.execute(<<-SQL)
      SELECT *
      FROM replies
    SQL
    data.map { |datum| Reply.new(datum) }
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return if data.empty?
    data.map { |datum| Reply.new(datum) }
  end

  
  def self.find_by_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    return nil if data.empty?
    data.map { |datum| Reply.new(datum) }
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end
  
  def author
    data = QuestionsDBConnection.instance.execute(<<-SQL, @user_id)
      SELECT
        *
      FROM
        users 
      WHERE
        id = ? 
    SQL
  
    return nil if data.length == 0 
    User.new(data.first)
  end 
  
  def question
    data = QuestionsDBConnection.instance.execute(<<-SQL, @question_id)
      SELECT 
        *
      FROM 
        questions
      WHERE
        id = ? 
    SQL
    return nil if data.length == 0
    Question.new(data.first)
  end 
  
  def parent_reply
    data = QuestionsDBConnection.instance.execute(<<-SQL, @reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil if data.length == 0
    Reply.new(data.first)
  end
  
  def child_replies
    data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL
    return nil if data.length == 0
    Reply.new(data.first)
  end
  
end