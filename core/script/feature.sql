-- CREATE OR REPLACE FUNCTION get_road_geojson (the_roadno VARCHAR)
-- RETURNS SETOF json 
-- AS 
-- $$
-- BEGIN

--     RETURN QUERY
--     SELECT ST_AsGeoJSON(geom) FROM madagascar_roads WHERE roadno=the_roadno;

-- END; 
-- $$
-- LANGUAGE 'plpgsql';

CREATE TABLE hospital (
    hp_id SERIAL PRIMARY KEY,
    name VARCHAR(25)
);
SELECT AddGeometryColumn('','hospital','coordinate','4326','POINT',2);
CREATE INDEX "hospital_geometry_idx" ON hospital USING GIST ("coordinate");
INSERT INTO hospital (name, coordinate) VALUES ('hp_1', '0101000020E6100000759E366093CD4740F6289B0E69E332C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_2', '0101000020E6100000B3D8006072D94740C88BDAAA78E832C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_3', '0101000020E6100000E3058B18B1F74740E5C935EB6DEE32C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_4', '0101000020E6100000F7138BFD12D44740D12AE1B0A0DE32C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_5', '0101000020E6100000FF919B2D9DC74740A7ADF36207E432C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_6', '0101000020E6100000792F3832F7994840C451FA8D305C32C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_7', '0101000020E61000003AB02BC7C88848406C5364B7A5D332C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_8', '0101000020E61000009B601B4ACC4D48403BEEC81501FC32C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_9', '0101000020E61000004B35DA5B3DBF4740DB5F34ECFBDD32C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_10', '0101000020E6100000386B7553F37F47407B307A99897A31C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_11', '0101000020E61000003C5F7FDA4E514740C789AE59CCCA2FC0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_12', '0101000020E61000001F78B4489D8D47400B09F102FF8C30C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_13', '0101000020E6100000000669B5939F4740CDC00528939C33C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_14', '0101000020E6100000B4B1FDCF4B974740FB4371ACD7D434C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_15', '0101000020E61000006181893D159B4740C3810AF2231B35C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_16', '0101000020E610000076B09D332D2C4640594489E947E536C0');
INSERT INTO hospital (name, coordinate) VALUES ('hp_17', '0101000020E61000003865FF692B074740AACB2C11B16436C0');




CREATE TABLE surface_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) UNIQUE,
  unit_price REAL, -- m3
  duration REAL -- h/m3
);
INSERT INTO surface_type VALUES
(DEFAULT, 'tar', 80000, 1.5),
(DEFAULT, 'cobblestone', 60000, 3),
(DEFAULT, 'land', 10000, 2);
ALTER TABLE surface_type ADD CONSTRAINT surf_name UNIQUE(name);





CREATE TABLE degradation ( 
    id SERIAL PRIMARY KEY,
    roadno VARCHAR(10),
    surftype VARCHAR(30) REFERENCES surface_type(name),
    starts INT NOT NULL,
    ends INT NOT NULL,
    start_desc VARCHAR(80),
    end_desc VARCHAR(80),
    length REAL NOT NULL,
    width REAL NOT NULL,
    level INT NOT NULL
);
INSERT INTO degradation VALUES (DEFAULT, 'RNP 2', 'tar', 11, 34, 'Ambohimalaza', 'Maharidaza', 23, 5.5, 25);

INSERT INTO degradation VALUES (DEFAULT, 'RNP 2', 'tar', 113, 129, 'X', 'Y', 16, 5.5, 15);



CREATE TABLE degradation_detail (
  id SERIAL PRIMARY KEY,
  degradation_id INT REFERENCES degradation(id),
  kilometer_point INT NOT NULL,
  location geometry(Point, 4326)
);
CREATE INDEX "degradation_detail_geometry_idx" ON degradation_detail USING GIST ("location");
INSERT INTO degradation_detail VALUES (DEFAULT, 1, 11, '0101000020E61000007755D250C4CC4740723F54D814E632C0');
INSERT INTO degradation_detail VALUES (DEFAULT, 1, 16, '0101000020E6100000B331026C38D1474013848659C3E132C0');
INSERT INTO degradation_detail VALUES (DEFAULT, 1, 21, '0101000020E6100000A53606D7BBD54740E9AE70BB65DC32C0');
INSERT INTO degradation_detail VALUES (DEFAULT, 1, 26, '0101000020E6100000CDE88B978AD847407826B1E12FE332C0');
INSERT INTO degradation_detail VALUES (DEFAULT, 1, 34, '0101000020E6100000446496C0ABDD474021D5B17273E432C0');

INSERT INTO degradation_detail VALUES (DEFAULT, 2, 113, '0101000020E610000044F95F8D511F484085AA5A6AE2F132C0');
INSERT INTO degradation_detail VALUES (DEFAULT, 2, 129, '0101000020E61000003226ED3F502E4840772502F8B6F232C0');






CREATE TABLE population (
  id SERIAL PRIMARY KEY,
  region VARCHAR(80) NOT NULL,
  nbr INT NOT NULL,
  location geometry(Point, 4326)
);
CREATE INDEX "population_geometry_idx" ON population USING GIST ("location");
INSERT INTO population (location , id, region, nbr) VALUES ('0101000020E6100000394D0F4DF5C3474045AF98804EE632C0', 1, 'Ankadifotsy', 5980);
INSERT INTO population (location , id, region, nbr) VALUES ('0101000020E61000000496D2E19ACF47401948E95C01E432C0', 2, 'Ambohimangakely', 4660);
INSERT INTO population (location , id, region, nbr) VALUES ('0101000020E610000006C88960D9D747406DC82EFECBDE32C0', 3, 'Manakavaly', 3340);
INSERT INTO population (location , id, region, nbr) VALUES ('0101000020E61000001EFB126D30BE4740FC03356B65DB32C0', 4, 'Alarobia', 5400);






Select hospital.name, deg.kilometer_point, ST_Distance(deg.location::geography, (coordinate::geography)) distance From hospital
JOIN degradation_detail deg ON ST_DWithin(deg.location::geography, hospital.coordinate::geography, 5000)
--Where ST_Distance(deg.location::geography, (coordinate::geography)) <= 5000;


Select hospital.name, deg.kilometer_point, ST_Distance(deg.location::geography, (coordinate::geography)) distance From hospital
JOIN degradation_detail deg ON ST_DWithin(deg.location::geography, hospital.coordinate::geography, 5000) WHERE deg.degradation_id = 1 ORDER BY kilometer_point;





-- kp to point
SELECT DISTINCT(ST_LineInterpolatePoint(ST_GeometryN(geom, 1), ((129 - start_km)/(end_km - start_km)))) AS point_geom
FROM madagascar_roads WHERE start_km <= 129 AND end_km >= 129 AND roadno = 'RNP 2';







6_x = 48.244676277029185
6_y = -18.944861075530316

7_x = 48.361824026866444
7_y = -18.948104382061015

SELECT ST_Distance(ST_GeomFromText('Point(48.361824026866444 -18.948104382061015)')::geography, ST_GeomFromText('Point(48.244676277029185 -18.944861075530316)')::geography);