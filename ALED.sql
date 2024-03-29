-- CREATE ROLE & TABLESPACE & USER logistique --

CREATE ROLE logistique;
GRANT SELECT, UPDATE ON Produits TO logistique;
GRANT SELECT, UPDATE ON Category TO logistique;

CREATE BIGFILE TABLESPACE tbs_logistique
DATAFILE 'logistique_datatbs.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M
ONLINE;

CREATE USER usr_logistique_1 IDENTIFIED BY usr_logistique_1
DEFAULT TABLESPACE tbs_logistique
TEMPORARY TABLESPACE tbs_temp
QUOTA 100K ON tbs_logistique
profile Utilisateur
ACCOUNT UNLOCK;
GRANT CREATE SESSION TO usr_logistique_1;
GRANT logistique TO usr_logistique_1;


-- CREATE ROLE & TABLESPACE & USER commerce --

CREATE ROLE commerce;
GRANT SELECT, UPDATE ON Facture TO commerce;
GRANT SELECT, UPDATE ON Client TO commerce;

CREATE BIGFILE TABLESPACE tbs_commerce
DATAFILE 'commerce_datatbs.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M
ONLINE;

CREATE USER usr_commerce_1 IDENTIFIED BY usr_commerce_1
DEFAULT TABLESPACE tbs_commerce
TEMPORARY TABLESPACE tbs_temp
QUOTA 100K ON tbs_commerce
profile Utilisateur
ACCOUNT UNLOCK;
GRANT CREATE SESSION TO usr_commerce_1;
GRANT commerce TO usr_commerce_1;

CREATE USER usr_commerce_2 IDENTIFIED BY usr_commerce_2
DEFAULT TABLESPACE tbs_commerce
TEMPORARY TABLESPACE tbs_temp
QUOTA 100K ON tbs_commerce
profile Utilisateur
ACCOUNT UNLOCK;
GRANT CREATE SESSION TO usr_commerce_2;
GRANT commerce TO usr_commerce_2;


-- CREATE ROLE & TABLESPACE & USER  ressource --

CREATE ROLE ressource;
GRANT SELECT, UPDATE ON Employee TO ressource;

CREATE BIGFILE TABLESPACE tbs_ressource
DATAFILE 'ressource_exo_datatbs.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M
ONLINE;

CREATE USER usr_ressource_1 IDENTIFIED BY usr_ressource_1
DEFAULT TABLESPACE tbs_ressource
TEMPORARY TABLESPACE tbs_temp
QUOTA 100K ON tbs_ressource
profile Utilisateur
ACCOUNT UNLOCK;
GRANT CREATE SESSION TO usr_ressource_1;
GRANT ressource TO usr_ressource_1;


-- CREATE TABLESPACE TEMP --

CREATE BIGFILE TEMPORARY TABLESPACE tbs_temp
TEMPFILE 'exo_temp_datatbs.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M;

-- CREATE ROLE & USER & logistique_A --

CREATE ROLE logistique_A;
GRANT SELECT ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE, CREATE ANY TABLE, DELETE ANY TABLE, UPDATE ANY TABLE, INSERT ANY TABLE TO logistique_A;

CREATE USER usr_logistique_admin IDENTIFIED BY usr_logistique_admin
DEFAULT TABLESPACE tbs_logistique
TEMPORARY TABLESPACE tbs_temp
QUOTA 100K ON tbs_logistique
profile Admin
ACCOUNT UNLOCK;
GRANT CREATE SESSION TO usr_logistique_admin;
GRANT logistique_A TO usr_logistique_admin;


-- CREATE ROLE & USER & commerce_A --

CREATE ROLE commerce_A;
GRANT SELECT ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE, CREATE ANY TABLE, DELETE ANY TABLE, UPDATE ANY TABLE, INSERT ANY TABLE TO commerce_A;

