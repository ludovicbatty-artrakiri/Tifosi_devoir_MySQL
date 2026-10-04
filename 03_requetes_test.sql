-- =====================================================================
--  Projet  : Tifosi - Restaurant de street-food italien
--  Script  : 03_requetes_test.sql
--  Rôle    : Vérification de la base à l'aide de 10 requêtes de test
--  Exécution :
--      mysql -u tifosi -p tifosi < 03_requetes_test.sql
--      (ou mysql -u tifosi -p -t tifosi < 03_requetes_test.sql pour un
--       affichage en tableaux)
--  Pré-requis : avoir exécuté 01_creation_schema.sql puis
--               02_insertion_donnees.sql
--
-- =====================================================================

USE tifosi;

-- Encodage de la connexion (affichage correct des accents)
SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Requête 1 : Afficher la liste des noms des focaccias par ordre alphabétique croissant
-- ---------------------------------------------------------------------
SELECT nom AS focaccia
FROM focaccia
ORDER BY nom ASC;

-- Résultat attendu :
--   8 focaccias triées de A à Z :
--   Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia,
--   Paysanne, Raclaccia, Tradizione
--
-- Résultat obtenu (8 lignes) :
--   +-----------------+
--   | focaccia        |
--   +-----------------+
--   | Américaine      |
--   | Emmentalaccia   |
--   | Gorgonzollaccia |
--   | Hawaienne       |
--   | Mozaccia        |
--   | Paysanne        |
--   | Raclaccia       |
--   | Tradizione      |
--   +-----------------+
--
-- Écart / commentaire :
--   Aucun écart. Le « A » accentué d'« Américaine » est bien classé avant « E »
--   grâce à l'interclassement utf8mb4_unicode_ci (insensible aux accents).

-- ---------------------------------------------------------------------
-- Requête 2 : Afficher le nombre total d'ingrédients
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS nb_ingredients
FROM ingredient;

-- Résultat attendu :
--   25 (nombre de lignes du fichier ingredient.xlsx)
--
-- Résultat obtenu (1 ligne) :
--   +----------------+
--   | nb_ingredients |
--   +----------------+
--   |             25 |
--   +----------------+
--
-- Écart / commentaire :
--   Aucun écart. On compte les ingrédients référencés (table ingredient),
--   y compris ceux qui ne sont utilisés dans aucune focaccia (cf. requête 9).

-- ---------------------------------------------------------------------
-- Requête 3 : Afficher le prix moyen des focaccias
-- ---------------------------------------------------------------------
SELECT ROUND(AVG(prix), 2) AS prix_moyen
FROM focaccia;

-- Résultat attendu :
--   (9.80 + 10.80 + 8.90 + 9.80 + 8.90 + 11.20 + 10.80 + 12.80) / 8
--   = 83.00 / 8 = 10.375, soit 10.38 € arrondi au centime
--
-- Résultat obtenu (1 ligne) :
--   +------------+
--   | prix_moyen |
--   +------------+
--   |      10.38 |
--   +------------+
--
-- Écart / commentaire :
--   Aucun écart. Sans ROUND, AVG renvoie 10.375000 : l'arrondi à 2 décimales
--   est ajouté pour obtenir un prix lisible.

-- ---------------------------------------------------------------------
-- Requête 4 : Afficher la liste des boissons avec leur marque, triée par nom de boisson
-- ---------------------------------------------------------------------
SELECT b.nom AS boisson,
       m.nom AS marque
FROM boisson b
INNER JOIN marque m ON m.id_marque = b.id_marque
ORDER BY b.nom ASC;

-- Résultat attendu :
--   12 boissons, chacune avec sa marque, par ordre alphabétique :
--   Capri-sun (Coca-cola) ... Pepsi Max Zéro (Pepsico)
--
-- Résultat obtenu (12 lignes) :
--   +---------------------------+-------------+
--   | boisson                   | marque      |
--   +---------------------------+-------------+
--   | Capri-sun                 | Coca-cola   |
--   | Coca-cola original        | Coca-cola   |
--   | Coca-cola zéro            | Coca-cola   |
--   | Eau de source             | Cristalline |
--   | Fanta citron              | Coca-cola   |
--   | Fanta orange              | Coca-cola   |
--   | Lipton Peach              | Pepsico     |
--   | Lipton zéro citron        | Pepsico     |
--   | Monster energy ultra blue | Monster     |
--   | Monster energy ultra gold | Monster     |
--   | Pepsi                     | Pepsico     |
--   | Pepsi Max Zéro            | Pepsico     |
--   +---------------------------+-------------+
--
-- Écart / commentaire :
--   Aucun écart. Les 12 boissons apparaissent : chaque boisson a obligatoirement
--   une marque (id_marque NOT NULL), donc la jointure interne n'en perd aucune.

-- ---------------------------------------------------------------------
-- Requête 5 : Afficher la liste des ingrédients pour une Raclaccia
-- ---------------------------------------------------------------------
SELECT i.nom AS ingredient,
       c.quantite AS quantite_g
FROM ingredient i
INNER JOIN comprend c ON c.id_ingredient = i.id_ingredient
INNER JOIN focaccia f ON f.id_focaccia  = c.id_focaccia
WHERE f.nom = 'Raclaccia'
ORDER BY i.nom;

