DROP DATABASE IF EXISTS skladiste;
CREATE DATABASE skladiste;
USE skladiste;

CREATE TABLE drzava(
id INTEGER NOT NULL,
skracenica CHAR(3) NOT NULL,
naziv VARCHAR(20) NOT NULL,
glavni_grad VARCHAR(30) NOT NULL,
PRIMARY KEY(id)
);


CREATE TABLE adresa(
ID INTEGER NOT NULL,
naziv VARCHAR(50) NOT NULL,
id_drzava INTEGER NOT NULL, 
grad VARCHAR(30) NOT NULL,
postanski_broj VARCHAR(10) NOT NULL CHECK (postanski_broj<100000), 
PRIMARY KEY (ID),
FOREIGN KEY (id_drzava) REFERENCES drzava(id)
);

CREATE TABLE vrsta_posla(
ID INTEGER NOT NULL,
naziv VARCHAR(20) NOT NULL,
duznost VARCHAR(50) NOT NULL,
radno_vrijeme VARCHAR(50) NOT NULL,
opis VARCHAR(100) NOT NULL,
PRIMARY KEY (ID)
);


CREATE TABLE firma(
ID INTEGER NOT NULL,
naziv VARCHAR(50) NOT NULL,
OIB CHAR(11) NOT NULL UNIQUE, 
ID_adresa INT, 
PRIMARY KEY (ID),
check (length(oib) = 11),
FOREIGN KEY  (id_adresa) REFERENCES adresa (id)
);


CREATE TABLE skladiste(
ID INTEGER NOT NULL,
ID_firma INT NOT NULL, 
naziv VARCHAR(20) NOT NULL,
ID_adresa INT NOT NULL, 
PRIMARY KEY (ID),
FOREIGN KEY (id_firma) REFERENCES firma(id),
FOREIGN KEY  (id_adresa) REFERENCES adresa (id)

);
-- drop table zaspolenik;
CREATE TABLE zaposlenik(
ID INTEGER NOT NULL,
ime VARCHAR(30),
prezime VARCHAR(30),
OIB CHAR(11) UNIQUE NOT NULL,
datum_zaposlenja DATE NOT NULL,
ID_skladiste INT ,
ID_vrsta_posla INT, 
PRIMARY KEY (ID),
check (length(oib) = 11),
FOREIGN KEY (id_skladiste) REFERENCES  skladiste(id),
FOREIGN KEY (id_vrsta_posla) REFERENCES vrsta_posla(id)
);

CREATE TABLE racun(
ID INTEGER NOT NULL,
ID_zaposlenik INT , 
datum_izdavanja DATE NOT NULL, 
ID_firma INT, 
PRIMARY KEY (ID),
FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
FOREIGN KEY (id_firma) REFERENCES firma(id)
);

CREATE TABLE artikl(
ID INTEGER NOT NULL,
cijena DECIMAL(10,2) NOT NULL, 
naziv VARCHAR(20) NOT NULL,
vrsta_artikla VARCHAR(30) NOT NULL, 
PRIMARY KEY (ID),
check (cijena < 5000 AND cijena >= 0 )
);

CREATE TABLE stavka_racun(
ID INTEGER NOT NULL,
ID_racun INT , 
ID_artikl INT , 
kolicina INT NOT NULL CHECK (kolicina < 50 AND kolicina >= 0), 
PRIMARY KEY (ID),
FOREIGN KEY (id_racun) REFERENCES racun(id) ON DELETE CASCADE,
FOREIGN KEY (id_artikl) REFERENCES artikl(id)
);


CREATE TABLE artikli_u_skladistu(
ID INTEGER NOT NULL,
ID_skladiste INT , 
ID_artikl INT ,
kolicina INT CHECK (kolicina < 1000 AND kolicina >= 0), 
PRIMARY KEY (ID),
FOREIGN KEY (id_skladiste) REFERENCES skladiste(id),
FOREIGN KEY (id_artikl) REFERENCES artikl(id)

);

CREATE TABLE kupac(
ID INTEGER NOT NULL,
ime VARCHAR(40),
prezime VARCHAR(40),
ID_adresa INTEGER,
telefon VARCHAR(20),
PRIMARY KEY (ID),
FOREIGN KEY (id_adresa) REFERENCES adresa(id)

);

CREATE TABLE izdatnica (
ID INTEGER NOT NULL,
datum_dostavljanja DATE NOT NULL,
vrijeme_dostavljanja TIME NOT NULL,
ID_zaposlenik INT ,
ID_kupac INT , 
PRIMARY KEY (ID),
FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
FOREIGN KEY (id_kupac) REFERENCES kupac(id)

);


CREATE TABLE stavka_izdatnica(
ID INTEGER NOT NULL,
ID_izdatnica INTEGER ,
ID_artikli_u_skladistu INTEGER, 
kolicina INTEGER CHECK (kolicina < 25 AND kolicina >= 0), 
PRIMARY KEY (ID),
FOREIGN KEY (id_izdatnica) REFERENCES izdatnica(id),
FOREIGN KEY (id_artikli_u_skladistu) REFERENCES artikli_u_skladistu(id)
);


CREATE TABLE dobavljac(
ID INTEGER NOT NULL,
ID_zaposlenik INT,
vozacka VARCHAR(5),
godine_iskustva INTEGER CHECK (godine_iskustva < 25 ),
PRIMARY KEY (ID),
FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id)
);


CREATE TABLE povratno(
ID INTEGER NOT NULL,
id_dobavljac INT,
id_izdatnica INT,
razlog_povratka VARCHAR(50),
datum_ponovnog_dostavljanja DATE,
PRIMARY KEY(ID),
FOREIGN KEY (id_dobavljac) REFERENCES dobavljac(id),
FOREIGN KEY (id_izdatnica) REFERENCES izdatnica(id)
);

INSERT INTO drzava VALUES (1,'HRV','HRVATSKA' , 'ZAGREB'),
						  (2,'SRB','SRBIJA', 'BEOGRAD'),
                          (3,'BIH','BOSNA I HERCEGOVINA','SARAJEVO'),
                          (4,'SLO','SLOVENIJA', 'LJUBLJANA');

INSERT INTO adresa VALUES (1, 'Kaštanjer 22',1, 'Pula', 52100),
						  (2, 'Škurinje 12',1, 'Rijeka', 51000),
                          (3, 'Zagrebačka ulica 17',2, 'Zagreb', 10000),
                          (4, 'Vukovarska ul. 56',3, 'Split', 21000),
                          (5, 'VUkovarska ul. 39',4, 'Osijek', 31000);

INSERT INTO vrsta_posla VALUES (1, 'Direktor', 'CEO servisa', '8:00-15:00','Dogovaranje novih poslova, briga o firmi'),
                               (2, 'Voditelj', 'Menadžer skladišta', '8:00-15:00','Nadziranje radnika, upravljanje Poslovnice servisom'),
                               (3, 'Dostavljac', 'dostava robe', '8:00-15:00','Dostava robe kupcima'),
                               (4, 'Blagajnik', 'Rad u skladištu', '8:00-15:00','primatelj robe ,izdavanje racuna'),
                               (5, 'Skladistar', 'Rad u skladištu', '8:00-15:00','Pakiranje robe, kontrola proizvoda, slaganje proizvoda');


