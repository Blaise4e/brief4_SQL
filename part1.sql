-- DROP DATABASE s6_mvc_btp
CREATE DATABASE IF NOT EXISTS S6_MVC_BTP;

USE S6_MVC_BTP;

CREATE TABLE client (
    id int NOT NULL AUTO_INCREMENT,
    nom VARCHAR (255),
    anneeNaiss YEAR(4),
    ville VARCHAR(255),
    PRIMARY KEY (id)
    );
    
CREATE TABLE commande (
    num INT NOT NULL AUTO_INCREMENT,
    idC INT,
    labelP VARCHAR (255),
    qte INT(11),
    PRIMARY KEY (num, labelP, idC),
    FOREIGN KEY (idC) REFERENCES client (id),
    FOREIGN KEY (labelP) REFERENCES produit (label)
    );
    
CREATE TABLE produit (
    label VARCHAR (255),
    idF INT (11),
    prix FLOAT (2),
    PRIMARY KEY (label, idF),
    FOREIGN KEY (label) REFERENCES commande (labelP),
    FOREIGN KEY (idF) REFERENCES fournisseur (id)
    );
   
CREATE TABLE fournisseur (
    id int NOT NULL AUTO_INCREMENT,
    nom VARCHAR (255),
    age INT (2),
    ville VARCHAR (255),
    PRIMARY KEY (ID)
    ); 

INSERT INTO client (nom, anneeNaiss, ville) VALUES 
('Jean', 1965, '75006 Paris'),
('Paul', 1958, '75003 Paris'),
('Vincent', 1954, '94200 Evry'),
('Pierre', 1950, '92400 Courbevoie'),
('Daniel', 1963, '44000 Nantes');

INSERT INTO fournisseur (nom, age, ville) VALUES
('Abounayan', 52, '92190 Meudon'),
('Cima', 37, '44510 Nantes'),
('Preblocs', 48, '92230 Gennevilliers'),
('Samaco', 61, '75018 Paris'),
('Damasco', 29, '49100 Angers');

INSERT INTO produit (label, prix, idF) VALUES 
('sable', 300, 1),
('briques', 1500, 1),
('parpaing', 1150, 1),
('sable', 350, 2),
('tuiles', 1200, 3),
('parpaing', 1300, 3),
('briques', 1500, 4),
('ciment', 1300, 4),
('parpaing', 1450, 4),
('briques', 1450, 5),
('tuiles', 1100, 5);

INSERT INTO commande (num, idC, labelP, qte) VALUES 
(1, 1, 'briques', 5),
(1, 1, 'ciment', 10),
(2, 2, 'briques', 12),
(2, 2, 'sable', 9),
(2, 2, 'parpaing', 15),
(3, 3, 'sable', 17),
(4, 4, 'briques', 8),
(4, 4, 'tuiles', 17),
(5, 5, 'parpaing', 10),
(5, 5, 'ciment', 14),
(6, 5, 'briques', 21),
(7, 2, 'ciment', 12),
(8, 4, 'parpaing', 8),
(9, 1, 'tuiles', 15);

-- 1 toutes les informations sur les clients.  
USE s6_mvc_btp
SELECT * FROM client;

-- 2 toutes les informations ?? utiles ?? l???utilisateur ?? sur les clients, i.e. sans l???identifiant (servant ?? lier les relations). 

SELECT nom, anneeNaiss, ville FROM client;

-- 3 le nom des clients dont l?????ge est sup??rieur ?? 50
SELECT * FROM Client WHERE anneeNaiss < (YEAR(CURDATE()) - 50);;

-- 4 la liste des produits (leur label), sans doublon !
SELECT DISTINCT label FROM produit;

-- 5 idem, mais cette fois la liste est tri??e par ordre alphab??tique d??croissant
SELECT DISTINCT label FROM produit ORDER BY label DESC; 

-- 6 Les commandes avec une quantit?? entre 8 et 18 inclus (avec BETWEEN)
SELECT * FROM commande WHERE qte BETWEEN 8 AND  18;

-- 6 Les commandes avec une quantit?? entre 8 et 18 inclus (sans BETWEEN)
SELECT * FROM commande WHERE qte > 8 AND qte < 18;

-- 7 le nom et la ville des clients dont le nom commence par ???P???.
SELECT nom, ville FROM client WHERE nom LIKE "P%";

-- 8 le nom des fournisseurs situ??s ?? PARIS.
SELECT nom FROM fournisseur WHERE ville LIKE "%Paris";

-- 9 l???identifiant Fournisseur et le prix associ??s des "briques" et des "parpaing" (without IN)
SELECT idF, prix FROM produit WHERE label ="briques" or label="parpaing";

