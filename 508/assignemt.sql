-- Query 1

SELECT prof.profName FROM prof JOIN dept ON prof.deptName = dept.deptName WHERE dept.numPhDs < 45 ;

-- Query 2
SELECT studentName from student as st inner Join (select min(gpa)as mingpa from student) as mins on st.gpa = mins.mingpa ;

-- Query 3
select enroll.sectno, enroll.cno, avg(student.gpa) from enroll
    join student on enroll.sid = student.sid
where enroll.deptName = "Computer Science"
group by sectno, cno;
-- this is not gonna work if there is a class with no enrollment

-- Query 4 
select enroll.sectno, enroll.cno, course.courseName, count(*) as cnt  from enroll
join course on enroll.cno = course.cno
group by sectno, cno
having count(*) < 12 ; 

-- Query 5 
select studentName, sid from (select enroll.sectno, enroll.cno, enroll.sid, student.studentName, count(sectno) as cnt from enroll
    join student on enroll.sid = student.sid
group by sid) as cnttbl
where cnttbl.cnt = (select max(cnt) from (select enroll.sectno, enroll.cno, enroll.sid, student.studentName, count(sectno) as cnt from enroll
											join student on enroll.sid = student.sid
											group by sid) as maxtbl
);

-- Query 6
SELECT 
    student.studentName, major.deptName
FROM
    student
        JOIN
    enroll ON student.sid = enroll.sid
        JOIN
    course ON course.cno = enroll.cno
        JOIN
    major ON major.sid = student.sid
WHERE
    course.courseName LIKE 'College Geometry%';
    
-- Query 7 

SELECT dept.deptName, dept.numPhDs FROM dept 
where dept.deptName NOT IN (SELECT 
    major.deptName
FROM
    student
        JOIN
    enroll ON student.sid = enroll.sid
        JOIN
    course ON course.cno = enroll.cno
        JOIN
    major ON major.sid = student.sid
WHERE
    course.courseName LIKE 'College Geometry%') ; 
    
-- Query 8
SELECT studentName from enroll
	join student on enroll.sid = student.sid
	join enroll as en2 on enroll.sid = en2.sid and enroll.deptName <> en2.deptName
	where enroll.deptName = "Computer Science" and en2.deptName = "Civil Engineering" ;

-- Query 9 
SELECT dept.deptName,   avg(gpa) from dept
	join major on dept.deptName = major.deptName
    join student on major.sid = student.sid
    group by dept.deptName
    having count(major.sid) > 3;
    
-- Query 10
SELECT 
    e2.sid, studentName, gpa
FROM
    (SELECT 
        *
    FROM
        enroll
    WHERE
        enroll.deptName = 'Civil Engineering') AS e2
        JOIN
    student ON student.sid = e2.sid
GROUP BY e2.sid
HAVING COUNT(*) = (SELECT 
        COUNT(*)
    FROM
        course
    GROUP BY deptName
    HAVING deptname = 'Civil Engineering');

