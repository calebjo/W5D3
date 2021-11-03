require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include singleton
    def initialize
        super('plays.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    def initialize
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
class Questions
    def initialize
    end
end
class Replies
    def initialize
    end
end
class QuestionsFollow
    def initialize
    end
end

class QuestionLikes
    def initialize
    end
end