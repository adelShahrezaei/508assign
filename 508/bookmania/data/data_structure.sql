-- MySQL dump 10.13  Distrib 5.7.22, for Linux (x86_64)
--
-- Host: homework.canlsvpzzur2.us-east-1.rds.amazonaws.com    Database: booktrade
-- ------------------------------------------------------
-- Server version	5.6.39-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `author_title`
--

DROP TABLE IF EXISTS `author_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `author_title` (
  `authorID` int(11) NOT NULL,
  `ISBN` varchar(15) NOT NULL,
  PRIMARY KEY (`authorID`,`ISBN`),
  KEY `fk_author_title_2_idx` (`ISBN`),
  CONSTRAINT `fk_author_title_1` FOREIGN KEY (`authorID`) REFERENCES `authors` (`authorID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_author_title_2` FOREIGN KEY (`ISBN`) REFERENCES `titles` (`ISBN`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author_title`
--

LOCK TABLES `author_title` WRITE;
/*!40000 ALTER TABLE `author_title` DISABLE KEYS */;
INSERT INTO `author_title` VALUES (17,'0060504080'),(33,'0060528877'),(34,'0060528877'),(17,'0060786507'),(17,'0060852550'),(17,'0060852577'),(17,'0060921145'),(17,'0062124269'),(35,'0072958863'),(36,'0072958863'),(37,'0072958863'),(35,'0073523321'),(36,'0073523321'),(37,'0073523321'),(38,'0130351199'),(38,'0130914290'),(38,'0131479547'),(38,'0132380331'),(38,'0132433109'),(38,'013513711X'),(38,'0135259657'),(38,'0139737448'),(24,'0142437174'),(26,'0142437174'),(27,'0142437174'),(28,'0142437174'),(29,'0142437174'),(38,'0155775065'),(39,'0155775065'),(34,'0316013277 '),(34,'0316178551'),(34,'0316578991'),(34,'0316592102'),(34,'0316706000'),(34,'0316706280'),(8,'0316767727'),(8,'0316769029 '),(8,'0316769177'),(33,'0375724427'),(33,'0394572742'),(9,'0439064864'),(10,'0439064864'),(9,'0439554934'),(10,'0439554934'),(11,'0446676500'),(12,'0446676500'),(18,'0450040186'),(18,'0452277752 '),(19,'0452277752 '),(9,'0545010225'),(10,'0545010225'),(22,'0553250558'),(17,'0571171788'),(17,'0571179509'),(34,'0571200613'),(30,'0618056823'),(31,'0618056823'),(20,'0671685635'),(33,'0679737863'),(13,'0688166326 '),(32,'0802137954'),(17,'0812474945'),(23,'0812518489'),(15,'0812971892'),(34,'0971367035'),(34,'2743609397'),(8,'9780989671453');
/*!40000 ALTER TABLE `author_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authors` (
  `authorID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `bio` varchar(1000) DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `death` datetime DEFAULT NULL,
  `image_url` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`authorID`),
  UNIQUE KEY `authorID_UNIQUE` (`authorID`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (8,'J.D Salinger','Jerome David Salinger was an American author, best known for his 1951 novel The Catcher in the Rye, as well as his reclusive nature. His last original published work was in 1965; he gave his last interview in 1980. Raised in Manhattan, Salinger began writing short stories while in secondary school, and published several stories in the early 1940s before serving in World War II. In 1948 he published the critically acclaimed story \"A Perfect Day for Bananafish\" in The New Yorker magazine, which became home to much of his subsequent work. In 1951 Salinger released his novel The Catcher in the Rye, an immediate popular success. His depiction of adolescent alienation and loss of innocence in the protagonist Holden Caulfield was influential','1919-01-01 00:00:00','2010-01-27 00:00:00','https://images.gr-assets.com/authors/12887776'),(9,'J.K. Rowling','Although she writes under the pen name J.K. Rowling, pronounced like rolling, her name when her first Harry Potter book was published was simply Joanne Rowling. Anticipating that the target audience of young boys might not want to read a book written by a woman, her publishers demanded that she use two initials, rather than her full name. As she had no middle name, she chose K as the second initial of her pen name, from her paternal grandmother Kathleen Ada Bulgen Rowling. She calls herself Jo and has said, \"No one ever called me \'Joanne\' when I was young, unless they were angry.\" Following her marriage, she has sometimes used the name Joanne Murray when conducting personal business. During the Leveson Inquiry she gave evidence under the name of Joanne Kathleen Rowling. In a 2012 interview, Rowling noted that she no longer cared that people pronounced her name incorrectly.','1965-07-31 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/15104351'),(10,'Mary GrandPré','Educated at the Minneapolis College of Art and Design, Mary GrandPre began her career as a conceptual illustrator for local editorial clients. Continually experimenting with media, Mary underwent many artistic changes in her expressive visual form. Her concerns for light, color, drawing, and design came together in evocative, ethereal pastel paintings evolving toward a style she now calls \"soft geometry\". \r\nMary\'s new work attracted corporate advertising and editorial clients. Some of the include: Ogilvy & Mather, BBD&O, Whittle Communications, The Richards Group, Neenah Paper, Atlantic Monthly Magazine, Random House, Berkley, Penguin, Dell and McGraw Hill publishers. Recently, she was featured on the cover of Time Magazine for her work with the Harry Potter Series and also worked as a visionary in the environment/scenery development in Dreamworks animated film Antz.','1954-01-01 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/13953448'),(11,'Martin Luther King Jr.','Martin Luther King, Jr. was one of the pivotal leaders of the American civil rights movement. King was a Baptist minister, one of the few leadership roles available to black men at the time. He became a civil rights activist early in his career. He led the Montgomery Bus Boycott (1955–1956) and helped found the Southern Christian Leadership Conference (1957), serving as its first president. His efforts led to the 1963 March on Washington, where King delivered his “I Have a Dream” speech. Here he raised public consciousness of the civil rights movement and established himself as one of the greatest orators in U.S. history. In 1964, King became the youngest person to receive the Nobel Peace Prize for his efforts to end segregation and racial discrimination through civil disobedience and other non-violent means.','1929-01-15 00:00:00','1968-04-04 00:00:00','https://images.gr-assets.com/authors/11985185'),(12,'Clayborne Carson','Clayborne Carson is an African-American professor of history at Stanford University, and director of the Martin Luther King, Jr., Research and Education Institute.','1944-06-15 00:00:00','0000-00-00 00:00:00','https://kinginstitute.stanford.edu/sites/defa'),(13,'David J. Garrow','David J. Garrow is an American historian and author of the book Bearing the Cross: Martin Luther King, Jr., and the Southern Christian Leadership Conference, which won the 1987 Pulitzer Prize for Biography.','1953-11-05 00:00:00','0000-00-00 00:00:00','http://www.davidgarrow.com/Image/djg_med.jpg'),(14,'Stephen B. Oates','A former professor of history at the University of Massachusetts Amherst. He is an expert in 19th-century United States history.\r\n\r\nOates has written 16 books during his career, including biographies of Martin Luther King, Jr., Abraham Lincoln, Clara Barton, and John Brown, and an account of Nat Turner\'s slave rebellion. His Portrait of America, a compilation of essays about United States history, is widely used in advanced high school and undergraduate university American history courses. His two \"Voices of the Storm\" books are compilations of monologues of key individuals in events leading up to and during the American Civil War. He also appeared in the well-known Ken Burns PBS documentary on the war.\r\n','1936-03-01 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/12813253'),(15,'Reza Aslan','Dr. Reza Aslan, an internationally acclaimed writer and scholar of religions, is author most recently of Zealot: The Life and Times of Jesus of Nazareth.\r\n\r\nHe is the founder of AslanMedia.com, an online journal for news and entertainment about the Middle East and the world, and co-founder and Chief Creative Officer of BoomGen Studios, the premier entertainment brand for creative content from and about the Greater Middle East.','1972-03-05 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/13757025'),(16,'Asma Barlas','Asma Barlas (born 1950), is a Pakistani-American writer and academic. Her specialties include comparative and international politics, Islam and Qur\'anic hermeneutics, and women\'s studies. Barlas was one of the first women to be inducted into the foreign service in 1976. Six years later, she was dismissed on the orders of General Zia ul Haq. She worked briefly as assistant editor of the opposition newspaper The Muslim before receiving political asylum in the United States in 1983. Barlas joined the politics department of Ithaca College in 1991. She was the founding director of the Center for the Study of Culture, Race, and Ethnicity for 12 years. She held Spinoza Chair in Philosophy at the University of Amsterdam in 2008.','1950-02-01 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/14033842'),(17,'Barbara Kingsolver','Barbara Kingsolver is an American novelist, essayist, and poet. She was raised in rural Kentucky and lived briefly in Africa in her early childhood. Kingsolver earned degrees in Biology at DePauw University and the University of Arizona and worked as a freelance writer before she began writing novels. Her most famous works include The Poisonwood Bible, the tale of a missionary family in the Congo, and Animal, Vegetable, Miracle, a non-fiction account of her family\'s attempts to eat locally.\r\n','1955-08-04 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/13504990'),(18,'Stephen King','Stephen Edwin King was born the second son of Donald and Nellie Ruth Pillsbury King. After his father left them when Stephen was two, he and his older brother, David, were raised by his mother. Parts of his childhood were spent in Fort Wayne, Indiana, where his father\'s family was at the time, and in Stratford, Connecticut. When Stephen was eleven, his mother brought her children back to Durham, Maine, for good. Her parents, Guy and Nellie Pillsbury, had become incapacitated with old age, and Ruth King was persuaded by her sisters to take over the physical care of them. Other family members provided a small house in Durham and financial support. After Stephen\'s grandparents passed away, Mrs. King found work in the kitchens of Pineland, a nearby residential facility for the mentally challenged.','1947-09-21 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/13628141'),(19,'Richard Bachman','\r\nAt the beginning of Stephen King\'s career, the general view among publishers was that an author was limited to one book per year, since publishing more would be unacceptable to the public. King therefore wanted to write under another name, in order to increase his publication without over-saturating the market for the King \"brand\". He convinced his publisher, Signet Books, to print these novels under a pseudonym.\r\n\r\nIn his introduction to The Bachman Books, King states that adopting the nom de plume Bachman was also an attempt to make sense out of his career and try to answer the question of whether his success was due to talent or luck. He says he deliberately released the Bachman novels with as little marketing presence as possible and did his best to \"load the dice against\" Bachman. King concludes that he has yet to find an answer to the \"talent versus luck\" question, as he felt he was outed as Bachman too early to know. The Bachman book Thinner (1984) sold 28,000 copies during it','1941-09-21 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/12897024'),(20,'Peter Straub','Peter Straub was born in Milwaukee, Wisconsin on 2 March, 1943, the first of three sons of a salesman and a nurse. The salesman wanted him to become an athlete, the nurse thought he would do well as either a doctor or a Lutheran minister, but all he wanted to do was to learn to read.\r\n\r\nWhen kindergarten turned out to be a stupefyingly banal disappointment devoted to cutting animal shapes out of heavy colored paper, he took matters into his own hands and taught himself to read by memorizing his comic books and reciting them over and over to other neighborhood children on the front steps until he could recognize the words.','1943-02-03 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/12004689'),(22,'T.E.D. Klein','Theodore \"Eibon\" Donald Klein is an American horror writer and editor.\r\n\r\nKlein has published very few works, but they have all achieved positive notice for their meticulous construction and subtle use of horror: critic S. T. Joshi writes, \"In close to 25 years of writing Klein has only two books and a handful of scattered tales to his credit, and yet his achievement towers gigantically over that of his more prolific contemporaries.','1947-05-15 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/14067223'),(23,'Charles L. Grant','Charles Lewis Grant was a novelist and short story writer specializing in what he called \"dark fantasy\" and \"quiet horror.\" He also wrote under the pseudonyms of Geoffrey Marsh, Lionel Fenn, Simon Lake, Felicia Andrews, and Deborah Lewis.\r\n\r\nGrant won a World Fantasy Award for his novella collection Nightmare Seasons, a Nebula Award in 1976 for his short story \"A Crowd of Shadows\", and another Nebula Award in 1978 for his novella \"A Glow of Candles, a Unicorn\'s Eye,\" the latter telling of an actor\'s dilemma in a post-literate future. Grant also edited the award winning Shadows anthology, running eleven volumes from 1978-1991. Contributors include Stephen King, Ramsey Campbell, R.A. Lafferty, Avram Davidson, and Steve Rasnic and Melanie Tem. Grant was a former Executive Secretary and Eastern Regional Director of the Science Fiction and Fantasy Writers of America and president of the Horror Writers Association.','1942-09-12 00:00:00','2006-09-15 00:00:00','https://images.gr-assets.com/authors/14286748'),(24,'Mark Twain','Samuel Langhorne Clemens, better known by his pen name Mark Twain, was an American author and humorist. He is noted for his novels Adventures of Huckleberry Finn (1885), called \"the Great American Novel\", and The Adventures of Tom Sawyer (1876).\r\n\r\nTwain grew up in Hannibal, Missouri, which would later provide the setting for Huckleberry Finn and Tom Sawyer. He apprenticed with a printer. He also worked as a typesetter and contributed articles to his older brother Orion\'s newspaper. After toiling as a printer in various cities, he became a master riverboat pilot on the Mississippi River, before heading west to join Orion. He was a failure at gold mining, so he next turned to journalism. While a reporter, he wrote a humorous story, \"The Celebrated Jumping Frog of Calaveras County,\" which proved to be very popular and brought him nationwide attention. His travelogues were also well-received. Twain had found his calling.','1835-11-30 00:00:00','1910-04-21 00:00:00','https://images.gr-assets.com/authors/13221038'),(26,'Edward Windsor Kemble','Edward Windsor Kemble, usually cited as E. W. Kemble, was an American illustrator. He is known best for illustrating the first edition of Adventures of Huckleberry Finn and for his cartoons of African Americans.','1861-01-18 00:00:00','1933-09-19 00:00:00','https://upload.wikimedia.org/wikipedia/common'),(27,'Herberto Sales','Herberto Sales (Herberto de Azevedo Sales), jornalista, contista, romancista e memorialista, nasceu em Andaraí, BA, em 21 de setembro de 1917. Faleceu no dia 13 de agosto de 1999, no Rio de Janeiro.\r\n\r\nFilho de Heráclito Sousa Sales e Aurora de Azevedo Sales. Fez o curso primário em sua cidade natal, e o curso ginasial (abandonado no 5º ano) em Salvador, no colégio Antônio Vieira, dos jesuítas. O professor Agenor Almeida descobriu-lhe, numa prova, a vocação literária, chamando para isso a atenção do padre Cabral, que por sua vez foi o descobridor, alguns anos antes, no mesmo colégio, da vocação literária de Jorge Amado. Abandonados os estudos, voltou para Andaraí, onde viveu até 1948. Com a publicação, em 1944, de Cascalho, seu romance de estreia, projetou de impacto o seu nome nos meios literários do país. No Rio de Janeiro, para onde então se transferiu e residiu até 1974, foi jornalista militante, com atividade nos Diários Associados, de Assis Chateaubriand, na área da revista O Cru','1917-09-21 00:00:00','1999-09-13 00:00:00','http://www.erealizacoes.com.br/upload/colabor'),(28,'Saadah Alim','Saadah Alim, (lahir di Padang, Sumatera Barat, 9 Juni 1897 – meninggal di Jakarta, 18 Agustus 1968 pada umur 71 tahun), adalah seorang penulis Indonesia [1]. Setelah lulus Sekolah Guru (Kweekschool) di Bukittinggi, ia mengajar di HIS di Padang tahun 1918--1920, dan menjadi guru Meisjes Normaal School (Sekolah Guru Wanita) di Padang.','1897-06-09 00:00:00','1968-08-18 00:00:00',''),(29,'Guy Cardwell','','0000-00-00 00:00:00','0000-00-00 00:00:00',''),(30,'John Dos Passos','John Roderigo Dos Passos was an American novelist and artist.\r\n\r\nHe received a first-class education at The Choate School, in Connecticut, in 1907, under the name John Roderigo Madison. Later, he traveled with his tutor on a tour through France, England, Italy, Greece and the Middle East to study classical art, architecture and literature.\r\n\r\nIn 1912 he attended Harvard University and, after graduating in 1916, he traveled to Spain to continue his studies. In 1917 he volunteered for the S.S.U. 60 of the Norton-Harjes Ambulance Corps, along with E.E. Cummings and Robert Hillyer.','1896-01-14 00:00:00','1970-09-28 00:00:00','https://images.gr-assets.com/authors/14083752'),(31,'E.L. Doctorow','\r\nE. L. DOCTOROW’S works of fiction include Homer & Langley,The March, Billy Bathgate, Ragtime, the Book of Daniel, City of God, Welcome to Hard Times, Loon Lake, World’s Fair, The Waterworks, and All the Time in the World. Among his honors are the National Book Award, three National Book Critics Circle Awards, two PEN Faulkner Awards, The Edith Wharton Citation for Fiction, and the presidentially conferred National Humanities Medal. In 2009 he was short listed for the Man Booker International Prize honoring a writer’s lifetime achievement in fiction, and in 2012 he won the PEN Saul Bellow Award given to an author whose “scale of achievement over a sustained career places him in the highest rank of American Literature.”','1931-06-01 00:00:00','2015-05-21 00:00:00','https://images.gr-assets.com/authors/13874147'),(32,'J.P. Donleavy','James Patrick Donleavy was an Irish American author, born to Irish immigrants. He served in the U.S. Navy during World War II after which he moved to Ireland. In 1946 he began studies at Trinity College, Dublin, but left before taking a degree. He was first published in the Dublin literary periodical, Envoy.','1926-04-23 00:00:00','2017-11-09 00:00:00','https://images.gr-assets.com/authors/13031778'),(33,'John Cheever','John Cheever was an American novelist and short story writer, sometimes called \"the Chekhov of the suburbs\" or \"the Ovid of Ossining.\" His fiction is mostly set in the Upper East Side of Manhattan, the suburbs of Westchester, New York, and old New England villages based on various South Shore towns around Quincy, Massachusetts, where he was born.\r\n\r\nHis main themes include the duality of human nature: sometimes dramatized as the disparity between a character\'s decorous social persona and inner corruption, and sometimes as a conflict between two characters (often brothers) who embody the salient aspects of both--light and dark, flesh and spirit. Many of his works also express a nostalgia for a vanishing way of life, characterized by abiding cultural traditions and a profound sense of community, as opposed to the alienating nomadism of modern suburbia.','1912-05-27 00:00:00','1982-05-18 00:00:00','https://images.gr-assets.com/authors/12088998'),(34,'Rick Moody','Rick Moody (born Hiram Frederick Moody, III on October 18, 1961, New York City), is an American novelist and short story writer best known for The Ice Storm (1994), a chronicle of the dissolution of two suburban Connecticut families over Thanksgiving weekend in 1973, which brought widespread acclaim, and became a bestseller; it was later made into a feature film.','1961-09-08 00:00:00','0000-00-00 00:00:00','https://images.gr-assets.com/authors/12784813'),(35,'Abraham Silberschatz','Yale University. Prior to joining Yale, he was the Vice President of the Information Sciences Research Center at Bell Laboratories. Prior to that, he held a chaired professorship in the Department of Computer Sciences at the University of Texas at Austin.\r\nProfessor Silberschatz is an ACM Fellow and an IEEE Fellow. He received the 2002 IEEE Taylor L. Booth Education Award, the 1998 ACM Karl V. Karlstrom Outstanding Educator Award, and the 1997 ACM SIGMOD Contribution Award. In recognition of his outstanding level of innovation and technical excellence, he was awarded the Bell Laboratories President\'s Award for three different projects - the QTM Project (1998), the DataBlitz Project (1999), and the Netlnventory Project (2004).\r\nProfessor Silberschatz\' writings have appeared in numerous ACM and IEEE publications and other professional conferences and journals. He has also written Op-Ed articles for the New York Times, the Boston Globe, and the Hartford Courant, among others.','0000-00-00 00:00:00','0000-00-00 00:00:00','https://upload.wikimedia.org/wikipedia/en/thu'),(36,'Henry F. Korth','Henry F. Korth is Wieseman Professor of Computer Science and Engineering at Lehigh University. His publications include three books, one of which, Database Systems Concepts, is in its sixth edition; over 100 technical papers; and twelve book chapters. He holds eleven patents. Previously, he was a Director at Bell Labs, Vice President of Panasonic Technologies, and an Asosciate Professor at the University of Texas at Austin. He is a fellow of the ACM and the IEEE, and a winner of the VLDB 10-year award. He holds a Ph.D. from Princeton University.','0000-00-00 00:00:00','0000-00-00 00:00:00','http://dae.cse.lehigh.edu/DAE/sites/default/f'),(37,'S. Sudarshan','My main research area is database systems . Current sub areas of interest include\r\nHolistic optimization spanning the programming language/SQL boundary. This project addresses optimization of database applications where the bottleneck is in the programming language -- database interface. We have developed techniques for automated rewriting of database applications, which can replace iterative invocation of queries by creating query batches, or asynchronous query invocation, and in other cases replace blocks of code by equivalent SQL queries. This work spans the boundaries of programming language static analysis and database query optimization. For details see the home page of the DBridge Project at http://www.cse.iitb.ac.in/dbms/dbridge.\r\nQuery Optimization. The Pyro query optimization project, which is based on the Volcano/Cascades framework, has run for many years, with early work focusing on multiquery optimization and parametric query optimization. More recently we have been workin','0000-00-00 00:00:00','0000-00-00 00:00:00','https://www.cse.iitb.ac.in/~sudarsha/Sudarsha'),(38,'William Stallings','Dr. William Stallings is an American author. He has written textbooks on computer science topics such as operating systems, computer networks, computer organization, and cryptography.','1945-02-01 00:00:00','0000-00-00 00:00:00','https://www.computerhope.com/people/pictures/'),(39,'Lawrie Brown','Lawrence Peter \"Lawrie\" Brown is a cryptographer and computer security researcher, currently a (retired and now visiting) Senior Lecturer with UNSW Canberra at the Australian Defence Force Academy. His notable work includes the design of the block ciphers LOKI and the AES candidate LOKI97. He received his Ph.D. in mathematics from the University of New South Wales in 1991, with a dissertation on the design of LOKI and the cryptanalysis of the Data Encryption Standard.[1] Subsequently, his research changed focus to the Safe Erlang mobile code system, to aspects of trust issues in eCommerce with some of his PhD students, and with the use of Proxy Certificates for Client Authentication.','0000-00-00 00:00:00','0000-00-00 00:00:00','https://www.unsw.adfa.edu.au/sites/default/fi');
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `availability`
--

DROP TABLE IF EXISTS `availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `availability` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `availability`
--

LOCK TABLES `availability` WRITE;
/*!40000 ALTER TABLE `availability` DISABLE KEYS */;
INSERT INTO `availability` VALUES (0,'Not Available'),(1,'Available'),(2,'Coming Soon');
/*!40000 ALTER TABLE `availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `book_title_view`
--

DROP TABLE IF EXISTS `book_title_view`;
/*!50001 DROP VIEW IF EXISTS `book_title_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `book_title_view` AS SELECT 
 1 AS `userID`,
 1 AS `username`,
 1 AS `bname`,
 1 AS `bookID`,
 1 AS `avail`,
 1 AS `addDate`,
 1 AS `ISBN`,
 1 AS `name`,
 1 AS `edition`,
 1 AS `image_url`,
 1 AS `amazon_price`,
 1 AS `publisher_name`,
 1 AS `author_names`,
 1 AS `topic_names`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `books` (
  `bookID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `addDate` datetime NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Availability` int(11) DEFAULT NULL,
  `ISBN` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`bookID`),
  UNIQUE KEY `bookID_UNIQUE` (`bookID`),
  KEY `fk_books_1_idx` (`ISBN`),
  KEY `fk_books_2_idx` (`userID`),
  CONSTRAINT `fk_books_1` FOREIGN KEY (`ISBN`) REFERENCES `titles` (`ISBN`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `fk_books_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (10,11,'2018-04-24 20:19:00','High Tide in Tucson',2,'0571179509'),(11,11,'2018-04-24 01:10:20','Three Early Stories',1,'9780989671453'),(12,11,'2018-04-24 04:20:00','Purple America',2,'2743609397'),(13,11,'2018-04-24 00:00:00','The Wilco Book',1,'0971367035'),(14,12,'2018-04-24 00:00:00','No god but God: The Origins, Evolution and Fu',1,'0812971892'),(15,12,'2018-04-24 00:00:00','The Pet',2,'0812518489'),(16,12,'2018-04-24 00:00:00','The Bean Trees',0,'0812474945'),(17,12,'2018-04-24 00:00:00','The Ginger Man',1,'0802137954'),(18,13,'2018-04-24 00:00:00','Bearing the Cross: Martin Luther King, JR., a',1,'0688166326 '),(19,13,'2018-04-24 00:00:00','Falconer',2,'0679737863'),(20,13,'2018-04-24 00:00:00','Ghost Story',0,'0671685635'),(21,11,'2018-04-24 00:00:00','1919 ',1,'0618056823'),(22,20,'2018-04-24 00:00:00','Garden State',1,'0571200613'),(23,14,'2018-04-24 00:00:00','High Tide in Tucson',0,'0571179509'),(24,14,'2018-04-24 00:00:00','Pigs in Heaven',2,'0571171788'),(25,14,'2018-04-24 00:00:00','The Ceremonies',1,'0553250558'),(26,15,'2018-04-24 00:00:00','Harry potter and the Deathly Hallows',1,'0545010225'),(27,15,'2018-04-24 00:00:00','The Bachman Books',2,'0452277752 '),(28,15,'2018-04-24 00:00:00','The Shining',0,'0450040186'),(29,15,'2018-04-24 00:00:00','The Autobiography of Martin Luther King, Jr.',2,'0446676500'),(30,15,'2018-04-24 00:00:00','Harry Potter and the Sorcerer\'s Stone',1,'0439554934'),(31,16,'2018-04-24 00:00:00','Harry Potter and the Chamber of Secrets',0,'0439064864'),(32,16,'2018-04-24 00:00:00','The Journals Of John Cheever',0,'0394572742'),(33,16,'2018-04-24 00:00:00','The Stories of John Cheever',1,'0375724427'),(34,17,'2018-04-24 00:00:00','The Catcher in the Rye',1,'0316769177'),(35,17,'2018-04-24 00:00:00','Franny and Zooey ',0,'0316769029 '),(36,17,'2018-04-24 00:00:00','Nine Stories',2,'0316767727'),(37,17,'2018-04-24 00:00:00','The Ring of Brightest Angels Around Heaven: A',2,'0316706280'),(38,18,'2018-04-24 00:00:00','The Ice Storm',1,'0316706000'),(39,18,'2018-04-24 00:00:00','Demonology: Stories',0,'0316592102'),(40,15,'2018-04-24 00:00:00','Black Veil: A Memoir with Digressions',1,'0316578991'),(41,18,'2018-04-24 00:00:00','Hotels of North America',2,'0316178551'),(42,19,'2018-04-24 00:00:00','Hotels of North America',1,'0316178551'),(43,19,'2018-04-24 00:00:00','The Diviners',0,'0316013277 '),(44,19,'2018-04-24 00:00:00','The Adventures of Huckleberry Finn',1,'0142437174'),(45,19,'2018-04-24 00:00:00','Flight Behavior',2,'0062124269'),(46,15,'2018-04-24 00:00:00','Animal Dreams',1,'0060921145'),(47,20,'2018-04-24 00:00:00','The Lacuna',2,'0060852577'),(48,20,'2018-04-24 00:00:00','Animal, Vegetable, Miracle: A Year of Food Li',0,'0060852550'),(49,20,'2018-04-24 00:00:00','The Poisonwood Bible',1,'0060786507'),(50,20,'2018-04-24 00:00:00','The Wapshot Chronicle',2,'0060528877'),(51,20,'2018-04-24 00:00:00','Small Wonder',2,'0060504080'),(53,10,'2018-04-24 00:00:00','Data and Computer Communications',1,'0132433109'),(54,10,'2018-04-24 00:00:00','',1,'0316706000'),(55,11,'2018-04-24 00:00:00','Bearing the Cross: Martin Luther King, JR., a',2,'0688166326 '),(56,4,'2018-04-24 00:00:00','ISDN and Broadband ISDN with Frame Relay and ',2,'0139737448'),(57,4,'2018-04-24 00:00:00','Network Security Essentials: Applications and',1,'0132380331'),(58,4,'2018-04-24 00:00:00','Operating Systems: Internals and Design Princ',1,'0131479547'),(59,11,'2018-04-24 00:00:00','Computer Security: Principles and Practice (2',1,'0155775065'),(60,24,'2018-04-24 00:00:00','Cryptography and Network Security: Principles',2,'0130914290'),(61,24,'2018-04-24 00:00:00','Operating Systems: Internals and Design Princ',0,'0131479547'),(62,11,'2018-04-24 00:00:00','The Bible',1,'0060786507');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `boot_title_no_agg`
--

DROP TABLE IF EXISTS `boot_title_no_agg`;
/*!50001 DROP VIEW IF EXISTS `boot_title_no_agg`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `boot_title_no_agg` AS SELECT 
 1 AS `userID`,
 1 AS `username`,
 1 AS `bname`,
 1 AS `bookID`,
 1 AS `avail`,
 1 AS `addDate`,
 1 AS `ISBN`,
 1 AS `name`,
 1 AS `edition`,
 1 AS `image_url`,
 1 AS `amazon_price`,
 1 AS `publisher_name`,
 1 AS `author_name`,
 1 AS `authorID`,
 1 AS `topic_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `boot_title_no_agg_no_topic`
--

DROP TABLE IF EXISTS `boot_title_no_agg_no_topic`;
/*!50001 DROP VIEW IF EXISTS `boot_title_no_agg_no_topic`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `boot_title_no_agg_no_topic` AS SELECT 
 1 AS `userID`,
 1 AS `username`,
 1 AS `bname`,
 1 AS `bookID`,
 1 AS `addDate`,
 1 AS `ISBN`,
 1 AS `name`,
 1 AS `edition`,
 1 AS `image_url`,
 1 AS `amazon_price`,
 1 AS `publisher_name`,
 1 AS `author_name`,
 1 AS `authorID`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `exchanges`
--

DROP TABLE IF EXISTS `exchanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exchanges` (
  `userID1` int(11) NOT NULL,
  `userID2` int(11) NOT NULL,
  `bookID` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`userID1`,`userID2`,`bookID`),
  KEY `fk_exchanges_1_idx` (`bookID`),
  KEY `fk_exchanges_3_idx` (`userID2`),
  CONSTRAINT `fk_exchanges_1` FOREIGN KEY (`bookID`) REFERENCES `books` (`bookID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_exchanges_2` FOREIGN KEY (`userID1`) REFERENCES `users` (`userID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_exchanges_3` FOREIGN KEY (`userID2`) REFERENCES `users` (`userID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchanges`
--

LOCK TABLES `exchanges` WRITE;
/*!40000 ALTER TABLE `exchanges` DISABLE KEYS */;
INSERT INTO `exchanges` VALUES (11,13,21,'2018-04-24 22:28:15'),(11,24,59,'2018-04-25 01:03:54'),(12,18,40,'2018-04-24 15:09:43'),(14,20,46,'2018-04-24 01:40:55'),(15,12,40,'2018-04-24 11:47:53'),(15,14,46,'2018-04-24 01:53:09'),(20,14,22,'2018-04-24 01:39:46'),(20,15,46,'2018-04-24 01:32:27');
/*!40000 ALTER TABLE `exchanges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friends`
--

DROP TABLE IF EXISTS `friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friends` (
  `userID1` int(11) NOT NULL,
  `userID2` int(11) NOT NULL,
  PRIMARY KEY (`userID1`,`userID2`),
  KEY `fk_friends_2_idx` (`userID2`),
  CONSTRAINT `fk_friends_1` FOREIGN KEY (`userID1`) REFERENCES `users` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_friends_2` FOREIGN KEY (`userID2`) REFERENCES `users` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friends`
--

LOCK TABLES `friends` WRITE;
/*!40000 ALTER TABLE `friends` DISABLE KEYS */;
INSERT INTO `friends` VALUES (7,11),(12,13),(15,13),(18,13),(11,15),(15,18);
/*!40000 ALTER TABLE `friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `userID` int(11) NOT NULL,
  `points` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`userID`),
  CONSTRAINT `fk_members_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (6,'1'),(7,'1'),(9,'1'),(10,'4'),(11,'1'),(12,'5'),(13,'6'),(14,'1'),(15,'2'),(16,'2'),(17,'2'),(18,'1'),(19,'2'),(20,'1'),(21,'1'),(22,'0'),(23,'0'),(24,'1'),(25,'0');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publishers`
--

DROP TABLE IF EXISTS `publishers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publishers` (
  `name` varchar(45) NOT NULL,
  `address` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publishers`
--

LOCK TABLES `publishers` WRITE;
/*!40000 ALTER TABLE `publishers` DISABLE KEYS */;
INSERT INTO `publishers` VALUES (' Knopf',' New York, NY 10019'),(' Random House Trade ','745 Broadway in Manhattan'),('Arthur A. Levine Books','557 Broadway New York, NY 10012'),('Back Bay Books','New York, NY'),('Bantam Books','Walter B. Pitkin, Jr. Sidney B. Kramer Ian Ba'),('ddddaaaaadfffft','injaunja'),('Devault-Graves Digital Editions','2197 Cowden Ave, Memphis, TN 38104'),('goodbook','inja unja'),('Grand Central Publishing','New York City ,NY'),('Grove press','New York City, New York'),('Hachette','1290 6th Ave, New York, NY 10104'),('Harper Perennial','New York, London.'),('Harper Perennial Modern Classics ','Richmond,VIrginia'),('HarperCollins','New York City '),('Little, Brown and Company','New York City ,NY'),('Macmillan Publishers','75 Varick St, New York, NY 10013'),('McGraw-Hill Education','James H. McGraw John A. Hill'),('Oxford University Press','Oxford, England, UK'),('pearson','inja unja'),('Pearson Publishing company','330 Hudson in New York City, New York. '),('Penguin Books Publishing company','City of Westminster, London, England'),('Perfection Learning','california,california'),('Picturebox, Inc.','california,california'),('Pocket Books','1230 Avenue of the Americas, Rockefeller Cent'),('Prentice Hall','Upper Saddle River, NJ'),('Random House','400 Hahn Rd, Westminster, MD 21157'),('Scholastic Inc','557 Broadway, New York City, New York 10012'),('Tor Books','Flatiron Building, New York City'),('University of Texas Press ','Texas '),('Vintage International ','Dhaka,Bangladesh');
/*!40000 ALTER TABLE `publishers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `title_topic`
--

DROP TABLE IF EXISTS `title_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `title_topic` (
  `ISBN` varchar(15) NOT NULL,
  `topicID` int(11) NOT NULL,
  PRIMARY KEY (`ISBN`,`topicID`),
  KEY `fk_title_topic_2_idx` (`topicID`),
  CONSTRAINT `fk_title_topic_1` FOREIGN KEY (`ISBN`) REFERENCES `titles` (`ISBN`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_title_topic_2` FOREIGN KEY (`topicID`) REFERENCES `topics` (`topicID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `title_topic`
--

LOCK TABLES `title_topic` WRITE;
/*!40000 ALTER TABLE `title_topic` DISABLE KEYS */;
INSERT INTO `title_topic` VALUES ('0060528877',3),('0060786507',3),('0060852577',3),('0060959037',3),('0062124269',3),('0316013277 ',3),('0316178551',3),('0316592102',3),('0316706000',3),('0316706280',3),('0316767727',3),('0316769177',3),('0375724427',3),('0439554934',3),('0450040186',3),('0545010225',3),('0553250558',3),('0571171788',3),('0571200613',3),('0618056823',3),('0679737863',3),('0802137954',3),('0812474945',3),('0812516621',3),('0812518489',3),('2743609397',3),('9780989671453',3),('0060528877',4),('0060786507',4),('0316769029 ',4),('0316769177',4),('0375724427',4),('0450040186',4),('0618056823',4),('0679737863',4),('0802137954',4),('9780989671453',4),('0060528877',5),('0316013277 ',5),('0316767727',5),('0316769029 ',5),('0316769177',5),('0375724427',5),('0571200613',5),('0618056823',5),('0679737863',5),('0802137954',5),('9780989671453',5),('0316706000',6),('0571200613',6),('2743609397',6),('9780989671453',6),('0060504080',7),('0316592102',7),('0316706280',7),('0375724427',7),('2743609397',7),('9780989671453',7),('0439064864',9),('0439554934',9),('0545010225',9),('0553250558',9),('0812516621',9),('0439064864',10),('0439554934',10),('0545010225',10),('0452277752 ',11),('0316578991',14),('0394572742',14),('0446676500',14),('0688166326 ',14),('0060852577',15),('0292709048',15),('0446676500',15),('0688166326 ',15),('0812971892',15),('0060504080',16),('0130914290',16),('0292709048',16),('0316578991',16),('0394572742',16),('0446676500',16),('0571179509',16),('0688166326 ',16),('0812971892',16),('0971367035',16),('0446676500',17),('0812971892',17),('0446676500',18),('0446676500',19),('0688166326 ',20),('0452277752 ',21),('0316578991',22),('0394572742',22),('0812474945',23),('0812971892',23),('0292709048',24),('0812971892',24),('0292709048',25),('0292709048',26),('0060786507',27),('0060852577',27),('0618056823',27),('0060786507',28),('0060921145',29),('0060959037',29),('0062124269',29),('0316178551',29),('0316706000',29),('0571171788',29),('0060921145',30),('0060959037',30),('0142437174',30),('0316178551',30),('0316706000',30),('0571171788',30),('0571200613',30),('0679737863',30),('2743609397',30),('0060852550',31),('0060852550',32),('0394572742',32),('0060504080',33),('0060852550',33),('0060959037',33),('0060852550',34),('0060852550',35),('0060921145',36),('0062124269',36),('0316706000',36),('0571200613',36),('0142437174',37),('0316178551',37),('0316592102',37),('0571171788',38),('0571179509',38),('0060504080',39),('0142437174',39),('0394572742',39),('0060504080',40),('0450040186',41),('0671685635',41),('0450040186',42),('0553250558',42),('0671685635',42),('0812516621',42),('0812518489',42),('0142437174',43),('0671685635',43),('0671685635',44),('0671685635',45),('0553250558',46),('0802137954',47),('0802137954',48),('0316178551',49),('0316578991',50),('0971367035',51),('0971367035',52),('0971367035',53),('0316706280',54),('0072958863',55),('0073523321',55),('0130351199',55),('0130914290',55),('0131479547',55),('0132380331',55),('0132433109',55),('0135259657',55),('0139737448',55),('0072958863',56),('0073523321',56),('0130351199',56),('0130914290',56),('0131479547',56),('0132380331',56),('0132433109',56),('0135259657',56),('0139737448',56),('0072958863',57),('0073523321',57),('0130351199',57),('0130914290',57),('0131479547',57),('0132380331',57),('0132433109',57),('013513711X',57),('0135259657',57),('0139737448',57),('0072958863',58),('0073523321',58),('0130351199',58),('0130914290',58),('0131479547',58),('0132380331',58),('0132433109',58),('0135259657',58),('0139737448',58),('0072958863',59),('0073523321',59),('0130351199',59),('0130914290',59),('0131479547',59),('0132380331',59),('0132433109',59),('013513711X',59),('0135259657',59),('0139737448',59),('0072958863',60),('0073523321',60),('0130351199',60),('0130914290',60),('0131479547',60),('0132380331',60),('0132433109',60),('0135259657',60),('0139737448',60),('0155775065',60),('0072958863',61),('0073523321',61),('0130351199',61),('0130914290',61),('0131479547',61),('0132380331',61),('0132433109',61),('0135259657',61),('0139737448',61),('0155775065',61),('0130351199',62),('0130914290',62),('0131479547',62),('0132380331',62),('0132433109',62),('013513711X',62),('0135259657',62),('0139737448',62),('0155775065',62);
/*!40000 ALTER TABLE `title_topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `titles`
--

DROP TABLE IF EXISTS `titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `titles` (
  `ISBN` varchar(15) NOT NULL,
  `name` varchar(256) NOT NULL,
  `edition` varchar(45) NOT NULL,
  `image_url` varchar(256) DEFAULT NULL,
  `amazon_price` int(11) DEFAULT NULL,
  `publisher_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ISBN`),
  UNIQUE KEY `ISBN_UNIQUE` (`ISBN`),
  KEY `fk_titles_1_idx` (`publisher_name`),
  CONSTRAINT `fk_titles_1` FOREIGN KEY (`publisher_name`) REFERENCES `publishers` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `titles`
--

LOCK TABLES `titles` WRITE;
/*!40000 ALTER TABLE `titles` DISABLE KEYS */;
INSERT INTO `titles` VALUES ('0060504080','Small Wonder','First','https://images.gr-assets.com/books/1410140967l/14248.jpg',10,'Harper Perennial'),('0060528877','The Wapshot Chronicle','four','https://images.gr-assets.com/books/1405912722l/11890.jpg',9,'Harper Perennial Modern Classics '),('0060786507','The Poisonwood Bible','second ','https://images.gr-assets.com/books/1412242487l/7244.jpg',11,'Harper Perennial Modern Classics '),('0060852550','Animal, Vegetable, Miracle: A Year of Food Life','First','https://images.gr-assets.com/books/1480104279l/25460.jpg',12,'HarperCollins'),('0060852577','The Lacuna','six','https://images.gr-assets.com/books/1355810301l/6433752.jpg',11,'HarperCollins'),('0060921145','Animal Dreams','fifth','https://images.gr-assets.com/books/1481663395l/77262.jpg',9,'HarperCollins'),('0060959037','Prodigal Summer','First','https://images.gr-assets.com/books/1426308771l/14249.jpg',12,'HarperCollins'),('0062124269','Flight Behavior','second ','https://images.gr-assets.com/books/1352212134l/13438524.jpg',12,'HarperCollins'),('0072958863','Database System Concepts','First','https://images.gr-assets.com/books/1348935598l/161332.jpg',33,'McGraw-Hill Education'),('0073523321','Database Systems Concepts','First','https://images.gr-assets.com/books/1347954216l/6758846.jpg',29,'McGraw-Hill Education'),('0130351199','Computer Organization and Architecture: Designing for Performance','First','https://images.gr-assets.com/books/1173511225l/299635.jpg',28,'Prentice Hall'),('0130914290','Cryptography and Network Security: Principles and Practice','First','https://images.gr-assets.com/books/1387711067l/634829.jpg',27,'Prentice Hall'),('0131479547','Operating Systems: Internals and Design Principles','First','https://images.gr-assets.com/books/1172483702l/180249.jpg',34,'Prentice Hall'),('0132380331','Network Security Essentials: Applications and Standards','First','https://images.gr-assets.com/books/1347320357l/299641.jpg',31,'Prentice Hall'),('0132433109','Data and Computer Communications','First','https://images.gr-assets.com/books/1347868351l/299634.jpg',21,'Prentice Hall'),('013513711X','Computer Security: Principles and Practice','six','https://images.gr-assets.com/books/1328050672l/9330894.jpg',16,'Prentice Hall'),('0135259657','High-Speed Networks: TCP/IP and ATM Design Principles','First','https://images.gr-assets.com/books/1266701531l/2287089.jpg',28,'Prentice Hall'),('0139737448','ISDN and Broadband ISDN with Frame Relay and ATM','First','https://images.gr-assets.com/books/1348686369l/516876.jpg',23,'Prentice Hall'),('0142437174','The Adventures of Huckleberry Finn','First','https://images.gr-assets.com/books/1405973850l/2956.jpg',6,'Harper Perennial Modern Classics '),('0155775065','Computer Security: Principles and Practice (2nd Edition) (Stallings)','First','https://images.gr-assets.com/books/1490134068l/34658410.jpg',18,'Prentice Hall'),('0292709048','\"Believing Women\" in Islam: Unreading Patriarchal Interpretations of the Qur\'an','First','https://images.gr-assets.com/books/1348961323l/530114.jpg',12,'University of Texas Press '),('0316013277 ','The Diviners','second ','https://images.gr-assets.com/books/1344269903l/15375.jpg',6,'Back Bay Books'),('0316178551','Hotels of North America','First','https://images.gr-assets.com/books/1427831935l/18583265.jpg',10,'Little, Brown and Company'),('0316578991','Black Veil: A Memoir with Digressions','second ','https://images.gr-assets.com/books/1430892785l/15379.jpg',20,'Little, Brown and Company'),('0316592102','Demonology: Stories','four','https://images.gr-assets.com/books/1344269724l/164615.jpg',15,'Back Bay Books'),('0316706000','The Ice Storm','six','https://images.gr-assets.com/books/1389277858l/15374.jpg',9,'Back Bay Books'),('0316706280','The Ring of Brightest Angels Around Heaven: A Novella and Stories','First','https://images.gr-assets.com/books/1344268212l/94607.jpg',3,'Back Bay Books'),('0316767727','Nine Stories','first ','https://images.gr-assets.com/books/1514839407l/4009.jpg',0,'Hachette'),('0316769029 ','Franny and Zooey ','3rd','https://images.gr-assets.com/books/1355037988l/5113.jpg',22,'Back Bay Books'),('0316769177','The Catcher in the Rye','First','https://images.gr-assets.com/books/1398034300l/5107.jpg',25,'Back Bay Books'),('0375724427','The Stories of John Cheever','Third ','https://images.gr-assets.com/books/1339732173l/11686.jpg',14,'Vintage International '),('0394572742','The Journals Of John Cheever','second ','https://images.gr-assets.com/books/1387707112l/776180.jpg',18,' Knopf'),('0439064864','Harry Potter and the Chamber of Secrets','Third ','https://images.gr-assets.com/books/1474169725l/15881.jpg',10,'Hachette'),('0439554934','Harry Potter and the Sorcerer\'s Stone','First','https://images.gr-assets.com/books/1474154022l/3.jpg',9,'Scholastic Inc'),('0446676500','The Autobiography of Martin Luther King, Jr.','First','https://images.gr-assets.com/books/1386926572l/42547.jpg',10,'Arthur A. Levine Books'),('0450040186','The Shining','Third ','https://images.gr-assets.com/books/1353277730l/11588.jpg',9,'Oxford University Press'),('0452277752 ','The Bachman Books','First','https://images.gr-assets.com/books/1374049003l/10617.jpg',14,'pearson'),('0545010225','Harry Potter and the Deathly Hallows','First ','https://images.gr-assets.com/books/1474171184l/136251.jpg',12,'Arthur A. Levine Books'),('0553250558','The Ceremonies','First','https://images.gr-assets.com/books/1394205084l/757479.jpg',7,'Bantam Books'),('0571171788','Pigs in Heaven','second ','https://images.gr-assets.com/books/1347616121l/14250.jpg',13,'HarperCollins'),('0571179509','High Tide in Tucson','second ','https://images.gr-assets.com/books/1389679947l/14256.jpg',8,'Grand Central Publishing'),('0571200613','Garden State','second ','https://images.gr-assets.com/books/1408925245l/15384.jpg',8,'Little, Brown and Company'),('0618056823','1919 ','Third ','https://images.gr-assets.com/books/1440254386l/7104.jpg',18,'Macmillan Publishers'),('0671685635','Ghost Story','First','https://images.gr-assets.com/books/1441771752l/19581.jpg',12,'Pocket Books'),('0679737863','Falconer','second ','https://images.gr-assets.com/books/1339091605l/722367.jpg',12,'Vintage International '),('0688166326 ','Bearing the Cross: Martin Luther King, JR., and the Southern Christian Leadership Conference','First','https://images.gr-assets.com/books/1428594389l/1659305.jpg',11,'Harper Perennial'),('0802137954','The Ginger Man','six','https://images.gr-assets.com/books/1348768755l/127020.jpg',9,'Grove press'),('0812474945','The Bean Trees','four','https://images.gr-assets.com/books/1443483961l/30868.jpg',8,'Perfection Learning'),('0812516621','The Hungry Moon','second ','https://images.gr-assets.com/books/1503443113l/218637.jpg',11,'Penguin Books Publishing company'),('0812518489','The Pet','First','https://images.gr-assets.com/books/1312066961l/219472.jpg',7,'Tor Books'),('0812971892','No god but God: The Origins, Evolution and Future of Islam','First','https://images.gr-assets.com/books/1388221846l/25307.jpg',14,' Random House Trade '),('0971367035','The Wilco Book','First','https://images.gr-assets.com/books/1348624317l/62087.jpg',3,'Picturebox, Inc.'),('2743609397','Purple America','First','https://images.gr-assets.com/books/1166672342l/15376.jpg',0,' Random House Trade '),('9780989671453','Three Early Stories','second ','https://images.gr-assets.com/books/1400991049l/22314610.jpg',21,'Devault-Graves Digital Editions');
/*!40000 ALTER TABLE `titles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `titles_agg`
--

DROP TABLE IF EXISTS `titles_agg`;
/*!50001 DROP VIEW IF EXISTS `titles_agg`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `titles_agg` AS SELECT 
 1 AS `ISBN`,
 1 AS `name`,
 1 AS `edition`,
 1 AS `image_url`,
 1 AS `amazon_price`,
 1 AS `publisher_name`,
 1 AS `author_names`,
 1 AS `topic_names`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `titles_author_agg`
--

DROP TABLE IF EXISTS `titles_author_agg`;
/*!50001 DROP VIEW IF EXISTS `titles_author_agg`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `titles_author_agg` AS SELECT 
 1 AS `ISBN`,
 1 AS `name`,
 1 AS `edition`,
 1 AS `image_url`,
 1 AS `amazon_price`,
 1 AS `publisher_name`,
 1 AS `author_names`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topics` (
  `topicID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`topicID`),
  UNIQUE KEY `topicID_UNIQUE` (`topicID`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
INSERT INTO `topics` VALUES (1,'sddlkdslds'),(2,'goood'),(3,'Fiction'),(4,'Classic'),(5,'Literature'),(6,'American literature'),(7,'Short Stories'),(8,'20th century Literature'),(9,'Fantasy'),(10,'Young Adult'),(11,'Fantasy> Magic'),(12,'Childrens'),(13,'Adventure'),(14,'Biography'),(15,'History'),(16,'Nonfiction'),(17,'Politics'),(18,'Cultural>African American'),(19,'Biography>Autobiography'),(20,'Race'),(21,'Anthologies'),(22,'Biography Memoir'),(23,'Religion'),(24,'Religion>Islam'),(25,'woman'),(26,'Feminism'),(27,'Historical>Historical Fiction '),(28,'Cultural>Africa'),(29,'Contemporary'),(30,'Novels'),(31,'Food and Drink>Food'),(32,'Autobiography>Memoir'),(33,'Environment>Nature'),(34,'Food and Drink>Cookbooks'),(35,'Food and Drink>Foodie'),(36,'Literary Fiction'),(37,'Abandoned'),(38,'Adult Fiction'),(39,'Writing >Essay'),(40,'Autobiography>Memoir'),(41,'Thriller'),(42,'Horror'),(43,'Suspense'),(44,'Mystery'),(45,'Paranormal>Ghosts'),(46,'Horror>Lovecraftian'),(47,'Humor'),(48,'Cultural>Ireland'),(49,'Travel'),(50,'Helth>Mental Health'),(51,'Music'),(52,'Art'),(53,'Art>Photography'),(54,'Favorites'),(55,'Science'),(56,'Science>programing'),(57,'Computer Science>Computer'),(58,'Science>Technology'),(59,'Reference>Research'),(60,'Textbooks'),(61,'Reference'),(62,'Academic>College');
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `user_points_view`
--

DROP TABLE IF EXISTS `user_points_view`;
/*!50001 DROP VIEW IF EXISTS `user_points_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `user_points_view` AS SELECT 
 1 AS `userID`,
 1 AS `username`,
 1 AS `screen_name`,
 1 AS `email`,
 1 AS `address`,
 1 AS `points`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(40) NOT NULL,
  `password` varchar(40) NOT NULL,
  `address` varchar(256) DEFAULT NULL,
  `email` varchar(40) NOT NULL,
  `type` varchar(10) NOT NULL,
  `screen_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `userID_UNIQUE` (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'adel','adel','here and there ','a@b.c','',NULL),(2,'sdsad','sddsdsadsada','ddsdsdd','dsadsdd@b.c','',NULL),(3,'ali','1234','sdss  sadsadd','b@v.c','member',NULL),(4,'admin','admin','sdksaldk','a@k.h','admin',NULL),(5,'eresd','eeee','eeee','eeee','eeee',NULL),(6,'32323','232323','2332323','2332','member',NULL),(7,'reza','khiar','sldskd l f kdjfkl fdlf ','1@2.c','member',NULL),(9,'john2','john2','Richmond, VA','john2@baging.com','member',NULL),(10,'TJ','TJ','Richmod, VA','TJ@gmail.com','member',NULL),(11,'ram','ram','Orlando, FL','ram@gmail.com','member',NULL),(12,'vcu','vcu','Richmod, VA','vcu@vcu.edu','member',NULL),(13,'richmond','richmond','Richmod, VA','richmond@gmail.com','member',NULL),(14,'virginia','virginia','virginia,virginia','virginia@gmail.com','member',NULL),(15,'alex','alex','New York City, NY','ny@gmail.com','member',''),(16,'jimi','jimi','washington,dc','dc@gmail.com','member',NULL),(17,'mike','mike','Losangelos,la','la@gmail.com','member',NULL),(18,'texas','texas','texas,tx','texas@gmail.com','member',NULL),(19,'sweet','sweet','Henricio,virginia','sweet@gmail.com','member',NULL),(20,'heman','heman','Henricio,virginia','heman@gmail.com','member',NULL),(21,'Laiba','laibatj143','','laiba.ali4500@gmail.com','member',NULL),(22,'12334','1234','123','123@yahoo','member',NULL),(23,'r','r','','r@gmail.com','member',NULL),(24,'jaman','jaman','Richmod, VA','jaman@gmail.com','member',NULL),(25,'duke','duke','Richmond, VA','duke@gmail.com','member',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `view_authors_count`
--

DROP TABLE IF EXISTS `view_authors_count`;
/*!50001 DROP VIEW IF EXISTS `view_authors_count`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_authors_count` AS SELECT 
 1 AS `count`,
 1 AS `name`,
 1 AS `authorID`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_topics_count`
--

DROP TABLE IF EXISTS `view_topics_count`;
/*!50001 DROP VIEW IF EXISTS `view_topics_count`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_topics_count` AS SELECT 
 1 AS `count`,
 1 AS `name`,
 1 AS `topicID`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wishlist` (
  `userID` int(11) NOT NULL,
  `bookID` int(11) NOT NULL,
  PRIMARY KEY (`userID`,`bookID`),
  KEY `fk_wishlist_2_idx` (`bookID`),
  CONSTRAINT `fk_wishlist_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_wishlist_2` FOREIGN KEY (`bookID`) REFERENCES `books` (`bookID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
INSERT INTO `wishlist` VALUES (11,10),(12,21),(10,36),(15,36),(4,40),(15,40),(18,44),(11,46),(15,46),(12,48),(24,55);
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'booktrade'
--
/*!50003 DROP PROCEDURE IF EXISTS `sign_up` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adel`@`%` PROCEDURE `sign_up`(
	in p_username varchar(40),
    in p_password varchar(40),
    in p_email varchar(40),
    in p_address varchar(256)
	)
BEGIN
	DECLARE LID int;
	if ( select exists (select 1 from users where username = p_username) ) THEN
     
        select 'Username Exists !!';
     
    ELSE
     
        insert into users
        (
            username,
            password,
			email,
            address,
            type
        )
        values
        (
            p_username,
            p_password,
            p_email,
            p_address,
            'member'
        );
        SET LID = LAST_INSERT_ID();
        insert into members
        (
            userID,
            points
        )
        values
        (
            LID,
            0
        );
        

     
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `book_title_view`
--

/*!50001 DROP VIEW IF EXISTS `book_title_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `book_title_view` AS select `b`.`userID` AS `userID`,`users`.`username` AS `username`,`b`.`Name` AS `bname`,`b`.`bookID` AS `bookID`,`avail`.`name` AS `avail`,`b`.`addDate` AS `addDate`,`t`.`ISBN` AS `ISBN`,`t`.`name` AS `name`,`t`.`edition` AS `edition`,`t`.`image_url` AS `image_url`,`t`.`amazon_price` AS `amazon_price`,`t`.`publisher_name` AS `publisher_name`,`t`.`author_names` AS `author_names`,`t`.`topic_names` AS `topic_names` from (((`books` `b` join `titles_agg` `t` on((`t`.`ISBN` = `b`.`ISBN`))) join `users` on((`users`.`userID` = `b`.`userID`))) join `availability` `avail` on((`avail`.`id` = `b`.`Availability`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `boot_title_no_agg`
--

/*!50001 DROP VIEW IF EXISTS `boot_title_no_agg`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `boot_title_no_agg` AS select `b`.`userID` AS `userID`,`users`.`username` AS `username`,`b`.`Name` AS `bname`,`b`.`bookID` AS `bookID`,`avail`.`name` AS `avail`,`b`.`addDate` AS `addDate`,`t`.`ISBN` AS `ISBN`,`t`.`name` AS `name`,`t`.`edition` AS `edition`,`t`.`image_url` AS `image_url`,`t`.`amazon_price` AS `amazon_price`,`t`.`publisher_name` AS `publisher_name`,`a`.`name` AS `author_name`,`a`.`authorID` AS `authorID`,`tp`.`name` AS `topic_name` from (((((((`books` `b` join `titles` `t` on((`t`.`ISBN` = `b`.`ISBN`))) join `users` on((`users`.`userID` = `b`.`userID`))) join `availability` `avail` on((`avail`.`id` = `b`.`Availability`))) join `author_title` `at` on((`at`.`ISBN` = `t`.`ISBN`))) join `authors` `a` on((`a`.`authorID` = `at`.`authorID`))) join `title_topic` `tt` on((`t`.`ISBN` = `tt`.`ISBN`))) join `topics` `tp` on((`tt`.`topicID` = `tp`.`topicID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `boot_title_no_agg_no_topic`
--

/*!50001 DROP VIEW IF EXISTS `boot_title_no_agg_no_topic`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `boot_title_no_agg_no_topic` AS select `b`.`userID` AS `userID`,`users`.`username` AS `username`,`b`.`Name` AS `bname`,`b`.`bookID` AS `bookID`,`b`.`addDate` AS `addDate`,`t`.`ISBN` AS `ISBN`,`t`.`name` AS `name`,`t`.`edition` AS `edition`,`t`.`image_url` AS `image_url`,`t`.`amazon_price` AS `amazon_price`,`t`.`publisher_name` AS `publisher_name`,`a`.`name` AS `author_name`,`a`.`authorID` AS `authorID` from ((((`books` `b` join `titles` `t` on((`t`.`ISBN` = `b`.`ISBN`))) join `users` on((`users`.`userID` = `b`.`userID`))) join `author_title` `at` on((`at`.`ISBN` = `t`.`ISBN`))) join `authors` `a` on((`a`.`authorID` = `at`.`authorID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `titles_agg`
--

/*!50001 DROP VIEW IF EXISTS `titles_agg`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `titles_agg` AS select `t`.`ISBN` AS `ISBN`,`t`.`name` AS `name`,`t`.`edition` AS `edition`,`t`.`image_url` AS `image_url`,`t`.`amazon_price` AS `amazon_price`,`t`.`publisher_name` AS `publisher_name`,`t`.`author_names` AS `author_names`,group_concat(`tps`.`name` separator ', ') AS `topic_names` from ((`titles_author_agg` `t` join `title_topic` `tp` on((`tp`.`ISBN` = `t`.`ISBN`))) join `topics` `tps` on((`tps`.`topicID` = `tp`.`topicID`))) group by `t`.`ISBN` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `titles_author_agg`
--

/*!50001 DROP VIEW IF EXISTS `titles_author_agg`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `titles_author_agg` AS select `t`.`ISBN` AS `ISBN`,`t`.`name` AS `name`,`t`.`edition` AS `edition`,`t`.`image_url` AS `image_url`,`t`.`amazon_price` AS `amazon_price`,`t`.`publisher_name` AS `publisher_name`,group_concat(`a`.`name` separator ',') AS `author_names` from ((`titles` `t` join `author_title` `at` on((`at`.`ISBN` = `t`.`ISBN`))) join `authors` `a` on((`a`.`authorID` = `at`.`authorID`))) group by `t`.`ISBN` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_points_view`
--

/*!50001 DROP VIEW IF EXISTS `user_points_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `user_points_view` AS select `users`.`userID` AS `userID`,`users`.`username` AS `username`,`users`.`screen_name` AS `screen_name`,`users`.`email` AS `email`,`users`.`address` AS `address`,`members`.`points` AS `points` from (`users` join `members` on((`users`.`userID` = `members`.`userID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_authors_count`
--

/*!50001 DROP VIEW IF EXISTS `view_authors_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `view_authors_count` AS select count(`t`.`ISBN`) AS `count`,`a`.`name` AS `name`,`a`.`authorID` AS `authorID` from ((`titles` `t` join `author_title` `at` on((`t`.`ISBN` = `at`.`ISBN`))) join `authors` `a` on((`at`.`authorID` = `a`.`authorID`))) group by `a`.`name`,`a`.`authorID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_topics_count`
--

/*!50001 DROP VIEW IF EXISTS `view_topics_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`adel`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `view_topics_count` AS select count(`t`.`ISBN`) AS `count`,`tp`.`name` AS `name`,`tp`.`topicID` AS `topicID` from ((`titles` `t` join `title_topic` `tt` on((`t`.`ISBN` = `tt`.`ISBN`))) join `topics` `tp` on((`tt`.`topicID` = `tp`.`topicID`))) group by `tp`.`name`,`tp`.`topicID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-25  0:24:35
