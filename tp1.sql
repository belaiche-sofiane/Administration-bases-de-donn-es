drop table DEPT cascade constraints;
drop table EMP cascade constraints;



/* ajout de la clé primaire */
Alter table DEPT add constraint ndept_PK primary key(n_dept);
Alter table EMP add constraint num_PK primary key(num);
/*ajout de la clé étrangére */
Alter table EMP add constraint dom foreign key(n_dept) references DEPT(n_dept); 
Alter table EMP add constraint top foreign key(n_sup) references EMP(num) on delete cascades; 



/* insertion de la tuple suivante afin d'eviter une erreur dans la table DEPT */
INSERT INTO DEPT VALUES
        (100,'direction','Montpellier');

/*rlwrap sqlplus e20160010106/tempo@oracle.etu.umontpellier.fr:1523/pmaster
*/





/* Question 1: */
/* création de Trigger afin de vérifier le salaire à chague ajout d'individu dans la table */
create or replace trigger ouv
after insert or update of salaire on EMP
for each row
begin
if (:new.salaire < 0)

then
raise_application_error(-20010, 'Erreur de salaire') ;
end if ;
end ;
/
/* vérification le bon fonctionnement de Trigger */
INSERT INTO EMP VALUES
        ('Sofiane',16733,'directeur',22715,'23-may-92',3333,NULL,30);

/* Question 2: le trigger qui verifier le salaire des ouvriers de departement 10 */

create or replace trigger VerificationSalaire
before insert or update of salaire on EMP	
for each row
when (new.n_dept = 10)
begin
if (:new.salaire < 1000)
then
raise_application_error(-20010, 'Erreur de salaire') ;
end if ;
end ;
/

 /* vérification le bon fonctionnement de trigger*/
INSERT INTO EMP VALUES
        ('JOUBERT',25718,'president',NULL,'10-oct-92',300,NULL,10);


/* Question 3: procedure qui verfier la date */

create OR REPLACE procedure pro_ouvrable is
begin
if (to_char(sysdate,'day')='samedi') or (to_char(sysdate,'day')='dimanche')
then
raise_application_error(-20010, 'Modification interdite le '||to_char(sysdate,'day') ) ;
end if ;
end ;
/



/*creation trigger*/
create or replace trigger verification_jour_ouvrable
after delete or insert or update on EMP
begin
pro_ouvrable;
end;
/

/*********testtttt***/
INSERT INTO EMP VALUES
        ('MARTIN',16710,'directeur',25717,'23/06/1990',20000,NULL,30);




/*question4*/:
create table historique (dateOperation date, nomUsager varchar(50), typeOperation varchar(50));

create or replace trigger TableHistorique 
after insert or update or delete on dept 
for each row 

declare
typeOperation varchar(50);
begin
if inserting then typeOperation:='insertion';
elsif updating then typeOperation:='update';
elsif deleting then typeOperation:='delete';

end if;
insert into historique values(sysdate,user,typeOperation);
end;
/

/*question 5 */:
create or replace trigger cascade 
after update or delete on dept
for each row 
declare
oldvalue dept.n_dept%type;
newvalue dept.n_dept%type;
begin
oldvalue := :old.n_dept;
newvalue := :new.n_dept;
if deleting then delete from emp where n_dept=oldvalue;
elsif updating then update emp set n_dept= newvalue where n_dept=oldvalue;

end if;
end;
/












































