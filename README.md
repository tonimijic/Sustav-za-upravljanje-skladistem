Sveučilište Jurja Dobrile u Puli
Fakultet informatike u Puli

Dokumentacija
Sustav za upravljanje skladištem

Tim - 4
**Izradili**: Atila Astaloš, Ivan Maurović, Toni Mijić, Mateo Smoljan, Robert Vidaković
**Kolegij**: Baze podataka 2
**Mentor**: doc.dr.sc Goran Oreški

--- 

## Uvod
Za projekt iz kolegija Baze podataka 2, pod mentorstvom doc.dr.sc. Gorana Oreškog, izradili smo bazu podataka za skladište. Osnova ovoga rada je utemeljena na sustavu za upravljanje skladištem. 

U procesu stvaranja baza podataka, prvo smo definirali potrebne tablice koje će čuvati ključne informacije o proizvodima, skladištima, dobavljačima i ostalim relevantnim entitetima. Svaka tablica je dizajnirana kako bi odražavala specifičnosti skladišnog sustava i omogućila optimalno pohranjivanje podataka.

Posvetili smo se potrebi za praćenjem inventara i zaliha unutar skladišta. Shvatili smo da to ne samo da olakšava praćenje količina proizvoda, već pomaže u sprječavanju prekomjerne potrošnje ili potrebi za nepotrebnim narudžbama. 

--- 

## Ivan Maurović

## ER dijagram

<img src="https://cdn.discordapp.com/attachments/1190245422741061764/1196412358332010557/ERD_baze_2.png"/>

**EER dijagram**

<img src="https://cdn.discordapp.com/attachments/1164449330988580864/1196141423733510196/EER_diagram_-_skladiste.png"/>

**Opis dijagrama**

Skup entiteta **firma** povezan je s skupom entiteta **adresa** više naprema jedan, jer možemo imati da na jednoj **adresi** bude više **firma**, dok svaka **firma** može biti stacionirat na samo jednoj **adresi**.

Skup entiteta **adresa** povezan je s skupom entiteta **država** više naprema jedan, jer možemo imati da u jednoj **državi** se nalazimo na više **adresa**, dok **adresa** može biti samo u jednoj **državi**.

Skup entiteta **račun** povezan je s skupom entiteta **firma** više naprema jedan, jer **firma**  može izdati  više **računa**, dok **račun** može biti izdan samo u jednoj **firmi**.

Skup entiteta **račun** povezan je s skupom entiteta **zaposlenik** više naprema jedan, jer možemo imati da  **zaposlenik** izdaje više **računa**, dok jedan **račun** može biti izdati samo od jednog **zaposlenika**.

Skup entiteta **zaposlenik** povezan je s skupom entiteta **skladište** više naprema jedan, jer možemo imati da u jednom **skladištu** radi više **zaposlenika**, dok **zaposlenik** može raditi samo u jednom **skladištu**.

Skup entiteta **zaposlenik** povezan je s skupom entiteta **vrsta_posla** više naprema jedan, jer jednu **vrsta_posla** može raditi više **zaposlenika**, dok **zaposlenik** može raditi najviše jednu **vrstu_posla**.

Skup entiteta **izdatnica** povezan je s skupom entiteta **zaposlenik** više naprema jedan, jer možemo imati da jedan **zaposlenik** izdaje više **izdatnica**, dok **izdatnica** može biti izdana od samo jednog **zaposlnika**.

Skup entiteta **izdatnica** povezan je s skupom entiteta **kupac** više naprema jedan, jer možemo imati da jedan **kupac** kreira više **izdatnica**, dok **izdatnica** može biti kreirana od samo u jednog **kupca**.

Skup entiteta **kupac** povezan je s skupom entiteta **adresa** više naprema jedan, jer možemo imati da na jednoj **adresi** se nalazi više **kupaca**, dok **kupac** može biti samo prijavljen na jednoj **adresi**.

Skup entiteta **povratno** povezan je s skupom entiteta **izdatnica** više naprema jedan, jer na jednoj **izdatnici** možemo imati više **povrata**, dok **povrat* može biti najviše na jednoj **izdatnici**.

Skup entiteta **povratno** povezan je s skupom entiteta **dobavljac** više naprema jedan, jer možemo imati da jedan **dobavljac** ima više **povrata**, dok **povrat** može biti samo kod jednog **dobavljača**.

Skup entiteta **skladište** povezan je s skupom entiteta **firma** jedan naprema više, jer možemo imati da jedna **firma** posjeduje više **skladišta**, dok **skladište** može biti u posjedu najviše jedne **firme**.

Skup entiteta **skladište** povezan je s skupom entiteta **adresa** više naprema jedan, jer možemo na jednoj **adresi** posjedovati više **skladišta**, dok **skladište** može biti najviše na jednoj **adresi**.

Veza s atributom **artikli_u_skladištu** povezan je s skupom entiteta **skladište** više naprema više, jer **skladište** može sadržati više vrsta **artikala_u_skladištu**, dok **artikl_u_skladištu** može biti u više **skladišta** ne treba biti samo u jednom.

Veza s atributom **artikli_u_skldaištu** povezan je s skupom entiteta **artikl** više naprema više, jer možemo imati jednu vrstu **artikla** u više **artikla_u_skladišta**, dok **artikl_u_skladištu** može biti više **artikla**.

Skup entiteta **artikla** povezan je s skupom entiteta **racun** više naprema jedan, jer možemo imati na jednom **racunu**  više **artikala**, dok **artikl** može biti samo na jednom **racunu** Iz ovog odnosa više na jedan dolazimo do stvaranja nove tablice **stavka_racun**. Iz ovog odnosa možemo izvući količinu pojedinog **artikla** na svakom **racunu**.