-- 9 l???identifiant Fournisseur et le prix associ??s des "briques" et des "parpaing" (with IN)
SELECT idF, prix FROM produit WHERE label IN ("briques", "parpaing");

-- 10 la liste des noms des clients avec ce qu???ils ont command?? (label + quantit?? des produits)
SELECT nom, labelP, qte FROM client INNER JOIN commande ON commande.idC=client.id;

-- 11 le produit cart??sien entre les clients et les produits (i.e. toutes les combinaisons possibles
--d???un achat par un client), on affichera le nom des clients ainsi que le label produits

SELECT nom, labelP FROM client, commande;

-- 12 la liste, tri??e par ordre alphab??tique, des noms des clients qui commandent le produit "briques".
SELECT DISTINCT nom FROM client,commande WHERE labelP = 'briques' ORDER BY nom ASC;

-- 13 le nom des fournisseurs qui vendent des "briques" ou des "parpaing" (cart??sien)
SELECT DISTINCT nom FROM fournisseur,produit WHERE fournisseur.id = produit.idF AND label = 'briques' OR label = 'parpaing';

-- 13 le nom des fournisseurs qui vendent des "briques" ou des "parpaing" (avec jointure)
SELECT DISTINCT nom FROM fournisseur JOIN produit ON produit.idF=fournisseur.id WHERE label = 'briques' OR label = 'parpaing';

-- 13 le nom des fournisseurs qui vendent des "briques" ou des "parpaing" (avec requ??te imbriqu??e)
SELECT DISTINCT nom FROM fournisseur WHERE id IN (SELECT idF FROM produit WHERE label = 'briques' OR label = 'parpaing');

-- 13 bis le nom des produits fournis par des fournisseurs parisiens (produit cart??sien )
SELECT DISTINCT label FROM produit,fournisseur WHERE  produit.idF = fournisseur.id AND ville LIKE "%Paris";

-- 13 bis le nom des produits fournis par des fournisseurs parisiens (jointure)
SELECT DISTINCT label FROM produit JOIN fournisseur ON produit.idF = fournisseur.id WHERE ville LIKE "%Paris";

-- 13 bis le nom des produits fournis par des fournisseurs parisiens (requ??te imbriqu??e)
SELECT DISTINCT label FROM produit WHERE idF IN (SELECT id FROM fournisseur WHERE ville LIKE "%Paris");

-- 14 les noms et adresses des clients ayant command?? des briques, tel que la quantit?? command??e soit comprise entre 10 et 15.
SELECT nom, ville FROM client WHERE id IN (SELECT idC FROM commande WHERE labelP LIKE "briques" AND qte BETWEEN 10 AND 15);

-- 15 le nom des fournisseurs, le nom des produits et leur co??t, correspondant pour tous les fournisseurs proposant au moins un produit command?? par Jean
SELECT fournisseur.nom, produit.label, produit.prix 
FROM client 
JOIN commande ON commande.idC = client.id 
JOIN produit ON produit.label = commande.labelP
JOIN fournisseur ON fournisseur.id = produit.idF
WHERE client.nom LIKE 'Jean'

-- 16 idem, mais on souhaite cette fois que le r??sultat affiche le nom des fournisseurs tri?? dans l???ordre alphab??tique descendant et pour chaque fournisseur le nom des produits dans l???ordre ascendant.
SELECT fournisseur.nom, produit.label, produit.prix 
FROM client 
JOIN commande ON commande.idC = client.id 
JOIN produit ON produit.label = commande.labelP
JOIN fournisseur ON fournisseur.id = produit.idF
WHERE client.nom LIKE 'Jean'
ORDER BY fournisseur.nom DESC, produit.label ASC;

-- deuxi??me mani??re 
SELECT label, prix, nom FROM fournisseur , produit WHERE label IN
(SELECT labelP FROM commande WHERE idC IN
(SELECT id FROM client WHERE nom = 'Jean'))

-- 17 le nom et le co??t moyen des produits
SELECT label, SUM(prix) FROM produit GROUP BY label

-- 18 le nom des produits propos??s et leur co??t moyen lorsque celui-ci est sup??rieur ?? 1200.
SELECT label, AVG(prix) FROM produit WHERE prix > 1200 GROUP BY label

-- 20 le nom des produits dont le co??t est inf??rieur au co??t moyen de tous les produits
SELECT label FROM produit WHERE prix < (SELECT AVG(prix) FROM produit);

-- 21 le nom des produits propos??s et leur co??t moyen pour les produits fournis par au moins 3 fournisseurs.
SELECT label, AVG(prix) FROM produit GROUP BY label HAVING COUNT(idF) >= 3 

