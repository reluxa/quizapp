class Question
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :title,      String    # A varchar type string, for short strings
  has n, :answers
  belongs_to :correct, :model => "Answer", :required => false
  belongs_to :owner, :model => "DmUser", :required => true
end


class Answer
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :mtext,      String    # A varchar type string, for short strings
end

class DmUser
  property :name, String
end

class QuizStats
  include DataMapper::Resource
  property :id,         Serial    # An auto-increment integer key
  property :result,      Integer
  belongs_to :owner, :model => "DmUser", :required => true
end