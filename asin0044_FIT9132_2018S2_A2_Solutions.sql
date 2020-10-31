--Student ID: 29968550
--Student Fullname: Ashwani Kumar Singh
--Tutor Name: Mark Creado

/*  --- COMMENTS TO YOUR MARKER --------

3.3 In task 3.2 Ada is reserving one book. So, for inserting data in loan table for task 3.3 I'm
    fetching data from reserve table since there is just one entry in reserve table about Ada. 

3.4 In task 3.3 Ada has got a loan and in task 3.4 she wants to renew the book for loan. So I'm
    updating the previous loan_actual_return_date of loan table to due date because she is renewing 
    the book on due date and inserting a new row in loan table for her new loan of same book so I'm 
    retrieving values of all attribute from her previous loan record.

4.3 After reading the question requirements I came to conclusion that the relationship between branch 
    and manager is N:M. So, I'm creating a bridge entity between branch and manager to eliminate N:M 
    relationship and then inserting the values in bridge entity according to the requirements of 
    question 4.3.
    
*/

--Q1
/*
1.1
Add to your solutions script, the CREATE TABLE and CONSTRAINT definitions which are missing from the 
FIT9132_2018S2_A2_Schema_Start.sql script. You MUST use the relation and attribute names shown in the data model above 
to name tables and attributes which you add.
*/


CREATE TABLE book_copy(
    branch_code        NUMBER(2)     NOT NULL,
    bc_id              NUMBER(6)     NOT NULL,
    bc_purchase_price  NUMBER(7,2)   NOT NULL,
    bc_reserve_flag    CHAR(1)       NOT NULL,
    book_call_no       VARCHAR(20)   NOT NULL
);

ALTER TABLE book_copy ADD CONSTRAINT book_copy_pk PRIMARY KEY ( branch_code,bc_id );

COMMENT ON COLUMN book_copy.branch_code IS
    'Book copy branch code';
    
COMMENT ON COLUMN book_copy.bc_id IS
    'Book copy identifier';
    
COMMENT ON COLUMN book_copy.bc_purchase_price IS
    'Book copy purchase price';
    
COMMENT ON COLUMN book_copy.bc_reserve_flag IS
    'Book copy reserve status';
    
COMMENT ON COLUMN book_copy.book_call_no IS
    'Book copy call number';

ALTER TABLE book_copy
    ADD CONSTRAINT bc_reserve_flag_chk CHECK ( bc_reserve_flag IN ('Y','N') );


CREATE TABLE reserve(
    branch_code                    NUMBER(2)     NOT NULL,
    bc_id                          NUMBER(6)     NOT NULL,
    reserve_date_time_placed       DATE          NOT NULL,
    bor_no                         NUMBER(6)     NOT NULL
);

ALTER TABLE reserve ADD CONSTRAINT reserve_pk PRIMARY KEY ( branch_code, bc_id, reserve_date_time_placed);


COMMENT ON COLUMN reserve.branch_code IS
    'Reserve branch code identifies the branch code identifier';
    
COMMENT ON COLUMN reserve.bc_id IS
    'Reserve book copy id identifies book copy identifier';
    
COMMENT ON COLUMN reserve.reserve_date_time_placed IS
    'Reserve date and time placed ';
    
COMMENT ON COLUMN reserve.bor_no IS
    'Reserve borrower number';
   

CREATE TABLE loan(
    branch_code               NUMBER(2)  NOT NULL,
    bc_id                     NUMBER(6)  NOT NULL,
    loan_date_time            DATE       NOT NULL,
    loan_due_date             DATE       NOT NULL,
    loan_actual_return_date   DATE,
    bor_no                    NUMBER(2)  NOT NULL
);

ALTER TABLE loan ADD CONSTRAINT loan_pk PRIMARY KEY ( branch_code,bc_id,loan_date_time);


COMMENT ON COLUMN loan.branch_code IS
    'Loan branch code identifies branch code identifier';

COMMENT ON COLUMN loan.bc_id IS
    'Loan book copy identifier';

COMMENT ON COLUMN loan.loan_date_time IS
    'Loan date and time';

COMMENT ON COLUMN loan.loan_due_date IS
    'Loan due date';

COMMENT ON COLUMN loan.loan_actual_return_date IS
    'Loan actual return date';
    
COMMENT ON COLUMN loan.bor_no IS
    'Loan borrower number identifies borrower number identifier';
    
ALTER TABLE book_copy
    ADD CONSTRAINT branch_bookcopy FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE book_copy
    ADD CONSTRAINT bookdetails_bookcopy FOREIGN KEY ( book_call_no )
        REFERENCES book_detail ( book_call_no );


