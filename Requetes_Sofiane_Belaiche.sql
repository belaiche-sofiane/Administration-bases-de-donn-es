
--Sofiane belaiche


--partie 1


--creation de package DataCacheMetrics

create or replace package DataCacheMetrics 
as
function blocksNumberInDataCache return integer ;
function allocatedBytesInDataCache return integer ;
function ratioCachePerUser (username varchar) return float ;
function blocksNumberPerTablespace (tsname varchar) return integer ;
end DataCacheMetrics;
/


--fonction1:
create or replace package body DataCacheMetrics 
as
replace function allocatedBytesInDataCache return integer
is
begin
declare
nombreOctets number;
begin
select value into nombreOctets from v$parameter where name ='db_block_size';
return nombreOctets*blocksNumberInDataCache;
exception when others then return -1;
end;
end;


--fonction3
function blocksNumberPerTablespace(tsname  varchar)
return number
is 
begin
declare
res number;
Cursor c is

select count(block#) from v$bh, v$tablespace  where v$bh.ts#=v$tablespace.ts# and v$tablespace.NAME=tsname;
begin
open c;
fetch c into res;
return res;
end;
end;

end DataCacheMetrics;
/

--question2

create or replace procedure afficheBlocsParTableSpace 
is
var number;
Cursor c is select name from v$tablespace;
begin
var := blocksNumberPerTablespace('c.name');
DBMS_OUTPUT.PUT_LINE('le resultats: ' || var);
   
end;
/ 


--question3
---test de la fonction allocatedBytesInDataCache
--la requete:
select  allocatedBytesInDataCache from dual;
---le resultat:
ALLOCATEDBYTESINDATACACHE
-------------------------
		579616768

---partie 2
set linesize 200 --> controle le nombre de caractéres que SQL imprime sur une ligne physique et dans ce cas il imprime 200 caractéres par ligne.
col osuser for a30 --> c'est une requete qui controle la taille de la colonne osuser afin de réguler le nombre de caractéres qui s'affichent et dans ce cas c'est 30.
select s.sid, s.osuser, substr(a.sql_text,1,60), plan_hash_value from v$session s join v$sqlarea  a on a.hash_value = s.prev_hash_value ; --c'est une requete qui permet d'afficher les 
-- utilisateurs de la base de données ainsi que leurs derniéres requetes exécutées.