Veza s atributom **stavka_izdatnice** povezan je s skupom entiteta **izdatnica** više naprema jedan, jer **izdatnica** može imati više **stavaka_izdatnice**, dok **stavka_izdatnice** može biti najviše na jednoj **izdatnica**.

Veza s atributom **stavka_izdatnice** povezan je s veza s atributom **artikli_u_skladištu** jedan naprema jedan, jer možemo imati jednu vrstu  **artikla_u_skladistu** na jednoj **stavci_izdatnice**, dok **stavka_izdatnice** može sadržati najviše jedan **artikl_u_skladištu**.


## Okidaći

**1. Ažuriranje količine artikala u skladištu nakon izdavanja**

Nakon novoga izdavanja dolazi do ažuriranja podataka u tablici artikli_u_skladištu korištenjem UPDATE argumenta te dolazi do oduzima broja koliko je izdano od broja artikala koji su u skladištu.

```mysql
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
```

**2. Prilikom postavljanja novih računa postavi datum izdavanja na trenutni datum**

Prilikom unosa novoga računa naredbom INSERT automatski se datum izdavanja računa  postavlja na trenutni datum (NOW()).

```mysql
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
```
**3. Zabranjuje da količina novoga artikla u skladištu bude manja od 1 te javlja da količina mora biti 1 ili vise**

Kada želimo dodavati novi artikl u skladište naredbom INSERT ako nam količina toga artikla nije 1 ili više dolazi do zabrane unosa tog artikla te nam javlja grešku 'Količina mora biti 1 ili više', a ako je količina 1 ili više onda dozvoljava unos novoga artikla ü skladište.

```mysql
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
```

**4. Prije unosa novog računa provjerava se ID zaposlenika ako ID ne postaji izlazi greška 'Zaposlenik ne postoji'**

Kod unosa novoga računa naredbom INSERT dolazi do provjeri ID_zaposlenika  te ako taj ID ne postoji onda nije moguć unos tog računa te izbacuje se greška 'Zaposlenik ne postoji' , a ako zaposlenik postoji novi se račun unosi.

```mysql
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
```

**5. Prikaz ukupne cijene računa u dodatnoj koloni ukupna_cijena**

Prilikom unosa novih stavaka računa izračunava se ukupna cijena umnoškom cijene i količine iz tablice artikl te se onda ukupna cijena ažurira u tablici račun. U tablici račun dodan je atribut ukupna_cijena tipa DECIMAL (10,2) pomoću ALTER TABLE račun tako da kada želimo prikazati tablicu račun imamo dodatni stupac u kojemu piše ukupna_cijena.

```mysql
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
```

## Toni Mijić
## Tablice

**Relacija drzava**:
sve drzave koje se koriste za skladiste

- id podataka tipa integer,primarni kljuc
- skracenica podatak tipa char limitiran na 3 znaka
- naziv podatak tipa varchar limitiran na 20 znakova
- glavni_grad podatak tipa varchar limitiran na 30 znakova

```mysql
CREATE TABLE drzava(
id INTEGER NOT NULL,
skracenica CHAR(3) NOT NULL,
naziv VARCHAR(20) NOT NULL,
glavni_grad VARCHAR(30) NOT NULL,
PRIMARY KEY(id)
);
Drop table drzava;
```

**Relacija adresa**:
prikazuje adrese koje se koriste za skladiste

- primarni kljuc je id tipa integer
- id_drzava tipa integer referencira se na drzava(id) kao FOREIGN KEY
- naziv,grad su tipa varchar
- postanski_broj tipa integer i ima check koji provjerava da broj ne ide u nedogled vec do 100 000

```mysql
CREATE TABLE adresa(
ID INTEGER NOT NULL,
naziv VARCHAR(50) NOT NULL,
id_drzava INTEGER NOT NULL, 
grad VARCHAR(30) NOT NULL,
postanski_broj INT NOT NULL CHECK (postanski_broj<100000), 
PRIMARY KEY (ID),
FOREIGN KEY (id_drzava) REFERENCES drzava(id)
);
Drop table adresa;
```

**Relacija vrsta_posla**:
Vrste posla u skladistima

- primarni kljuc je id tipa integer
- naziv,duznost,radno_vrijeme ,opis su sve tipa varchar

```mysql
CREATE TABLE vrsta_posla(
ID INTEGER NOT NULL,
naziv VARCHAR(20) NOT NULL,
duznost VARCHAR(50) NOT NULL,
radno_vrijeme VARCHAR(50) NOT NULL,
opis VARCHAR(100) NOT NULL,
PRIMARY KEY (ID)
);
Drop table vrsta_posla;
```

**Relacija firma**:
sve firme koje rade sa skladistem tj. dostavljaju u skladiste

- primarni kljuc je id tipa integer
- oib je tipa char limitiran na 11 te smo napravili check koji provjerava da li je duzina oiba 11 
- id_adresa tipa integer referencira se na adresa(id) kao FOREIGN KEY

```mysql
CREATE TABLE firma(
ID INTEGER NOT NULL,
naziv VARCHAR(50) NOT NULL,
OIB CHAR(11) NOT NULL UNIQUE, 
ID_adresa INT, 
PRIMARY KEY (ID),
check (length(oib) = 11),
FOREIGN KEY  (id_adresa) REFERENCES adresa (id)
);
Drop table firma;
```
**Relacija skladiste**:
lokacija i detalji svakog zasebnog skladista

- id_firma tipa integer referencira se na firma(id) kao FOREIGN KEY
- id_adresa tipa integer referencira se na adresa(id) kao FOREIGN KEY
- primarni kljuc je id tipa integer
- naziv je tipa varchar


```mysql
CREATE TABLE skladiste(
ID INTEGER NOT NULL,
ID_firma INT NOT NULL, 
naziv VARCHAR(20) NOT NULL,
ID_adresa INT NOT NULL, 
PRIMARY KEY (ID),
FOREIGN KEY (id_firma) REFERENCES firma(id),
FOREIGN KEY  (id_adresa) REFERENCES adresa (id)
);
Drop table skladiste;
```

