-- Pizzeria Test Queries

-- Llista quants productes de categoria 'Begudas' s'han venut en una determinada localitat
SELECT COUNT(*) AS 'begudes_venudes' FROM productes
JOIN comanda_items USING (producte_id)
WHERE tipus = 'beguda';

-- Llista quantes comandes ha efectuat un determinat empleat
SELECT COUNT(*), e.empleat_id, e.nom AS 'empleat_nom', e.carrec FROM comandes c
JOIN comandes_domicili cd ON c.comandes_domicili_id = cd.comanda_domicili_id
JOIN empleats e ON cd.repartidor_empleat_id = e.empleat_id 
WHERE repartidor_empleat_id = 4;