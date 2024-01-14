# Sustav-za-upravljanje-skladistem
projekt baze podataka 2
```mysql
CREATE TABLE vozilo_na_misiji(
    id INTEGER PRIMARY KEY,
    id_vozilo INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    id_misija INTEGER NOT NULL,
    FOREIGN KEY (id_vozilo) REFERENCES vozila(id) ON DELETE CASCADE,
    FOREIGN KEY (id_misija) REFERENCES misija(id) ON DELETE CASCADE
);
-- DROP TABLE vozilo_na_misiji;
ALTER TABLE vozilo_na_misiji
	ADD CONSTRAINT ck_kolicina1 CHECK(kolicina>0);
```
