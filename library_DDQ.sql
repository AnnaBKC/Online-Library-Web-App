CREATE TABLE `members`(
    `mem_id` INT UNIQUE NOT NULL AUTO_INCREMENT,
    `mem_first_name` VARCHAR(255) NOT NULL,
    `mem_mid_name` VARCHAR(255),
    `mem_last_name` VARCHAR(255) NOT NULL,
    `mem_email` VARCHAR(255) UNIQUE NOT NULL,
    `mem_zip_code` CHAR(5) NOT NULL,
    PRIMARY KEY (`mem_id`)
);

CREATE TABLE `loans`(
    `loan_id` INT UNIQUE NOT NULL AUTO_INCREMENT,
    `mem_id` INT NOT NULL,
    `loan_date` DATE NOT NULL,
    PRIMARY KEY (`loan_id`),
    FOREIGN KEY (`mem_id`) REFERENCES `members`(`mem_id`) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE `authors`(
    `auth_id` INT UNIQUE NOT NULL AUTO_INCREMENT,
    `auth_first_name` VARCHAR(255) NOT NULL,
    `auth_mid_name` VARCHAR(255),
    `auth_last_name` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`auth_id`)
);

CREATE TABLE `books`(
    `book_id` INT UNIQUE NOT NULL AUTO_INCREMENT,
    `isbn` VARCHAR(255) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `auth_id` INT NOT NULL,
    `year` INT NOT NULL,
    `copies_available` INT NOT NULL,
    PRIMARY KEY (`book_id`),
    FOREIGN KEY (`auth_id`) REFERENCES `authors`(`auth_id`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `book_loan`(
    `loan_id` INT NOT NULL,
    `book_id` INT NOT NULL, 
    `loan_status` BOOLEAN NOT NULL DEFAULT 1,
    PRIMARY KEY (`loan_id`,`book_id`),
    FOREIGN KEY (`loan_id`) REFERENCES `loans`(`loan_id`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`book_id`) REFERENCES `books`(`book_id`) ON UPDATE CASCADE ON DELETE CASCADE
);


-- SAMPLE DATA 

INSERT INTO `members` (mem_first_name, mem_mid_name, mem_last_name, mem_email, mem_zip_code) VALUES 
('Jane', 'H', 'Smith', 'janesmith@test.com', '98054'),
('George', NULL , 'Sawyer', 'georgesw@test.com', '97551'),
('Brian', 'Jonathan', 'Parker', 'brianparker@test.com', '67871'),
('Lauren', 'Lily', 'MacArthur', 'laurenmac@test.com', '40133');

INSERT INTO `authors` (auth_first_name, auth_mid_name, auth_last_name) VALUES
('John', 'Ray', 'Grisham')
,('Jane', NULL, 'Austen')
,('Stephen', 'Edwin', 'King')
,('Nicholas', 'Charles', 'Sparks')
,('J.K.',NULL,'Rowling')
,('W.','Frederick','Zimmerman')
,('Douglas',NULL,'Adams')
,('Bill',NULL,'Bryson')
,('J.R.R.',NULL,'Tolkien')
,('Jude',NULL,'Fisher')
,('Gary',NULL,'Paulsen')
,('Molly',NULL,'Hatchet')
,('Dale',NULL,'Peck')
,('Delia',NULL,'Sherman')
,('Patricia','A.','McKillip')
,('Zilpha','Keatley','Snyder')
,('Kate',NULL,'Horsley')
,('Philippa',NULL,'Carr')
,('Edward','P.','Jones')
,('Satyajit',NULL,'Das')
,('Mark',NULL,'Smylie')
,('John',NULL,'McPhee')
,('Wendy',NULL,'Wasserstein')
,('Heidi','Hayes','Jacobs')
,('Heidi',NULL,'Boyd')
,('Frank',NULL,'Herbert')
,('Brian',NULL,'Herbert')
,('Gary',NULL,'Russell')
,('Bryce',NULL,'Courtenay')
,('Dave',NULL,'Lakhani')
,('Louis','E.','Catron')
,('Adam',NULL,'Ginsberg')
,('Marsha',NULL,'Collier');

INSERT INTO `books` (isbn, title, auth_id, year, copies_available) VALUES
('0446520802', 'The Notebook', (SELECT auth_id FROM authors WHERE auth_first_name = 'Nicholas' AND auth_last_name = 'Sparks'), '1996', 10),
('0440245923', 'The Firm', (SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'Grisham'), '2009', 10),
('1840227931', 'Pride and Prejudice', (SELECT auth_id FROM authors WHERE auth_first_name = 'Jane' AND auth_last_name = 'Austen'), '2019', 10),
('0345806786', 'The Shining', (SELECT auth_id FROM authors WHERE auth_first_name = 'Stephen' AND auth_last_name = 'King'), '2013', 10),
('439785960','Harry Potter and the Half-Blood Prince (Harry Potter  #6)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.K.' AND auth_last_name = 'Rowling'),'2006',10),
('439358078','Harry Potter and the Order of the Phoenix (Harry Potter  #5)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.K.' AND auth_last_name = 'Rowling'),'2004',10),
('439554896','Harry Potter and the Chamber of Secrets (Harry Potter  #2)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.K.' AND auth_last_name = 'Rowling'),'2003',10),
('043965548X','Harry Potter and the Prisoner of Azkaban (Harry Potter  #3)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.K.' AND auth_last_name = 'Rowling'),'2004',10),
('439682584','Harry Potter Boxed Set  Books 1-5 (Harry Potter  #1-5)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.K.' AND auth_last_name = 'Rowling'),'2005',10),
('976540606','Unauthorized Harry Potter Book Seven News: Half-Blood Prince Analysis and Speculation',(SELECT auth_id FROM authors WHERE auth_first_name = 'W.' AND auth_last_name = 'Zimmerman'),'2005',10),
('439827604','Harry Potter Collection (Harry Potter  #1-6)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.K.' AND auth_last_name = 'Rowling'),'2005',10),
('517226952','The Ultimate Hitchhikers Guide: Five Complete Novels and One Story (Hitchhikers Guide to the Galaxy  #1-5)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Douglas' AND auth_last_name = 'Adams'),'2005',10),
('345453743','The Ultimate Hitchhikers Guide to the Galaxy (Hitchhikers Guide to the Galaxy  #1-5)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Douglas' AND auth_last_name = 'Adams'),'2002',10),
('1400052920','The Hitchhikers Guide to the Galaxy (Hitchhikers Guide to the Galaxy  #1)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Douglas' AND auth_last_name = 'Adams'),'2004',10),
('739322206','The Hitchhikers Guide to the Galaxy (Hitchhikers Guide to the Galaxy  #1)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Douglas' AND auth_last_name = 'Adams'),'2005',10),
('517149257','The Ultimate Hitchhikers Guide (Hitchhikers Guide to the Galaxy  #1-5)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Douglas' AND auth_last_name = 'Adams'),'1996',10),
('076790818X','A Short History of Nearly Everything',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'2004', 10),
('767915062','Bill Brysons African Diary',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'2002',10),
('767910435','Brysons Dictionary of Troublesome Words: A Writer Guide to Getting It Right',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'2004',10),
('767903862','In a Sunburned Country',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'2001',10),
('076790382X','I am a Stranger Here Myself: Notes on Returning to America After Twenty Years Away',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'2000',10),
('60920084','The Lost Continent: Travels in Small Town America',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'1990',10),
('380713802','Neither Here nor There: Travels in Europe',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'1993',10),
('380727501','Notes from a Small Island',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'1997',10),
('380715430','The Mother Tongue: English and How It Got That Way',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bill' AND auth_last_name = 'Bryson'),'1991',10),
('345538374','J.R.R. Tolkien 4-Book Boxed Set: The Hobbit and The Lord of the Rings',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.R.R.' AND auth_last_name = 'Tolkien'),'2012',10),
('618517650','The Lord of the Rings (The Lord of the Rings  #1-3)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.R.R.' AND auth_last_name = 'Tolkien'),'2004',10),
('618346252','The Fellowship of the Ring (The Lord of the Rings  #1)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.R.R.' AND auth_last_name = 'Tolkien'),'2003',10),
('618260587','The Lord of the Rings (The Lord of the Rings  #1-3)',(SELECT auth_id FROM authors WHERE auth_first_name = 'J.R.R.' AND auth_last_name = 'Tolkien'),'2002',10),
('618510826','The Lord of the Rings: Complete Visual Companion',(SELECT auth_id FROM authors WHERE auth_first_name = 'Jude' AND auth_last_name = 'Fisher'),'2004',10),
('689840926','Hatchet (Brians Saga  #1)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Gary'AND auth_last_name = 'Paulsen'),'2000',10),
('385326505','Guts: The True Stories behind Hatchet and the Brian Books',(SELECT auth_id FROM authors WHERE auth_first_name = 'Gary'AND auth_last_name = 'Paulsen'),'2001',10),
('1575606240','Molly Hatchet - 5 of the Best',(SELECT auth_id FROM authors WHERE auth_first_name = 'Molly' AND auth_last_name = 'Hatchet'),'2003',10),
('1595580271','Hatchet Jobs: Writings on Contemporary Fiction',(SELECT auth_id FROM authors WHERE auth_first_name = 'Dale' AND auth_last_name = 'Peck'),'2005',10),
('670059676','Changeling (Changeling  #1)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Delia' AND auth_last_name = 'Sherman'),'2006',10),
('141312629','The Changeling Sea',(SELECT auth_id FROM authors WHERE auth_first_name = 'Patricia' AND auth_last_name = 'McKillip'),'2003',10),
('595321801','The Changeling',(SELECT auth_id FROM authors WHERE auth_first_name = 'Zilpha' AND auth_last_name = 'Snyder'),'2004',10),
('1590301943','The Changeling',(SELECT auth_id FROM authors WHERE auth_first_name = 'Kate' AND auth_last_name = 'Horsley'),'2005',10),
('449146979','The Changeling (Daughters of England  #15)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Philippa' AND auth_last_name = 'Carr'),'1990',10),
('61159174','The Known World',(SELECT auth_id FROM authors WHERE auth_first_name = 'Edward' AND auth_last_name = 'Jones'),'2006',10),
('006076273X','The Known World',(SELECT auth_id FROM authors WHERE auth_first_name = 'Edward' AND auth_last_name = 'Jones'),'2004',10),
('60749911','The Known World',(SELECT auth_id FROM authors WHERE auth_first_name = 'Edward' AND auth_last_name = 'Jones'),'2004',10);