-- Résultat attendu :
--   7 ingrédients (d'après focaccia.xlsx) :
--   Base tomate, Raclette, Cresson, Ail, Champignon, Parmesan, Poivre
--
-- Résultat obtenu (7 lignes) :
--   +-------------+------------+
--   | ingredient  | quantite_g |
--   +-------------+------------+
--   | Ail         |          2 |
--   | Base Tomate |        200 |
--   | Champignon  |         40 |
--   | Cresson     |         20 |
--   | Parmesan    |         50 |
--   | Poivre      |          1 |
--   | Raclette    |         50 |
--   +-------------+------------+
--
-- Écart / commentaire :
--   Aucun écart : 7 ingrédients, identiques à la recette du fichier.
--   La quantité (en grammes) est affichée en complément.

-- ---------------------------------------------------------------------
-- Requête 6 : Afficher le nom et le nombre d'ingrédients pour chaque focaccia
-- ---------------------------------------------------------------------
SELECT f.nom AS focaccia,
       COUNT(c.id_ingredient) AS nb_ingredients
FROM focaccia f
LEFT JOIN comprend c ON c.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY f.nom;

-- Résultat attendu :
--   Américaine 8, Emmentalaccia 7, Gorgonzollaccia 8, Hawaienne 9,
--   Mozaccia 10, Paysanne 12, Raclaccia 7, Tradizione 9
--   (total 70 ingrédients-recette)
--
-- Résultat obtenu (8 lignes) :
--   +-----------------+----------------+
--   | focaccia        | nb_ingredients |
--   +-----------------+----------------+
--   | Américaine      |              8 |
--   | Emmentalaccia   |              7 |
--   | Gorgonzollaccia |              8 |
--   | Hawaienne       |              9 |
--   | Mozaccia        |             10 |
--   | Paysanne        |             12 |
--   | Raclaccia       |              7 |
--   | Tradizione      |              9 |
--   +-----------------+----------------+
--
-- Écart / commentaire :
--   Aucun écart. LEFT JOIN + COUNT(colonne) : une focaccia sans ingrédient
--   apparaîtrait quand même avec 0 (elle serait perdue avec un INNER JOIN).

-- ---------------------------------------------------------------------
-- Requête 7 : Afficher le nom de la focaccia qui a le plus d'ingrédients
-- ---------------------------------------------------------------------
SELECT f.nom AS focaccia,
       COUNT(*) AS nb_ingredients
FROM focaccia f
INNER JOIN comprend c ON c.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom
HAVING COUNT(*) = (
    SELECT MAX(t.nb)
    FROM (SELECT COUNT(*) AS nb
          FROM comprend
          GROUP BY id_focaccia) AS t
);

-- Résultat attendu :
--   Paysanne (12 ingrédients)
--
-- Résultat obtenu (1 ligne) :
--   +----------+----------------+
--   | focaccia | nb_ingredients |
--   +----------+----------------+
--   | Paysanne |             12 |
--   +----------+----------------+
--
-- Écart / commentaire :
--   Aucun écart. On compare au MAX plutôt que d'utiliser ORDER BY ... LIMIT 1 :
--   en cas d'égalité, toutes les focaccias ex aequo seraient affichées.

-- ---------------------------------------------------------------------
-- Requête 8 : Afficher la liste des focaccias qui contiennent de l'ail
-- ---------------------------------------------------------------------
SELECT f.nom AS focaccia
FROM focaccia f
INNER JOIN comprend   c ON c.id_focaccia   = f.id_focaccia
INNER JOIN ingredient i ON i.id_ingredient = c.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom;

-- Résultat attendu :
--   4 focaccias : Gorgonzollaccia, Mozaccia, Paysanne, Raclaccia
--
-- Résultat obtenu (4 lignes) :
--   +-----------------+
--   | focaccia        |
--   +-----------------+
--   | Gorgonzollaccia |
--   | Mozaccia        |
--   | Paysanne        |
--   | Raclaccia       |
--   +-----------------+
--
-- Écart / commentaire :
--   Aucun écart.

-- ---------------------------------------------------------------------
-- Requête 9 : Afficher la liste des ingrédients inutilisés
-- ---------------------------------------------------------------------
SELECT i.nom AS ingredient_inutilise
FROM ingredient i
LEFT JOIN comprend c ON c.id_ingredient = i.id_ingredient
WHERE c.id_ingredient IS NULL
ORDER BY i.nom;

-- Résultat attendu :
--   2 ingrédients présents dans ingredient.xlsx mais dans aucune recette :
--   Salami, Tomate cerise
--
-- Résultat obtenu (2 lignes) :
--   +----------------------+
--   | ingredient_inutilise |
--   +----------------------+
--   | Salami               |
--   | Tomate cerise        |
--   +----------------------+
--
-- Écart / commentaire :
--   Aucun écart. 25 ingrédients au total - 23 utilisés = 2 inutilisés.

-- ---------------------------------------------------------------------
-- Requête 10 : Afficher la liste des focaccias qui n'ont pas de champignons
-- ---------------------------------------------------------------------
SELECT f.nom AS focaccia
FROM focaccia f
WHERE f.id_focaccia NOT IN (
    SELECT c.id_focaccia
    FROM comprend c
    INNER JOIN ingredient i ON i.id_ingredient = c.id_ingredient
    WHERE i.nom = 'Champignon'
)
ORDER BY f.nom;

-- Résultat attendu :
--   2 focaccias : Américaine, Hawaienne
--
-- Résultat obtenu (2 lignes) :
--   +-------------+
--   | focaccia    |
--   +-------------+
--   | Américaine  |
--   | Hawaienne   |
--   +-------------+
--
-- Écart / commentaire :
--   Aucun écart. Un simple WHERE i.nom <> 'Champignon' serait faux : il renverrait
--   toutes les focaccias (chacune a au moins un autre ingrédient). Il faut exclure
--   les focaccias qui possèdent le champignon, d'où la sous-requête NOT IN.


