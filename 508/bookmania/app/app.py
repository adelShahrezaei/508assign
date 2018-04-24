from flask import Flask, render_template, flash, request, session, redirect, url_for
import mysql.connector as mysql
from datetime import date, datetime, timedelta
import time

app = Flask(__name__)
app.secret_key = 'thisisasecretkey'

# MySQL configurations
config = {
    'user': 'adel',
    'password': 'mamal65serenti',
    'host': 'homework.canlsvpzzur2.us-east-1.rds.amazonaws.com',
    'database': 'booktrade'
}


@app.route('/')
def main():
    return redirect('/signin')

@app.route('/browse', methods=['GET'])
def browse():
    # publishers = get_publishers()
    topics = get_book_topics_count()
    authors = get_book_authors_count()
    userID = session.get('userID')
    authFilter = request.args.get('authorID',None)
    topicFilter = request.args.get('topicID',None)
    query = request.args.get('query',None)
    filter = ''
    if (authFilter!=None or topicFilter !=None):
        filter = "where"
        if (authFilter !=None):
            filter = filter+" author_names like '%"+authFilter+"%' "
        
        if (topicFilter !=None):
            filter = filter+" topic_names like '%"+topicFilter+"%' "
    if (query != None):
        filter = "where"
        
        filter = filter+(" author_names like '%%%s%%' OR name like '%%%s%%' OR bname like '%%%s%%' OR topic_names like '%%%s%%' OR username like '%%%s%%'") % (query,query,query,query,query)
        
     
        

    books = get_browse_book_list(request.args.get('sort','bname'),filter)

    
    return render_template(
        'browse.html',books = books,  authors=authors, topics=topics)


@app.route('/admin', methods=['GET'])
def admin():

    publishers = get_publishers()
    topics = get_topics()
    authors = get_authors()
    
    titles = get_title_list(request.args.get('sort','name'),request.args.get('filter',''))
    
    return render_template(
        'admin.html',titles = titles,  authors=authors, topics=topics, publishers=publishers)


@app.route('/userhome')
def user_home():
    update = 0
    if (request.args.get('action')=="delete"):
        
        delete_user_book(request.args.get('id'))

    if (request.args.get('action')=="update"):
        update = 1
        book = get_user_book(request.args.get('id'))

    
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    userID = int(session.get('userID'))
    print(userID)
    titles = get_title_list(sort='ISBN', filter='')
    books = get_user_book_list(userID,request.args.get('sort','name'),request.args.get('filter',''))
    wishlist = get_whishlist(session.get('userID'))
    friends = get_friends(userID)
    exchanges = get_exchanges(userID)

    # get user points
    query = ("SELECT * from user_points_view where userID = %(userID)s")

    cursor.execute(query, {'userID': userID})

    user = cursor.fetchone()

    # get user books
    # get user wishlist
    # get user trades
    # print (user_books)
    conn.close()
    if (update == 0):
        return render_template('userhome.html',exchanges = exchanges,wishlist=wishlist, session=session, friends=friends,titles=titles,user_books=books, user=user)
    else : 
        return render_template('userhome.html',exchanges = exchanges, update='update',wishlist=wishlist,friends=friends, book=book, session=session,titles=titles,user_books=books, user=user)

@app.route('/user', methods=['GET'])
def user():
    userID = request.args.get('userID')
 
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    myID = int(session.get('userID'))
    
    friends = get_friends(userID)
    books = get_user_book_list(userID,request.args.get('sort','name'),request.args.get('filter',''))
    wishlist = get_whishlist(userID)
    exchanges = get_exchanges(userID)

    
    # get user points
    query = ("SELECT * from user_points_view where userID = %(userID)s")

    cursor.execute(query, {'userID': userID})

    user = cursor.fetchone()

    # get user books
    # get user wishlist
    # get user trades
    # print (user_books)
    conn.close()
    return render_template('user.html',exchanges = exchanges, wishlist=wishlist, friends=friends, session=session,user_books=books, user=user)
    

    
    


  
@app.route('/signup')
def signup():
    return render_template('signup.html')


@app.route('/signin')
def signin():
    return render_template('signin.html')


@app.route('/signout')
def signout():
    session.clear()
    return redirect('/signin')