INSERT INTO `books` (isbn, title, auth_id, year, copies_available) VALUES
('273704745','Traders  Guns & Money: Knowns and Unknowns in the Dazzling World of Derivatives',(SELECT auth_id FROM authors WHERE auth_first_name = 'Satyajit' AND auth_last_name = 'Das'),'2006',10),
('1932386106','Artesia: Adventures in the Known World',(SELECT auth_id FROM authors WHERE auth_first_name = 'Mark' AND auth_last_name = 'Smylie'),'2005',10),
('374517193','The John McPhee Reader (John McPhee Reader  #1)',(SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'McPhee'),'1982',10),
('374280398','Uncommon Carriers',(SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'McPhee'),'2006',10),
('374519749','Heirs of General Practice',(SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'McPhee'),'1986',10),
('374522596','The Control of Nature',(SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'McPhee'),'1990',10),
('374518734','Annals of the Former World',(SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'McPhee'),'1999',10),
('374522871','Coming Into the Country',(SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'McPhee'),'1991',10),
('374519323','La Place de la Concorde Suisse',(SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'McPhee'),'1994',10),
('374520658','Harry Potter and the Half-Blood Prince (Harry Potter  #6)',(SELECT auth_id FROM authors WHERE auth_first_name = 'John' AND auth_last_name = 'McPhee'),'1987',10),
('822205106','Harry Potter and the Order of the Phoenix (Harry Potter  #5)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Wendy' AND auth_last_name = 'Wasserstein'),'2002',10),
('679734996','Harry Potter and the Chamber of Secrets (Harry Potter  #2)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Wendy' AND auth_last_name = 'Wasserstein'),'1991',10),
('1596670231','Harry Potter and the Prisoner of Azkaban (Harry Potter  #3)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Heidi' AND auth_last_name = 'Jacobs'),'2006',10),
('1581807740','Harry Potter Boxed Set  Books 1-5 (Harry Potter  #1-5)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Heidi' AND auth_last_name = 'Boyd'),'2006',10),
('871202867','Harry Potter Collection (Harry Potter  #1-6)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Heidi' AND auth_last_name = 'Jacobs'),'1997',10),
('871209993','The Ultimate Hitchhiker''s Guide to the Galaxy (Hitchhikers Guide to the Galaxy  #1-5)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Heidi' AND auth_last_name = 'Jacobs'),'2004',10),
('1581805632','A Short History of Nearly Everything',(SELECT auth_id FROM authors WHERE auth_first_name = 'Heidi' AND auth_last_name = 'Boyd'),'2004',10),
('441294677','Bill Bryson''s African Diary',(SELECT auth_id FROM authors WHERE auth_first_name = 'Frank' AND auth_last_name = 'Herbert'),'1987',10),
('441102670','Bryson''s Dictionary of Troublesome Words: A Writer''s Guide to Getting It Right',(SELECT auth_id FROM authors WHERE auth_first_name = 'Frank' AND auth_last_name = 'Herbert'),'1987',10),
('441172695','In a Sunburned Country',(SELECT auth_id FROM authors WHERE auth_first_name = 'Frank' AND auth_last_name = 'Herbert'),'1987',10),
('765306476','I am a Stranger Here Myself: Notes on Returning to America After Twenty Years Away',(SELECT auth_id FROM authors WHERE auth_first_name = 'Brian' AND auth_last_name = 'Herbert'),'2004',10),
('399128980','The Lost Continent: Travels in Small Town America', (SELECT auth_id FROM authors WHERE auth_first_name = 'Frank' AND auth_last_name = 'Herbert'),'1984',10),
('765353709','Neither Here nor There: Travels in Europe',(SELECT auth_id FROM authors WHERE auth_first_name = 'Frank' AND auth_last_name = 'Herbert'),'2006',10),
('441328008','Notes from a Small Island',(SELECT auth_id FROM authors WHERE auth_first_name = 'Frank' AND auth_last_name = 'Herbert'),'1987',10),
('618212906','The Mother Tongue: English and How It Got That Way',(SELECT auth_id FROM authors WHERE auth_first_name = 'Gary' AND auth_last_name = 'Russell'),'2002',10),
('034541005X','J.R.R. Tolkien 4-Book Boxed Set: The Hobbit and The Lord of the Rings',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bryce' AND auth_last_name = 'Courtenay'),'1996',10),
('385732546','The Lord of the Rings (The Lord of the Rings  #1-3)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Bryce' AND auth_last_name = 'Courtenay'),'2005',10),
('471780936','The Lord of the Rings (The Lord of the Rings  #1-3)',(SELECT auth_id FROM authors WHERE auth_first_name = 'Dave' AND auth_last_name = 'Lakhani'),'2006',10),
('325001537','The Lord of the Rings: Weapons and Warfare',(SELECT auth_id FROM authors WHERE auth_first_name = 'Louis' AND auth_last_name = 'Catron'),'2000',10),
('006076287X','The Lord of the Rings: Complete Visual Companion',(SELECT auth_id FROM authors WHERE auth_first_name = 'Adam' AND auth_last_name = 'Ginsberg'),'2005',10),
('470045299', 'Agile Web Development with Rails: A Pragmatic Guide',(SELECT auth_id FROM authors WHERE auth_first_name = 'Marsha' AND auth_last_name = 'Collier'), '2006', 10);




 



