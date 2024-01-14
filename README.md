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