ALTER TABLE reserve
    ADD CONSTRAINT bookcopy_reserve FOREIGN KEY ( branch_code,bc_id )
        REFERENCES book_copy ( branch_code,bc_id );


ALTER TABLE reserve
    ADD CONSTRAINT borrower_reserve FOREIGN KEY ( bor_no )
        REFERENCES borrower ( bor_no );


ALTER TABLE loan
    ADD CONSTRAINT bookcopy_loan FOREIGN KEY ( branch_code,bc_id )
        REFERENCES book_copy ( branch_code,bc_id );

ALTER TABLE loan
    ADD CONSTRAINT borrower_loan FOREIGN KEY ( bor_no )
        REFERENCES borrower ( bor_no );

   

/*
1.2
Add the full set of DROP TABLE statements to your solutions script. In completing this section you must not use the CASCADE 
CONSTRAINTS clause as part of your DROP TABLE statement (you should include the PURGE clause).
 
*/


DROP TABLE bd_author   PURGE;

DROP TABLE author      PURGE;

DROP TABLE bd_subject  PURGE;

DROP TABLE subject     PURGE;

DROP TABLE reserve     PURGE;

DROP TABLE loan        PURGE;

DROP TABLE book_copy   PURGE;

DROP TABLE book_detail PURGE;

DROP TABLE publisher   PURGE;

DROP TABLE borrower    PURGE;

DROP TABLE branch      PURGE;

DROP TABLE manager     PURGE;


--Q2
/*
2.1
MonLib has just purchased its first 3 copies of a recently released edition of a book. Readers of this book will learn about 
the subjects "Database Design" and "Database Management". 

Some of  the details of the new book are:

	      	Call Number: 005.74 C822D 2018
Title: Database Systems: Design, Implementation, and Management
	      	Publication Year: 2018
	      	Edition: 13
	      	Publisher: Cengage
	Authors: Carlos CORONEL (author_id = 1 ) and 
   Steven MORRIS  (author_id = 2)  	      	
Price: $120
	
You may make up any other reasonable data values you need to be able to add this book.

Each of the 3 MonLib branches listed below will get a single copy of this book, the book will be available for borrowing 
(ie not on counter reserve) at each branch:

		Caulfield (Ph: 8888888881)
		Glen Huntly (Ph: 8888888882)
        Carnegie (Ph: 8888888883)

Your are required to treat this add of the book details and the three copies as a single transaction.
*/

INSERT INTO book_detail VALUES (
    '005.74 C822D 2018',
    'Database Systems: Design, Implementation, and Management',
    'R',
    891,
    TO_DATE('2018','YYYY'),
    '13',
    (
        SELECT
            pub_id
        FROM
            publisher
        WHERE
            pub_name = 'Cengage'
    )
);

INSERT INTO bd_subject VALUES (
    (
        SELECT
            subject_code
        FROM
            subject
        WHERE
            subject_details = 'Database Design'
    ),
    '005.74 C822D 2018'
);

INSERT INTO bd_subject VALUES (
    (
        SELECT
            subject_code
        FROM
            subject
        WHERE
            subject_details = 'Database Management'
    ),
    '005.74 C822D 2018'
);

INSERT INTO bd_author VALUES (
    '005.74 C822D 2018',1
);

INSERT INTO bd_author VALUES (
    '005.74 C822D 2018',2
);

INSERT INTO book_copy VALUES (
     (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888881'
    ),
     100,
     120,
     'N',
     '005.74 C822D 2018'
);

INSERT INTO book_copy VALUES (
     (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888882'
    ),
     100,
     120,
     'N',
     '005.74 C822D 2018'
);

INSERT INTO book_copy VALUES (
     (
        SELECT
            branch_code
        FROM
            branch
        WHERE
            branch_contact_no = '8888888883'
    ),
     100,
     120,
     'N',
     '005.74 C822D 2018'
);

UPDATE branch
SET branch_count_books = branch_count_books + 1
WHERE branch_code=(
SELECT branch_code
FROM branch
WHERE branch_contact_no='8888888881');

UPDATE branch
SET branch_count_books = branch_count_books + 1
WHERE branch_code=(
SELECT branch_code
FROM branch
WHERE branch_contact_no='8888888882');

UPDATE branch
SET branch_count_books = branch_count_books + 1
WHERE branch_code=(
SELECT branch_code
FROM branch
WHERE branch_contact_no='8888888883');

COMMIT;

/*
2.2
An Oracle sequence is to be implemented in the database for the subsequent insertion of records into the database for  
BORROWER table. 

Provide the CREATE 	SEQUENCE statement to create a sequence which could be used to provide primary key values for the BORROWER 
table. The sequence should start at 10 and increment by 1.
*/

