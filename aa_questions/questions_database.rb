require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :id, :fname, :lname
    
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            users
        WHERE
            id = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end
end

class Question
    attr_accessor :id, :title, :body, :u_id
    
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @u_id = options['u_id']
    end

    def find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?
        SQL
        return nil unless question.length > 0

        Question.new(question.first)
    end

    def find_by_author_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions
        WHERE
            u_id = ?
        SQL
        return nil unless question.length > 0

        Question.new(question.first)
    end
end

class Reply
    attr_accessor :id, :body, :u_id, :q_id, :r_id
    
    def initialize(options)
        @id = options['id']
        @body = options['body']
        @u_id = options['u_id']
        @q_id = options['q_id']
        @r_id = options['r_id']
    end

    def find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            replies
        WHERE
            id = ?
        SQL
        return nil unless reply.length > 0

        Reply.new(reply.first)
    end

    def find_by_user_id(u_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            reply
        WHERE
            u_id = ?
        SQL
        return nil unless question.length > 0

        Reply.new(reply.first)
    end

    def find_by_question_id(q_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            reply
        WHERE
            q_id = ?
        SQL
        return nil unless question.length > 0

        Reply.new(reply.first)
    end
end

class QuestionFollow
    attr_accessor :u_id, :q_id
    
    def initialize(options)
        @u_id = options['u_id']
        @q_id = options['q_id']
    end
end

class QuestionLike
    attr_accessor :u_id, :q_id
    
    def initialize(options)
        @u_id = options['u_id']
        @q_id = options['q_id']
    end
end