**Relacija zaposlenik**:
prikazuje detalje o zaposlenicima

- primarni kljuc je id tipa integer
- oib je unique i limitiran na 11 znakova te ima isti check da provjerava da je duzina oiba 11 
- datum_zaposlenja je tipa datum
- id_skladiste tipa integer referencira se na skladiste(id) kao FOREIGN KEY
- id_vrsta_posla tipa integer referencira se na vrsta_posla(id) kao FOREIGN KEY

```mysql
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
Drop table zaposlenik;
```

**Relacija racun**:
prikaz racuna izdanih sa odredenom firmom

- primarni kljuc je id tipa integer
- id_zaposlenik tipa integer referencira se na zaposlenik(id) kao FOREIGN KEY
- id_firma tipa integer referencira se na firma(id) kao FOREIGN KEY

```mysql
CREATE TABLE racun(
ID INTEGER NOT NULL,
ID_zaposlenik INT , 
datum_izdavanja DATE NOT NULL, 
ID_firma INT, 
PRIMARY KEY (ID),
FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
FOREIGN KEY (id_firma) REFERENCES firma(id)
);
Drop table racun;
```

**Relacija artikl**:
detalji artikala

- primarni kljuc je id tipa integer
- cijena je decimal i ima check koji provjerava da cijena ne prelazi 5000 i da ne ide ispod nule

```mysql
CREATE TABLE artikl(
ID INTEGER NOT NULL,
cijena DECIMAL(10,2) NOT NULL, 
naziv VARCHAR(20) NOT NULL,
vrsta_artikla VARCHAR(30) NOT NULL, 
PRIMARY KEY (ID),
check (cijena < 5000 AND cijena >= 0 )
);
Drop table artikl;
```
**Relacija stavka_racun**:
prikaz artikala koji su bili na racun

- primarni kljuc je id tipa integer
- id_racun tipa integer referencira se na racun(id) kao FOREIGN KEY
- id_artikl tipa integer referencira se na artikl(id) kao FOREIGN KEY
- kolicina tipa integer i ima check koji provjerava da kolicina ne prelazi 50 i da ne ide ispod nule

 ```mysql
CREATE TABLE stavka_racun(
ID INTEGER NOT NULL,
ID_racun INT , 
ID_artikl INT , 
kolicina INT NOT NULL CHECK (kolicina < 50 AND kolicina >= 0), 
PRIMARY KEY (ID),
FOREIGN KEY (id_racun) REFERENCES racun(id) ON DELETE CASCADE,
FOREIGN KEY (id_artikl) REFERENCES artikl(id)
);
Drop table stavka_racun;
```

**Relacija artikli_u_skladistu**:
svi artikli koji dolaze se nalaze na ovom popisu

- primarni kljuc je id tipa integer
- id_skladiste tipa integer referencira se na skladiste(id) kao FOREIGN KEY
- id_artikl tipa integer referencira se na artikl(id) kao FOREIGN KEY
- kolicina tipa integer i ima check koji provjerava da kolicina ne prelazi 1000 i da ne ide ispod nule

 ```mysql
CREATE TABLE artikli_u_skladistu(
ID INTEGER NOT NULL,
ID_skladiste INT , 
ID_artikl INT ,
kolicina INT CHECK (kolicina < 1000 AND kolicina >= 0), 
PRIMARY KEY (ID),
FOREIGN KEY (id_skladiste) REFERENCES skladiste(id),
FOREIGN KEY (id_artikl) REFERENCES artikl(id)
);
Drop table artikli_u_skladistu;
 ```

**Relacija kupac**:
detalji o kupcu

- ime,prezime,telefon tipa varchar
- primarni kljuc je id tipa integer
- id_adresa tipa integer referencira se na adresa(id) kao FOREIGN KEY

 ```mysql
CREATE TABLE kupac(
ID INTEGER NOT NULL,
ime VARCHAR(40),
prezime VARCHAR(40),
ID_adresa INTEGER,
telefon VARCHAR(20),
PRIMARY KEY (ID),
FOREIGN KEY (id_adresa) REFERENCES adresa(id)
);
Drop table kupac;
 ```
**Relacija izdatnica**:
racun koji prikazuje kupca i sta je kupljeno

- primarni kljuc je id tipa integer
- datum i vrijeme dostavljanja su tipa date time
- id_zaposlenik tipa integer referencira se na zaposlenik(id) kao FOREIGN KEY
- id_kupac tipa integer referencira se na kupac(id) kao FOREIGN KEY

 ```mysql
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
Drop table izdatnica;
 ```
**Relacija stavka_izdatnica**:
artikli koji se nalaze na izdatnici

- primarni kljuc je id tipa integer
- id_izdatnica tipa integer referencira se na izdatnica(id) kao FOREIGN KEY
- id_artikli_u_skladistu tipa integer referencira se na artikli_u_skladistu(id) kao FOREIGN KEY
- kolicina tipa integer i ima check koji provjerava da kolicina ne prelazi 25 i da ne ide ispod nule

```mysql
CREATE TABLE stavka_izdatnica(
ID INTEGER NOT NULL,
ID_izdatnica INTEGER ,
ID_artikli_u_skladistu INTEGER, 
kolicina INTEGER CHECK (kolicina < 25 AND kolicina >= 0), 
PRIMARY KEY (ID),
FOREIGN KEY (id_izdatnica) REFERENCES izdatnica(id),
FOREIGN KEY (id_artikli_u_skladistu) REFERENCES artikli_u_skladistu(id)
);
Drop table stavka_izdatnica
```

**Relacija dobavljac**:
bavi se izdatnicom

