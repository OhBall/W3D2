require_relative 'questionsdbconnection.rb'
require_relative 'user.rb'
require_relative 'reply.rb'
require_relative 'question_follows.rb'
class Question 
  
  def self.all
    data = QuestionsDBConnection.instance.execute(<<-SQL)
      SELECT *
      FROM questions
    SQL
    return nil if data.empty?
    data.map { |datum| Question.new(datum) }
  end 
  
  def self.most_followed(n)
    Question_Follows.most_followed_questions(n)
  end 
  
  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil if data.empty?
    Question.new(data.first)
  end
  
  def self.most_liked(n) #Fetches n most liked questions.
    QuestionLike.most_liked_questions(n)
  end 
    
  
  def self.find_by_title(title)
    data = QuestionsDBConnection.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ? 
    SQL
    return nil if data.empty? 
    data.map { |datum| Question.new(datum) }
  end
  
  def self.find_by_author_id(author_id) 
    data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
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
    
  attr_accessor :title, :body, :user_id, :id
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def author
    data = QuestionsDBConnection.instance.execute(<<-SQL, self.user_id)
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
  
  def followers
    Question_Follows.followers_for_question_id(self.id)
  end 
  
  def replies
    Reply.find_by_question_id(self.id)
  end
  
  def likers
    QuestionLike.likers_for_question_id(self.id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(question_id)
  end
end