@app.route('/dosignin', methods=['POST'])
def do_sign_in():
    session.clear()
    flag = 0
    message = ""
    conn = mysql.connect(**config)
    cursor = conn.cursor()

    try:
        _username = request.form['inputUsername']
        _password = request.form['inputPassword']

        # validate the received values

        if _username and _password:

            # All Good, let's call MySQL

            query = ("SELECT userID,username, password,type from users "
                     "where username = (%s) AND password = (%s)")

            cursor.execute(query, (_username, _password))
            data = cursor.fetchall()

            if len(data) is 0:
                conn.commit()
                message = "Wrong username or password!"
            else:
                flag = 1
                session['username'] = str(data[0][1])
                session['usertype'] = str(data[0][3])
                session['userID'] = str(data[0][0])
                

                if flag:
                    return redirect(url_for('user_home'))

        else:
            message = "<span>Enter the required fields</span>"

    except Exception as e:
        print(cursor._last_executed)
        message = 'error:' + str(e)
    finally:
        cursor.close()
        conn.close()
        print (str(data[0][3]))
        if (flag==1):
            
            if (str(data[0][3])=='admin'):
                return redirect('/admin')
            else:   
                return redirect('/userhome')
        else:
            return render_template('message.html', message = "Wrong user name or password")


@app.route('/dosignup', methods=['POST'])
def do_sign_up():
    message = ""
    conn = mysql.connect(**config)
    cursor = conn.cursor()

    # try:
    _username = request.form['inputUsername']
    _email = request.form['inputEmail']
    _address = request.form['inputAddress']
    _password = request.form['inputPassword']

    # validate the received values

    if _username and _email and _password:

        # All Good, let's call MySQL

        cursor.callproc('sign_up', (_username, _password, _email, _address))
        

    
        conn.commit()
        message = "User Successfully Created"
    
    else:
        message = "<span>Enter the required fields</span>"

    # except Exception as e:
    #     message = 'error:'+str(e)


# finally:
    cursor.close()
    conn.close()
    return render_template("message.html", message=message)


@app.route('/create_user_book', methods=['POST'])
def create_user_book():
    print (request.form)
    ###TEST
    # session['userID'] = '7'
    userbook = {
        'userID': session.get('userID'),
        'addDate': datetime.now().date(),
        'name': request.form['name'],
        'Availability': request.form['avail'],
        'ISBN': request.form['ISBN']
    }
    return create_user_book_fn(userbook)


def create_user_book_fn(userbook):

    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    try:

        query = (
            "INSERT INTO books"
            "(userID,addDate,Name,Availability,ISBN) "
            "VALUES (%(userID)s,%(addDate)s,%(name)s,%(Availability)s,%(ISBN)s);"
        )

        cursor.execute(query, userbook)

        conn.commit()

        # get user books
        # get user wishlist
        # get user trades

        flash("Book Added")
        return redirect('/userhome')

    except Exception as e:

        print(str(e))
        # print (cursor._last_executed)

    finally:
        cursor.close()
        conn.close()

def delete_user_book(bookID):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    query= ("delete from books where bookID = %(bookID)s" )
    cursor.execute(query, {'bookID': bookID})
    conn.commit()
    conn.close()
    flash("Book Deleted")
    return True


@app.route('/update_user_book', methods=['POST'])
def update_user_book():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    book = {'1':request.form.get('ISBN'), '2':request.form.get('name'), '3':request.form.get('avail'), '4':request.form.get('bookID')}
    query= ("update books set ISBN = (%(1)s), Name = (%(2)s), Availability = (%(3)s)   where bookID = (%(4)s) " )
    cursor.execute(query, book)
    
    
    conn.commit()
    conn.close()
    flash("book updated")

    return redirect('/userhome')

def get_user_book(bookID):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    query= ("select * from books where bookID = (%(1)s) " )
    cursor.execute(query, {'1':bookID})
    
    
    
    conn.close()
    return cursor.fetchone()