INSERT INTO firma VALUES (1, 'Skladište d.o.o', 86475366923,4),
						 (2, 'KLIMAOPREMA d.d.', 86475366964,4),
						 (3, 'SOLVIS d.o.o.', 56783247536,3),
                         (4, 'EKO ELEKTRONIKA d.o.o.', 56869234292,1),
                         (5, 'ETRADEX d.o.o.', 82575356279,2),
						 (6, 'CAREL ADRIATIC d.o.o.', 84564986549,2);

INSERT INTO skladiste values (1, 1, 'Skladište 1', 1),
                            (2, 1,'Skladište 2', 2),
                            (3, 1, 'Skladište 3', 3),
                            (4, 1, 'Skladište 4', 4),
                            (5, 1, 'Skladište 5', 5);



 INSERT INTO zaposlenik VALUES (1, 'Kristijan', 'Perić',12345678911, STR_TO_DATE('05.04.2015.', '%d.%m.%Y.' ),1,1),
							   (2,  'Dean', 'Zrinić', 12345679821,STR_TO_DATE('23.11.2016.', '%d.%m.%Y.' ),4 ,1),
                               (3,  'Marko', 'Boškin', 12345698732,STR_TO_DATE('21.10.2020.', '%d.%m.%Y.' ),4 ,1),
                               (4,  'Noel', 'Hafizović', 12345679543,STR_TO_DATE('13.08.2021.', '%d.%m.%Y.' ),4 ,4),
                               (5,  'Klara', 'Matijašić', 11249735726,STR_TO_DATE('01.03.2021.', '%d.%m.%Y.' ),4 ,2),
                               (6,  'Nina', 'Lipovac', 67512894332,STR_TO_DATE('04.05.2022.', '%d.%m.%Y.' ), 4, 2),
                               (7,  'Petra', 'Sirotić', 85623778843,STR_TO_DATE('25.05.2022.', '%d.%m.%Y.' ),5 ,2),
                               (8,  'Antonia', 'Jukić', 24578843621,STR_TO_DATE('04.11.2019.', '%d.%m.%Y.' ),5 ,3),
                               (9,  'Simona', 'Bibić', 21213466312,STR_TO_DATE('05.01.2019.', '%d.%m.%Y.' ),5 ,3),
                               (10,  'Sara', 'Legović', 57843188732,STR_TO_DATE('09.02.2019.', '%d.%m.%Y.' ),5 ,3),
                               (11,  'Antonio', 'Križanac', 12312452756,STR_TO_DATE('07.07.2015.', '%d.%m.%Y.' ),2 ,3),
                               (12,  'Andrej', 'Plenković', 24576642287,STR_TO_DATE('05.12.2017.', '%d.%m.%Y.' ) ,2,1),
                               (13,  'Sara', 'Preiša', 98774758176,STR_TO_DATE('30.12.2020.', '%d.%m.%Y.' ), 5, 2),
                               (14,  'Tea', 'Sibić', 22547463154, STR_TO_DATE('22.9.2021.', '%d.%m.%Y.' ),2, 3),
                               (15,  'Izabel', 'Božić', 21254784056,STR_TO_DATE('13.3.2021.', '%d.%m.%Y.' ), 5 ,2),
                               (16,  'Daira', 'Zubac', 53467224044,STR_TO_DATE('16.5.2022.', '%d.%m.%Y.' ), 3, 1),
                               (17,  'Leonarda', 'Merić', 34600572923,STR_TO_DATE('10.2.2020.', '%d.%m.%Y.' ),3 ,1),
                               (18,  'Megan', 'Racetin', 77854102955,STR_TO_DATE('04.06.2018.', '%d.%m.%Y.' ), 3, 1),
                               (19,   'Vesna', 'Lončar', 77874962044,STR_TO_DATE('24.04.2018.', '%d.%m.%Y.' ),3 , 1),
                               (20,  'Marko', 'Mirković', 78799632587,STR_TO_DATE('01.01.2018.', '%d.%m.%Y.' ),3 ,2),
                               (21,  'Sandra', 'Baban', 88541298099,STR_TO_DATE('31.1.2016.', '%d.%m.%Y.' ), 3, 2),
                               (22,  'Lucia', 'Maletić', 87954698098,STR_TO_DATE('09.11.2016.', '%d.%m.%Y.' ),3 ,2),
                               (23,  'Andrej', 'Ivanovski', 83791480601,STR_TO_DATE('18.07.2017.', '%d.%m.%Y.' ),3 ,3),
                               (24,  'Nensi', 'Modrušan', 99745200710,STR_TO_DATE('05.08.2019.', '%d.%m.%Y.' ),3 , 3),
                               (25,  'Almira', 'Trbić', 97066589534, STR_TO_DATE('17.09.2019.', '%d.%m.%Y.' ),3, 3),
                               (26,  'Ivan', 'Budimir', 45697022431, STR_TO_DATE('18.10.2019.', '%d.%m.%Y.' ),5, 1),
                               (27,  'Leonard', 'Filipović', 44875230330,STR_TO_DATE('27.6.2021.', '%d.%m.%Y.' ),5 ,2),
                               (28,  'Linda', 'Hafizović', 58267102107,STR_TO_DATE('23.4.2021.', '%d.%m.%Y.' ), 5, 3),
                               (29,  'karla', 'Jurman', 12226703283,STR_TO_DATE('19.05.2021.', '%d.%m.%Y.' ),5 , 1),
                               (30,  'Tomas', 'Senković', 62244574381,STR_TO_DATE('28.11.2020.', '%d.%m.%Y.' ),5 ,1),
                               (31,  'Ivan', 'Prtrov', 57679304431,STR_TO_DATE('11.01.2020.', '%d.%m.%Y.' ),5 ,2),
                               (32,  'Mario', 'Turić',99230413214,STR_TO_DATE('24.7.2022.', '%d.%m.%Y.' ),5, 4),
                               (33,  'Marko', 'Dukić', 76852339131,STR_TO_DATE('11.09.2016.', '%d.%m.%Y.' ),5 ,4),
                               (34,  'Petar', 'Horvat', 19367487710,STR_TO_DATE('16.10.2019.', '%d.%m.%Y.' ),5 ,4),
                               (35,  'Denis', 'Denisović', 13425676721,STR_TO_DATE('15.04.2018.', '%d.%m.%Y.' ),5 ,4),
                               (36,  'Karlo', 'Pereša', 45653487921,STR_TO_DATE('05.02.2018.', '%d.%m.%Y.' ),5 ,2),
                               (37,  'Joško', 'Antić', 35526748181,STR_TO_DATE('07.01.2020.', '%d.%m.%Y.' ),5 ,3),
                               (38,  'Andrej', 'Matković',67738291043,STR_TO_DATE('25.08.2016.', '%d.%m.%Y.' ),5 ,3),
							   (39,  'Juraj', 'Buić', 78993654712,STR_TO_DATE('05.12.2018.', '%d.%m.%Y.' ),5 ,2),
							   (40,  'Marta', 'Špada', 35455786921,STR_TO_DATE('14.08.2019.', '%d.%m.%Y.' ),5 ,3);



