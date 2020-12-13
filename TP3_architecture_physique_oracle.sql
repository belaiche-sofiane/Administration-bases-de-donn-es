Question 1:
select * from v$instance;
select  HOST_NAME, STARTUP_TIME from v$instance;
prodpeda-oracle.umontpellier.fr  02/10/2020



Question 2:
select * from v$database;
NOM:cmaster
select ARCHIVELOG_CHANGE# from v$database;
ARCHIVELOG_CHANGE = 0


Question 3:
select * from v$option;
select * from v$option where value='TRUE';
True pour indiquer les options pour lesquelles on a le droit



Question 4:
select * from v$version;
version:12.2.0.1.0 

Question 5:
select * from v$session;







2.1/-

-----shared pool size:----------------
select * from v$sgainfo
Shared Pool Size ------> 419430400 bytes


-----Buffer Cache size:---------------
select * from v$sgainfo;
Buffer Cache Size ------> 889192448 bytes




----Redo buffers:--------------------
select * from v$sga;
Redo Buffers -------> 7979008 bytes 

------**********-----------****************
--question2: 
select * from v$sgastat; ------------ pour avoir plus de détails 
show parameter sharedpoolsize ----- c'est une commande qui donnne tous les détails
---question 3:

select * from v$sql, v$sqlarea, v$sqltext;

---question 4:
select p.pid, bg.name, bg.description, p.programfrom v$bgprocess bg, v$process pwhere bg.paddr = p.addr order by p.pid

--question 5:
select name,value from v$parameter;



--*-*-*-* consulter les tablespaces d ́efinis (dbatablespaces)
----emplacement des fichiers de controle:
select name from v$controlfile;

---emplacement des fichiers journaux:
select MEMBER from v$logfile;

---consulter l’emplacement des fichiers de donn ́ees (v$datafile):

/data/bases/prodpeda/CMASTER/oracle/CMASTER/PMASTER/system01.dbf
/data/bases/prodpeda/CMASTER/oracle/CMASTER/PMASTER/sysaux01.dbf
/data/bases/prodpeda/CMASTER/oracle/CMASTER/PMASTER/undotbs01.dbf
/data/bases/prodpeda/CMASTER/oracle/CMASTER/PMASTER/users01.dbf
/data/bases/prodpeda/CMASTER/oracle/CMASTER/PMASTER/DATA_ETUD.DBF


----ampon de donnees ”data buffer cache”
select file#, block#, class#, dirty, objd, object_name, ownerfrom v$bh, dba_objects where dirty = ’Y’ and objd = object_id;




------------creation de la table test:

create table teste 
(num Char (3),commentaire Char (97));


--la question 1  :V ́erifiez que que toutes vos tables sont situ ́ees dans le mˆeme tablespace et qu’il en va de mˆemepour les autres sch ́emas utilisateurs. 
desc user_tables;
select table_name,tablespace_name from user_tables;

-- la question 2: 
--remplissage de la table:

create or replace procedure remplissage (compteur number) is
i number;
comme char(97);
begin
comme := 'cot_';
for i in 0 .. compteur
loop
comme := dbms_random.value || i ;
insert into teste values (i,comme);
end loop;
end;
/

exec remplissage(999)


-----POUR RAFRAICHER LA TABLE:
analyze table TESTE compute statistics;

---la contrainte de domaine:
alter table teste add constraint quantite check (num>0 and num <999);























