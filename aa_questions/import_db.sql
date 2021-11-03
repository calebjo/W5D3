PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

-- CREATE TABLE questions (
--     id INTEGER PRIMARY KEY,
--     title TEXT NOT NULL,
--     body TEXT NOT NULL,

--     FOREIGN KEY (u_id) REFERENCES users(id)
-- );

-- DROP TABLE IF EXISTS question_follows;

-- CREATE TABLE question_follows (
--     FOREIGN KEY (u_id) REFERENCES users(id),
--     FOREIGN KEY (q_id) REFERENCES questions(id)
-- );

-- DROP TABLE IF EXISTS replies;

-- CREATE TABLE replies (
--     id INTEGER PRIMARY KEY,
--     body TEXT NOT NULL,

--     FOREIGN KEY (u_id) REFERENCES users(id),
--     FOREIGN KEY (q_id) REFERENCES questions(id),
--     FOREIGN KEY (r_id) REFERENCES replies(id)
-- );

-- DROP TABLE IF EXISTS question_likes;

-- CREATE TABLE question_likes (
--     FOREIGN KEY (u_id) REFERENCES users(id),
--     FOREIGN KEY (q_id) REFERENCES questions(id)
-- );


INSERT INTO users
    users (fname, lname) 
VALUES 
    ('cal', 'jon'),
    ('ed', 'fo');

-- INSERT INTO questions
--     questions (title, body, u_id) 
-- VALUES 
--     ('wigs', 'do you?', (SELECT id FROM users WHERE fname = 'cal')),
--     ('elon', 'for pres?', (SELECT id FROM users WHERE fname = 'ed'));

-- INSERT INTO replies
--     replies (body, u_id, q_id, r_id) 
-- VALUES 
--     ('no', (SELECT id FROM users WHERE fname = 'cal'),(SELECT id FROM questions WHERE title = 'wigs'), NULL),
--     ('future?', (SELECT id FROM users WHERE fname = 'cal'),(SELECT id FROM questions WHERE title = 'wigs'), (SELECT id FROM replies WHERE body = 'no'));
