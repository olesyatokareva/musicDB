--1.	Процедура добавления нового исполнителя.

CREATE PROCEDURE  add_artist(artist_id integer, 
				   artist_name varchar(100), 
				   country varchar(30), 
				   type_artist varchar(30))
LANGUAGE SQL
AS $$

INSERT INTO artists
VALUES 
(artist_id, artist_name, country, type_artist);

$$;

--2.	Процедура добавления нового пользователя.

CREATE PROCEDURE  add_user(id_user integer, user_name varchar(70))
LANGUAGE SQL
AS $$

INSERT INTO users
VALUES 
(id_user, user_name);

$$;

--3.	Процедура добавления нового музыкального произведения.

CREATE PROCEDURE  add_song(song_id integer,
				 song_name varchar(100),
				 genre_name varchar(50), 
				 album_id integer,
				 artist_id integer)
LANGUAGE SQL
AS $$

INSERT INTO songs
VALUES 
(song_id, song_name, genre_name, album_id);

INSERT INTO art_songs
VALUES
(artist_id, song_id)

$$;


--4.	Процедура добавления музыкального произведения в плейлист.

CREATE PROCEDURE  add_songs_in_playlist(playlist_id integer, song_id integer)
LANGUAGE SQL
AS $$

INSERT INTO playlistsongs
VALUES 
(playlist_id, song_id);

$$;

--5.	Процедура добавления нового плейлиста.

CREATE PROCEDURE  add_songs_in_playlist(playlist_id integer,
					        playlist_name varchar(100),
						  id_user integer)
LANGUAGE SQL
AS $$

INSERT INTO playlists
VALUES 
(playlist_id, playlist_name, id_user);

$$;
