--1. Найти музыкальное произведение, у которого два исполнителя.

WITH song AS (
	SELECT song_id, count(song_id) AS "countt" from art_songs
	GROUP BY song_id)
SELECT ss.song_name
from songs ss
JOIN song s
ON ss.song_id = s.song_id
WHERE s.countt = 2;

--2. Узнать, кому принадлежит альбом «QUEEN OF RAP».

SELECT ar.artist_name
from artists ar
JOIN albums al
ON ar.artist_id = al.artist_id
WHERE al.album_name = 'QUEEN OF RAP';

 

--3. Вывести на экран альбомы, которые были выпущены после 2015 года.

SELECT album_name,
release_date
from albums
WHERE (EXTRACT (YEAR FROM release_date)) < 2015;
4. Найти пользователя, у которого нет плейлистов.

WITH us_pl AS (
	SELECT DISTINCT user_name, us.id_user FROM
	users us
	JOIN playlists pl
	ON us.id_user = pl.id_user
)
SELECT user_name, id_user FROM users
EXCEPT
SELECT user_name, id_user FROM us_pl; 

 
--5. Найти пользователя, у которого в плейлисте не менее 4 песен.

WITH count_songs AS (
		SELECT playlist_id, count(*) AS "count"
		FROM playlistsongs
		GROUP BY playlist_id
)
SELECT us.user_name,
cs.count,
pl.playlist_name
FROM count_songs cs
JOIN playlists pl ON cs.playlist_id = pl.playlist_id
JOIN users us ON pl.id_user = us.id_user
WHERE cs.count >= 4;

  
--6. Найти исполнителя, у которого не одно музыкальное произведение.

WITH count_songs AS (
		SELECT artist_id, count(*) AS "count"
		FROM art_songs
		GROUP BY artist_id
)
SELECT ar.artist_name,
cs.count
FROM artists ar
JOIN count_songs cs
ON ar.artist_id = cs.artist_id
WHERE count > 1;
 

--7. Вывести на экран всех сольных исполнителей

SELECT artist_name,
type_artist
FROM artists
WHERE type_artist = 'сольный'; 

--8. Найти самое «старое» музыкальное произведение, вывести вместе с исполнителем.

SELECT song_name, 
(EXTRACT(YEAR FROM release_date)) AS "year",
ar.artist_name
FROM songs JOIN albums 
ON songs.album_id = albums.album_id
JOIN art_songs ars
ON songs.song_id = ars.song_id
JOIN artists ar
ON ars.artist_id = ar.artist_id
ORDER BY year
LIMIT 1; 


--9. Найти всех русских исполнителей.

SELECT artist_name,
country
FROM artists
WHERE country = 'Россия'; 


--10.  Вывести на экран все плейлисты пользователя 4455

SELECT user_name,
playlist_name
FROM users us
JOIN playlists pl
ON us.id_user = pl.id_user
WHERE us.id_user = 4455; 

  

--11. Найти самую часто прослушиваемую песню (которая чаще всего встречается в плейлистах).

WITH song AS (
	SELECT song_id,
	count(*) AS "count"
	FROM playlistsongs
	GROUP BY song_id
	ORDER BY count DESC
	LIMIT 1
)
SELECT ss.song_name,
s.count
FROM songs ss
JOIN song s
ON ss.song_id = s.song_id;

 

--12. Создать топ-3 по добавлению треков в плейлисты.

WITH song AS (
	SELECT song_id,
	count(*) AS "count"
	FROM playlistsongs
	GROUP BY song_id
	ORDER BY count DESC
	LIMIT 3
)
SELECT ss.song_name,
s.count
FROM songs ss
JOIN song s
ON ss.song_id = s.song_id;

 


--13. Узнать, кому принадлежит плейлист «Вечеринка» и сколько в нем песен.

WITH v AS (
	SELECT playlist_id, count(*) AS "count"
	FROM playlistsongs
	GROUP BY playlist_id
)
SELECT users.user_name,
pl.playlist_name,
v.count
FROM playlists pl
JOIN v ON pl.playlist_id = v.playlist_id
JOIN users 
ON users.id_user = pl.id_user
WHERE pl.playlist_name = 'Вечеринка';

 


--14. Найти плейлист с самым большим количеством песен, вывести на экран пользователя, которому этот плейлист принадлежит.

WITH v AS (
	SELECT playlist_id, count(*) AS "count"
	FROM playlistsongs
	GROUP BY playlist_id
	ORDER BY count DESC
	LIMIT 1
)
SELECT users.user_name,
pl.playlist_name,
v.count
FROM playlists pl
JOIN v ON pl.playlist_id = v.playlist_id
JOIN users 
ON users.id_user = pl.id_user;

 


--15. Найти альбомы, которые выпустили с разницей в 2 года.

SELECT a1.album_name AS "al1",
a2.album_name AS "al2"
FROM albums a1 JOIN albums a2
ON (extract(YEAR FROM a1.release_date)) = (extract(YEAR FROM a2.release_date)) + 2
ORDER BY a1.release_date;

 
--16. Найти исполнителя, у которого больше всего песен.

WITH song_count AS (
	SELECT artist_id,
	count(*) AS "count"
	FROM art_songs
	GROUP BY artist_id
)
SELECT art.artist_name,
sc.count
FROM artists art
JOIN song_count sc
ON art.artist_id = sc.artist_id
ORDER BY sc.count DESC;



--17. Найти пользователей, которые слушают "Britney Spears".

SELECT us.user_name,
pl.playlist_name,
ss.song_name
FROM users us
JOIN playlists pl
ON us.id_user = pl.id_user
JOIN playlistsongs ps
ON pl.playlist_id = ps.playlist_id
JOIN songs ss
ON ps.song_id = ss.song_id
JOIN art_songs ars
ON ss.song_id = ars.song_id
JOIN artists art
ON ars.artist_id = art.artist_id
WHERE art.artist_name = 'Britney Spears';

 


--18. Найти реперов из США.

SELECT DISTINCT art.artist_name 
FROM artists art
JOIN art_songs ars 
ON art.artist_id = ars.artist_id
JOIN songs ss
ON ars.song_id = ss.song_id
WHERE ss.genre_name = 'рэп' AND art.country = 'США';


--19. Вывести на экран пользователей в виде: если в плейлисте больше 5 песен – true, в противном случае – false.
WITH plsongs AS (
	SELECT playlist_id,
	COUNT (*) AS "count"
	FROM playlistsongs
	GROUP BY playlist_id
), uspl AS (
	SELECT *
	FROM plsongs ps
	JOIN playlists pl
	ON ps.playlist_id = pl.playlist_id
	JOIN users us
	ON pl.id_user = us.id_user
), t AS (
	SELECT user_name, 
	count,
	true AS "boolean"
	FROM uspl
	WHERE count >= 5
), f AS (
	SELECT user_name,
	count,
	false AS "boolean"
	FROM uspl
	WHERE count < 5
)
SELECT user_name, count, boolean  FROM t
UNION
SELECT user_name, count, boolean FROM f;
 

--20. Вывести количество музыкальных произведений в каждом жанре.

SELECT genre_name,
count(*) AS "count"
FROM songs
GROUP BY genre_name;


  