def get_user_book_list(user ,sort='name', filter=''):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = (
        "select books.userID as userID, books.bookID as bookID, totaltitles.ISBN as ISBN, totaltitles.name as name, totaltitles.authors as authors, totaltitles.topics as topics, totaltitles.publisher_name as publisher_name, avail.name as avail, totaltitles.amazon_price as amazon_price from books join "
        "(select t.*, ta.authors, tt2.topics  from titles t join "
        "(SELECT t.ISBN, group_concat(ath.name separator ', ') authors FROM titles t join author_title a on t.ISBN=a.ISBN "
        "join authors ath on a.authorID = ath.authorID "
        "group by t.ISBN) ta on ta.ISBN = t.ISBN "
        "left join "
        "(SELECT t.ISBN, group_concat(topics.name separator ', ') topics FROM titles t join title_topic tt on t.ISBN=tt.ISBN "
        "join topics on tt.topicID = topics.topicID "
        "group by t.ISBN) tt2 on t.ISBN = tt2.ISBN ) as totaltitles "
        "on books.ISBN = totaltitles.ISBN "
        "join availability avail on books.Availability= avail.id "
        "where userID = %(userID)s AND (totaltitles.name like %(filter)s or publisher_name like %(filter)s or authors like %(filter)s or topics like %(filter)s)"
        "order by "+sort+" asc"
        )
    cursor.execute(query,{'filter':'%'+filter+'%', 'userID':user})
    # print (cursor._executed) 
    return cursor.fetchall()

@app.route('/create_title', methods=['POST'])
def create_title():

    ###TEST
    authors = request.form.getlist('authors')
    topics = request.form.getlist('topics')
    title = {
        'ISBN': request.form.get('ISBN'),
        'name': request.form.get('name'),
        'edition': request.form.get('edition', 'first'),
        'image_url': request.form.get('image_url', None),
        'amazon_price': request.form.get('amazon_price', None),
        'publisher_name': request.form.get('publisher_name', None)
    }

    return create_title_fn(title, authors, topics)


def create_title_fn(title, authors, topics):

    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    try:

        query = (
            "INSERT INTO titles "
            "(`ISBN`,`name`,`edition`,`image_url`,`amazon_price`,`publisher_name`) "
            "VALUES (%(ISBN)s,%(name)s,%(edition)s,%(image_url)s,%(amazon_price)s,%(publisher_name)s);"
        )

        cursor.execute(query, title)

        conn.commit()

        for author in authors:
            add_title_author(title['ISBN'], author)
        for topic in topics:
            add_topic_fn(topic, title['ISBN'])
        # get user books
        # get user wishlist
        # get user trades

        flash("Title Added")
        return redirect('/admin')

    except Exception as e:

        print(str(e))
        # print (cursor._last_executed)

    finally:
        cursor.close()
        conn.close()


@app.route('/create_author', methods=['POST'])
def create_author():

    ###TEST
    birth = request.form.get('birthday', None)
    death = request.form.get('death', None)
    print (birth, death)
    if (birth!=''):
        birth = datetime.strptime(birth, '%d-%m-%Y')
    
    if (death!=''):
        death = datetime.strptime(death, '%d-%m-%Y')
    
    author = {
        'name':
        request.form.get('name', None),
        'bio':
        request.form.get('bio', None),
        'birthday': birth,
        'death': death,
        'image_url':
        request.form.get('image_url', None)
    }

    return create_author_fn(author)


def create_author_fn(author):

    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    try:

        query = (
            "INSERT INTO authors "
            "(`name`,`bio`,`birthday`,`death`,`image_url`) "
            "VALUES(%(name)s,%(bio)s,%(birthday)s,%(death)s,%(image_url)s);")

        cursor.execute(query, author)

        conn.commit()

        # get user books
        # get user wishlist
        # get user trades
        flash("Author Added")
        return redirect('/admin')

    except Exception as e:

        print(str(e))
        # print (cursor._last_executed)

    finally:
        cursor.close()
        conn.close()


@app.route('/create_publisher', methods=['POST'])
def create_publisher():

    publisher = {
        'name': request.form['name'],
        'address': request.form['address']
    }
    return create_publisher_fn(publisher)


def create_publisher_fn(publisher):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    try:

        query = (
            "INSERT INTO publishers (name, address) VALUES (%(name)s, %(address)s)"
        )

        cursor.execute(query, publisher)

        conn.commit()

        # get user books
        # get user wishlist
        # get user trades
        flash("Publisher Added")
        return redirect('/admin')

    except Exception as e:

        print(str(e))
        print(cursor._last_executed)

    finally:
        cursor.close()
        conn.close()


