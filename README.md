# Sustav-za-upravljanje-skladistem
projekt baze podataka 2

## Toni Mijić
## Tablice

**Relacija drzava**:
sve drzave koje se koriste za skladiste

- id podataka tipa integer ,primarni ključ
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
-id_drzava tipa integer referencira se na drzava(id) kao FOREIGN KEY
-naziv,grad su tipa varchar
-postanski_broj tipa integer i ima check koji provjerava da broj ne ide u nedogled vec do 100 000

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

-primarni kljuc je id tipa integer
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
- oib je unique i limitiran na 11 znakova
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
FOREIGN KEY (id_skladiste) REFERENCES  skladiste(id),
FOREIGN KEY (id_vrsta_posla) REFERENCES vrsta_posla(id)
);
Drop table zaposlenik;
```

