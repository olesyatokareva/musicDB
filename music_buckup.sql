PGDMP      '                |            music    16.2    16.2 '    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16397    music    DATABASE     y   CREATE DATABASE music WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE music;
                postgres    false            �            1255    16543 L   add_artist(integer, character varying, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.add_artist(IN artist_id integer, IN artist_name character varying, IN country character varying, IN type_artist character varying)
    LANGUAGE sql
    AS $$

INSERT INTO artists
VALUES 
(artist_id, artist_name, country, type_artist);

$$;
 �   DROP PROCEDURE public.add_artist(IN artist_id integer, IN artist_name character varying, IN country character varying, IN type_artist character varying);
       public          postgres    false            �            1255    16545 I   add_song(integer, character varying, character varying, integer, integer) 	   PROCEDURE     ;  CREATE PROCEDURE public.add_song(IN song_id integer, IN song_name character varying, IN genre_name character varying, IN album_id integer, IN artist_id integer)
    LANGUAGE sql
    AS $$

INSERT INTO songs
VALUES 
(song_id, song_name, genre_name, album_id);

INSERT INTO art_songs
VALUES
(artist_id, song_id)

$$;
 �   DROP PROCEDURE public.add_song(IN song_id integer, IN song_name character varying, IN genre_name character varying, IN album_id integer, IN artist_id integer);
       public          postgres    false            �            1255    16546 '   add_songs_in_playlist(integer, integer) 	   PROCEDURE     �   CREATE PROCEDURE public.add_songs_in_playlist(IN playlist_id integer, IN song_id integer)
    LANGUAGE sql
    AS $$

INSERT INTO playlistsongs
VALUES 
(playlist_id, song_id);

$$;
 Y   DROP PROCEDURE public.add_songs_in_playlist(IN playlist_id integer, IN song_id integer);
       public          postgres    false            �            1255    16547 :   add_songs_in_playlist(integer, character varying, integer) 	   PROCEDURE     �   CREATE PROCEDURE public.add_songs_in_playlist(IN playlist_id integer, IN playlist_name character varying, IN id_user integer)
    LANGUAGE sql
    AS $$

INSERT INTO playlists
VALUES 
(playlist_id, playlist_name, id_user);

$$;
 }   DROP PROCEDURE public.add_songs_in_playlist(IN playlist_id integer, IN playlist_name character varying, IN id_user integer);
       public          postgres    false            �            1255    16544 $   add_user(integer, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.add_user(IN id_user integer, IN user_name character varying)
    LANGUAGE sql
    AS $$

INSERT INTO users
VALUES 
(id_user, user_name);

$$;
 T   DROP PROCEDURE public.add_user(IN id_user integer, IN user_name character varying);
       public          postgres    false            �            1255    16515    email()    FUNCTION     �   CREATE FUNCTION public.email() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.email = NEW.user_name || '@gmail.com';
RETURN NEW;
END;
$$;
    DROP FUNCTION public.email();
       public          postgres    false            �            1255    16542 ,   update_name_user(integer, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.update_name_user(IN id_user integer, IN new_name character varying)
    LANGUAGE sql
    AS $$

UPDATE users SET user_name = new_name
WHERE id_user = id_user

$$;
 [   DROP PROCEDURE public.update_name_user(IN id_user integer, IN new_name character varying);
       public          postgres    false            �            1259    16424    albums    TABLE     P  CREATE TABLE public.albums (
    album_id integer NOT NULL,
    album_name character varying(30) NOT NULL,
    artist_id integer NOT NULL,
    release_date date,
    CONSTRAINT albums_album_id_check CHECK (((album_id > 0) AND (album_id < 99999))),
    CONSTRAINT albums_release_date_check CHECK (((EXTRACT(year FROM release_date) < EXTRACT(year FROM CURRENT_DATE)) AND ((EXTRACT(month FROM release_date) >= (1)::numeric) AND (EXTRACT(month FROM release_date) <= (12)::numeric)) AND ((EXTRACT(day FROM release_date) >= (1)::numeric) AND (EXTRACT(day FROM release_date) <= (31)::numeric))))
);
    DROP TABLE public.albums;
       public         heap    postgres    false            �            1259    16437 	   art_songs    TABLE     `   CREATE TABLE public.art_songs (
    artist_id integer NOT NULL,
    song_id integer NOT NULL
);
    DROP TABLE public.art_songs;
       public         heap    postgres    false            �            1259    16419    artists    TABLE     N  CREATE TABLE public.artists (
    artist_id integer NOT NULL,
    artist_name character varying(100) NOT NULL,
    country character varying(30),
    type_artist character varying(30),
    CONSTRAINT artists_type_artist_check CHECK ((((type_artist)::text ~ 'сольный'::text) OR ((type_artist)::text ~ 'группа'::text)))
);
    DROP TABLE public.artists;
       public         heap    postgres    false            �            1259    16414    songs    TABLE     �  CREATE TABLE public.songs (
    song_id integer NOT NULL,
    song_name character varying(100) NOT NULL,
    genre_name character varying(50) NOT NULL,
    album_id integer,
    CONSTRAINT songs_genre_name_check CHECK ((((genre_name)::text ~ 'поп-музыка'::text) OR ((genre_name)::text ~ 'рок-н-ролл'::text) OR ((genre_name)::text ~ 'рэп'::text) OR ((genre_name)::text ~ 'шансон'::text) OR ((genre_name)::text ~ 'R&D/соул'::text)))
);
    DROP TABLE public.songs;
       public         heap    postgres    false            �            1259    16536    count_songs_in_genre    VIEW     �   CREATE VIEW public.count_songs_in_genre AS
 SELECT genre_name,
    count(*) AS count
   FROM public.songs
  GROUP BY genre_name;
 '   DROP VIEW public.count_songs_in_genre;
       public          postgres    false    216            �            1259    16432 	   playlists    TABLE     �   CREATE TABLE public.playlists (
    playlist_id integer NOT NULL,
    playlist_name character varying(100),
    id_user integer NOT NULL,
    CONSTRAINT playlists_playlist_id_check CHECK (((playlist_id > 0) AND (playlist_id < 99999)))
);
    DROP TABLE public.playlists;
       public         heap    postgres    false            �            1259    16429    playlistsongs    TABLE     f   CREATE TABLE public.playlistsongs (
    playlist_id integer NOT NULL,
    song_id integer NOT NULL
);
 !   DROP TABLE public.playlistsongs;
       public         heap    postgres    false            �            1259    16526    popylar_song    VIEW     p  CREATE VIEW public.popylar_song AS
 WITH song AS (
         SELECT playlistsongs.song_id,
            count(*) AS count
           FROM public.playlistsongs
          GROUP BY playlistsongs.song_id
          ORDER BY (count(*)) DESC
         LIMIT 1
        )
 SELECT ss.song_name,
    s.count
   FROM (public.songs ss
     JOIN song s ON ((ss.song_id = s.song_id)));
    DROP VIEW public.popylar_song;
       public          postgres    false    216    216    219            �            1259    16522    russian_artist    VIEW     �   CREATE VIEW public.russian_artist AS
 SELECT artist_name,
    country
   FROM public.artists
  WHERE ((country)::text = 'Россия'::text);
 !   DROP VIEW public.russian_artist;
       public          postgres    false    217    217            �            1259    16531    top    VIEW     g  CREATE VIEW public.top AS
 WITH song AS (
         SELECT playlistsongs.song_id,
            count(*) AS count
           FROM public.playlistsongs
          GROUP BY playlistsongs.song_id
          ORDER BY (count(*)) DESC
         LIMIT 3
        )
 SELECT ss.song_name,
    s.count
   FROM (public.songs ss
     JOIN song s ON ((ss.song_id = s.song_id)));
    DROP VIEW public.top;
       public          postgres    false    216    216    219            �            1259    16409    users    TABLE     W  CREATE TABLE public.users (
    id_user integer NOT NULL,
    user_name character varying(70) NOT NULL,
    email character varying(100),
    CONSTRAINT users_email_check CHECK ((((email)::text ~~ '%gmail.com'::text) OR (email IS NULL))),
    CONSTRAINT users_email_check1 CHECK ((((email)::text ~~ '%gmail.com'::text) OR (email IS NULL)))
);
    DROP TABLE public.users;
       public         heap    postgres    false            ^           2606    16520    art_songs art_songs_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.art_songs
    ADD CONSTRAINT art_songs_pkey PRIMARY KEY (artist_id, song_id);
 B   ALTER TABLE ONLY public.art_songs DROP CONSTRAINT art_songs_pkey;
       public            postgres    false    221    221            X           2606    16428    albums pk_albums 
   CONSTRAINT     T   ALTER TABLE ONLY public.albums
    ADD CONSTRAINT pk_albums PRIMARY KEY (album_id);
 :   ALTER TABLE ONLY public.albums DROP CONSTRAINT pk_albums;
       public            postgres    false    218            V           2606    16423    artists pk_artists 
   CONSTRAINT     W   ALTER TABLE ONLY public.artists
    ADD CONSTRAINT pk_artists PRIMARY KEY (artist_id);
 <   ALTER TABLE ONLY public.artists DROP CONSTRAINT pk_artists;
       public            postgres    false    217            \           2606    16436    playlists pk_playlists 
   CONSTRAINT     ]   ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT pk_playlists PRIMARY KEY (playlist_id);
 @   ALTER TABLE ONLY public.playlists DROP CONSTRAINT pk_playlists;
       public            postgres    false    220            T           2606    16418    songs pk_songs 
   CONSTRAINT     Q   ALTER TABLE ONLY public.songs
    ADD CONSTRAINT pk_songs PRIMARY KEY (song_id);
 8   ALTER TABLE ONLY public.songs DROP CONSTRAINT pk_songs;
       public            postgres    false    216            Q           2606    16413    users pk_users 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id_user);
 8   ALTER TABLE ONLY public.users DROP CONSTRAINT pk_users;
       public            postgres    false    215            Z           2606    16518     playlistsongs playlistsongs_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.playlistsongs
    ADD CONSTRAINT playlistsongs_pkey PRIMARY KEY (playlist_id, song_id);
 J   ALTER TABLE ONLY public.playlistsongs DROP CONSTRAINT playlistsongs_pkey;
       public            postgres    false    219    219            R           1259    16541    index_songs    INDEX     @   CREATE INDEX index_songs ON public.songs USING btree (song_id);
    DROP INDEX public.index_songs;
       public            postgres    false    216            O           1259    16540    index_users    INDEX     @   CREATE INDEX index_users ON public.users USING btree (id_user);
    DROP INDEX public.index_users;
       public            postgres    false    215            f           2620    16516    users email_ch    TRIGGER     d   CREATE TRIGGER email_ch BEFORE INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.email();
 '   DROP TRIGGER email_ch ON public.users;
       public          postgres    false    226    215            `           2606    16445    albums fk_albums_artists    FK CONSTRAINT     �   ALTER TABLE ONLY public.albums
    ADD CONSTRAINT fk_albums_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id);
 B   ALTER TABLE ONLY public.albums DROP CONSTRAINT fk_albums_artists;
       public          postgres    false    218    4694    217            d           2606    16472    art_songs fk_art_songs_artists    FK CONSTRAINT     �   ALTER TABLE ONLY public.art_songs
    ADD CONSTRAINT fk_art_songs_artists FOREIGN KEY (artist_id) REFERENCES public.artists(artist_id);
 H   ALTER TABLE ONLY public.art_songs DROP CONSTRAINT fk_art_songs_artists;
       public          postgres    false    217    4694    221            e           2606    16477    art_songs fk_art_songs_songs    FK CONSTRAINT     �   ALTER TABLE ONLY public.art_songs
    ADD CONSTRAINT fk_art_songs_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id);
 F   ALTER TABLE ONLY public.art_songs DROP CONSTRAINT fk_art_songs_songs;
       public          postgres    false    216    4692    221            c           2606    16440    playlists fk_playlists_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_playlists_users FOREIGN KEY (id_user) REFERENCES public.users(id_user);
 F   ALTER TABLE ONLY public.playlists DROP CONSTRAINT fk_playlists_users;
       public          postgres    false    220    4689    215            a           2606    16462 (   playlistsongs fk_playlistsongs_playlists    FK CONSTRAINT     �   ALTER TABLE ONLY public.playlistsongs
    ADD CONSTRAINT fk_playlistsongs_playlists FOREIGN KEY (playlist_id) REFERENCES public.playlists(playlist_id);
 R   ALTER TABLE ONLY public.playlistsongs DROP CONSTRAINT fk_playlistsongs_playlists;
       public          postgres    false    4700    220    219            b           2606    16467 $   playlistsongs fk_playlistsongs_songs    FK CONSTRAINT     �   ALTER TABLE ONLY public.playlistsongs
    ADD CONSTRAINT fk_playlistsongs_songs FOREIGN KEY (song_id) REFERENCES public.songs(song_id);
 N   ALTER TABLE ONLY public.playlistsongs DROP CONSTRAINT fk_playlistsongs_songs;
       public          postgres    false    219    4692    216            _           2606    16450    songs fk_songs_albums    FK CONSTRAINT     |   ALTER TABLE ONLY public.songs
    ADD CONSTRAINT fk_songs_albums FOREIGN KEY (album_id) REFERENCES public.albums(album_id);
 ?   ALTER TABLE ONLY public.songs DROP CONSTRAINT fk_songs_albums;
       public          postgres    false    218    4696    216           