@app.route('/create_topic', methods=['POST'])
def create_topic():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    try:

        query = ("INSERT INTO topics (name) VALUES (%(name)s)")
        data = {'name': request.form['name']}
        cursor.execute(query, data)

        conn.commit()

        # get user books
        # get user wishlist
        # get user trades
        flash("Topic Added")
        return redirect('/admin')

    except Exception as e:

        print(str(e))
        print(cursor._last_executed)

    finally:
        cursor.close()
        conn.close()


def add_topic_fn(topicID, ISBN):

    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    try:

        # query = ("select topicID where topic=%s")
        # topicID = None
        # cursor.execute(query, (topic))
        # if (cursor.rowcount() == 0):
        #     #if topic does not exist create it
        #      query = ("insert into topics (name) values (%s)")
        #      cursor.execute(query,(topic))
        #      conn.commit()

        #      topicID = cursor.lastrowid
        # else:
        # topicID = cursor.fetchone()['topicID']

        query = ("insert into title_topic (ISBN, topicID) values (%s,%s)")
        cursor.execute(query, (ISBN, topicID))
        conn.commit()

        # get user books
        # get user wishlist
        # get user trades

        return True

    except Exception as e:

        print(str(e))
        print(cursor._last_executed)

    finally:
        cursor.close()
        conn.close()


# def get_user_books(userID):
#     conn = mysql.connect(**config)
#     cursor = conn.cursor(dictionary=True)

#     try:

#         # get user points
#         query = ("SELECT * from user_points_view where userID = %(userID)s")

#         cursor.execute(query, {'userID': userID})

#         user = cursor.fetchone()

#         # get user books
#         # get user wishlist
#         # get user trades

#         return render_template('userhome.html', session=session, user=user)

#     except Exception as e:
#         print(cursor._last_executed)
#         message = 'error:' + str(e)


def add_title_author(ISBN, authorID):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = ("insert into author_title (ISBN, authorID) values (%s,%s)")
    cursor.execute(query, (ISBN, authorID))
    conn.commit()

    return True


def get_publishers():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = ("SELECT * from publishers")
    cursor.execute(query)
    return cursor.fetchall()


def get_topics():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = ("SELECT * from topics")
    cursor.execute(query)
    return cursor.fetchall()


def get_authors():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = ("SELECT name, authorID from authors")
    cursor.execute(query)
    return cursor.fetchall()


def get_title_list(sort='name', filter=None):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = (
        "select t.*, ta.authors, tt2.topics  from titles t join "
        "(SELECT t.ISBN, group_concat(ath.name separator ', ') authors FROM titles t join author_title a on t.ISBN=a.ISBN "
        "join authors ath on a.authorID = ath.authorID "
        "group by t.ISBN) ta on ta.ISBN = t.ISBN "
        "left join "
        "(SELECT t.ISBN, group_concat(tps.name separator ', ') topics FROM titles t join title_topic tt on t.ISBN=tt.ISBN "
        "join topics tps on tps.topicID = tt.topicID "
        "group by t.ISBN) tt2 on t.ISBN = tt2.ISBN "
        "where name like %(filter)s or publisher_name like %(filter)s or authors like %(filter)s or topics like %(filter)s"
        "order by "+sort+" asc"
        )
    cursor.execute(query,{'filter':'%'+filter+'%'})
    print (cursor._executed) 
    return cursor.fetchall()

def get_book_authors_count():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = (
        "SELECT count(*) as count, a.name as name, a.authorID as authorID " 
        "FROM books join author_title at on at.ISBN = books.ISBN " 
        "join authors a on a.authorID = at.authorID "
        "group by a.name"
        )
    cursor.execute(query)
    # print (cursor._executed) 
    return cursor.fetchall()

def get_topics_count():
    pass

def get_book_topics_count():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = (
        "SELECT count(*) as count, a.name as name, a.topicID as topicID " 
        "FROM books join title_topic at on at.ISBN = books.ISBN " 
        "join topics a on a.topicID = at.topicID "
        "group by a.name"
        )
    cursor.execute(query)
    # print (cursor._executed) 
    return cursor.fetchall()