INSERT INTO racun values (1, 32, STR_TO_DATE('05.11.2023.', '%d.%m.%Y.'), 5),
                        (2, 33, STR_TO_DATE('01.09.2023.', '%d.%m.%Y.'), 4),
                        (3, 32, STR_TO_DATE('30.12.2021.', '%d.%m.%Y.'),4),
                        (4, 35, STR_TO_DATE('25.8.2021.', '%d.%m.%Y.'),3 ),
                        (5, 4, STR_TO_DATE('10.12.2021.', '%d.%m.%Y.'), 2),
                        (6, 4, STR_TO_DATE('15.12.2021.', '%d.%m.%Y.'),2),
                         (7, 4, STR_TO_DATE('25.10.2021.', '%d.%m.%Y.'),2),
                        (8, 4, STR_TO_DATE('11.11.2021.', '%d.%m.%Y.'),2),
                        (9, 34, STR_TO_DATE('28.07.2021.', '%d.%m.%Y.'),6),
                        (10, 34, STR_TO_DATE('23.11.2021.', '%d.%m.%Y.'),6);

INSERT INTO artikl values (1, 3090.99, 'Perilica posuđa ', 'Kućanski aparati'),
                            (2, 3599.99, 'Perilica rublja ', 'Kućanski aparati'),
                            (3, 4199.99, 'Hladnjak', 'Kućanski aparati'),
                            (4, 3199.99, 'Sušilica rublja', 'Kućanski aparati'),
                            (5, 349.99, 'Aparat za kavu', 'Kućanski aparati'),
                            (6, 419.99, 'Mikser', 'Kućanski aparati'),
                            (7, 239.99, 'Blander', 'Kućanski aparati'),
                            (8, 549.99, 'Toster', 'Kućanski aparati'),
							(9, 2169.99, 'Mobitel', 'Elektronika'),
                            (10, 2399.99, 'Tablet', 'Elektronika'),
                            (11, 4589.99, 'Televizor', 'Elektronika'),
                            (12, 1679.99, 'Pametni sat', 'Elektronika'),
							(13, 1099.99, 'Auto gume ', 'Auto i Moto oprema'),
                            (14, 772.98, 'Moto gume', 'Auto i Moto oprema'),
                            (15, 249.99, 'Ratkape', 'Auto i Moto oprema'),
                            (16, 859.49, 'Aluminiski naplatci', 'Auto i Moto oprema'),
                            (17, 529.49, 'Čelični  naplatci', 'Auto i Moto oprema');

INSERT INTO stavka_racun values (1, 1, 2, 2),
								(2, 2, 5, 2),
								(3, 3, 4, 1),
								(4, 4, 11, 2),
								(5, 5, 13, 4),
								(6, 6, 16, 4),
								(7, 7, 12, 1),
								(8, 8, 6, 1),
								(9, 9, 3, 1),
                                (14, 10, 11, 2);
                                

INSERT INTO artikli_u_skladistu VALUES (1, 1, 10, 5 ),
										(2, 1, 7, 9 ),
                                        (3, 1, 9, 17 ),
                                        (4, 1, 1, 20 ),
                                        (5, 2, 2, 11 ),
                                        (6, 2, 3, 12 ),
                                        (7, 2, 4, 14 ),
                                        (8, 2, 5, 10 ),
                                        (9, 3, 6, 22 ),
                                        (10, 3, 7, 15 ),
                                        (11, 3, 8, 16 ),
                                        (12, 3, 9, 12 ),
                                        (13, 4, 10, 19 ),
                                        (14, 4, 11, 10 ),
                                        (15, 4, 12, 18 ),
                                        (16, 5, 13, 40 ),
                                        (17, 5, 14, 40 ),
                                        (18, 5, 15, 60 ),
                                        (19, 5, 16, 30 ),
                                        (20, 5, 17, 50 );

INSERT INTO kupac values (1,  'Mateo', 'Crljenica',  5, 099584132),
                         (2,  'Ivan', 'Boljunćič', 3, 095684132),
                         (3,  'Jusuf', 'Garipi',  2, 091784132),
                         (4,  'Lana', 'Garić',  1, 099589932),
                         (5,  'Lukas', 'Mirković',  1, 091491232),
                         (6,  'Patrik', 'Kralj',  5, 0915841321),
                         (7,  'Marko', 'Zahirović',  4, 098511132),
                         (8,  'Nolan', 'Runovac', 5, 091534832),
                         (9,  'Tomas', 'Mirković', 1, 099581234),
                         (10,  'Božoidar', 'Trpić', 1, 09957989),
                         (11,  'Marko', 'Filipović', 1, 099871123),
                         (12,  'Filip', 'Božac', 4, 095098098),
                         (13,  'Petar', 'Zecimir', 3, 0914567132),
                         (14,  'Jakov', 'Pušić', 2, 099545132),
                         (15,  'Jagoda', 'Mirzić', 2, 099500132);

INSERT INTO izdatnica VALUES (1, STR_TO_DATE('07.05.2023.', '%d.%m.%Y.') , '18:45',13,5),
                            (2,STR_TO_DATE('29.07.2023.', '%d.%m.%Y.'), '13:30',2,3),
							(3,STR_TO_DATE('06.05.2023.', '%d.%m.%Y.'), '18:00',6,5),
                            (4,STR_TO_DATE('05.11.2023.', '%d.%m.%Y.'), '9:45',8,1),
                            (5,STR_TO_DATE('05.04.2023.', '%d.%m.%Y.'), '10:30',11,10),
                            (6,STR_TO_DATE('05.06.2023.', '%d.%m.%Y.'), '11:00',1,7);

INSERT INTO stavka_izdatnica values(1,5,5,6 ),
								(2,3,1,5 ),
                                (3,4,12,3 ),
                                (4,6,8,1 ),
                                (5,2,13,16 ),
                                (6,1,19,21 );

INSERT INTO dobavljac values (1,8, 'B', 3),
                              (2, 25, 'B',2),
                              (3, 25, 'B',3),
                              (4, 38, 'C1', 6),
                              (5, 9, 'B', 1),
                              (6, 25, 'C', 1);

INSERT INTO povratno values (1, 2 , 2,"kupac nije bio kući", STR_TO_DATE('1.08.2023.', '%d.%m.%Y.' )),
							  (2, 3, 3, "nije plaćeno na vrijeme", STR_TO_DATE('10.05.2023.', '%d.%m.%Y.' )),
                              (3, 5, 5 ,"potrgan paket zahtjev zamjene", STR_TO_DATE('07.04.2023.', '%d.%m.%Y.' )),
                              (4, 6, 1 ,"paket je kasnio ", STR_TO_DATE('10.06.2023.', '%d.%m.%Y.' )),
                              (5, 1, 4 ,"kupac nije bio kući", STR_TO_DATE('13.05.2023.', '%d.%m.%Y.' )),
                              (6, 4 , 6 ,"kuapc nije bio kuci" , STR_TO_DATE('15.08.2023.', '%d.%m.%Y.' ));



