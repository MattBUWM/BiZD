--create type enum_nazwa_fazy as enum ('faza eliminacyjna', 'faza zasadnicza', 'faza finalowa');
--create type enum_plec as enum ('K', 'M');
--create type enum_rodzaj_turnieju as enum ('Klasyczny', 'Szybki', 'Błyskawiczny');

create table gracz (id NUMBER GENERATED ALWAYS AS IDENTITY, 
                    imie varchar(100) not NULL, 
                    nazwisko varchar(100) not NULL, 
                    narodowosc varchar(3) not NULL, 
                    elo integer NULL,
                   	plec VARCHAR2(2) CHECK (plec in ('K', 'M')) not NULL,
					data_dolaczenia date
					);

create table turniej (id NUMBER GENERATED ALWAYS AS IDENTITY, 
                      nazwa varchar(100) not NULL, 
                      data_rozpoczecia date not NULL, 
                      rodzaj_turnieju VARCHAR2(15) CHECK (rodzaj_turnieju in ('Klasyczny', 'Szybki', 'Błyskawiczny')) not NULL, 
                      nagroda numeric(12,2) not NULL
					  );
					  
					
create table gracze_w_turnieju (id_turnieju NUMBER NOT NULL, 
                                id_gracza NUMBER NOT NULL,
								pozycja integer NULL
                               );


create table fazy_turnieju(id NUMBER GENERATED ALWAYS AS IDENTITY, turniej_id NUMBER NOT NULL,
 							enum_nazwa_fazy VARCHAR2(30) CHECK (enum_nazwa_fazy in ('faza eliminacyjna', 'faza zasadnicza', 'faza finalowa')) NOT NULL);

create table sedzia(id NUMBER GENERATED ALWAYS AS IDENTITY, imie varchar(50) NOT NULL, nazwisko varchar(50) NOT NULL);

create table gra (id NUMBER GENERATED ALWAYS AS IDENTITY, id_gracz_bialy NUMBER NOT NULL, 
                  id_gracz_czarny NUMBER NOT NULL, 
                  przebieg_gry varchar(250), zwycięzca NUMBER,
				  data_gry timestamp NOT NULL, format_czasowy NUMBER NOT NULL, 
				  faza_turnieju_id numeric(10) not NULL, 
                  sedzia_id NUMBER NOT NULL);
                  
				  
create table historia_zmiany_elo (id_gracza NUMBER NOT NULL,
					id_gry NUMBER NOT NULL, zmiana_elo integer NOT NULL,
					data_zmiany date);
                    
ALTER TABLE gracz
ADD PRIMARY KEY (id);

ALTER TABLE turniej
ADD PRIMARY KEY (id);

ALTER TABLE gracze_w_turnieju
ADD PRIMARY KEY (id_turnieju, id_gracza);

ALTER TABLE fazy_turnieju
ADD PRIMARY KEY (id);

ALTER TABLE sedzia
ADD PRIMARY KEY (id);

ALTER TABLE gra
ADD PRIMARY KEY (id);

ALTER TABLE gracze_w_turnieju
ADD FOREIGN KEY (id_turnieju) REFERENCES turniej (id)
ADD FOREIGN KEY (id_gracza) REFERENCES gracz (id)
;

ALTER TABLE fazy_turnieju
ADD FOREIGN KEY (turniej_id) REFERENCES turniej (id);

ALTER TABLE gra
ADD FOREIGN KEY (id_gracz_bialy) REFERENCES gracz (id)
ADD FOREIGN KEY (id_gracz_czarny) REFERENCES gracz (id)
ADD FOREIGN KEY (zwycięzca) REFERENCES gracz (id)
ADD FOREIGN KEY (faza_turnieju_id) REFERENCES fazy_turnieju (id)
ADD FOREIGN KEY (sedzia_id) REFERENCES sedzia (id)
;

ALTER TABLE historia_zmiany_elo
ADD FOREIGN KEY (id_gracza) REFERENCES gracz (id)
ADD FOREIGN KEY (id_gry) REFERENCES gra (id)
;

INSERT INTO gracz (imie, nazwisko, narodowosc, elo, plec, data_dolaczenia) VALUES ('gracz1', 'gracz1', 'POL', 1000, 'K', sysdate);
INSERT INTO gracz (imie, nazwisko, narodowosc, elo, plec, data_dolaczenia) VALUES ('gracz2', 'gracz2', 'GER', 1000, 'M', sysdate);

