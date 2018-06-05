DROP TABLE if EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE if exists questions;

CREATE TABLE questions (
  id INTEGER PRIMARY key,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE if exists questions_follows;

CREATE TABLE questions_follows (
  id INTEGER PRIMARY key,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE if exists replies;

CREATE TABLE replies (
  id INTEGER PRIMARY key,
  question_id INTEGER NOT NULL,
  reply_id INTEGER, --we do not use NOT NULL because initial comments do NOT have parents 
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id)
);

DROP TABLE if exists question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY key,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

--Begin Seeding

INSERT INTO 
  users (fname, lname)
VALUES
  ('Alejandro', 'Marquez'),
  ('Oliver', 'Ball');

INSERT INTO  
  questions (title, body, user_id)
VALUES
  ('WTF?', 'Seriously? WTF!', 1),
  ('OLIVER_WTF?', 'OLIVER_Seriously? WTF!', 2),
  ('Why does nobody like my posts?', 'It''s very hurtful.', 2);

INSERT INTO
  questions_follows(user_id, question_id)
VALUES
  (1,2),
  (2,1),
  (2,2);

INSERT INTO
  replies(question_id, reply_id, user_id, body)
VALUES
  (1, NULL, 2, 'IDK'),
  (1, 1, 1, 'Alejandro replies to Oliver''s idk reply'),
  (2, NULL, 1, 'Reply to Oliver''s question');
  
INSERT INTO 
  question_likes(user_id, question_id)
VALUES
  (2,1),
  (1,1),
  (1,2);
  
  -- DROP TABLE if exists question_likes;
  -- 
  -- CREATE TABLE question_likes (
  --   id INTEGER PRIMARY key,
  --   user_id INTEGER NOT NULL,
  --   question_id INTEGER NOT NULL,
  -- 
  --   FOREIGN KEY (user_id) REFERENCES users(id),
  --   FOREIGN KEY (question_id) REFERENCES questions(id)
  -- );