def get_topics_count():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = (
        "SELECT * FROM booktrade.view_topics_count;"
        )
    cursor.execute(query)
    # print (cursor._executed)
    conn.close() 
    return cursor.fetchall()

def get_browse_book_list(sort='name', filter=None):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    if sort == 'None':
        sort = 'bname'
    query = ("SELECT * FROM booktrade.book_title_view "+filter+" order by "+sort+" asc ;")

    cursor.execute(query)
    print (cursor._executed) 
    conn.close()
    return cursor.fetchall()

def get_books_for_title(ISBN, filters):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)


    query = ("SELECT * FROM booktrade.books_title_agg where %(filters)s;")

    cursor.execute(query, {'filters': filter})
    conn.close()
    return cursor.fetchall()
    

def get_whishlist(user):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    query =  ("SELECT b.* from wishlist w join book_title_view b on b.bookID=w.bookID where w.userID='%s'") % (user)
    cursor.execute(query)
    conn.close()

    return cursor.fetchall()

@app.route('/addfriend', methods=['get'])
def add_friend():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    query = ("insert into friends (userID1,userID2) values ('%s', '%s') ;") % (session.get('userID'), request.args.get('userID'))
    cursor.execute(query)
    conn.commit()
    flash("Firend Added")
    conn.close()
    return redirect(request.referrer)
def get_friends(userID):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    query =  ("SELECT users.*, userID1 FROM booktrade.friends join users on userID2= users.userID where friends.userID1='%s'") % (userID)
    cursor.execute(query)
    conn.close()

    return cursor.fetchall()

@app.route('/addtowish', methods=['get'])
def add_whishlist():
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    query = ("insert into wishlist (userID,bookID) values ('%s', '%s') ;") % (session.get('userID'), request.args.get('bookID'))
    cursor.execute(query)
    conn.commit()
    flash("Added To Wishlist")
    conn.close()
    return redirect(request.referrer)
    
def get_most_recent_books(count):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    conn.close()

def get_highest_ranked_books(count):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    conn.close()
    pass

def exchange_book(bookID, userID):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    conn.close()
    pass

def get_author(authorID):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    conn.close()
    pass
def get_points(userID):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = ("select points from members where userID=%s ") % (userID)
    cursor.execute(query)
    
    conn.close()
    return cursor.fetchone()
    
def get_exchanges(userID):

    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = ("select users.username,e.userID2 as userID,  b.name, e.date from exchanges e "
            "join users on e.userID2 = users.userID "
            "join book_title_view b on b.bookID = e.bookID "
            "where e.userID1 = %s") % (userID) 
    cursor.execute(query)
    
    conn.close()
    return cursor.fetchall()
    

@app.route('/exchange', methods=['get'])
def exchange():
    
    points = get_points(session.get('userID'))


    
    books = get_user_book_list(user=session.get('userID'))

    return render_template('exchange.html',books = books,points=points['points'], bookID2 = request.args.get('bookID2'),userID2 = request.args.get('userID2') )

@app.route('/do_exchange', methods=['POST'])
def do_exchange():
    userID1 = session.get('userID')
    userID2 = request.form.get('userID2')
    bookID = request.form.get('bookID2')
    

    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)
    query = ("insert into exchanges (userID1, userID2, bookID, date) values ('%s','%s','%s','%s') ") % (userID1,userID2,bookID, time.strftime('%Y-%m-%d %H:%M:%S'))
    cursor.execute(query)
    conn.commit()    
    

    query = ("update books set userID=%s where bookID =%s") % (userID1,bookID)
    cursor.execute(query)
    conn.commit()       

    # query = query + ("; update books set userID= '%s' where bookID = '%s'") % (userID2,bookID1)
    
    query = ("update members set points= points+1 where userID IN ('%s')") % (userID2)
    cursor.execute(query)
    conn.commit()   
    query = ("update members set points= points-1 where userID IN ('%s')") % (userID1)
    cursor.execute(query)
    conn.commit()   

    conn.close()
    
    flash("Book Exchanged!")
    return redirect('/userhome')