-- 1. prosječna starost zaposlenika, broj zaposlenika u svakoj firmi, te ukupan broj izdanih računa po firmama, s time da uzima u obzir samo one zaposlenike koji su se zaposlili prije 2022. godine
SELECT firma.naziv AS 'Firma', COUNT(DISTINCT zaposlenik.ID) AS 'Broj_zaposlenika', 
       AVG(DATEDIFF('2024-01-03', zaposlenik.datum_zaposlenja)/365) AS 'Prosjecna_staz', 
       SUM(racun.ID IS NOT NULL) AS 'Broj_izdanih_racuna'
FROM firma
JOIN skladiste ON firma.ID = skladiste.ID_firma
JOIN zaposlenik ON skladiste.ID = zaposlenik.ID_skladiste
LEFT JOIN racun ON zaposlenik.ID = racun.ID_zaposlenik
WHERE YEAR(zaposlenik.datum_zaposlenja) <= 2022
GROUP BY firma.naziv
ORDER BY Broj_izdanih_racuna DESC, Broj_zaposlenika DESC;


-- 2. dohvati državu s najvišom ukupnom vrijednošću izdanih računa
SELECT drzava.naziv AS drzava, 
       SUM(artikl.cijena * stavka_racun.kolicina) AS ukupna_vrijednost_racuna
FROM drzava
JOIN adresa ON drzava.ID = adresa.id_drzava
JOIN firma ON adresa.ID = firma.ID_adresa
JOIN skladiste ON firma.ID = skladiste.ID_firma
JOIN zaposlenik ON skladiste.ID = zaposlenik.ID_skladiste
JOIN racun ON zaposlenik.ID = racun.ID_zaposlenik
JOIN stavka_racun ON racun.ID = stavka_racun.ID_racun
JOIN artikl ON stavka_racun.ID_artikl = artikl.ID
GROUP BY drzava.naziv
ORDER BY ukupna_vrijednost_racuna DESC
LIMIT 1;

-- 3. Dohvati artikle čija je količina manja od prosječne količine po skladistu
SELECT a.*, au.kolicina, s.naziv AS naziv_skladista
FROM artikl a
JOIN artikli_u_skladistu au ON a.ID = au.ID_artikl
JOIN skladiste s ON au.ID_skladiste = s.ID
WHERE au.kolicina < (SELECT AVG(kolicina) FROM artikli_u_skladistu)
ORDER BY s.naziv, a.naziv;


-- 4. pronađi dobavljača s najdužim radnim stažem te najviše povratnih informacija
SELECT 
    dobavljac.ID AS id_dobavljac,
    zaposlenik.ime AS ime_zaposlenika,
    zaposlenik.prezime AS prezime_zaposlenika,
    dobavljac.godine_iskustva AS godine_iskustva,
    COUNT(DISTINCT povratno.id_izdatnica) AS broj_povratnih_informacija
FROM
    dobavljac
        JOIN
    zaposlenik ON dobavljac.ID_zaposlenik = zaposlenik.ID
        JOIN
    izdatnica ON zaposlenik.ID = izdatnica.ID_zaposlenik
        LEFT JOIN
    povratno ON izdatnica.ID = povratno.id_izdatnica
GROUP BY dobavljac.ID
ORDER BY godine_iskustva DESC , broj_povratnih_informacija DESC
LIMIT 1;

-- 5. prikazi sve firme koje imaju više od jednog skladišta, zajedno s brojem skladišta koje posjeduju
SELECT firma.naziv AS naziv_firme,
       COUNT(DISTINCT skladiste.ID) AS broj_skladista
FROM firma
JOIN skladiste ON firma.ID = skladiste.ID_firma
GROUP BY firma.ID
HAVING broj_skladista > 1;

-- 6. Prikaži sve dostave koje je obavio određeni dostavljač
SELECT
    d.ID AS Dostava_ID,
    d.datum_dostavljanja AS Datum_Dostave,
    d.vrijeme_dostavljanja AS Vrijeme_Dostave,
    (SELECT ime FROM zaposlenik WHERE ID = d.ID_zaposlenik) AS Dostavljac_Ime,
    (SELECT prezime FROM zaposlenik WHERE ID = d.ID_zaposlenik) AS Dostavljac_Prezime,
    (SELECT ime FROM kupac WHERE ID = (SELECT ID_kupac FROM paket WHERE ID = d.ID_paket)) AS Kupac_Ime,
    (SELECT prezime FROM kupac WHERE ID = (SELECT ID_kupac FROM paket WHERE ID = d.ID_paket)) AS Kupac_Prezime,
    (SELECT grad FROM adresa WHERE ID = (SELECT id_adresa FROM kupac WHERE ID = (SELECT ID_kupac FROM paket WHERE ID = d.ID_paket))) AS Adresa_Grad,
    (SELECT postanski_broj FROM adresa WHERE ID = (SELECT id_adresa FROM kupac WHERE ID = (SELECT ID_kupac FROM paket WHERE ID = d.ID_paket))) AS Adresa_Postanski_Broj,
    (SELECT razlog_povratka FROM povratno WHERE id_dostavljac = d.ID) AS Razlog_Povratka
FROM
    dostavljac d
WHERE
    d.ID_zaposlenik = 25;


-- 7. Pronađi sve pakete koji su dostavljeni s razlogom povratka
SELECT p.*, povratno.razlog_povratka
FROM paket p
JOIN dostavljac d ON p.ID = d.id_paket
JOIN povratno ON d.ID = povratno.id_dostavljac;

-- 8. vrsta posla i ukupan broj zaposlenika koji obavljaju tu vrstu posla
SELECT vrsta_posla.naziv AS vrsta_posla,
       COUNT(zaposlenik.ID) AS ukupan_broj_zaposlenika
FROM vrsta_posla
LEFT JOIN zaposlenik ON vrsta_posla.ID = zaposlenik.ID_vrsta_posla
GROUP BY vrsta_posla.ID;


-- 9. informacije o zaposlenicima koji su bili uključeni u izdavanje robe za firmu koja je imala povratnu informaciju o nekoj robi
SELECT 
  zaposlenik.ime, 
  zaposlenik.prezime, 
  firma.naziv AS naziv_firme, 
  izdatnica.datum_dostavljanja, 
  povratno.razlog_povratka
FROM 
  zaposlenik
JOIN 
  izdatnica ON zaposlenik.ID = izdatnica.ID_zaposlenik
JOIN 
  povratno ON izdatnica.ID = povratno.id_izdatnica
JOIN 
  firma ON zaposlenik.ID_skladiste = firma.ID
JOIN 
  adresa ON firma.ID_adresa = adresa.ID
WHERE 
  povratno.razlog_povratka IS NOT NULL
  AND izdatnica.datum_dostavljanja BETWEEN '2023-01-01' AND '2023-12-31'
LIMIT 1;

-- 10. Izračunaj ukupnu vrijednost artikala
SELECT SUM(cijena * kolicina) AS ukupna_vrijednost
FROM stavka_racun
JOIN artikl ON stavka_racun.ID_artikl = artikl.ID;


-- 11. Prikaži sve dostavljače i broj dostava koje su obavili
SELECT
    d.ID AS dostavljac_id,
    z.ime AS ime_dostavljaca,
    z.prezime AS prezime_dostavljaca,
    COUNT(d.ID) AS broj_dostava
FROM dostavljac d
JOIN zaposlenik z ON d.ID_zaposlenik = z.ID
GROUP BY dostavljac_id;

