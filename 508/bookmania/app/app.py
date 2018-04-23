from flask import Flask, render_template, flash, request, session, redirect, url_for
import mysql.connector as mysql
from datetime import date, datetime, timedelta

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
    return render_template('index.html')


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
    titles = get_title_list(sort='ISBN', filter='')
    books = get_user_book_list('7',request.args.get('sort','name'),request.args.get('filter',''))
    
    try:

        # get user points
        query = ("SELECT * from user_points_view where userID = %(userID)s")

        cursor.execute(query, {'userID': userID})

        user = cursor.fetchone()

        # get user books
        # get user wishlist
        # get user trades
        # print (user_books)
        if (update == 0):
            return render_template('userhome.html', session=session,titles=titles,user_books=books, user=user)
        else : 
            return render_template('userhome.html', update='update', book=book, session=session,titles=titles,user_books=books, user=user)
    except Exception as e:
        
        message = 'error:' + str(e)


@app.route('/signup')
def signup():
    return render_template('signup.html')


@app.route('/signin')
def signin():
    return render_template('signin.html')


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

            query = ("SELECT userID,username, password, type from users "
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
        if not flag:
            return render_template("message.html", message=message)


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
        data = cursor.fetchall()

        if len(data) is 0:
            conn.commit()
            message = "User Successfully Created"
        else:
            message = 'error:' + str(data[0])
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
    session['userID'] = '7'
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

def get_user_book_list(user ,sort='name', filter=None):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    query = (
        "select books.bookID as bookID, totaltitles.ISBN as ISBN, totaltitles.name as name, totaltitles.authors as authors, totaltitles.topics as topics, totaltitles.publisher_name as publisher_name, avail.name as avail, totaltitles.amazon_price as amazon_price from books join "
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
        "where totaltitles.name like %(filter)s or publisher_name like %(filter)s or authors like %(filter)s or topics like %(filter)s"
        "order by "+sort+" asc"
        )
    cursor.execute(query,{'filter':'%'+filter+'%'})
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

    author = {
        'name':
        request.form.get('name', None),
        'bio':
        request.form.get('bio', None),
        'birthday':
        datetime.strptime(request.form.get('birthday', None), '%d-%m-%Y'),
        'death':
        datetime.strptime(request.form.get('death', None), '%d-%m-%Y'),
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


def get_user_books(userID):
    conn = mysql.connect(**config)
    cursor = conn.cursor(dictionary=True)

    try:

        # get user points
        query = ("SELECT * from user_points_view where userID = %(userID)s")

        cursor.execute(query, {'userID': userID})

        user = cursor.fetchone()

        # get user books
        # get user wishlist
        # get user trades

        return render_template('userhome.html', session=session, user=user)

    except Exception as e:
        print(cursor._last_executed)
        message = 'error:' + str(e)


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
        "(SELECT t.ISBN, group_concat(tt.topicID separator ', ') topics FROM titles t join title_topic tt on t.ISBN=tt.ISBN "
        "group by t.ISBN) tt2 on t.ISBN = tt2.ISBN "
        "where name like %(filter)s or publisher_name like %(filter)s or authors like %(filter)s or topics like %(filter)s"
        "order by "+sort+" desc"
        )
    cursor.execute(query,{'filter':'%'+filter+'%'})
    print (cursor._executed) 
    return cursor.fetchall()