CREATE VIEW gracze_kobiety AS 
SELECT * FROM gracz WHERE plec = 'K';

CREATE VIEW gracze_mezczyzni AS 
SELECT * FROM gracz WHERE plec = 'M';

CREATE VIEW topka_graczy AS
SELECT * FROM gracz ORDER BY(elo) FETCH NEXT 10 ROWS ONLY;

CREATE FUNCTION gracze_danej_narodowosci (kraj VARCHAR2) RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;  
BEGIN
  open c1 for
  SELECT imie, nazwisko, elo
  FROM gracz
  WHERE narodowosc = kraj;
  RETURN c1;
END;

SELECT gracze_danej_narodowosci('GER') from dual;

CREATE FUNCTION id_sedzi(sedzia_imie VARCHAR2, sedzia_nazwisko VARCHAR2) RETURN NUMBER
IS
  sedzia_id NUMBER;
  BEGIN
      SELECT id INTO sedzia_id
      FROM sedzia
      WHERE imie = sedzia_imie AND nazwisko = sedzia_nazwisko;
  RETURN sedzia_id;
END;


SELECT id_sedzi('sedzia1', 'sedzia1_nazw') from dual;

CREATE FUNCTION gry_z_danym_sedzia (sedzia_imie VARCHAR2, sedzia_nazwisko VARCHAR2) RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
  result NUMBER;
BEGIN
  result := id_sedzi(sedzia_imie, sedzia_nazwisko);
  open c1 for
  SELECT *
  FROM gra
  WHERE sedzia_id = result;
  RETURN c1;
END;

CREATE FUNCTION gry_z_danej_fazy (nazwa_fazy VARCHAR2, nazwa_turnieju VARCHAR2) RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
  result NUMBER;
BEGIN
  result := id_turnieju(nazwa_turnieju);
  open c1 for
  SELECT *
  FROM gra INNER JOIN fazy_turnieju ON gra.faza_turnieju_id = fazy_turnieju.id
  WHERE fazy_turnieju.turniej_id = result AND fazy_turnieju.enum_nazwa_fazy = nazwa_fazy;
  RETURN c1;
END;

SELECT gry_z_danej_fazy('faza eliminacyjna', 'turniej0') FROM dual;
SELECT * FROM turniej;
SELECT * FROM fazy_turnieju;

  

CREATE FUNCTION id_gracza(gracz_imie VARCHAR2, gracz_nazwisko VARCHAR2) RETURN NUMBER
IS
  gracz_id NUMBER;
  BEGIN
      SELECT id INTO gracz_id
      FROM gracz
      WHERE imie = gracz_imie AND nazwisko = gracz_nazwisko;
  RETURN gracz_id;
END;

CREATE FUNCTION gry_danego_gracza (gracz_imie VARCHAR2, gracz_nazwisko VARCHAR2) RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
  result NUMBER;
BEGIN
  result := id_gracza(gracz_imie, gracz_nazwisko);
  open c1 for
  SELECT *
  FROM gra
  WHERE id_gracz_czarny = result OR id_gracz_bialy = result;
  RETURN c1;
END;

SELECT * FROM gra;
SELECT gry_danego_gracza('gracz2', 'gracz2') FROM dual;

CREATE FUNCTION id_turnieju(turniej_nazwa VARCHAR2) RETURN NUMBER
IS
  turniej_id NUMBER;
  BEGIN
      SELECT id INTO turniej_id
      FROM turniej
      WHERE nazwa = turniej_nazwa;
  RETURN turniej_id;
END;

CREATE FUNCTION gracze_z_danego_turnieju (turniej_nazwa VARCHAR2) RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
  result NUMBER;
BEGIN
  result := id_turnieju(turniej_nazwa);
  open c1 for
  SELECT *
  FROM gracz INNER JOIN gracze_w_turnieju ON gracz.id=gracze_w_turnieju.id_gracza
  WHERE gracze_w_turnieju.id_turnieju = result;
  RETURN c1;
END;

SELECT gracze_z_danego_turnieju('turniej0') FROM dual;


CREATE FUNCTION gry_wygrane_przez_gracza(gracz_imie VARCHAR2, gracz_nazwisko VARCHAR2) RETURN NUMERIC
IS
    wynik NUMERIC;
    result NUMBER;
