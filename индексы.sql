--Добавим индекс index_users. Он будет полезен тем, что будет уменьшать время поиска определенного пользователя.
CREATE INDEX index_users ON users (id_user);

--Добавим индекс index_songs. Он будет полезен тем, что будет уменьшать время поиска определенного музыкального произведения.
CREATE INDEX index_songs ON songs (song_id);