- primarni kljuc je id tipa integer
- id_zaposlenik tipa integer referencira se na zaposlenik(id) kao FOREIGN KEY
- godine iskustva tipa integer i ima check koji provjerava da nema vise od 25 godina iskustva

```mysql
CREATE TABLE dobavljac(
ID INTEGER NOT NULL,
ID_zaposlenik INT,
vozacka VARCHAR(5),
godine_iskustva INTEGER CHECK (godine_iskustva < 25 ),
PRIMARY KEY (ID),
FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id)
);
Drop table dobavljac;
```
**Relacija povratno**:
sve izdatnice koje nisu iz prve dostavljene

- primarni kljuc je id tipa integer
- id_dobavljac tipa integer referencira se na dobavljac(id) kao FOREIGN KEY
- id_izdatnica tipa integer referencira se na izdatnica(id) kao FOREIGN KEY

```mysql
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
Drop table povratno;
```


## Mateo Smoljan

## Upiti


#### Upit u MySQLu predstavlja strukturiranu naredbu koja se koristi za dohvaćanje, ažuriranje, unos ili brisanje podataka iz baze podataka, koristeći SQL jezik.

1. Upit daje informacije o prosječnom stažu zaposlenika, broju zaposlenika te ukupnom broju izdanih računa po firmama, uzimajući u obzir samo zaposlenike koji su se zaposlili prije 2022. godine.
```sql
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
```
2. Upit dohvaća državu s najvišom ukupnom vrijednošću izdanih računa.
```sql
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
```

3. Dohvatća artikle čija je količina manja od prosječne količine po skladistu
```sql
SELECT a.*, au.kolicina, s.naziv AS naziv_skladista
FROM artikl a
JOIN artikli_u_skladistu au ON a.ID = au.ID_artikl
JOIN skladiste s ON au.ID_skladiste = s.ID
WHERE au.kolicina < (SELECT AVG(kolicina) FROM artikli_u_skladistu)
ORDER BY s.naziv, a.naziv;
```

4. Pronađi dobavljača s najdužim radnim stažem te najviše povratnih informacija

```sql
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
```

5. Prikazi sve firme koje imaju više od jednog skladišta, zajedno s brojem skladišta koje posjeduju

```sql
SELECT firma.naziv AS naziv_firme,
       COUNT(DISTINCT skladiste.ID) AS broj_skladista
FROM firma
JOIN skladiste ON firma.ID = skladiste.ID_firma
GROUP BY firma.ID
HAVING broj_skladista > 1;
```

6. Prikaži sve dostave koje je obavio određeni dostavljač

```sql
SELECT
    i.ID AS Dostava_ID,
    i.datum_dostavljanja AS Datum_Dostave,
    i.vrijeme_dostavljanja AS Vrijeme_Dostave,
    z.ime AS Dostavljac_Ime,
    z.prezime AS Dostavljac_Prezime,
    k.ime AS Kupac_Ime,
    k.prezime AS Kupac_Prezime,
    a.grad AS Adresa_Grad,
    a.postanski_broj AS Adresa_Postanski_Broj,
    p.razlog_povratka AS Razlog_Povratka
FROM
    izdatnica i
JOIN
    zaposlenik z ON i.ID_zaposlenik = z.ID
JOIN
    stavka_izdatnica si ON i.ID = si.ID_izdatnica
JOIN
    kupac k ON i.ID_kupac = k.ID
JOIN
    adresa a ON k.ID_adresa = a.ID
LEFT JOIN
    povratno p ON i.ID = p.id_izdatnica
WHERE
    i.ID_zaposlenik = 11;
```


7. Pronađi sve pakete koji su dostavljeni s razlogom povratka

```sql
SELECT i.*, povratno.razlog_povratka
FROM izdatnica i
JOIN zaposlenik z ON i.ID_zaposlenik = z.ID
JOIN povratno ON i.ID = povratno.id_izdatnica;
```

8. Vrsta posla i ukupan broj zaposlenika koji obavljaju tu vrstu posla

```sql
SELECT vrsta_posla.naziv AS vrsta_posla,
       COUNT(zaposlenik.ID) AS ukupan_broj_zaposlenika
FROM vrsta_posla
LEFT JOIN zaposlenik ON vrsta_posla.ID = zaposlenik.ID_vrsta_posla
GROUP BY vrsta_posla.ID;
```

9. Informacije o zaposlenicima koji su bili uključeni u izdavanje robe za firmu koja je imala povratnu informaciju o nekoj robi

```sql
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
```

10. Izračunaj ukupnu vrijednost artikala

```sql
SELECT SUM(cijena * kolicina) AS ukupna_vrijednost
FROM stavka_racun
JOIN artikl ON stavka_racun.ID_artikl = artikl.ID;
```

11. Prikaži sve dostavljače i broj dostava koje su obavili

```sql
SELECT
    z.ID AS dostavljac_id,
    z.ime AS ime_dostavljaca,
    z.prezime AS prezime_dostavljaca,
    COUNT(i.ID) AS broj_dostava
FROM zaposlenik z
JOIN izdatnica i ON z.ID = i.ID_zaposlenik
GROUP BY dostavljac_id;
```

12. Dohvati informacije o stavkama izdatnica, uključujući naziv artikla, količinu, datum i vrijeme dostavljanja, ime i prezime zaposlenika. Podaci su sortirani prema datumu i vremenu dostavljanja u silaznom redoslijedu