BEGIN
    result := id_gracza(gracz_imie, gracz_nazwisko);
    SELECT COUNT(id) INTO wynik FROM gra
    WHERE zwycięzca = result;
    RETURN wynik;
END;

CREATE OR REPLACE PROCEDURE dodaj_gracza(imie VARCHAR2, nazwisko VARCHAR2, narodowosc VARCHAR2, plec VARCHAR2, elo NUMBER := 0)
AS
    wynik VARCHAR2(30);
BEGIN
    INSERT INTO gracz(imie, nazwisko, narodowosc, elo, plec, data_dolaczenia) 
    VALUES (imie, nazwisko, narodowosc, elo, plec, sysdate);
    wynik := 'poszlo';
END;
call dodaj_gracza('gracz_test2345', 'gracz_test2345', 'POL', 'M');
SELECT * FROM gracz;

CREATE OR REPLACE PROCEDURE edytuj_gracza(id_gracza NUMBER, imie_g VARCHAR2 := NULL, nazwisko_g VARCHAR2 := NULL, narodowosc_g VARCHAR2 := NULL, plec_g VARCHAR2 := NULL, elo_g NUMBER := NULL)
AS
    wynik VARCHAR2(30);
BEGIN
--    UPDATE gracz SET gracz.imie = imie_g WHERE id = id_gracza;
    IF imie_g IS NOT NULL THEN
            UPDATE gracz SET gracz.imie = imie_g WHERE id = id_gracza;
    END IF;
    IF nazwisko_g IS NOT NULL THEN
            UPDATE gracz SET nazwisko = nazwisko_g WHERE id = id_gracza;
    END IF;
    IF narodowosc_g IS NOT NULL THEN
            UPDATE gracz SET narodowosc = narodowosc_g WHERE id = id_gracza;
    END IF;
    IF plec_g IS NOT NULL THEN
            UPDATE gracz SET plec = plec_g WHERE id = id_gracza;
    END IF;
    IF elo_g IS NOT NULL THEN
            UPDATE gracz SET elo = elo_g WHERE id = id_gracza;
    END IF;
    wynik := 'poszlo';
END;

DROP PROCEDURE edytuj_gracza;

SELECT * FROM gracz;
call edytuj_gracza(1, 'gracz_imie1_zm2');
SELECT * FROM gracz;

CREATE OR REPLACE PROCEDURE usun_gracza(id_gracza NUMBER)
AS
    wynik VARCHAR2(30);
BEGIN
    DELETE FROM gracz WHERE id = id_gracza;
    wynik := 'poszlo';
END;

SELECT * FROM gracz;
call usun_gracza(42);
SELECT * FROM gracz;

CREATE OR REPLACE PROCEDURE dodaj_gre(id_gracz_bialy NUMBER, id_gracz_czarny NUMBER, przebieg_gry VARCHAR2, zwycięzca NUMBER, data_gry TIMESTAMP,
format_czasowy NUMBER, faza_turnieju_id NUMBER, sedzia_id NUMBER)
AS
    wynik VARCHAR2(30);
BEGIN
    INSERT INTO gra(id_gracz_bialy, id_gracz_czarny, przebieg_gry, zwycięzca, data_gry, format_czasowy, faza_turnieju_id, sedzia_id) 
    VALUES (id_gracz_bialy, id_gracz_czarny, przebieg_gry, zwycięzca, data_gry, format_czasowy, faza_turnieju_id, sedzia_id);
    wynik := 'poszlo';
END;

CREATE OR REPLACE PROCEDURE dodaj_faze_turnieju(turniej_id NUMBER, nazwa_turnieju VARCHAR2)
AS
    wynik VARCHAR2(30);
BEGIN
    INSERT INTO fazy_turnieju(turniej_id, enum_nazwa_fazy) 
    VALUES (turniej_id, nazwa_turnieju);
    wynik := 'poszlo';
END;

CREATE OR REPLACE PROCEDURE dodaj_graczy_w_turnieju(id_turnieju NUMBER, pozycja NUMBER)
AS
    wynik VARCHAR2(30);
BEGIN
    INSERT INTO gracze_w_turnieju(id_turnieju, pozycja) 
    VALUES (id_turnieju, pozycja);
    wynik := 'poszlo';
END;

CREATE OR REPLACE PROCEDURE dodaj_sedzie(imie VARCHAR2, nazwisko VARCHAR2)
AS
    wynik VARCHAR2(30);