-- 12. dohvati informacije o stavkama izdatnica, uključujući naziv artikla, količinu, datum i vrijeme dostavljanja, ime i prezime zaposlenika. Podaci su sortirani prema datumu i vremenu dostavljanja u silaznom redoslijedu
SELECT si.ID AS 'ID_Stavke', a.naziv AS 'Naziv_Artikla', si.kolicina AS 'Količina', iz.datum_dostavljanja AS 'Datum_Dostavljanja', iz.vrijeme_dostavljanja AS 'Vrijeme_Dostavljanja', z.ime AS 'Ime_Zaposlenika', z.prezime AS 'Prezime_Zaposlenika'
FROM stavka_izdatnica si
JOIN artikli_u_skladistu aus ON si.ID_artikli_u_skladistu = aus.ID
JOIN izdatnica iz ON si.ID_izdatnica = iz.ID
JOIN artikl a ON aus.ID_artikl = a.ID
JOIN zaposlenik z ON iz.ID_zaposlenik = z.ID
ORDER BY iz.datum_dostavljanja DESC, iz.vrijeme_dostavljanja DESC;


-- 13. Prikaži sve razloge povratka koji se odnose na određenog dostavljača
SELECT
    p.ID AS povrat_id,
    d.ID AS dostavljac_id,
    z.ime AS ime_dostavljaca,
    z.prezime AS prezime_dostavljaca,
    p.razlog_povratka,
    p.datum_ponovnog_dostavljanja
FROM povratno p
JOIN dostavljac d ON p.id_dostavljac = d.ID
JOIN zaposlenik z ON d.ID_zaposlenik = z.ID;


-- 14. Izlistaj sve adrese koje imaju više od jednog skladišta
SELECT a.*, COUNT(s.ID) AS Broj_skladišta
FROM adresa a
JOIN skladiste s ON a.ID = s.ID_adresa
GROUP BY a.ID
HAVING Broj_skladišta > 1;


-- 15. Prikazi informacije o zaposlenicima, njihovim skladistima, gradovima i vrsti posla
SELECT
    z.ID AS Zaposlenik_ID,
    z.ime AS Zaposlenik_Ime,
    z.prezime AS Zaposlenik_Prezime,
    z.OIB AS Zaposlenik_OIB,
    z.datum_zaposlenja AS Zaposlenik_Datum_Zaposlenja,
    s.naziv AS Skladiste_Naziv,
    a.grad AS Grad,
    a.postanski_broj AS Postanski_Broj,
    vp.naziv AS Vrsta_Posla
FROM zaposlenik z
JOIN skladiste s ON z.ID_skladiste = s.ID
JOIN adresa a ON s.ID_adresa = a.ID
JOIN vrsta_posla vp ON z.ID_vrsta_posla = vp.ID
ORDER BY Zaposlenik_ID;







-- Funkcije