```sql
SELECT si.ID AS 'ID_Stavke', a.naziv AS 'Naziv_Artikla', si.kolicina AS 'Količina', iz.datum_dostavljanja AS 'Datum_Dostavljanja', iz.vrijeme_dostavljanja AS 'Vrijeme_Dostavljanja', z.ime AS 'Ime_Zaposlenika', z.prezime AS 'Prezime_Zaposlenika'
FROM stavka_izdatnica si
JOIN artikli_u_skladistu aus ON si.ID_artikli_u_skladistu = aus.ID
JOIN izdatnica iz ON si.ID_izdatnica = iz.ID
JOIN artikl a ON aus.ID_artikl = a.ID
JOIN zaposlenik z ON iz.ID_zaposlenik = z.ID
ORDER BY iz.datum_dostavljanja DESC, iz.vrijeme_dostavljanja DESC;
```

13. Prikaži sve razloge povratka koji se odnose na određenog dostavljača

```sql
SELECT
    p.ID AS povrat_id,
    i.ID_zaposlenik AS dostavljac_id,
    z.ime AS ime_dostavljaca,
    z.prezime AS prezime_dostavljaca,
    p.razlog_povratka,
    p.datum_ponovnog_dostavljanja
FROM povratno p
JOIN izdatnica i ON p.id_izdatnica = i.ID
JOIN zaposlenik z ON i.ID_zaposlenik = z.ID;
```

14. Izlistaj sve adrese koje imaju više od jednog skladišta

```sql
SELECT a.*, COUNT(s.ID) AS Broj_skladišta
FROM adresa a
JOIN skladiste s ON a.ID = s.ID_adresa
GROUP BY a.ID
HAVING Broj_skladišta > 1;
```

15. Prikazi informacije o zaposlenicima, njihovim skladistima, gradovima i vrsti posla

```sql
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
```
## Robert Vidaković
## Funkcije


Funkcije su blokovi koda koji se mogu ponovno iskoristiti te obaviti određene zadatke. One se koriste za izvođenje operacija na podacima ili vraćanje određenih vrijednosti. MySQL podržava različite vrste funkcija, ugrađene funkcije i korisnički definirane funkcije.

**1.	Funkcija – Provjera dostupnosti proizvoda**

```sql
DROP FUNCTION dostupnost_proizvoda_na_skladistu;
DELIMITER //
CREATE FUNCTION dostupnost_proizvoda_na_skladistu(skladiste_ID INTEGER, artikl_ID INTEGER) RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE dostupna_kolicina INTEGER;

    SELECT COALESCE(SUM(aus.kolicina), 0) INTO dostupna_kolicina
    FROM artikli_u_skladistu aus
    WHERE aus.ID_skladiste = skladiste_ID AND aus.ID_artikl = artikl_ID;
	
    IF dostupna_kolicina > 0 THEN
        RETURN CONCAT('Proizvod je dostupan na skladištu: ', dostupna_kolicina, ' komada');
    ELSE
        RETURN CONCAT('Proizvod nije dostupan na skladištu: ', dostupna_kolicina, ' komada');
    END IF;
END //
DELIMITER ;
```
Ova funkcija provjerava dostupnost proizvoda na skladištu te vraća njihovu količinu.

**DELIMITER //** postavlja delimiter za definiciju funkcije. Definiramo tijelo funkcije unutar bloka između **DELIMITER //** i **DELIMITER ;**.

Pomoću linije **CREATE FUNCTION dostupnost_proizvoda_na_skladistu(skladiste_ID INTEGER, artikl_ID INTEGER) RETURNS VARCHAR(50)** definiramo funkciju s dva ulazna parametra: **skladiste_ID** i **artikl_ID** tipa INTEGER koja vraća vrijednost tipa VARCHAR(50).

Funkcija daje deterministički rezultat, što znači da će s istim ulaznim vrijednostima uvijek proizvesti isti rezultat. **BEGIN** i **END //** određuju početak i kraj funkcije.

Deklariramo varijablu **dostupna_kolicina** koja će pohraniti rezultat upita. SELECT upit koristi **COALESCE** funkciju kako bi osigurao da se, u slučaju nedostatka podataka, vrijednost postavi na nulu. Zatim dohvaća količinu proizvoda na određenom skladištu iz tablice **artikli_u_skladistu**.

Nakon što smo dobili rezultate, funkcija provjerava je li količina veća od nula. Ako jest, vraća poruku koja informira korisnika da je proizvod dostupan na skladištu s točnim brojem dostupnih komada. U suprotnom, vraća poruku da proizvod nije dostupan.

Funkciju pozivamo sa naredbom:
```sql
SELECT dostupnost_proizvoda_na_skladistu(2, 2) AS dostupna_kolicina;
``` 

<br>

**2.	Funkcija – Broj zaposlenika određenog skladišta**

```sql
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
```
Ova funkcija vraća broj zaposlenika određenog skladišta.

Funkcija započinje definicijom parametra **skladiste_ID** tipa INTEGER, što omogućuje korisniku da odabere skladište za koje želi dobiti informacije o broju zaposlenika.

Unutar tijela funkcije, deklariramo varijablu **broj_zaposlenika** tipa INTEGER koja će pohraniti rezultat upita. SELECT upit broji zaposlenike u tablici zaposlenik gdje **ID_skladiste** odgovara zadanoj vrijednosti **skladiste_ID**. Dobiveni rezultat se pohranjuje u varijablu **broj_zaposlenika**.

Primjer poziva funkcije: 
```sql
SELECT zaposlenici_u_skladistu(2) AS broj_zaposlenika;.
```

<br>

**3.	Funkcija – Sveukupan iznos računa**

```sql
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
```
Ova funkcija vraća sveukupan iznos određenog računa.

Definicija parametra **racun_ID** tipa INTEGER omogućuje korisniku specificiranje računa za koji želi dobiti informacije. Kao i u prošlim funkcijama, označavamo da funkcija daje deterministički rezultat.