BEGIN
    INSERT INTO sedzia(imie, nazwisko) 
    VALUES (imie, nazwisko);
    wynik := 'poszlo';
END;

CREATE OR REPLACE PROCEDURE dodaj_turniej(nazwa VARCHAR2, data_rozpoczecia TIMESTAMP, rodzaj_turnieju VARCHAR2, nagroda NUMBER)
AS
    wynik VARCHAR2(30);
BEGIN
    INSERT INTO turniej(nazwa, data_rozpoczecia, rodzaj_turnieju, nagroda) 
    VALUES (nazwa, data_rozpoczecia, rodzaj_turnieju, nagroda);
    wynik := 'poszlo';
END;

CREATE FUNCTION gry_przegrane_przez_gracza(gracz_imie VARCHAR2, gracz_nazwisko VARCHAR2) RETURN NUMERIC
IS
    wynik NUMERIC;
    result NUMBER;
BEGIN
    result := id_gracza(gracz_imie, gracz_nazwisko);
    SELECT COUNT(id) INTO wynik FROM gra
    WHERE (id_gracz_czarny = result OR id_gracz_bialy = result) AND przebieg_gry IS NOT NULL AND zwycięzca <> result;
    RETURN wynik;
END;


CREATE FUNCTION gry_zremisowane_przez_gracza(gracz_imie VARCHAR2, gracz_nazwisko VARCHAR2) RETURN NUMERIC
IS
    wynik NUMERIC;
    result NUMBER;
BEGIN
    SELECT COUNT(id) INTO wynik FROM gra
    WHERE (id_gracz_czarny = result OR id_gracz_bialy = result) AND przebieg_gry IS NOT NULL AND zwycięzca IS NULL;
    RETURN wynik;
END;

ALTER TABLE turniej 
ADD CONSTRAINT nagroda_not_negative
CHECK (nagroda>=0)

ALTER TABLE gracz 
ADD CONSTRAINT elo_not_negative
CHECK (elo>=0);

SELECT gry_z_danym_sedzia('sedzia1', 'sedzia1_nazw') FROM dual;

--
--execute gracze_danej_narodowosci('POL');

--create or replace type gracze_nar as object (
--  imie varchar2,
--  nazwisko varchar2,
--  elo integer);
--

CREATE TABLE log (id NUMBER GENERATED ALWAYS AS IDENTITY, 
                  uzytkownik varchar(100) not NULL, 
                  tabela varchar(100) not NULL, 
                  operacja varchar(100) not NULL,
                  czas timestamp not NULL
                  );

CREATE OR REPLACE TRIGGER gracz_insert_log
AFTER INSERT ON gracz
DECLARE
    user_name varchar(100);
BEGIN
    SELECT user INTO user_name FROM dual;
    INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gracz', 'INSERT', sysdate);
END;

CREATE OR REPLACE TRIGGER zmiana_elo_after_update
AFTER UPDATE ON gracz
FOR EACH ROW

BEGIN
   IF :new.elo <> :old.elo THEN
       INSERT INTO historia_elo2
       ( id_gracza,
         zmiana_elo,
         data_zmiany)
       VALUES
       ( :new.id,
         :new.elo,
         sysdate);
    END IF;
END;

SELECT * FROM gracz;
UPDATE gracz SET elo = 1200 WHERE id = 60;
SELECT * FROM historia_elo2;

create table historia_elo2 (id_gracza NUMBER NOT NULL,
                    zmiana_elo integer NOT NULL,
                    data_zmiany timestamp NOT NULL);

DROP TABLE historia_elo;

SELECT * FROM gracz;
SELECT * FROM historia_elo;

UPDATE gracz SET elo = 1200 WHERE id = 1;
UPDATE gracz SET elo = 900 WHERE id = 1;

SELECT * FROM historia_elo WHERE id_gracza = 1;

INSERT INTO gracz (imie, nazwisko, narodowosc, elo, plec, data_dolaczenia) VALUES ('gracz3', 'gracz3', 'GER', 1500, 'M', sysdate);

INSERT INTO turniej (
                      nazwa, 
                      data_rozpoczecia, 
                      rodzaj_turnieju, 
                      nagroda
					  ) VALUES ('turniej0', sysdate, 'Klasyczny', 1000);

INSERT INTO fazy_turnieju(turniej_id,
 							enum_nazwa_fazy) VALUES (1, 'faza eliminacyjna');
