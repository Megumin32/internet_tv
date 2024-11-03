-- チャンネルテーブル
CREATE TABLE channels (
  channel_id INT NOT NULL AUTO_INCREMENT,
  channel_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (channel_id)
);

-- ジャンルテーブル
CREATE TABLE genres (
  genre_id INT NOT NULL AUTO_INCREMENT,
  genre_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (genre_id)
);

-- 番組テーブル
CREATE TABLE programs (
  program_id INT NOT NULL AUTO_INCREMENT,
  program_name VARCHAR(100) NOT NULL,
  air_time INT NOT NULL,
  season INT,
  episode INT,
  episode_title VARCHAR(100) NOT NULL,
  episode_detail VARCHAR(100) NOT NULL,
  genre_id INT,
  PRIMARY KEY (program_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON UPDATE CASCADE
);

-- 放送枠テーブル
CREATE TABLE slots (
  slot_id INT NOT NULL AUTO_INCREMENT,
  channel_id INT,
  program_id INT,
  start_time DATETIME,
  end_time DATETIME,
  PRIMARY KEY (slot_id),
  FOREIGN KEY (channel_id) REFERENCES channels(channel_id) ON UPDATE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(program_id) ON UPDATE CASCADE
);

-- ユーザテーブル
CREATE TABLE users (
  user_id INT NOT NULL AUTO_INCREMENT,
  user_name VARCHAR(100) NOT NULL,
  mail_address VARCHAR(100) NOT NULL,
  PRIMARY KEY (user_id)
);

-- 視聴履歴テーブル
CREATE TABLE histories (
  history_id INT NOT NULL AUTO_INCREMENT,
  slot_id INT,
  user_id INT,
  PRIMARY KEY (history_id),
  FOREIGN KEY (slot_id) REFERENCES slots(slot_id) ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON UPDATE CASCADE  
);