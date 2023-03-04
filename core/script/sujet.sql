INSERT INTO degradation VALUES
(1, 'RNP 2', 'tar', 0, 0, 'X1', 'Y1', 0, 0, 0),
(2, 'RNP 2', 'tar', 0, 0, 'X2', 'Y2', 0, 0, 0),
(3, 'RNP 2', 'tar', 0, 0, 'X3', 'Y3', 0, 0, 0),

(4, 'RNP 7', 'tar', 0, 0, 'X4', 'Y4', 0, 0, 0),
(5, 'RNP 7', 'tar', 0, 0, 'X5', 'Y5', 0, 0, 0),
(6, 'RNP 7', 'tar', 0, 0, 'X6', 'Y6', 0, 0, 0);



INSERT INTO degradation_detail VALUES
(1, 1, 0, ST_SetSRID(ST_MakePoint(48.0467218, -18.8768764), 4326)),
(2, 1, 0, ST_SetSRID(ST_MakePoint(48.0519575, -18.8725314), 4326)),

(3, 2, 0, ST_SetSRID(ST_MakePoint(47.9894283, -18.8873931), 4326)),
(4, 2, 0, ST_SetSRID(ST_MakePoint(47.9991486, -18.8915144), 4326)),

(5, 3, 0, ST_SetSRID(ST_MakePoint(48.1629958, -18.9085121), 4326)),
(6, 3, 0, ST_SetSRID(ST_MakePoint(48.1721582, -18.9155357), 4326)),



(7, 4, 0, ST_SetSRID(ST_MakePoint(47.0975661, -19.7917772), 4326)),
(8, 4, 0, ST_SetSRID(ST_MakePoint(47.0953075, -19.7959843), 4326)),

(9, 4, 0, ST_SetSRID(ST_MakePoint(47.0587143, -20.0669718), 4326)),
(10, 4, 0, ST_SetSRID(ST_MakePoint(47.0626196, -20.0775529), 4326)),

(11, 4, 0, ST_SetSRID(ST_MakePoint(47.0450248, -19.9137168), 4326)),
(12, 4, 0, ST_SetSRID(ST_MakePoint(47.045116, -19.9268152), 4326));




INSERT INTO hospital VALUES
(1, 'hopital_1', ST_SetSRID(ST_MakePoint(47.9995262, -18.8921933), 4326)),
(2, 'hopital_2', ST_SetSRID(ST_MakePoint(47.989484, -18.8878385), 4326)),
(3, 'hopital_3', ST_SetSRID(ST_MakePoint(48.1631291, -18.9107643), 4326)),
(4, 'hopital_4', ST_SetSRID(ST_MakePoint(47.0606723, -19.9156356), 4326)),
(5, 'hopital_5', ST_SetSRID(ST_MakePoint(47.0605435, -19.9255611), 4326)),
(6, 'hopital_6', ST_SetSRID(ST_MakePoint(47.0789636, -20.0647593), 4326)),
(7, 'hopital_7', ST_SetSRID(ST_MakePoint(47.081796, -20.0755622), 4326)),
(8, 'hopital_8', ST_SetSRID(ST_MakePoint(47.0966332, -19.7966552), 4326)),
(9, 'hopital_9', ST_SetSRID(ST_MakePoint(47.1104734, -19.7966148), 4326));