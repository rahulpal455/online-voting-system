CREATE DATABASE IF NOT EXISTS campus_voting;
USE campus_voting;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(40) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    password_hash CHAR(64) NOT NULL,
    role ENUM('ADMIN','VOTER') NOT NULL
);

CREATE TABLE elections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    starts_at DATETIME NOT NULL,
    ends_at DATETIME NOT NULL,
    status ENUM('OPEN','CLOSED') NOT NULL DEFAULT 'OPEN',
    CHECK (ends_at > starts_at)
);

CREATE TABLE candidates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    election_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    manifesto VARCHAR(255),
    CONSTRAINT candidate_in_own_election UNIQUE (id, election_id),
    FOREIGN KEY (election_id) REFERENCES elections(id) ON DELETE CASCADE
);

CREATE TABLE votes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    election_id INT NOT NULL,
    voter_id INT NOT NULL,
    candidate_id INT NOT NULL,
    cast_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT one_vote_per_election UNIQUE (election_id, voter_id),
    FOREIGN KEY (election_id) REFERENCES elections(id),
    FOREIGN KEY (voter_id) REFERENCES users(id),
    -- This composite key prevents a vote for a candidate from another election.
    FOREIGN KEY (candidate_id, election_id) REFERENCES candidates(id, election_id)
);

-- Password for every sample account: password
INSERT INTO users (username, full_name, password_hash, role) VALUES
('admin', 'Election Administrator', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'ADMIN'),
('alice', 'Alice Johnson', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'VOTER'),
('bob', 'Bob Singh', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'VOTER'),
('carol', 'Carol Das', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'VOTER');

INSERT INTO elections (title, starts_at, ends_at, status) VALUES
('University President Election', NOW() - INTERVAL 1 DAY, NOW() + INTERVAL 7 DAY, 'OPEN');

INSERT INTO candidates (election_id, name, department, manifesto) VALUES
(1, 'Riya Sharma', 'Computer Science', 'Improved student feedback and library hours.'),
(1, 'Arjun Mehta', 'Mechanical Engineering', 'More clubs and transparent society funding.');
