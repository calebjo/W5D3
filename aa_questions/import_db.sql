PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    u_id INTEGER NOT NULL,

    FOREIGN KEY (u_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    u_id INTEGER NOT NULL,
    q_id INTEGER NOT NULL,

    FOREIGN KEY (u_id) REFERENCES users(id),
    FOREIGN KEY (q_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    u_id INTEGER NOT NULL,
    q_id INTEGER NOT NULL,
    r_id INTEGER,

    FOREIGN KEY (u_id) REFERENCES users(id),
    FOREIGN KEY (q_id) REFERENCES questions(id),
    FOREIGN KEY (r_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    u_id INTEGER NOT NULL,
    q_id INTEGER NOT NULL,

    FOREIGN KEY (u_id) REFERENCES users(id),
    FOREIGN KEY (q_id) REFERENCES questions(id)
);

-- ----------------------------------------------------------------------------------
INSERT INTO
    users (fname, lname) 
VALUES 
    ('Caleb', 'Jones'),
    ('Ed', 'Foti'),
    ('John', 'Cigale'),
    ('David', 'Suh');

INSERT INTO
    questions (title, body, u_id) 
VALUES 
    ('wigs', 'do you?', (SELECT id FROM users WHERE fname = 'Caleb')),
    ('elon', 'for pres?', (SELECT id FROM users WHERE fname = 'Ed'));


INSERT INTO
    replies (body, u_id, q_id, r_id) 
VALUES 
    ('no', (SELECT id FROM users WHERE fname = 'Ed'),(SELECT id FROM questions WHERE title = 'wigs'), NULL);

INSERT INTO
    replies (body, u_id, q_id, r_id) 
VALUES 
    ('future?', (SELECT id FROM users WHERE fname = 'Caleb'),(SELECT id FROM questions WHERE title = 'wigs'), (SELECT id FROM replies WHERE body = 'no'));
    
INSERT INTO
    replies (body, u_id, q_id, r_id) 
VALUES 
    ('this is a test reply', (SELECT id FROM users WHERE fname = 'Caleb'),(SELECT id FROM questions WHERE title = 'wigs'), (SELECT id FROM replies WHERE body = 'future?'));

INSERT INTO
    replies (body, u_id, q_id, r_id) 
VALUES 
    ('a reply to a test reply', (SELECT id FROM users WHERE fname = 'Caleb'),(SELECT id FROM questions WHERE title = 'wigs'), (SELECT id FROM replies WHERE body = 'this is a test reply'));
INSERT INTO
    question_follows (u_id, q_id)
VALUES
    (1,1),
    (2,1),
    (3,1),
    (4,1),
    (1,2),
    (2,2);