CREATE SEQUENCE bor_no_seq
START WITH 10
INCREMENT BY 1;

/*
2.3
Provide the DROP SEQUENCE statement for the sequence object you have created in question 2.2 above. 
*/

DROP SEQUENCE bor_no_seq;

--Q3
/*
--3.1
Today is 20th September, 2018, add a new borrower in the database. Some of the details of the new borrower are:

		Name: Ada LOVELACE
		Home Branch: Caulfield (Ph: 8888888881)

You may make up any other reasonable data values you need to be able to add this borrower.

*/

INSERT INTO borrower VALUES (
    bor_no_seq.nextval,
    'Ada',
    'LOVELACE',
    'Hirapur',
    'Dhanbad',
    '8260',
    ( SELECT branch_code 
      FROM branch
      WHERE branch_contact_no='8888888881' )
);

COMMIT;

/*
--3.2
Immediately after becoming a member, at 4PM, Ada places a reservation on a book at the Carnegie branch (Ph: 8888888883). Some 
of the details of the book that Ada  has placed a reservation on are:

		Call Number: 005.74 C822D 2018
        Title: Database Systems: Design, Implementation, and Management
		Publication Year: 2018
		Edition: 13

You may assume:
MonLib has not purchased any further copies of this book, beyond those which you inserted in Task 2.1
that nobody has become a member of the library between Ada becoming a member and this reservation.

*/

INSERT INTO RESERVE ( branch_code, bc_id, reserve_date_time_placed, bor_no)
VALUES
( (SELECT branch_code FROM BRANCH
WHERE branch_contact_no = '8888888883'), (SELECT bc_id FROM BOOK_COPY
WHERE book_call_no = '005.74 C822D 2018' and branch_code = ( SELECT branch_code FROM BRANCH
WHERE branch_contact_no = '8888888883')), TO_DATE('20/09/2018 16:00:00', 'DD/MM/YYYY HH24:MI:SS'), (SELECT bor_no FROM BORROWER
WHERE bor_fname = 'Ada' AND bor_lname = 'LOVELACE'));

commit;

/*
3.3
After 7 days from reserving the book, Ada receives a notification from the Carnegie library that the book she had placed
reservation on is available. Ada is very excited about the book being available as she wants to do very well in FIT9132 unit 
that she is currently studying at Monash University. Ada goes to the library and borrows the book at 2 PM on the same day of 
receiving the notification.

You may assume that there is no other borrower named Ada Lovelace.
*/

INSERT INTO loan VALUES
((select branch_code 
from RESERVE 
where bor_no = 
(select bor_no 
from BORROWER 
where bor_fname = 'Ada' and bor_lname = 'LOVELACE')),
(select bc_id 
from RESERVE 
where bor_no = 
(select bor_no 
from BORROWER 
where bor_fname = 'Ada' and bor_lname = 'LOVELACE')), 
to_date((select reserve_date_time_placed 
from reserve 
where bor_no = 
(select bor_no 
from BORROWER 
where bor_fname = 'Ada' and bor_lname = 'LOVELACE'))+(7-(1/12))),
to_date((select reserve_date_time_placed 
from reserve 
where bor_no = 
(select bor_no 
from BORROWER 
where bor_fname = 'Ada' and bor_lname = 'LOVELACE'))+(35-(1/12))),
Null,
(select bor_no from BORROWER where bor_fname = 'Ada' and bor_lname = 'LOVELACE'));

commit;


/*
3.4
At 2 PM on the day the book is due, Ada goes to the library and renews the book as her exam for FIT9132 is in 2 weeks.
		
You may assume that there is no other borrower named Ada Lovelace.
*/



update LOAN
set loan_actual_return_date = (select loan_due_date from loan where 
bor_no =(select bor_no from borrower where bor_fname='Ada' and bor_lname='LOVELACE'));

INSERT INTO loan VALUES
((select branch_code 
from loan 
where bor_no = 
(select bor_no 
from BORROWER 
where bor_fname = 'Ada' and bor_lname = 'LOVELACE')),
(select bc_id 
from loan 
where bor_no = 
(select bor_no 
from BORROWER 
where bor_fname = 'Ada' and bor_lname = 'LOVELACE')), 
(select loan_due_date from loan where 
bor_no =(select bor_no from borrower where bor_fname='Ada' and bor_lname='LOVELACE')),
to_date((select loan_due_date from loan where 
bor_no =(select bor_no from borrower where bor_fname='Ada' and bor_lname='LOVELACE'))+(28)),
Null,
(select bor_no from BORROWER where bor_fname = 'Ada' and bor_lname = 'LOVELACE'));