INSERT INTO gra(id_gracz_bialy, 
                  id_gracz_czarny, przebieg_gry, zwycięzca, data_gry, format_czasowy, 
				  faza_turnieju_id, 
                  sedzia_id) VALUES (1, 2, 'abc', 2, sysdate, 10, 3, 1);
                  
INSERT INTO gracze_w_turnieju(id_turnieju, 
                                id_gracza,
								pozycja) VALUES (1, 1, 1);
                                
INSERT INTO gracze_w_turnieju(id_turnieju, 
                                id_gracza,
								pozycja) VALUES (1, 2, 1);
                                
SELECT * FROM turniej;
SELECT * FROM gracz;

                  

--CREATE TABLE log (id integer primary key generated always as identity, 
--                  uzytkownik varchar(100) not NULL, 
--                  tabela varchar(100) not NULL, 
--				  operacja varchar(100) not NULL,
--				  czas timestamp not NULL
--				  );
				  
--CREATE OR REPLACE TRIGGER gracz_insert_log
--AFTER INSERT ON gracz
--DECLARE
--	user_name varchar(100)
--BEGIN
--	SELECT user INTO user_name FROM dual;
--	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gracz', 'INSERT', sysdate);
--END;

CREATE OR REPLACE TRIGGER gracz_update_log
AFTER UPDATE ON gracz
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gracz', 'UPDATE', sysdate);
END;

CREATE OR REPLACE TRIGGER gracz_delete_log
AFTER DELETE ON gracz
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gracz', 'DELETE', sysdate);
END;

CREATE OR REPLACE TRIGGER gra_insert_log
AFTER INSERT ON gra
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gra', 'INSERT', sysdate);
END;

CREATE OR REPLACE TRIGGER gra_update_log
AFTER UPDATE ON gra
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gra', 'UPDATE', sysdate);
END;

CREATE OR REPLACE TRIGGER gra_delete_log
AFTER DELETE ON gra
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gra', 'DELETE', sysdate);
END;

CREATE OR REPLACE TRIGGER turniej_insert_log
AFTER INSERT ON turniej
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'turniej', 'INSERT', sysdate);
END;

CREATE OR REPLACE TRIGGER turniej_update_log
AFTER UPDATE ON turniej
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'turniej', 'UPDATE', sysdate);
END;

CREATE OR REPLACE TRIGGER turniej_delete_log
AFTER DELETE ON turniej
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'turniej', 'DELETE', sysdate);
END;

CREATE OR REPLACE TRIGGER gracze_w_turnieju_insert_log
AFTER INSERT ON gracze_w_turnieju
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gracze_w_turnieju', 'INSERT', sysdate);
END;

CREATE OR REPLACE TRIGGER gracze_w_turnieju_update_log
AFTER UPDATE ON gracze_w_turnieju
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gracze_w_turnieju', 'UPDATE', sysdate);
END;

CREATE OR REPLACE TRIGGER gracze_w_turnieju_delete_log
AFTER DELETE ON gracze_w_turnieju
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'gracze_w_turnieju', 'DELETE', sysdate);
END;

CREATE OR REPLACE TRIGGER fazy_turnieju_insert_log
AFTER INSERT ON fazy_turnieju
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'fazy_turnieju', 'INSERT', sysdate);
END;

CREATE OR REPLACE TRIGGER fazy_turnieju_update_log
AFTER UPDATE ON fazy_turnieju
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'fazy_turnieju', 'UPDATE', sysdate);
END;

CREATE OR REPLACE TRIGGER fazy_turnieju_delete_log
AFTER DELETE ON fazy_turnieju
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'fazy_turnieju', 'DELETE', sysdate);
END;

CREATE OR REPLACE TRIGGER sedzia_insert_log
AFTER INSERT ON sedzia
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'sedzia', 'INSERT', sysdate);
END;

CREATE OR REPLACE TRIGGER sedzia_update_log
AFTER UPDATE ON sedzia
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'sedzia', 'UPDATE', sysdate);
END;

CREATE OR REPLACE TRIGGER sedzia_delete_log
AFTER DELETE ON sedzia
DECLARE
	user_name varchar(100);
BEGIN
	SELECT user INTO user_name FROM dual;
	INSERT INTO log(uzytkownik, tabela, operacja, czas) VALUES (user_name, 'sedzia', 'DELETE', sysdate);
END;
