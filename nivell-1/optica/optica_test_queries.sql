-- Optica Test Queries

-- Llista el total de factures d'un client en un període determinat
SELECT client_id, nom, primer_cognom, ullera_id,u.venut_data FROM ulleres u
JOIN clients c ON c.client_id = u.venut_a_client_id
WHERE c.client_id = 12 AND u.venut_data BETWEEN '2019-09-20' AND '2020-11-19';

-- Llista els diferents models d'ulleres que ha venut un empleat durant un any
SELECT ullera_id, marca_nom, venut_per FROM ulleres
JOIN ulleres_marca USING (marca_id)
WHERE venut_per = 'Alexander';

-- Llista els diferents proveïdors que han subministrat ulleres venudes amb èxit per l'òptica
SELECT u.ullera_id, u.marca_id, um.marca_nom, p.nom AS 'nom_proveidor' FROM ulleres u
JOIN ulleres_marca um USING (marca_id)
JOIN proveidors p ON p.proveidor_id = um.comprat_a_proveidor_id
GROUP BY p.nom;