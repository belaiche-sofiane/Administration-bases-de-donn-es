


-- BELAICHE SOFIANE M2 IPS



--*******CHARGEMENT DES DONNÉES******* 
--1) script creation de la table:
create table Population(codeinsee varchar(6), annee integer, valpopulation integer, constraint pk primary key(codeinsee,annee));



--2) creation de fichier de controle:"

LOAD DATA 
CHARACTERSET UTF8
INFILE 'tuples.csv'
APPEND
INTO TABLE Population
FIELDS TERMINATED BY ','  
(codeinsee, annee,valpopulation)


--3) resultat de la requéte sur la vue usertables: 
ANALYZE TABLE Population COMPUTE STATISTICS;
--***- La requette **--
select table_name , num_rows,BLOCKS from user_tables where table_name = 'POPULATION';

--**** Resultats**--

TABLE_NAME	NUM_ROWS	BLOCKS
-----------------------------------------
POPULATION	1306821	         3520


-----*********Migration de schemas*****--

--2.1- Procedure qui affiche l'ordre de creation d'une table :

CREATE OR REPLACE PROCEDURE UneTable (nomTable in  varchar)
as
cursor curseur is select dbms_metadata.get_ddl('TABLE', table_name, 'E20160010106') as resultats from user_tables WHERE table_name=nomTable;
begin
    FOR rec in curseur 
    LOOP 
        DBMS_OUTPUT.PUT_LINE('resultat:' || rec.resultats); 
      END LOOP;
end;
/

--2.2- Fonction qui affiche l'ordre de création de toutes les tables:

create or replace function ToutesTables (nomUser  varchar)
return clob
is 
begin
declare
res clob;
cursor c is select dbms_metadata.get_ddl('TABLE',TABLE_NAME) as resultats  FROM DBA_TABLES WHERE OWNER=nomUser;
begin
DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false);
DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'PRETTY',false);
for var in c
loop
res:= res || var.resultats;
end loop;
return res;
end;
end;
/



--2.3-fonction nommee ToutesTablesInfos qui renvoie les ordres de creation des tables avec les infos de stockage

create or replace function ToutesTablesInfos (nomUser  varchar)
return clob
is 
begin
declare
res clob;
cursor c is select dbms_metadata.get_ddl('TABLE',TABLE_NAME) as resultats  FROM DBA_TABLES WHERE OWNER=nomUser;
begin
DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',true);
DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'PRETTY',false);
for var in c
loop
res:= res || var.resultats;
end loop;
return res;
end;
end;
/
--****informations associees `a l’organisation physique de la table:*************------

---version commentée de la table population:

--*** La requéte:

select dbms_metadata.get_ddl('TABLE','POPULATION')  FROM DBA_TABLES WHERE OWNER='E20160010106';

---***-Resultats:
CREATE TABLE "E20160010106"."POPULATION" ----Création de la table population
   (	"CODEINSEE" VARCHAR2(6),
	"ANNEE" NUMBER(*,0),
	"VALPOPULATION" NUMBER(*,0),
	 CONSTRAINT "PK" PRIMARY KEY ("CODEINSEE", "ANNEE") ---Création de la clée primaire pour les deux attributs(codeinsee,annee)
  USING INDEX PCTFREE 10 ----10% de l'espace reservé dans chaque bloc pour les mises à jour a venir
  INITRANS 2 --nombre initial d’entrees de transactions pre-allouees a un bloc
  MAXTRANS 255 ---nombre maximum de transactions concurrentes qui peuvent modifier unbloc alloue à une table
  COMPUTE STATISTICS
  STORAGE(INITIAL 65536 --taille en octets du premier extent
  NEXT 1048576 --taille en octets du extent suivant
  MINEXTENTS 1 MAXEXTENTS 2147483645 --infos concernant le stockage
  PCTINCREASE 0 --pourcentage d’augmentation entre 2 extents
  FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA_ETUD"  ENABLE

DBMS_METADATA.GET_DDL('TABLE','POPULATION')
--------------------------------------------------------------------------------
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED  40 --pourcentage minimum d’espace utilise dans un bloc  
  INITRANS 1 --nombre initial d’entrees de transactions pre-allouees `a un bloc
  MAXTRANS 255 ---nombre maximum de transactions concurrentes qui peuvent modifier unbloc alloue à une table
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 --infos concernant le stockage
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA_ETUD"




--*******Informations sur les organisations logique/physique*********------:

create or replace procedure Organisation
as
cursor curseur is select owner, segment_type, count(segment_name)  a, sum(bytes) octets  , sum(blocks) blocs,sum(extents) extensions from dba_segments group by owner,segment_type order by octets asc;
begin
    FOR rec in curseur 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(rec.owner ||'  segement_type:  ' || rec.segment_type || '   segment_name:  ' || rec.a || '  octets:  ' || rec.octets ||'  blocs:  ' || rec.blocs || '  extensions:  ' ||rec.extensions ); 
      END LOOP;
end;
/



-- Fonction GETXML du paquetage DBMSMETADATA
--1) fonction nommee TableXML qui renvoie la description XML d’une table en particulier du schema utilisateur

CREATE OR REPLACE function UneTableXml(nomTable varchar)
return clob
is 
begin
declare
res clob;
cursor c is select dbms_metadata.get_xml('TABLE', table_name,'E20160010106') as resultats from user_tables WHERE table_name=nomTable;
begin
for var in c
loop
res:=  var.resultats;
end loop;
return res;
end;
end;
/


--2) TableDataXML qui prend en argument le nom d’une table mais aussi une condition de filtre(clause where)
create or replace function TableDataXML (attribut varchar, nomTable varchar,filtre varchar) 
return clob
is
begin
declare
varr clob;
cursor c is select dbms_xmlgen.getxml(dbms_xmlgen.newcontext('select ' || attribut || ' from ' || nomTable || ' where ' || filtre)) as resultats from dual;
begin
for r in c
loop
varr := varr || r.resultats;
end loop;
return varr;
end;
end;
/


---***********Export des donnees********************:
--***  procedure qui permet de renvoyer les donnees correspondant au codeinsee, nom de la commune, valeur de la population en 2000, et valeur de la population en 2010 au format tabule

create or replace procedure factory_population
is
cursor reg is select p.codeinsee, valpopulation, annee, nomcommin from population p, commune c where p.codeinsee = c.codeinsee and annee in (2000,2010);
begin
for reg_t in reg
loop 
dbms_output.put_line(reg_t.codeinsee||chr(9)||reg_t.valpopulation||chr(9)||reg_t.annee||chr(9)||reg_t.nomcommin||chr(13)) ;
end loop ;
exception
when others then dbms_output.put_line('Pb sur affichage') ;
end ;
/






