Deklariramo varijablu sveukupno tipa **DECIMAL(10, 2)** koja će pohraniti rezultat. Zatim, koristimo **SUM** funkciju kako bi izračunali ukupnu cijenu svih stavki na određenom računu. Rezultat se pohranjuje u varijablu **sveukupno**. U upitu koristimo JOIN operaciju kako bi povezali tablicu ***stavka_racun*** s tablicom **artikl** prema odgovarajućim ID-jevima. Nakon dobivanja rezultata, funkcija koristi RETURN naredbu kako bi vratila iznos računa.

Primjer poziva funkcije: 
```sql
SELECT sveukupan_iznos_racuna(5) AS iznos_racuna;
```

<br>

**4.	Funkcija -  Količinu proizvoda prodanih u određenom razdoblju**

```sql
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
```
Ova funkcija vraća ukupnu količinu proizvoda prodanih u određenom vremenskom razdoblju.

U funkciji imamo dva parametra, **pocetni_datum** i **krajnji_datum**, oba su tipa **DATE**. DATE označava kalendarski datum, a uključuje godinu, mjesec i dan u mjesecu. Na primjer, **'2024-01-10'** predstavlja 10. siječnja 2024. godine.

Deklariramo varijablu **sveukupna_kolicina** tipa INTEGER koja će pohraniti rezultat izračuna. **SELECT SUM(sr.kolicina) INTO sveukupna_kolicina FROM stavka_racun sr JOIN racun r ON sr.ID_racun = r.ID WHERE r.datum_izdavanja BETWEEN pocetni_datum AND krajnji_datum;** izračunava ukupnu količinu proizvoda tako što sumira količinu proizvoda iz tablice **stavka_racun** gdje se pridružuju podaci iz tablice **racun** prema ID-jevima računa, datum izdavanja računa između pocetni_datum i krajnji_datum (uključuju se i ta razdoblja). Rezultat će se pohraniti u varijablu **sveukupna_kolicina**.

Primjer poziva funkcije: 
```sql
SELECT sveukupna_kolicina_prodanih_proizvoda('2021-01-01', '2021-12-31') AS prodana_kolicina;
```

<br>

**5.	Funkcija – Zaposlenik s najviše radnog staža**
```sql
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
```
Ova funkcija prima ID skladišta kao ulazni parametar i vraća ime i prezime zaposlenika koji ima najduži radni staž u tom skladištu. 

Definiramo funkciju naziva **zaposlenik_s_najvise_radnog_staza** koja ima jedan parametar **skladiste_ID** tipa INTEGER, a vraća niz od 60 znakova. 

Deklariramo varijablu **najduze_zaposlen** tipa VARCHAR(60) koja će se koristiti za pohranu imena i prezimena zaposlenika. Zatim se izvršava upit koji koristi SELECT naredbu kako bi se dohvatilo ime i prezime zaposlenika iz tablice zaposlenik. Naredba **CONCAT(ime, ' ', prezime)** spaja ime i prezime zaposlenika u jedan niz, te se pomoću **ORDER BY datum_zaposlenja ASC** rezultati sortiraju prema datumu zaposlenja uzlazno. **LIMIT 1** ograničava rezultate na samo jedan redak, odnosno zaposlenika s najdužim radnim stažem.

Primjer poziva funkcije: 
```sql
SELECT zaposlenik_s_najvise_radnog_staza(3);
```

<br>


## Toni Mijić

### PROCEDURE

##### Procedura 1

 Prva procedura je jednostavni primjer koja vraca firmu s kojom se najvise posluje do sada i ima jedan izlazni parametar
 procedura nema nijedan ulazni parametar

```mysql
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
```

##### Procedura 2

Druga procedura je jednostavni  prikaz skladista s najvecom kolicinom artikala tako da bismo znali koje skladiste treba izbjegavati puniti artiklima ako je potrebno
nema ulaznih ni izlaznih parametara

```mysql
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
```

##### Procedura 3


Treca prcoedura pronalazi najvrijednijeg radnika i dodjeljuje mu vip ulogu ima jedna ulazno/izlazni parametar 
Koristimo 2 pomocne varijable u koje cemo spremiti zaposlenika s najvise racuna te u drugu spremamo vip naziv

```mysql
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
```

##### Procedura 4

Cetvrta procedura je jednostavna procedura koja nam provjerava da li je odredeni artikl u odredenom skladistu postojeci i koja je kolicina
ima 2 ulazna i 3 izlazna parametra 

```mysql
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
```


##### Procedura 5 

Peta procedura je jednostavna procedura koja provjerava koje se skladiste najcesce koristi da vidimo u koje treba najbolja kvaliteta ljudi radi najvise posla
nema ulaznih ni izlaznih parametara

```mysql
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
```


##### Procedura 6
Sesta procedura salje iste artikle u skladista u koja mi odaberemo radi lakseg kontroliranja artikala po skladistima 
ima 2 ulazna parametra 

```mysql
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
```

##### Procedura 7

Sedma procedura  zbraja odredene iste artikle nakon prebacivanja u skladiste tako da se sve svrstava pod jedno 
ima jedan ulazni parametar 

```mysql
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
```

##### Procedura 8 
Osma procedura stavlja popust od 20% na sve proizvode  koji se nikada nisu prodali
nema ulaznih niti izlaznih parametara

```mysql
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
```


##### Procedura 9

Deveta procedura provjerava da li je dovoljno zaposlenika u odredenim skladistima i ako nije javlja gresku
ima jedan ulazni parametar 

```mysql
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
```

##### Procedura 10 

Deseta procedura  prebacuje zaposlenike u druga skladista ovisno o potrebama firme tj. nadopunjujemo proslu proceduru koja nam radi provjeru
ima dva ulazna parametra 

```mysql
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
```

## Robert Vidaković
## Pogledi

**1.	Pogled – Vrati artikl koji je prodan u najvećoj količini**
```sql
CREATE VIEW najprodavaniji_artikl AS
SELECT a.naziv AS artikl, SUM(sr.kolicina) AS ukupno_prodano
FROM artikl a
JOIN stavka_racun sr ON a.ID = sr.ID_artikl
GROUP BY a.ID
ORDER BY ukupno_prodano DESC
LIMIT 1;
```

