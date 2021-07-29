CREATE DATABASE IF NOT EXISTS music;

USE music;

CREATE TABLE musicien (
    nom VARCHAR (255),
    instrument VARCHAR(255),
    anneeExperience INT (2),
    nomOrchestre VARCHAR (255),
    PRIMARY KEY (nom),
    FOREIGN KEY (nomOrchestre) REFERENCES orchestre (nom)
    );

CREATE TABLE orchestre (
    nom VARCHAR (255),
    style VARCHAR(255),
    chef VARCHAR (255),
    PRIMARY KEY (nom)
    );

CREATE TABLE concert (
    nom VARCHAR (255),
    nomOrchestre VARCHAR (255),
    date_ DATE,
    lieu VARCHAR (255),
    prix FLOAT,
    PRIMARY KEY (nom),
    FOREIGN KEY (nomOrchestre) REFERENCES orchestre (nom)
    );

INSERT INTO orchestre VALUES
('orchestre1', 'jazz', 'leonardo'),
('orchestre2', 'pop', 'michaelgelo'),
('orchestre3', 'rnb', 'raphael'),
('orchestre4', 'house', 'donatello'),
('orchestre5', 'classic', 'Smith'),
('orchestre6', 'classic', 'Smith'),
('orchestre7', 'blues', 'Ray');

INSERT INTO concert VALUES
('Ultrall', 'orchestre1', '2021-06-15', 'Stade de France', 500),
('Die rich or trie dying', 'orchestre2', '2004-09-03', 'Zenith', 100),
('Ultral', 'orchestre1', '2014-09-05', 'NY', 600),
('Life', 'orchestre3', '2020-11-22', 'Dubai', 400),
('Fiestea', 'orchestre3', '2010-07-12', 'Miami', 50),
('Power', 'orchestre2', '1997-08-16', 'Douala', 1000),
('Mozart', 'orchestre5', '2019-04-20', 'Opéra Bastille', 10),
('Zen', 'orchestre7', '2015-02-22', 'LA', 50),
('Relax', 'orchestre6', '2016-01-01', 'PARIS', 200);

INSERT INTO musicien VALUES 
('Yannick', 'guitare', 10, 'orchestre1'),
('Patrick', 'piano', 10, 'orchestre1'),
('Cedric', 'violon', 10, 'orchestre1'),
('Jordan', 'batterie', 2, 'orchestre2'),
('Gaelle', 'saxophone', 4, 'orchestre3'),
('Georges', 'harmonica', 20, 'orchestre6');

-- 01 Donner la liste des noms des jeunes musiciens et leurs instruments ; où jeune si moins de 5 ans d'expérience
SELECT nom, instrument FROM musicien WHERE anneeExperience < 5

-- 02 Donner la liste des différents instruments de l'orchestre « Jazz92 ».
SELECT instrument FROM musicien WHERE nomOrchestre LIKE "Jazz92"

-- 03 Donner toutes les informations sur les musiciens jouant du violon.
SELECT nom, anneeExperience, nomOrchestre FROM musicien WHERE instrument LIKE "violon"

-- 04 Donner la liste des instruments dont les musiciens ont plus de 20 ans d'expérience.
SELECT instrument FROM musicien WHERE anneeExperience >= 20

-- 05 Donner la liste des noms des musiciens ayant entre 5 et 10 ans d'expérience (bornes incluses).
SELECT nom FROM musicien WHERE anneeExperience BETWEEN 5 AND 10

-- 06 Donner la liste des instruments commençants par « vio » (e.g. violon, violoncelle, ...)
SELECT instrument FROM musicien WHERE instrument LIKE "vio%"

-- 07 Donner la liste des noms d'orchestre de style jazz.
SELECT nom FROM orchestre WHERE style LIKE "Jazz"

-- 08 Donner la liste des noms d'orchestre dont le chef est John Smith.
SELECT nom FROM orchestre WHERE chef LIKE "John Smith"

-- 09 Donner la liste des concert triés par ordre alphabétique
SELECT * FROM concert ORDER BY nom ASC

-- 10 Donner la liste des concerts se déroulant le 31 décembre 2015 à Versailles.
SELECT nom FROM concert WHERE date_ LIKE "2015-12-31"

