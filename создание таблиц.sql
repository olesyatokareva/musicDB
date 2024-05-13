CREATE TABLE IF NOT EXISTS public.users
(
    id_user integer NOT NULL,
    user_name character varying(70) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT pk_users PRIMARY KEY (id_user),
    CONSTRAINT users_email_check CHECK (email::text ~~ '%gmail.com'::text OR email IS NULL),
    CONSTRAINT users_email_check1 CHECK (email::text ~~ '%gmail.com'::text OR email IS NULL)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;
-- Index: index_users

-- DROP INDEX IF EXISTS public.index_users;

CREATE INDEX IF NOT EXISTS index_users
    ON public.users USING btree
    (id_user ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: email_ch

-- DROP TRIGGER IF EXISTS email_ch ON public.users;

CREATE OR REPLACE TRIGGER email_ch
    BEFORE INSERT
    ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION public.email();



CREATE TABLE IF NOT EXISTS public.songs
(
    song_id integer NOT NULL,
    song_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    genre_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    album_id integer,
    CONSTRAINT pk_songs PRIMARY KEY (song_id),
    CONSTRAINT fk_songs_albums FOREIGN KEY (album_id)
        REFERENCES public.albums (album_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT songs_genre_name_check CHECK (genre_name::text ~ 'поп-музыка'::text OR genre_name::text ~ 'рок-н-ролл'::text OR genre_name::text ~ 'рэп'::text OR genre_name::text ~ 'шансон'::text OR genre_name::text ~ 'R&D/соул'::text)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.songs
    OWNER to postgres;
-- Index: index_songs

-- DROP INDEX IF EXISTS public.index_songs;

CREATE INDEX IF NOT EXISTS index_songs
    ON public.songs USING btree
    (song_id ASC NULLS LAST)
    TABLESPACE pg_default;




CREATE TABLE IF NOT EXISTS public.artists
(
    artist_id integer NOT NULL,
    artist_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    country character varying(30) COLLATE pg_catalog."default",
    type_artist character varying(30) COLLATE pg_catalog."default",
    CONSTRAINT pk_artists PRIMARY KEY (artist_id),
    CONSTRAINT artists_type_artist_check CHECK (type_artist::text ~ 'сольный'::text OR type_artist::text ~ 'группа'::text)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.artists
    OWNER to postgres;



CREATE TABLE IF NOT EXISTS public.albums
(
    album_id integer NOT NULL,
    album_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    artist_id integer NOT NULL,
    release_date date,
    CONSTRAINT pk_albums PRIMARY KEY (album_id),
    CONSTRAINT fk_albums_artists FOREIGN KEY (artist_id)
        REFERENCES public.artists (artist_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT albums_release_date_check CHECK (EXTRACT(year FROM release_date) < EXTRACT(year FROM CURRENT_DATE) AND EXTRACT(month FROM release_date) >= 1::numeric AND EXTRACT(month FROM release_date) <= 12::numeric AND EXTRACT(day FROM release_date) >= 1::numeric AND EXTRACT(day FROM release_date) <= 31::numeric),
    CONSTRAINT albums_album_id_check CHECK (album_id > 0 AND album_id < 99999)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.albums
    OWNER to postgres;



CREATE TABLE IF NOT EXISTS public.playlists
(
    playlist_id integer NOT NULL,
    playlist_name character varying(100) COLLATE pg_catalog."default",
    id_user integer NOT NULL,
    CONSTRAINT pk_playlists PRIMARY KEY (playlist_id),
    CONSTRAINT fk_playlists_users FOREIGN KEY (id_user)
        REFERENCES public.users (id_user) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT playlists_playlist_id_check CHECK (playlist_id > 0 AND playlist_id < 99999)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.playlists
    OWNER to postgres;
	


CREATE TABLE IF NOT EXISTS public.playlistsongs
(
    playlist_id integer NOT NULL,
    song_id integer NOT NULL,
    CONSTRAINT playlistsongs_pkey PRIMARY KEY (playlist_id, song_id),
    CONSTRAINT fk_playlistsongs_playlists FOREIGN KEY (playlist_id)
        REFERENCES public.playlists (playlist_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_playlistsongs_songs FOREIGN KEY (song_id)
        REFERENCES public.songs (song_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.playlistsongs
    OWNER to postgres;
	
	
CREATE TABLE IF NOT EXISTS public.art_songs
(
    artist_id integer NOT NULL,
    song_id integer NOT NULL,
    CONSTRAINT art_songs_pkey PRIMARY KEY (artist_id, song_id),
    CONSTRAINT fk_art_songs_artists FOREIGN KEY (artist_id)
        REFERENCES public.artists (artist_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_art_songs_songs FOREIGN KEY (song_id)
        REFERENCES public.songs (song_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.art_songs
    OWNER to postgres;