commit;


--Q4
/*
4.1
Record whether a book is damaged (D) or lost (L). If the book is not damaged or lost,then it  is good (G) which means, 
it can be loaned. The value cannot be left empty  for this. Change the "live" database and add this required information 
for all the  books currently in the database. You may assume that condition of all existing books will be recorded as being 
good. The information can be updated later, if need be. 
*/





ALTER TABLE book_copy ADD book_condition VARCHAR(1);
ALTER TABLE book_copy MODIFY book_condition NOT NULL NOVALIDATE; 

    
COMMENT ON COLUMN book_copy.book_condition IS
 'Condition of book';
 
ALTER TABLE book_copy
    ADD CONSTRAINT book_condition_check CHECK ( book_condition IN (
        'G',
        'D','L'
    ) );
 
UPDATE book_copy SET book_condition = 'G';


COMMIT;




/*
4.2
Allow borrowers to be able to return the books they have loaned to any library branch as MonLib is getting a number of requests 
regarding this from borrowers. As part of this process MonLib wishes to record which branch a particular loan is returned to. 
Change the "live" database and add this required information for all the loans  currently in the database. For all completed 
loans, to this time, books were returned at the same branch from where those were loaned.
*/


ALTER TABLE loan ADD loan_return_branch NUMBER(2);

COMMENT ON COLUMN loan.loan_return_branch IS
 ' Branch where loan is returned '
 
 UPDATE loan 
SET loan_return_branch = branch_code
WHERE loan_actual_return_date IS NOT NULL;

COMMIT; 
  




/*
4.3
Some of the MonLib branches have become very large and it is difficult for a single manager to look after all aspects of the 
branch. For this reason MonLib are intending to appoint two managers for the larger branches starting in the new year - one 
manager for the Fiction collection and another for the Non-Fiction collection. The branches which continue to have one manager 
will ask this manager to manage the branches Full collection. The number of branches which will require two managers is quite 
small (around 10% of the total MonLib branches). Change the "live" database to allow monLib the option of appointing two 
managers to a branch and track and also record, for all managers, which collection/s they are managing. 

In the new year, since the Carnegie branch (Ph: 8888888883) has a huge collection of books in comparison to the Caulfield and 
Glen Huntly branches, Robert (Manager id: 1) who is currently managing the Caulfield branch (Ph: 8888888881) has been asked to 
manage the Fiction collection of the Carnegie branch, as well as the full collection at the Caulfield branch. Thabie 
(Manager id: 2) who is currently managing the Glen Huntly branch (Ph: 8888888882) has been asked to manage the Non-Fiction 
collection of Carnegie branch, as well as the full collection at the Glen Huntly branch. Write the code to implement these 
changes.
*/



DROP TABLE aspect_manager CASCADE CONSTRAINT PURGE;

ALTER TABLE branch DROP CONSTRAINT manager_branch;

CREATE TABLE aspect_manager(
branch_code NUMBER(2) NOT NULL,
man_id NUMBER(2) NOT NULL,
aspect_type CHAR(4) NOT NULL
);

COMMENT ON COLUMN aspect_manager.branch_code IS
    'Branch code of manager';
    
COMMENT ON COLUMN aspect_manager.man_id IS
    'Manager id of manager';
    
COMMENT ON COLUMN aspect_manager.aspect_type IS
    'Aspect type of manager of managing branch';

ALTER TABLE aspect_manager 
ADD CONSTRAINT aspect_manager_pk  
PRIMARY KEY (branch_code,man_id );

ALTER TABLE aspect_manager 
ADD CONSTRAINT branch_aspect_manager
FOREIGN KEY(branch_code)
REFERENCES branch(branch_code);

ALTER TABLE aspect_manager 
ADD CONSTRAINT manager_aspect_manager
FOREIGN KEY(man_id)
REFERENCES manager(man_id);

ALTER TABLE aspect_manager
ADD CONSTRAINT aspect_type_chk 
CHECK ( aspect_type 
IN ( 'FULL','F','NF'));

INSERT INTO aspect_manager VALUES (
(SELECT branch_code 
FROM branch
WHERE branch_contact_no = '8888888883'),
1,'F');

INSERT INTO aspect_manager VALUES (
(SELECT branch_code 
FROM branch
WHERE branch_contact_no = '8888888881'),
1,'FULL');

INSERT INTO aspect_manager VALUES (
(SELECT branch_code 
FROM branch
WHERE branch_contact_no = '8888888883'),
2,'NF');

INSERT INTO aspect_manager VALUES (
(SELECT branch_code 
FROM branch
WHERE branch_contact_no = '8888888882'),
2,'FULL');

COMMIT;