-- 11 Donner les lieux de concerts où le prix est supérieur à 150 euros.
SELECT lieu FROM concert WHERE prix > 150

-- 12 Donner la liste des concerts se déroulant à Opéra Bastille pour moins de 50 euros.
SELECT nom FROM concert WHERE lieu LIKE "Opéra Bastille" AND prix < 50

-- 13 Donner la liste des concert ayant eu lieu en 2014.
SELECT nom FROM concert WHERE date_ LIKE "2014%"

-- 01 Donner la liste des noms et instruments des musiciens ayant plus de 3 ans d'expérience 
-- et faisant partie d'un orchestre de style jazz. On affichera par ordre alphabétique sur les noms.

SELECT musicien.nom, musicien.instrument 
FROM musicien 
JOIN orchestre ON orchestre.nom = musicien.nomOrchestre
WHERE style LIKE "jazz"

-- 02 Donner les différents lieux, triés par ordre alphabétique, de concerts où l'orchestre du chef Smith joue
-- avec un prix inférieur à 20. 
SELECT concert.lieu 
FROM concert
JOIN orchestre ON orchestre.nom = concert.nomOrchestre
WHERE chef LIKE "Smith" AND concert.prix < 20

-- 03 Donner le nombre de concerts de style blues en 2015. 
SELECT COUNT(concert.nom) 
FROM concert
JOIN orchestre ON orchestre.nom = concert.nomOrchestre
WHERE style LIKE "blues" AND date_ LIKE "2015%"

-- 04 Donner le prix moyen des concerts de style jazz par lieu de production.
SELECT AVG(concert.prix), concert.lieu
FROM concert
JOIN orchestre ON orchestre.nom = concert.nomOrchestre
WHERE orchestre.style LIKE "jazz"
ORDER BY concert.lieu

-- 05 Donner la liste des instruments participant aux concerts donnés par le chef Smith le 1er janvier 2016.
SELECT instrument
FROM musicien
JOIN orchestre ON orchestre.nom = musicien.nomOrchestre
JOIN concert ON concert.nomOrchestre = orchestre.nom
WHERE orchestre.chef LIKE "Smith" AND concert.date_ LIKE "2016-01-01"

-- 21 Donner le nombre moyen d'années d'expérience des joueurs de trompette par style d'orchestre
SELECT AVG(musicien.anneeExperience),  orchestre.style
FROM musicien
JOIN orchestre ON orchestre.nom = musicien.nomOrchestre
WHERE musicien.instrument LIKE "trompette" ORDER BY orchestre.style

-- Multi-tables, avec jointures
-- 01 Donner la liste des noms et instruments des musiciens ayant plus de 3 ans d'expérience
-- et faisant partie d'un orchestre de style jazz. On affichera par ordre alphabétique sur les noms.

SELECT nom, instrument 
FROM musicien
WHERE anneeExperience >3
AND nomOrchestre 
IN
(SELECT nom
FROM orchestre WHERE style LIKE "jazz");

-- 02 Donner les différents lieux, triés par ordre alphabétique, de concerts 
-- où l'orchestre du chef Smith joue avec un prix inférieur à 20.

SELECT lieu 
FROM concert 
WHERE prix < 20
AND nomOrchestre
IN(SELECT nom FROM orchestre WHERE chef LIKE "Smith") 
ORDER BY lieu ASC

-- 03 Donner le nombre de concerts de blues en 2015.

SELECT COUNT(nom)
FROM concert
WHERE nomOrchestre
IN(SELECT nom FROM orchestre WHERE style LIKE "blues" AND date_ LIKE "2015")

-- 04 Donner le prix moyen des concerts de style jazz par lieu de production

SELECT AVG(prix), lieu 
FROM concert
WHERE nomOrchestre
IN(SELECT nom FROM orchestre WHERE style LIKE "jazz" )
ORDER BY lieu

-- 05 Donner la liste des instruments participant aux concerts donnés par le chef Smith le 1er janvier 2016

SELECT instrument
FROM musicien
WHERE nomOrchestre
IN (SELECT nom FROM orchestre WHERE nom 
IN (SELECT nomOrchestre FROM concert WHERE chef LIKE "Smith" AND date_ LIKE "2016-01-01"))