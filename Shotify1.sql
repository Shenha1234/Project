create database shotify;
use shotify;

create table user(
   id bigint primary key,
   name varchar(200) not null,
   email varchar(300) not null unique,
   password varchar(200) not null,
   role varchar(300) not null default 'USER',
   profile_picture varchar(255),
   created_at timestamp default current_timestamp
   );
   
   select * from user;
   INSERT INTO user
(id, name, email, password, role, profile_picture)
VALUES
(1, 'Shenha Basuli', 'shenha@gmail.com', '123456', 'USER', 'profile1.jpg'),
(2, 'Rahul Das', 'rahul@gmail.com', '123456', 'USER', 'profile2.jpg'),
(3, 'Admin', 'admin@gmail.com', 'admin123', 'ADMIN', 'admin.jpg');


create table photographers (
    id bigint primary key auto_increment,
    user_id bigint not null,
    bio text,
    experience_years int default 0,
    specialization varchar(200),
    website varchar(255),
	foreign key (user_id) references user(id)
);   

INSERT INTO photographers
(user_id, bio, experience_years, specialization, website)
VALUES
(1, 'Professional photographer and creative artist', 5,
 'Wedding Photography', 'www.example.com'),

(2, 'Nature and wildlife photographer', 3,
 'Nature Photography', 'www.example2.com');
 
 select * from photographers;
 
 
 show tables;
 
 
 CREATE TABLE photos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    category_id BIGINT,
    title VARCHAR(200),
    description TEXT,
    image_url VARCHAR(500) NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES user(id),
        FOREIGN KEY (category_id) REFERENCES categories(id)
);

INSERT INTO photos
(user_id, category_id, title, description, image_url)
VALUES
(1, 1, 'Beautiful Wedding',
 'Wedding ceremony photography',
 'uploads/wedding1.jpg'),

(2, 2, 'Mountain View',
 'Beautiful mountain landscape',
 'uploads/mountain1.jpg'),

(1, 4, 'Portrait',
 'Professional portrait photography',
 'uploads/portrait1.jpg');

CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);
INSERT INTO categories
(name, description)
VALUES
('Wedding', 'Wedding and marriage photography'),
('Nature', 'Nature and landscape photography'),
('Wildlife', 'Wildlife photography'),
('Portrait', 'Portrait photography'),
('Fashion', 'Fashion photography');

CREATE TABLE competitions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(30) DEFAULT 'UPCOMING',
    created_by BIGINT,
        FOREIGN KEY (created_by) REFERENCES user(id)
);

INSERT INTO competitions
(title, description, start_date, end_date, status, created_by)
VALUES
(
    'Best Nature Photography',
    'Competition for the best nature photograph',
    '2026-09-01',
    '2026-10-01',
    'ACTIVE',
    3
),
(
    'Best Wedding Photography',
    'Wedding photography competition',
    '2026-10-05',
    '2026-11-05',
    'UPCOMING',
    3
);


CREATE TABLE competition_entries (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    competition_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    photo_id BIGINT NOT NULL,
    score DOUBLE DEFAULT 0,
    rank_position INT,
    result VARCHAR(50),
        FOREIGN KEY (competition_id) REFERENCES competitions(id),
        FOREIGN KEY (user_id) REFERENCES user(id),
        FOREIGN KEY (photo_id) REFERENCES photos(id)
);

INSERT INTO competition_entries
(competition_id, user_id, photo_id, score, rank_position, result)
VALUES
(1, 2, 5, 88.5, 1, 'WINNER'),
(1, 1, 4, 82.0, 2, 'RUNNER_UP');

SELECT id, user_id, title, image_url FROM photos;

SELECT id, title FROM competitions;

SELECT id, name, email FROM user;

SELECT * FROM photos;

SELECT * FROM competition_entries;

CREATE TABLE Likes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    photo_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES user(id),
        FOREIGN KEY (photo_id) REFERENCES photos(id),
    UNIQUE (user_id, photo_id)
);

INSERT INTO Likes
(user_id, photo_id)
VALUES
(1, 4),
(2, 5);

CREATE TABLE comments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    photo_id BIGINT NOT NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES user(id),
        FOREIGN KEY (photo_id) REFERENCES photos(id)
);

INSERT INTO comments
(user_id, photo_id, comment_text)
VALUES
(2, 5, 'Amazing wedding photograph!'),
(1, 4, 'Beautiful nature photography.');

CREATE TABLE followers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    follower_id BIGINT NOT NULL,
    following_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (follower_id) REFERENCES user(id),
        FOREIGN KEY (following_id) REFERENCES user(id),
    UNIQUE (follower_id, following_id)
);

INSERT INTO followers
(follower_id, following_id)
VALUES
(1, 2),
(2,1);

CREATE TABLE notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    message VARCHAR(500) NOT NULL,
    type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES user(id)
);

INSERT INTO notifications
(user_id, message, type, is_read)
VALUES
(1, 'Rahul liked your photo', 'LIKE', FALSE),
(2, 'You joined a competition', 'COMPETITION', FALSE);

CREATE TABLE reports (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    reporter_id BIGINT NOT NULL,
    photo_id BIGINT,
    reason VARCHAR(500) NOT NULL,
    status VARCHAR(30) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (reporter_id) REFERENCES user(id),
        FOREIGN KEY (photo_id) REFERENCES photos(id)
);

INSERT INTO reports
(reporter_id, photo_id, reason, status)
VALUES
(2, 5, 'Inappropriate content', 'PENDING');

CREATE TABLE admin (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    admin_level VARCHAR(50) DEFAULT 'SUPER_ADMIN',
        FOREIGN KEY (user_id) REFERENCES user(id)
);

INSERT INTO admin
(user_id, admin_level)
VALUES
(1, 'SUPER_ADMIN');

CREATE TABLE ml_result (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    photo_id BIGINT NOT NULL,
    quality_score DOUBLE,
    brightness_score DOUBLE,
    sharpness_score DOUBLE,
    composition_score DOUBLE,
    predicted_category VARCHAR(100),
    recommended_template VARCHAR(255),
    ml_status VARCHAR(50) DEFAULT 'COMPLETED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (photo_id) REFERENCES photos(id)
);

INSERT INTO ml_result
(photo_id,
 quality_score,
 brightness_score,
 sharpness_score,
 composition_score,
 predicted_category,
 recommended_template,
 ml_status)
VALUES
(
    4,
    92.5,
    88.0,
    95.0,
    90.0,
    'Wedding',
    'wedding_template_01.psd',
    'COMPLETED'
),
(
    5,
    89.0,
    91.0,
    87.0,
    93.0,
    'Nature',
    'nature_template_01.psd',
    'COMPLETED'
);

select * from ml_result;

select * from admin;