-- 1. provjera dostupnosti proizvoda na skladištu
DELIMITER //
CREATE FUNCTION dostupnost_proizvoda_na_skladistu(skladiste_ID INTEGER, artikl_ID INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE dostupna_kolicina INTEGER;

    SELECT COALESCE(SUM(aus.kolicina), 0) INTO dostupna_kolicina
    FROM artikli_u_skladistu aus
    WHERE aus.ID_skladiste = skladiste_ID AND aus.ID_artikl = artikl_ID;

    RETURN dostupna_kolicina;
END //
DELIMITER ;

SELECT dostupnost_proizvoda_na_skladistu(2, 3) AS dostupna_kolicina;


-- 2. funkcija koja vraća broj zaposlenika određenog skladišta
DELIMITER //
CREATE FUNCTION zaposlenici_u_skladistu(skladiste_ID INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE broj_zaposlenika INTEGER;
    SELECT COUNT(*) INTO broj_zaposlenika
    FROM zaposlenik
    WHERE ID_skladiste = skladiste_ID;
    RETURN broj_zaposlenika;
END //
DELIMITER ;

SELECT zaposlenici_u_skladistu(2) AS broj_zaposlenika;


-- 3. funkcija koja vraća sveukupan iznos određenog računa
DELIMITER //
CREATE FUNCTION sveukupan_iznos_računa(racun_ID INTEGER) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE sveukupno DECIMAL(10, 2);
    SELECT SUM(a.cijena * sr.kolicina) INTO sveukupno
    FROM stavka_racun sr
    JOIN artikl a ON sr.ID_artikl = a.ID
    WHERE sr.ID_racun = racun_ID;
    RETURN sveukupno;
END //
DELIMITER ;

SELECT sveukupan_iznos_racuna(5) AS iznos_racuna;


-- 4. funkcija koja vraća ukupnu količinu proizvoda prodanih u određenom razdoblju
DELIMITER //
CREATE FUNCTION sveukupna_kolicina_prodanih_proizvoda(pocetni_datum DATE, krajnji_datum DATE) RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE sveukupna_kolicina INTEGER;
    SELECT SUM(sr.kolicina) INTO sveukupna_kolicina
    FROM stavka_racun sr
    JOIN racun r ON sr.ID_racun = r.ID
    WHERE r.datum_izdavanja BETWEEN pocetni_datum AND krajnji_datum;
    RETURN sveukupna_kolicina;
END //
DELIMITER ;

SELECT sveukupna_kolicina_prodanih_proizvoda('2021-01-01', '2021-12-31') AS prodana_kolicina;


-- 5. funkcija koja vraća zaposlenika pojedinog skladišta s najviše radnog staža
DROP FUNCTION zaposlenik_s_najvise_radnog_staza;
DELIMITER //
CREATE FUNCTION zaposlenik_s_najvise_radnog_staza(skladiste_ID INTEGER) RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
    DECLARE najduze_zaposlen VARCHAR(60);
    SELECT CONCAT(ime, ' ', prezime) INTO najduze_zaposlen
    FROM zaposlenik
    WHERE ID_skladiste = skladiste_ID
    ORDER BY datum_zaposlenja ASC
    LIMIT 1;
    RETURN najduze_zaposlen;
END //
DELIMITER ;

SELECT zaposlenik_s_najvise_radnog_staza(3);



-- Okidaći 

-- 1. Ažuriranje količine artikala u skladistu nakon izdavanja 
DROP TRIGGER azuriranje_kolicine_artikla_nakon_izdavanja;
DELIMITER //
CREATE TRIGGER azuriranje_kolicine_artikla_nakon_izdavanja
AFTER INSERT ON stavka_izdatnica
FOR EACH ROW
BEGIN
    UPDATE artikli_u_skladistu
    SET kolicina = kolicina - NEW.kolicina
    WHERE ID = NEW.ID_artikli_u_skladistu;
END //
DELIMITER ;
INSERT INTO stavka_izdatnica VALUES (17,5,1,3 );
SELECT * FROM stavka_izdatnica;
SELECT * FROM artikli_u_skladistu;

 
 
 -- 2. Prilikom postavljanja novih računa postavi datum izdavanja na trenutni datum
 DROP TRIGGER dv_racun;
 DELIMITER //
CREATE TRIGGER dv_racun
 BEFORE INSERT ON racun
 FOR EACH ROW
BEGIN
 SET new.datum_izdavanja = NOW();
END//
DELIMITER ;

INSERT INTO racun (ID, ID_zaposlenik, datum_izdavanja, ID_firma) VALUES (34, 12, CURRENT_DATE, 1);
Select * From racun;


-- 3. Zabranjuje da kolicina novoga artikla u skladistu bude manja od 1 te javlja da kolicina mora biti 1 ili vise
DROP TRIGGER negativna_kolicina;
DELIMITER //
CREATE TRIGGER negativna_kolicina
BEFORE INSERT ON artikli_u_skladistu
FOR EACH ROW
BEGIN
    IF NEW.kolicina < 1 THEN
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = 'Količina mora biti 1 ili više';
    END IF;
END //
DELIMITER ;

INSERT INTO artikli_u_skladistu (ID, ID_skladiste, ID_artikl, kolicina) VALUES (21, 1, 1, 0);
INSERT INTO artikli_u_skladistu (ID, ID_skladiste, ID_artikl, kolicina) VALUES (22, 1, 1, 1);
Select* from artikli_u_skladistu;


-- 4. Prije unosa novog racuna provjerava se ID zaposlenika ako ID nepostaji izlazi greška 'Zaposlenik ne postoji'
DROP TRIGGER prije_unosa_racuna;
DELIMITER //
CREATE TRIGGER prije_unosa_racuna
BEFORE INSERT ON racun
FOR EACH ROW
BEGIN
    DECLARE zaposlenik_id INT;

    SELECT COUNT(*) INTO zaposlenik_id
    FROM zaposlenik
    WHERE ID = NEW.ID_zaposlenik;

    IF zaposlenik_id = 0 THEN
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = 'Zaposlenik ne postoji';
    END IF;
END//
DELIMITER ;

INSERT INTO racun (ID, ID_zaposlenik, datum_izdavanja, ID_firma) VALUES (NULL, 100, STR_TO_DATE('01.01.2024.', '%d.%m.%Y.'), 1);


-- 5. Prikaz ukupne cijene racuna u dodatnoj koloni ukupna_cijena
DROP TRIGGER azuriranje_uk_cijene_racuna;
DELIMITER //
CREATE TRIGGER azuriranje_uk_cijene_racuna
BEFORE INSERT ON stavka_racun
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(10, 2);

    SELECT SUM(a.cijena * NEW.kolicina)
    INTO total
    FROM artikl a
    WHERE a.ID = NEW.ID_artikl;

    UPDATE racun
    SET ukupna_cijena = total
    WHERE ID = NEW.ID_racun;
END //
DELIMITER ;

ALTER TABLE racun ADD COLUMN ukupna_cijena DECIMAL(10, 2);
INSERT INTO racun (ID, ID_zaposlenik, datum_izdavanja, ID_firma)
VALUES (11, 1, CURRENT_DATE, 1);

INSERT INTO artikl (ID, cijena, naziv, vrsta_artikla)
VALUES (18, 299.99, 'Pisaći stol', 'Namještaj');

INSERT INTO stavka_racun (ID, ID_racun, ID_artikl, kolicina)
VALUES (11, 11, 18, 3);
SELECT * FROM racun;


-- Procedure

-- 1. procedura koja vraca firmu s kojom se najvise posluje do sada 

DELIMITER //

CREATE PROCEDURE najvaznija_firma(OUT najvise_poslujuca_firma VARCHAR(50))
BEGIN
    SELECT firma.naziv
    INTO najvise_poslujuca_firma
    FROM firma
    JOIN racun ON firma.id = racun.id_firma
    GROUP BY firma.naziv
    ORDER BY COUNT(racun.id) DESC
    LIMIT 1;
END //

DELIMITER ;

CALL najvaznija_firma(@rezultat);
SELECT @rezultat AS 'najvaznija_firma';



 -- 2 procedura prikaz skladista s najvecom kolicinom artikala tako da bismo znali koje skladiste treba izbjegavati puniti artiklima ako je potrebno
DELIMITER //

CREATE PROCEDURE prikaz_najpunijeg_skladista()
BEGIN

    DECLARE skl_naziv VARCHAR(50);


    SELECT naziv INTO skl_naziv
    FROM (
        SELECT s.naziv, SUM(sa.kolicina) AS sveukupna_kolicina
        FROM skladiste s
        JOIN artikli_u_skladistu sa ON s.id = sa.id_skladiste
        GROUP BY s.id
        ORDER BY sveukupna_kolicina DESC
        LIMIT 1
    ) AS skladista;

    SELECT skl_naziv AS naziv_skladista;
END //

DELIMITER ;

CALL prikaz_najpunijeg_skladista();






-- 3. prcoedura pronalazi najvrijednijeg radnika i dodjeljuje mu vip ulogu 
DELIMITER //
CREATE PROCEDURE dodaj_nagradu_zaposleniku(INOUT vip_id INT)
BEGIN
    DECLARE najaktivniji_id INT;
    DECLARE vip_ime VARCHAR(60);

    SELECT id_zaposlenik INTO najaktivniji_id
    FROM (
        SELECT id_zaposlenik, COUNT(*) AS broj_racuna
        FROM racun
        WHERE YEAR(datum_izdavanja) = YEAR(CURRENT_DATE - INTERVAL 1 YEAR)
        GROUP BY id_zaposlenik
        ORDER BY broj_racuna DESC
        LIMIT 1
    ) AS najaktivniji;

    SET vip_id = najaktivniji_id;

    SELECT CONCAT('VIP ', ime) INTO vip_ime
    FROM zaposlenik
    WHERE ID = vip_id;

    UPDATE zaposlenik
    SET ime = vip_ime
    WHERE ID = vip_id;
END //
DELIMITER ;

SET @zaposlenik_id = 0;
CALL dodaj_nagradu_zaposleniku(@zaposlenik_id);
SELECT @zaposlenik_id;

-- 4. provjera odredenog artikla u skladistu
DELIMITER //
CREATE PROCEDURE Provjera_artikala_u_skladistu(IN skladiste_id INT, IN artikl_id INT,OUT naziv_artikla VARCHAR(50), OUT artiklPostoji INT, OUT broj_artikala INT)
BEGIN

    SELECT a.naziv, aus.kolicina INTO naziv_artikla, broj_artikala
    FROM artikl a
    LEFT JOIN artikli_u_skladistu AS aus ON a.id = aus.id_artikl
    WHERE aus.id_skladiste = skladiste_id AND aus.id_artikl = artikl_id;


    IF broj_artikala > 0 THEN
        SET artiklPostoji = 1;
    ELSE
        SET artiklPostoji = 0 ;
    END IF;
END //

DELIMITER ;

CALL Provjera_artikala_u_skladistu(1, 10,@naziv_artikala ,@artiklPostoji, @broj_artikala);
SELECT @naziv_artikala AS NazivArtikla ,@artiklPostoji AS ArtiklPostoji,  @broj_artikala AS Kolicina;

-- 5 najcesce koristeno skladiste da vidimo u koje treba najbolja kvaliteta ljudi radi najvise posla

DROP PROCEDURE IF EXISTS NajcesceKoristenoSkladiste;

DELIMITER //

CREATE PROCEDURE NajcesceKoristenoSkladiste ()
BEGIN
  SELECT
    s.ID AS ID_skladista,
    s.naziv AS Naziv_skladista,
    COUNT(i.ID) AS Broj_izdatnica
  FROM
    skladiste s
    LEFT JOIN zaposlenik z ON s.ID = z.ID_skladiste
    LEFT JOIN izdatnica i ON z.ID = i.ID_zaposlenik
  GROUP BY
    s.ID
  ORDER BY
    Broj_izdatnica DESC
  LIMIT 1;
END //

DELIMITER ;

CALL NajcesceKoristenoSkladiste();


-- 6. salje iste artikle u odredena skladista
DELIMITER //
CREATE PROCEDURE prijenos_artikala(IN p_id_artikl INT, IN p_id_odrediste INT)
BEGIN

    UPDATE artikli_u_skladistu AS a
    JOIN skladiste AS s ON a.id_skladiste = s.id
    SET a.id_skladiste = p_id_odrediste
    WHERE a.id_artikl = p_id_artikl AND s.id != p_id_odrediste;
END //
DELIMITER ;

CALL prijenos_artikala(1, 1);
SELECT * FROM artikli_u_skladistu WHERE id_skladiste = 1;

-- 7. zbraja odredene iste artikle tako da se sve svrstava pod jedno
DELIMITER //
CREATE PROCEDURE spoji_artikle(p_id_skladiste INT)
BEGIN

    UPDATE artikli_u_skladistu AS a1
    JOIN (
        SELECT id_artikl,id_skladiste, SUM(kolicina) AS ukupna_kolicina
        FROM artikli_u_skladistu
        WHERE id_skladiste = p_id_skladiste
        GROUP BY id_artikl, id_skladiste)
        AS a2 ON a1.id_artikl = a2.id_artikl AND a1.id_skladiste = a2.id_skladiste
    SET a1.kolicina = a2.ukupna_kolicina
    WHERE a1.id_artikl IS NOT NULL AND a1.id_skladiste IS NOT NULL AND a1.id_skladiste = p_id_skladiste;

    DELETE a1 FROM artikli_u_skladistu a1
    INNER JOIN artikli_u_skladistu a2
    WHERE a1.id_artikl = a2.id_artikl AND a1.id_skladiste = a2.id_skladiste AND a1.id< a2.ID AND a1.id_skladiste = p_id_skladiste;
END //
DELIMITER ;


CALL spoji_artikle(1);

SELECT aus.ID, aus.ID_skladiste, s.naziv AS skladiste, aus.ID_artikl, a.naziv AS artikl, aus.kolicina
FROM artikli_u_skladistu aus
JOIN skladiste s ON aus.ID_skladiste = s.ID
JOIN artikl a ON aus.ID_artikl = a.ID
WHERE aus.ID_skladiste = 1;

-- 8 popust od 20% na sve proizvode  koji se nikada nisu prodali

DELIMITER //
CREATE PROCEDURE popust_ne_prodani()
BEGIN
    UPDATE artikl
    SET cijena = cijena * 0.8
    WHERE id NOT IN (SELECT DISTINCT id_artikl FROM stavka_racun);
END //
DELIMITER ;

CALL popust_ne_prodani();
SELECT * FROM artikl;


-- 9 provjerava da li je dovoljno zaposlenika u odredenim skladistima

DROP PROCEDURE IF EXISTS provjeri_radnike;

DELIMITER //

CREATE PROCEDURE provjeri_radnike (IN p_id_skladiste INT)
BEGIN
  DECLARE broj_radnika INT;

  -- Provjeri broj radnika u određenom skladištu
  SELECT COUNT(*) INTO broj_radnika
  FROM zaposlenik
  WHERE id_skladiste = p_id_skladiste;

  -- Ako ima manje od 5 radnika, generiraj grešku
  IF broj_radnika < 5 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Skladište ima manje od 5 radnika, potrebno je dodati radnike';
  -- Ako ima više od 10 radnika, generiraj grešku
  ELSEIF broj_radnika > 10 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Skladište ima više od 10 radnika, previše radnika u skladištu';
  END IF;
END //

DELIMITER ;

CALL provjeri_radnike(5);


-- 10  procedura koja prebacuje zaposlenike u druga skladista ovisno o potrebama firme
DROP PROCEDURE IF EXISTS promjeni_radno_mjesto;


DELIMITER //
CREATE PROCEDURE promjeni_radno_mjesto (
  IN p_id_zaposlenik INT,
  IN p_novo_skladiste INT
)
BEGIN
  -- Provjeri postoji li zaposlenik s zadanim ID-om
  IF NOT EXISTS (SELECT 1 FROM zaposlenik WHERE ID = p_id_zaposlenik) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Zaposlenik s zadanim ID-om ne postoji';

  END IF;

  -- Provjeri postoji li skladište s zadanim ID-om
  IF NOT EXISTS (SELECT 1 FROM skladiste WHERE ID = p_novo_skladiste) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Skladište s zadanim ID-om ne postoji';

  END IF;

  -- Ažuriraj skladište zaposlenika
  UPDATE zaposlenik
  SET ID_skladiste = p_novo_skladiste
  WHERE ID = p_id_zaposlenik;
END //

DELIMITER ;

CALL promjeni_radno_mjesto(1, 3);

select* from zaposlenik;


-- Pogledi

-- 1. pogled koji vraća artikl koji je prodan u najvećoj količini
CREATE VIEW najprodavaniji_artikl AS
SELECT a.naziv AS artikl, SUM(sr.kolicina) AS ukupno_prodano
FROM artikl a
JOIN stavka_racun sr ON a.ID = sr.ID_artikl
GROUP BY a.ID
ORDER BY ukupno_prodano DESC
LIMIT 1;

SELECT * FROM najprodavaniji_artikl;


-- 2. pogled za praćenje narudžbi i njihovog statusa dostave
CREATE VIEW pregled_narudzbi AS
SELECT r.ID, r.datum_izdavanja, z.ime AS zaposlenik, k.ime AS kupac, iz.datum_dostavljanja, iz.vrijeme_dostavljanja
FROM racun r
JOIN zaposlenik z ON r.ID_zaposlenik = z.ID
JOIN stavka_racun sr ON r.ID = sr.ID_racun
JOIN artikl a ON sr.ID_artikl = a.ID
JOIN izdatnica iz ON r.ID = iz.ID
JOIN kupac k ON iz.ID = k.ID;

SELECT * FROM pregled_narudzbi;

/*
Privremene tablice - test

CREATE TEMPORARY TABLE temp_racun AS SELECT * FROM racun;
INSERT INTO temp_racun (ID, ID_zaposlenik, datum_izdavanja, ID_firma) VALUES
(1, 101, '2024-01-01', 201),
(2, 102, '2024-01-02', 202),
(3, 103, '2024-01-03', 203),
(4, 104, '2024-01-04', 204),
(5, 105, '2024-01-05', 205),
(6, 106, '2024-01-06', 206),
(7, 107, '2024-01-07', 207),
(8, 108, '2024-01-08', 208),
(9, 109, '2024-01-09', 209),
(10, 110, '2024-01-10', 210);

SELECT * FROM temp_racun;


CREATE TEMPORARY TABLE temp_zaposlenik AS SELECT * FROM zaposlenik LIMIT 0;
INSERT INTO temp_zaposlenik (ID, ime, prezime, OIB, datum_zaposlenja, ID_skladiste, ID_vrsta_posla) VALUES
(101, 'Antonieta', 'Suzanić', '12345678901', '2023-01-01', 301, 401),
(102, 'Vladimir', 'Grego', '23456789012', '2023-02-01', 302, 402),
(103, 'Norma', 'Gašparec', '34567890123', '2023-03-01', 303, 403),
(104, 'Cvita', 'Kostelac', '45678901234', '2023-04-01', 304, 404),
(105, 'Boris', 'GLADINA', '56789012345', '2023-05-01', 305, 405),
(106, 'Eva', 'Miller', '67890123456', '2023-06-01', 306, 406),
(107, 'David', 'Horvat', '78901234567', '2023-07-01', 307, 407),
(108, 'Stjepan', 'Kovačević', '89012345678', '2023-08-01', 308, 408),
(109, 'Vedran', 'Rogan', '90123456789', '2023-09-01', 309, 409),
(110, 'Zoran', 'Marković', '01234567890', '2023-10-01', 310, 410);

SELECT * FROM temp_zaposlenik;

CREATE TEMPORARY TABLE temp_stavka_racun AS SELECT * FROM stavka_racun LIMIT 0;
INSERT INTO temp_stavka_racun (ID, ID_racun, ID_artikl, kolicina) VALUES
(1, 1, 501, 5),
(2, 1, 502, 3),
(3, 2, 503, 2),
(4, 3, 504, 1),
(5, 4, 505, 4),
(6, 4, 506, 2),
(7, 5, 507, 3),
(8, 6, 508, 1),
(9, 7, 509, 2),
(10, 8, 510, 3);


CREATE TEMPORARY TABLE temp_artikl AS SELECT * FROM artikl LIMIT 0;
INSERT INTO temp_artikl (ID, cijena, naziv, vrsta_artikla) VALUES
(501, 20.50, 'Artikl1', 'Elektronika'),
(502, 15.75, 'Artikl2', 'Odjeća'),
(503, 30.00, 'Artikl3', 'Hrana'),
(504, 12.99, 'Artikl4', 'Knjige'),
(505, 25.00, 'Artikl5', 'Igračke'),
(506, 18.50, 'Artikl6', 'Sport'),
(507, 22.75, 'Artikl7', 'Kozmetika'),
(508, 10.99, 'Artikl8', 'Alati'),
(509, 16.50, 'Artikl9', 'Namještaj'),
(510, 28.75, 'Artikl10', 'Elektronika');


CREATE TEMPORARY TABLE temp_izdatnica AS SELECT * FROM izdatnica LIMIT 0;
INSERT INTO temp_izdatnica (ID, datum_dostavljanja, vrijeme_dostavljanja, ID_zaposlenik, ID_kupac) VALUES
(1, '2024-01-05', '14:30:00', 101, 601),
(2, '2024-01-06', '15:45:00', 102, 602),
(3, '2024-01-07', '16:30:00', 103, 603),
(4, '2024-01-08', '17:15:00', 104, 604),
-- (5, '2024-01-09', '18:00:00', 105, 605),
(6, '2024-01-10', '19:30:00', 106, 606),
(7, '2024-01-11', '20:45:00', 107, 607),
(8, '2024-01-12', '21:30:00', 108, 608),
(9, '2024-01-13', '22:15:00', 109, 609);
-- (10, '2024-01-14', '23:00:00', 110, 610);

SELECT * FROM temp_izdatnica;


CREATE TEMPORARY TABLE temp_kupac AS SELECT * FROM kupac LIMIT 0;
INSERT INTO temp_kupac (ID, ime, prezime, ID_adresa, telefon) VALUES
(601, 'Kupac1', 'Prezime1', 701, '123-456-7890'),
(602, 'Kupac2', 'Prezime2', 702, '987-654-3210'),
(603, 'Kupac3', 'Prezime3', 703, '555-123-4567'),
(604, 'Kupac4', 'Prezime4', 704, '111-222-3333'),
(605, 'Kupac5', 'Prezime5', 705, '444-555-6666'),
(606, 'Kupac6', 'Prezime6', 706, '777-888-9999'),
(607, 'Kupac7', 'Prezime7', 707, '999-000-1111'),
(608, 'Kupac8', 'Prezime8', 708, '222-333-4444'),
(609, 'Kupac9', 'Prezime9', 709, '666-777-8888'),
(610, 'Kupac10', 'Prezime10', 710, '000-111-2222');


SELECT DISTINCT temp_racun.ID, temp_racun.datum_izdavanja, temp_zaposlenik.ime AS zaposlenik, temp_kupac.ime AS kupac, temp_izdatnica.datum_dostavljanja, temp_izdatnica.vrijeme_dostavljanja
FROM temp_racun
JOIN temp_zaposlenik ON temp_racun.ID_zaposlenik = temp_zaposlenik.ID
JOIN temp_izdatnica ON temp_racun.ID = temp_izdatnica.ID
JOIN temp_kupac ON temp_izdatnica.ID_kupac = temp_kupac.ID;
*/


-- 3. pogled koji će prikazati sve artikle koji se trenutno nalaze na skladištu i čija je količina manja od prosječne količine za sve artikle na skladištu.
DROP VIEW artikli_za_dobavu;
CREATE VIEW artikli_za_dobavu AS
SELECT a.naziv AS artikl, a.vrsta_artikla, aus.kolicina AS kolicina_na_skladistu, AVG(aus.kolicina) AS prosjecna_kolicina
FROM artikl a
JOIN artikli_u_skladistu aus ON a.ID = aus.ID_artikl
GROUP BY a.ID
HAVING aus.kolicina < AVG(aus.kolicina);

SELECT * FROM artikli_za_dobavu;


-- 4. pregled dostupnih proizvoda u određenom skladištu
CREATE VIEW pregled_dostupnih_proizvoda AS
SELECT aus.ID_skladiste, a.ID AS ID_artikl, a.naziv AS artikl, COALESCE(aus.kolicina, 0) AS dostupna_kolicina
FROM skladiste s
LEFT JOIN artikli_u_skladistu aus ON s.ID = aus.ID_skladiste
LEFT JOIN artikl a ON aus.ID_artikl = a.ID;

SELECT * FROM pregled_dostupnih_proizvoda WHERE ID_skladiste = 5;


-- 5. pregled zarade u godini po kvartalima
CREATE VIEW zarada_po_kvartalima AS
SELECT YEAR(r.datum_izdavanja) AS godina,
    CASE
        WHEN MONTH(r.datum_izdavanja) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(r.datum_izdavanja) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(r.datum_izdavanja) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(r.datum_izdavanja) BETWEEN 10 AND 12 THEN 'Q4'
    END AS kvartal,
    SUM(sr.kolicina * a.cijena) AS prihod
FROM racun r
JOIN stavka_racun sr ON r.ID = sr.ID_racun
JOIN artikl a ON sr.ID_artikl = a.ID
GROUP BY YEAR(r.datum_izdavanja), kvartal;

SELECT * FROM zarada_po_kvartalima WHERE godina = 2021;