CREATE USER usr_commerce_admin IDENTIFIED BY usr_commerce_admin
DEFAULT TABLESPACE tbs_commerce
TEMPORARY TABLESPACE tbs_temp
QUOTA 100K ON tbs_commerce
profile Admin
ACCOUNT UNLOCK;
GRANT CREATE SESSION TO usr_commerce_admin;
GRANT commerce_A TO usr_commerce_admin;


-- CREATE ROLES logistique_G & commerce_G & ressource_G --

CREATE ROLE logistique_G;
CREATE ROLE commerce_G;
CREATE ROLE ressource_G;


-- ROLES_G TO ROLES & ROLES_A --

GRANT logistique_G TO logistique;
GRANT commerce_G TO commerce;
GRANT ressource_G TO ressource;

GRANT logistique_G TO logistique_A;
GRANT commerce_G TO commerce_A;

-- CREATE PROFILES --

CREATE PROFILE Utilisateur LIMIT
SESSIONS_PER_USER 10
CPU_PER_SESSION UNLIMITED
CPU_PER_CALL 1500
CONNECT_TIME 150
IDLE_TIME 50;

ALTER PROFILE Utilisateur LIMIT
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LIFE_TIME 100
PASSWORD_REUSE_TIME 150
PASSWORD_REUSE_MAX 5
PASSWORD_LOCK_TIME 6
PASSWORD_GRACE_TIME 20;


-- CREATE TABLES & KEYS --

CREATE TABLE Produits(
    Produit_id NUMBER GENERATED AS IDENTITY,
    Produit_name VARCHAR(255),
    Produit_category INT,
    Produit_price float,
    Produit_stock int)
TABLESPACE tbs_logistique;
ALTER TABLE Produits
ADD CONSTRAINT produit_pk PRIMARY KEY (Produit_id);

CREATE TABLE Category(
    Category_id NUMBER GENERATED BY DEFAULT AS IDENTITY START WITH 10 INCREMENT BY 10,
    Category_name VARCHAR(255) NOT NULL,
    Category_desc VARCHAR(255) NOT NULL,
    Category_sum_product_price NUMBER NOT NULL,
    Category_sum_product_stock NUMBER NOT NULL)
TABLESPACE tbs_logistique;
ALTER TABLE category
ADD CONSTRAINT category_pk PRIMARY KEY (Category_id);

ALTER TABLE Produits
    ADD CONSTRAINT fk_category_products
    FOREIGN KEY (Produit_category)
    REFERENCES category (Category_id);
    
    
CREATE TABLE Facture(
    Facture_id NUMBER GENERATED BY DEFAULT AS IDENTITY, 
    Facture_client INT,
    Date_facture DATE,
    Facture_desc VARCHAR(255) NOT NULL,
    Montant NUMBER(8, 2))
TABLESPACE tbs_commerce;
ALTER TABLE CLIENT
ADD CONSTRAINT facture_pk PRIMARY KEY (Facture_client);

CREATE TABLE Client(
    Client_id NUMBER GENERATED BY DEFAULT AS IDENTITY, 
    Nom_client VARCHAR(255), 
    Prenom_client VARCHAR(255), 
    Adresse_mail VARCHAR(255),
    Date_creation DATE)
TABLESPACE tbs_commerce;
ALTER TABLE CLIENT
ADD CONSTRAINT client_pk PRIMARY KEY (Client_id);

CREATE TABLE Employee(
    Employee_id NUMBER GENERATED BY DEFAULT AS IDENTITY, 
    Employee_nom VARCHAR(255), 
    Employee_prenom VARCHAR(255), 
    Employee_mail VARCHAR(255),
    Employee_telephone VARCHAR(255),
    Employee_salaire INT,
    Employee_date_naissance DATE,
    Employee_date_embauche DATE)
TABLESPACE tbs_ressource;
ALTER TABLE CLIENT
ADD CONSTRAINT employee_pk PRIMARY KEY (Employee_id);

-- J'ai mal à la tête sans rire, j'ai pas tout testé car j'en peux plus donc il y a surement des commandes qui bug --