Povezujemo tablicu **artikl** i **stavka_racun**. Povezivanje se odvija prema stupcu ID, gdje je ID artikla u tablici artikl jednak ID-u artikla u tablici stavka_racun.

Nakon povezivanja, podaci se grupiraju prema ID-u artikla, a zatim se sumira količina za svaki artikl koristeći funkciju **SUM**. Rezultat se sortira silazno prema ukupnoj prodaji koristeći **ORDER BY**. Na kraju koristimo **LIMIT 1** kako bi se ograničio rezultat na samo jedan redak, tj. najprodavaniji artikl. 

<br>

**2.	Pogled – Praćenje narudžbi i njihovog statusa**
```sql
CREATE VIEW pregled_narudzbi AS
SELECT r.ID, r.datum_izdavanja, z.ime AS zaposlenik, k.ime AS kupac, iz.datum_dostavljanja, iz.vrijeme_dostavljanja
FROM racun r
JOIN zaposlenik z ON r.ID_zaposlenik = z.ID
JOIN stavka_racun sr ON r.ID = sr.ID_racun
JOIN artikl a ON sr.ID_artikl = a.ID
JOIN izdatnica iz ON r.ID = iz.ID
JOIN kupac k ON iz.ID = k.ID;
```
Pogled će kao rezultat prikazati ID računa, datum izdavanja računa, ime zaposlenika koji je izdao račun, ime kupca, datum dostavljanja, i vrijeme dostavljanja.

Spajamo tablicu **zaposlenik** s tablicom **racun** tako da se ID_zaposlenik na računu podudara s ID-em zaposlenika. Zatim dodajemo podatke o stavkama računa iz tablice **stavka_racun** na temelju odgovarajućih ID-eva računa. Informacije o artiklima iz tablice artikl pridružujemo tako da se podudara sa ID-em artikla na tablici **stavka_racun**. Povezujemo tablicu izdatnica s racun po ID-u te dodajemo informacije o kupcu na tablici **izdatnica**.

<br>

**3.	Pogled – U svrhu dobave, treba prikazati sve artikle koji se trenutno nalaze na skladištu i čija je količina manja od prosječne količine za sve artikle na skladištu.**
```sql
CREATE VIEW artikli_za_dobavu AS
SELECT a.naziv AS artikl, a.vrsta_artikla, aus.kolicina AS kolicina_na_skladistu, AVG(aus.kolicina) AS prosjecna_kolicina
FROM artikl a
JOIN artikli_u_skladistu aus ON a.ID = aus.ID_artikl
GROUP BY a.ID
HAVING aus.kolicina < AVG(aus.kolicina);
```
**SELECT a.naziv AS artikl, a.vrsta_artikla, aus.kolicina AS kolicina_na_skladistu, AVG(aus.kolicina) AS prosjecna_kolicina**: Ovaj dio nabraja stupce koji će biti prikazani u rezultatu pogleda. To uključuje naziv artikla (a.naziv), vrstu artikla (a.vrsta_artikla), količinu artikla na skladištu (aus.kolicina) i prosječnu količinu tog artikla u skladištu (AVG(aus.kolicina)).

Pridružujemo podatke iz tablice **artikli_u_skladistu** sa tablicom **artikl** po ID-u, grupiramo prema ID-u artikla iz tablice **artikl** i uključujemo rezultate gdje je količina artikla u skladištu manja od prosječne količine artikala u skladištu.

<br>

**4.	Pogled - Dostupni proizvodi u određenom skladištu**
```sql
CREATE VIEW pregled_dostupnih_proizvoda AS
SELECT aus.ID_skladiste, a.ID AS ID_artikl, a.naziv AS artikl, COALESCE(aus.kolicina, 0) AS dostupna_kolicina
FROM skladiste s
LEFT JOIN artikli_u_skladistu aus ON s.ID = aus.ID_skladiste
LEFT JOIN artikl a ON aus.ID_artikl = a.ID;

SELECT * FROM pregled_dostupnih_proizvoda WHERE ID_skladiste = 5;
```
Pogled koji će ispisati sve artikle koji su trenutno dostupni u skladištu.

Nabrajamo stupce koji će biti uključeni u rezultat, funkcija **COALESCE** se koristi kako bi se postavila nulta vrijednost u slučaju da nema dostupne količine. Radimo LEFT JOIN tablice **artikli_u_skladistu** s tablicom **skladiste** da bi se uključila i skladišta koja nemaju podatke u tablici **artikli_u_skladistu**, te dodajemo informacije o artiklima iz tablice **artikl** tako što će povezati ID-eve artikala iz tablice **artikli_u_skladistu**.

<br>

**5.	Pogled – Zarada cijele godine po kvartalima**
```sql
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
```
Pomoću ovog pogleda možemo provjeriti zaradu po kvartalima.

Prvo izdvajamo godinu iz datuma izdavanja računa koristeći funkciju **YEAR**. **CASE** izraz koristimo kako bi se odredio kvartal godine na temelju mjeseca izdavanja računa. Svaki kvartal je označen s Q1, Q2, Q3 ili Q4, ovisno o mjesecu izdavanja. 

Kako bi izračunali ukupan prihod za svaki kvartal, moramo pomnožiti količinu koja se nalazi u **stavka_racun** sa cijenom artikla, tu koristimo **SUM(sr.kolicina * a.cijena) AS prihod** i postavljamo vrijednost kao prihod.

Onda povezujemo podatke o stavkama računa iz tablice **stavka_racun** na temelju odgovarajućih ID-eva računa, te povezujemo informacije o artiklima iz tablice **artikl** na temelju ID-eva artikala iz stavki računa. Na kraju se podaci grupiraju po godini i kvartalu.

