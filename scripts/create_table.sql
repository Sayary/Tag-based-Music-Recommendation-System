CREATE TABLE `albums` (
  `album_id` int(11) NOT NULL DEFAULT '0',
  `album_name` varchar(255) NOT NULL,
  `published_date` date DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `artist_id` int(11) NOT NULL,
  `description_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`album_id`),
  KEY `album_artist_idx` (`artist_id`),
  CONSTRAINT `album_artist` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`artist_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `artists` (
  `artist_id` int(11) NOT NULL DEFAULT '0',
  `artist_name` varchar(255) NOT NULL,
  `artist_image` varchar(255) DEFAULT NULL,
  `artist_style` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`artist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `companies` (
  `company_id` int(11) NOT NULL DEFAULT '0',
  `company_name` varchar(255) NOT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `listed_songs` (
  `track_id` int(11) NOT NULL DEFAULT '0',
  `list_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`track_id`,`list_id`),
  KEY `lists_FK_idx` (`list_id`),
  CONSTRAINT `lists_FK` FOREIGN KEY (`list_id`) REFERENCES `playlists` (`list_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `songs_FK` FOREIGN KEY (`track_id`) REFERENCES `songs` (`track_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `publications` (
  `album_id` int(11) NOT NULL DEFAULT '0',
  `artist_id` int(11) NOT NULL DEFAULT '0',
  `company_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`album_id`,`artist_id`,`company_id`),
  KEY `artist_public_idx` (`artist_id`),
  KEY `company_public_idx` (`company_id`),
  CONSTRAINT `artist_public` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`artist_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `album_public` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `company_public` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `songs` (
  `track_id` int(11) NOT NULL DEFAULT '0',
  `artist_id` int(11) NOT NULL,
  `album_id` int(11) NOT NULL,
  `resource_url` varchar(255) DEFAULT NULL,
  `description_type` varchar(45) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`track_id`),
  KEY `album_song_idx` (`album_id`),
  KEY `artist_song_idx` (`artist_id`),
  CONSTRAINT `album_song` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `artist_song` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`artist_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `tag_for_album` (
  `tag_id` int(11) NOT NULL,
  `album_id` int(11) NOT NULL,
  PRIMARY KEY (`tag_id`,`album_id`),
  KEY `to_album_idx` (`album_id`),
  CONSTRAINT `tag_to_tag_for_album` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `album_to_tag_for_album` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `tag_for_list` (
  `tag_id` int(11) NOT NULL,
  `list_id` int(11) NOT NULL,
  PRIMARY KEY (`tag_id`,`list_id`),
  KEY `to_list_idx` (`list_id`),
  CONSTRAINT `to_tag` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `to_list` FOREIGN KEY (`list_id`) REFERENCES `playlists` (`list_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `tag_for_song` (
  `tag_id` int(11) NOT NULL,
  `track_id` int(11) NOT NULL,
  PRIMARY KEY (`tag_id`,`track_id`),
  KEY `track_to_tag_for_song_idx` (`track_id`),
  CONSTRAINT `tag_to_tag_for_song` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `track_to_tag_for_song` FOREIGN KEY (`track_id`) REFERENCES `songs` (`track_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `tags` (
  `tag_id` int(11) NOT NULL DEFAULT '0',
  `tag_type` varchar(255) DEFAULT NULL,
  `tag_name` varchar(255) NOT NULL,
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `user_name` varchar(255) NOT NULL,
  `user_pwd` varchar(255) NOT NULL,
  `profile` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `playlists` (
  `list_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL,
  `description_type` varchar(45) DEFAULT NULL,
  `list_name` varchar(255) NOT NULL,
  PRIMARY KEY (`list_id`),
  KEY `user_list_idx` (`user_id`),
  CONSTRAINT `user_list` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Make sure that each user has at least one playlist
CREATE ASSERTION UserPlaylist CHECK (
  NOT EXISTS (
  SELECT user_id FROM user WHERE user_id NOT IN (
  SELECT user_id FROM playlists) ))