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

    def self.find_by_id(id)
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

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT
            *
        FROM
            users
        WHERE
            fname = ? AND
            lname = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end

    # use Question::find_by_author_id
    def authored_questions
        Question.find_by_author_id(@id)
    end

    # use Reply::find_by_user_id
    def authored_replies
        Reply.find_by_user_id(@id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(@id)
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

    def self.find_by_id(id)
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

    def self.find_by_author_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions
        WHERE
            u_id = ?
        SQL
        return nil unless question.length > 0

        questions = []
        question.each {|rep|questions << Question.new(rep)}
        questions
    end

    def author
        User.find_by_id(@u_id)
    end

    def replies
        Reply.find_by_question_id(@id)
    end

    def followers
        QuestionFollow.followers_for_question_id(@id)
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
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

    def self.find_by_id(id)
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

    def self.find_by_user_id(u_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, u_id)
        SELECT
            *
        FROM
            replies
        WHERE
            u_id = ?
        SQL
        return nil unless reply.length > 0

        replies = []
        reply.each {|rep|replies << Reply.new(rep)}
        replies
    end

    def self.find_by_question_id(q_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, q_id)
        SELECT
            *
        FROM
            replies
        WHERE
            q_id = ?
        SQL
        return nil unless reply.length > 0

        replies = []
        reply.each {|rep|replies << Reply.new(rep)}
        replies
    end

    def author
        User.find_by_id(@u_id)
    end

    def question
        Question.find_by_id(@q_id)
    end

    def parent_reply
        Reply.find_by_id(@r_id)
    end

    def child_replies
        # Reply.find_by_id(@id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, @id)
        SELECT
            *
        FROM
            replies
        WHERE
            r_id = ?
        SQL
        return nil unless reply.length > 0

        replies = []
        reply.each {|rep|replies << Reply.new(rep)}
        replies.length == 1 ? replies.first : replies
    end
end

class QuestionFollow
    attr_accessor :u_id, :q_id
    
    def initialize(options)
        @u_id = options['u_id']
        @q_id = options['q_id']
    end

    def self.followers_for_question_id(q_id)
        result = QuestionsDatabase.instance.execute(<<-SQL, q_id)
        SELECT
            *
        FROM
            question_follows
        JOIN 
            users ON users.id = question_follows.u_id
        WHERE
            q_id = ?
        SQL

        followers = []
        result.each {|rep|followers << User.new(rep)}
        followers.length == 1 ? followers.first : followers
    end

    def self.followed_questions_for_user_id(user_id)

        result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        
        SELECT
            *
        FROM
            questions
        JOIN
            question_follows ON questions.id = question_follows.q_id
        WHERE
            question_follows.u_id = ?
        SQL

        questions = []
        result.each {|res|questions << Question.new(res)}
        questions.length == 1 ? questions.first : questions
    end

    def self.most_followed_questions(n)
        result = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                *
            FROM
                questions
            JOIN 
                question_follows ON questions.id = question_follows.q_id

                GROUP BY questions.id 
                ORDER BY COUNT (question_follows.u_id) ASC
                LIMIT ?
        SQL
        questions = []
        result.each {|res|questions << Question.new(res)}
        questions.length == 1 ? questions.first : questions
    end
end

class QuestionLike
    attr_accessor :u_id, :q_id
    
    def initialize(options)
        @u_id = options['u_id']
        @q_id = options['q_id']
    end
end