<br>

## Privremene tablice

Privremene tablice su lokalne tablice koje se stvaraju i koriste tijekom izvođenja specifičnog upita ili sesije, a zatim se automatski brišu kada završi izvršavanje upita ili kada završi sesija korisnika. One nam pružaju privremeni prostor za pohranu podataka tijekom izvođenja upita ili skripti.

```sql
CREATE TEMPORARY TABLE temp_racun AS SELECT * FROM racun LIMIT 0;
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
```

Stvaramo privremenu tablicu pod nazivom **temp_racun** tako da koristimo upit SELECT * FROM racun, specificiramo LIMIT 0 kako bi dobili praznu tablicu s istom strukturom kao i tablica **racun**. Zatim unosimo nove podatke.

<br>

```sql
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
```
Kreiramo novu privremenu tablicu **temp_zaposlenik** s istom strukturom kao i tablica **zaposlenik** ali je prazna pa želimo dodati nove podatke.

<br>

```sql
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
(5, '2024-01-09', '18:00:00', 105, 605),
(6, '2024-01-10', '19:30:00', 106, 606),
(7, '2024-01-11', '20:45:00', 107, 607),
(8, '2024-01-12', '21:30:00', 108, 608),
(9, '2024-01-13', '22:15:00', 109, 609),
(10, '2024-01-14', '23:00:00', 110, 610);


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
```
Stvaramo sljedeće četiri privremene tablice na isti način kao i prijašnje, koristimo **CREATE TEMPORARY TABLE ime_tablice AS SELECT * FROM ime_tablice LIMIT 0;** te u tablice unosimo podatke.

<br>

```sql
SELECT DISTINCT temp_racun.ID, temp_racun.datum_izdavanja, temp_zaposlenik.ime AS zaposlenik, temp_kupac.ime AS kupac, 
	temp_izdatnica.datum_dostavljanja, temp_izdatnica.vrijeme_dostavljanja
FROM temp_racun
JOIN temp_zaposlenik ON temp_racun.ID_zaposlenik = temp_zaposlenik.ID
JOIN temp_izdatnica ON temp_racun.ID = temp_izdatnica.ID
JOIN temp_kupac ON temp_izdatnica.ID_kupac = temp_kupac.ID;
```
Ovaj upit služi samo kao provjera privremenih tablica te praćenje narudžbi.

Koristimo **DISTINCT** tako da uključimo samo jedinstvene retke te uzimamo ID računa i datum izdavanja računa iz privremene tablice **temp_racun**. Ime zaposlenika iz privremene tablice **temp_zaposlenik**, ime kupca iz privremene tablice **temp_kupac** te datum i vrijeme dostavljanja izdatnice iz privremene tablice **temp_izdatnica**.

Spajamo informacije o zaposlenicima iz privremenih tablica **temp_zaposlenik** i **temp_racun** na temelju ID-eva zaposlenika, informacije o izdatnicama iz privremene tablice **temp_izdatnica** na temelju ID-eva izdatnica te informacije o kupcima iz privremenih tablica **temp_kupac** i **temp_izdatnica** na temelju ID-eva kupaca.

<br>

```sql
SELECT tr.ID, tr.datum_izdavanja, SUM(tar.cijena * tsr.kolicina) AS ukupni_iznos
FROM temp_racun tr
JOIN temp_stavka_racun tsr ON tr.ID = tsr.ID_racun
JOIN temp_artikl tar ON tsr.ID_artikl = tar.ID
GROUP BY tr.ID, tr.datum_izdavanja;
```
Ovim upitom računamo ukupan iznos za svaki račun koji se nalazi u privremenoj tablici.

Uzimamo ID računa i datum izdavanja iz privremene tablice **temp_racun**, ukupni iznos za svaki račun, koji se računa kao zbroj umnoženih cijena artikala iz privremene tablice **temp_artikl** s količinama iz privremene tablice **temp_stavka_racun**. 


## Mateo Smoljan
## Transakcije

#### Transakcije u MySQL predstavljaju skup operacija baza podataka koje se izvršavaju kao jedna logička cjelina, osiguravajući konzistentnost podataka čak i u slučaju neuspjeha tijekom izvršavanja operacija.

1. Povećanje cijena

```mysql
SELECT @@autocommit;
SET AUTOCOMMIT = OFF;
DELIMITER //
CREATE PROCEDURE povecaj_cijenuu (IN artiklID INT, IN postotak DECIMAL(5,2))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT "Došlo je do greške prilikom izvršavanja procedure.";
    END;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;

    UPDATE artikl
    SET cijena = cijena * (1 + postotak/100)
    WHERE ID = artiklID;

    COMMIT;
END //
DELIMITER ;

CALL povecaj_cijenuu(1, 10);
```

2. Prima zaposlenikID i firmaID te unosi novi redak u tablicu racun s trenutačnim datumom izdavanja

```mysql
SELECT @@autocommit;
SET AUTOCOMMIT = OFF;
DELIMITER //
CREATE PROCEDURE novi_racun (IN zaposlenikID INT, IN firmaID INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT "Došlo je do greške prilikom izvršavanja procedure.";
    END;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;

    INSERT INTO racun (ID_zaposlenik, datum_izdavanja, ID_firma)
    VALUES (zaposlenikID, CURDATE(), firmaID);

    COMMIT;
END //
DELIMITER ;

CALL novi_racun(1, 5);
```



Spajamo informacije o stavkama računa iz privremenih tablica **temp_stavka_racun** i **temp_racun** na temelju ID-eva računa. Zatim informacije o artiklima iz privremenih tablica **temp_artikl** i **temp_stavka_racun** na temelju ID-eva artikala te grupiramo rezultate po ID-evima računa i datumima izdavanja.
