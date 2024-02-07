SELECT * FROM gracz;
drop table narodowosc;
create  table narodowosc (id NUMBER GENERATED ALWAYS AS IDENTITY, narodowosc varchar2(3));

INSERT INTO narodowosc (narodowosc) VALUES('ITA');
SELECT * FROM narodowosc;


SELECT elo FROM gracz WHERE id = 90;
UPDATE gracz SET gracz.elo = 1479 WHERE id = 90;
UPDATE gracz SET gracz.elo = imie_g WHERE id = 1475;
UPDATE gracz SET gracz.elo = imie_g WHERE id = 1478;
UPDATE gracz SET gracz.elo = imie_g WHERE id = 1453;
UPDATE gracz SET gracz.elo = imie_g WHERE id = 1465;
UPDATE gracz SET gracz.elo = imie_g WHERE id = 1465;

Select * from historia_elo2;

DECLARE
  value_rand NUMBER;
  value_rand_2 NUMBER;
  counter NUMBER;
BEGIN
counter := 1479;
FOR loop_counter IN 1..30 LOOP
    value_rand := ROUND(DBMS_RANDOM.VALUE * (7 - 1)+1);
    value_rand_2 := ROUND(DBMS_RANDOM.VALUE * (2 - 1)+1);
    if value_rand_2 = 2 THEN
        counter := counter - value_rand;
        INSERT INTO historia_elo2 (id_gracza, zmiana_elo, data_zmiany) VALUES (90, counter, TO_DATE('2003/05/'||TO_CHAR(loop_counter)||' 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
    else
        counter := counter + value_rand;
        INSERT INTO historia_elo2 (id_gracza, zmiana_elo, data_zmiany) VALUES (90, counter, TO_DATE('2003/05/'||TO_CHAR(loop_counter)||' 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
    end if;
  END LOOP;
END;

DECLARE
  value_rand NUMBER;
  value_rand_2 NUMBER;
  counter NUMBER;
BEGIN
counter := 1457;
FOR loop_counter IN 1..16 LOOP
    value_rand := ROUND(DBMS_RANDOM.VALUE * (7 - 1)+1);
    counter := counter + value_rand;
    INSERT INTO historia_elo2 (id_gracza, zmiana_elo, data_zmiany) VALUES (90, counter, TO_DATE('2003/06/'||TO_CHAR(loop_counter)||' 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));

  END LOOP;
END;


DECLARE
  value_rand NUMBER;
  value_rand_elo NUMBER;
  nar VARCHAR2(3);
  value_rand_plec NUMBER;
  plec VARCHAR2(1);
BEGIN
FOR loop_counter IN 1..100 LOOP
    value_rand := ROUND(DBMS_RANDOM.VALUE * (7 - 1)+1);
    
    value_rand_plec := ROUND(DBMS_RANDOM.VALUE * 2);
    IF value_rand_plec = 1 THEN
        plec := 'M';
    ELSE
        plec := 'K';
    END IF;
    SELECT narodowosc INTO nar FROM narodowosc WHERE id=value_rand; 
    value_rand_elo := ROUND(DBMS_RANDOM.VALUE * (1200 - 1000 + 1) + 1000);
   INSERT INTO gracz(imie, nazwisko, narodowosc, elo, plec, data_dolaczenia) VALUES ('gracz'||TO_CHAR(loop_counter), 'nazwisko'||TO_CHAR(loop_counter), nar, value_rand_elo, plec, sysdate); 
  END LOOP;
END;

SELECT * FROM historia_elo2;


DECLARE
  value_rand NUMBER;
BEGIN
FOR loop_counter IN 1..100 LOOP
    value_rand := ROUND(DBMS_RANDOM.VALUE * (7 - 1)+1);
    DBMS_OUTPUT.PUT_LINE(value_rand);
  END LOOP;
END;

select * FROM gracz;


CREATE FUNCTION hist_elo_gracza (gracz_id NUMBER) RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
BEGIN
  open c1 for
  SELECT *
  FROM historia_elo2
  WHERE id_gracza=gracz_id;
  RETURN c1;
END;



SELECT gracze_danej_narodowosci('GER') FROM dual;

CREATE OR REPLACE FUNCTION narodowosci_list RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
BEGIN
    open c1 for
    SELECT UNIQUE(narodowosc) FROM gracz;
  RETURN c1;
END;

SELECT narodowosci_list FROM dual;

CREATE OR REPLACE FUNCTION hist_elo_gracza_msc (gracz_id NUMBER, msc NUMBER) RETURN NUMBER
IS
  c1 NUMBER;
BEGIN
    SELECT AVG(zmiana_elo) INTO c1
    FROM historia_elo2
    WHERE EXTRACT(MONTH FROM data_zmiany) = msc;
    RETURN ROUND(c1);
END;

    SELECT AVG(zmiana_elo)
    FROM historia_elo2
    WHERE EXTRACT(MONTH FROM data_zmiany) = 6;
SELECT hist_elo_gracza_msc(90, 5) FROM dual;



--SELECT *
--FROM historia_elo2
--WHERE EXTRACT(MONTH FROM data_zmiany) = 5;
SELECT * FROM gracz;

DELETE FROM historia_elo2 WHERE EXTRACT(YEAR FROM data_zmiany) = 2024;
SELECT hist_elo_gracza(90) FROM dual;


CREATE OR REPLACE FUNCTION srednie_elo_graczy RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
--  srednie_elo NUMBER;
--  suma_graczy NUMBER;
BEGIN
    open c1 for
    SELECT COUNT(id), AVG(elo) FROM gracz;
    RETURN c1;
END;

SELECT srednie_elo_graczy FROM dual;

CREATE OR REPLACE FUNCTION srednie_elo_narodowosci RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
--  srednie_elo NUMBER;
--  suma_graczy NUMBER;
BEGIN
    open c1 for
    SELECT narodowosc, COUNT(narodowosc), AVG(elo), MEDIAN(elo), STDDEV(elo) FROM gracz GROUP BY narodowosc;
    RETURN c1;
END;

SELECT srednie_elo_narodowosci FROM dual;

CREATE OR REPLACE FUNCTION ilosc_graczy_nardowosci RETURN SYS_REFCURSOR
IS
  c1 SYS_REFCURSOR;
--  srednie_elo NUMBER;
--  suma_graczy NUMBER;
BEGIN
    open c1 for
    SELECT narodowosc, COUNT(narodowosc) FROM gracz GROUP BY narodowosc;
    RETURN c1;
END;

SELECT ilosc_graczy_nardowosci FROM dual;
