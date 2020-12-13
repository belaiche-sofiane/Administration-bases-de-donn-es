
select e20160010106.finances.conversionFED(salaire) from emp;
--donner les prévilioges a un utilisateur:
grant execute on finances to e20.....;
             . ..         to public;

1) user_tables
2) user_constraints
3) dba_tables
4) all_tables
5) user_triggers
6) dba_users

/* ************************----------------------------------****************************--------------*/
/* suppression de triggers*/
create or replace procedure supprime_triggers is
cursor trigger_cursor is select trigger_name from user_triggers;
begin 
for trigger in trigger_cursor loop
execute immediate 'drop trigger ' || trigger.trigger_name;
end loop;
end;
/

/* creation de la procédure */
create or replace procedure EmployesDuDepartement(dept in number,resultat out varchar(1000)) 
is
declare
cursor resultat is select nom from emp where n_dept = dept;
dbms_output.put_line(resultat);
end;
/
 

