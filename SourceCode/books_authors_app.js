var express = require('express');
var mysql = require('./dbcon.js');
var CORS = require('cors')

var app = express();
app.set('port', 3000);
app.use(express.json())
app.use(express.urlencoded({extended: false}))
app.use(CORS());
app.use(express.static('public'));

// Book page queries 
const getAllQuery = 'SELECT * FROM books';  // gets all the rows from the database
const getTitle = 'SELECT * FROM books WHERE title=?';
const getISBN = 'SELECT * FROM books WHERE isbn=?';
const getAuthLastName = 'SELECT * FROM books JOIN authors ON books.auth_id = authors.auth_id AND authors.auth_last_name=?'; 
const getYear = 'SELECT * FROM books WHERE year=?';
const getAllFields = 'SELECT * FROM books JOIN authors ON books.auth_id = authors.auth_id WHERE title=? AND isbn=? AND authors.auth_last_name = ? AND year=?';
const insertQuery = "INSERT INTO books (`isbn`, `title`, `auth_id`, `year`, `copies_available`) VALUES (?, ?, ?, ?, ?)";  // insert row in the database
const updateQuery = "UPDATE books SET isbn=?, title=?, auth_id=?, year=?, copies_available=? WHERE id=? ";  // updates row in the database
const getTitleLastName = 'SELECT * FROM books JOIN authors ON books.auth_id = authors.auth_id WHERE title=? AND authors.auth_last_name = ?';
const getTitleLastNameYear = 'SELECT * FROM books JOIN authors ON books.auth_id = authors.auth_id WHERE title=? AND authors.auth_last_name = ? AND year=?';
const getTitleYear = 'SELECT * FROM books JOIN authors ON books.auth_id = authors.auth_id WHERE title=? AND year=?';
const getLastNameYear = 'SELECT * FROM books JOIN authors ON books.auth_id = authors.auth_id WHERE authors.auth_last_name = ? AND year=?';
const updateBooks = 'UPDATE `books` SET isbn=?, title=?, auth_id=?, year=?, copies_available=? WHERE book_id =?';
const deleteBooks = 'DELETE FROM books WHERE book_id=?'

// Authors page queries
const getAllQueryAuth = 'SELECT * FROM authors';
const insertQueryAuth = "INSERT INTO authors (`auth_first_name`, `auth_mid_name`, `auth_last_name`) VALUES (?, ?, ?)"; 
const getAuthorID = "SELECT * FROM authors WHERE auth_id =?";
const getAuthorFirstName = "SELECT * FROM authors WHERE auth_first_name=?";
const getAuthorLastName = "SELECT * FROM authors WHERE auth_last_name=?";
const getAuthorFirstLastName = "SELECT * FROM authors  WHERE auth_first_name =? AND auth_last_name =?";
const updateAuthors = 'UPDATE authors SET auth_first_name=?, auth_mid_name=?, auth_last_name=? WHERE auth_id=?';
const deleteAuthors= 'DELETE FROM authors WHERE auth_id=?'

// Members page queries
const getAllMembers = 'SELECT * FROM members' ;
const insertMemberQuery = "INSERT INTO members (`mem_first_name`, `mem_mid_name`, `mem_last_name`, `mem_email`, `mem_zip_code`) VALUES (?, ?, ?, ?, ?)";
const deleteMemQuery = "DELETE FROM members WHERE mem_id=?";
const updateMembers = 'UPDATE members SET mem_first_name=?, mem_mid_name=?, mem_last_name=?, mem_email=?, mem_zip_code=? WHERE mem_id=?'

// Member Account page queries
const getAllLoans = `SELECT title, auth_first_name, auth_last_name, loans.loan_id, loan_date, book_loan.loan_status, books.book_id 
                    FROM members 
                    JOIN loans ON members.mem_id = loans.mem_id
                    JOIN book_loan ON loans.loan_id = book_loan.loan_id
                    JOIN books ON book_loan.book_id = books.book_id
                    JOIN authors ON books.auth_id = authors.auth_id
                    AND members.mem_id = ?;`
const insertBookLoanQuery = `INSERT INTO book_loan (loan_id, book_id)
                            VALUES (?,?);`
const insertLoanQuery =   `INSERT INTO loans (mem_id, loan_date)
                          VALUES (?, ?);`
const updateLoanQuery = `UPDATE loans JOIN book_loan ON loans.loan_id = book_loan.loan_id
                        SET loan_date=?, book_loan.loan_status = ? 
                        WHERE book_loan.loan_id=? AND book_id = ? `;
const deleteLoanQuery = `DELETE FROM book_loan 
                        WHERE loan_id=? and book_id =?`;

// sends the entire table/data back to the client
const getAllData = (res) => {
  mysql.pool.query(getAllQuery, (err, rows, field) => {
    if(err){
      next(err);
      return;
    }
    res.json({'rows':rows});
  });
};

// GET route for BOOKS
app.get('/books',function(req,res,next){
  var context = {};
  // all fields were selected.
  if (req.query.title && req.query.isbn && req.query.last_name && req.query.year){
    mysql.pool.query(getAllFields, [req.query.title, req.query.isbn, req.query.last_name, req.query.year], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

    // book title, author last name, year selected
  } else if (req.query.title && req.query.last_name && req.query.year){
    mysql.pool.query(getTitleLastNameYear, [req.query.title, req.query.last_name, req.query.year], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

  // book title and author last name field selected
  } else if (req.query.title && req.query.last_name){
    mysql.pool.query(getTitleLastName, [req.query.title, req.query.last_name], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    }); 

    // book title and year selected
  } else if (req.query.title && req.query.year){
    mysql.pool.query(getTitleYear, [req.query.title, req.query.year], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

    // book author last name and year selected
  } else if (req.query.last_name && req.query.year){
    mysql.pool.query(getLastNameYear, [req.query.last_name, req.query.year], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

   // book title selected
  }else if (req.query.title) {
    mysql.pool.query(getTitle, [req.query.title], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

    // book isbn selected
  } else if (req.query.isbn) {
    mysql.pool.query(getISBN, [req.query.isbn], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

    // book author last name selected.
  } else if (req.query.last_name) {
    mysql.pool.query(getAuthLastName, [req.query.last_name], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

    // book year selected
  } else if (req.query.year){
    mysql.pool.query(getYear, [req.query.year], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

    // no fields were selected, show all data
  } else {
    mysql.pool.query(getAllQuery, function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });
  }
});


// GET route for AUTHORS
app.get('/authors',function(req,res,next){
  var context = {};
  // first and last name selected
  if (req.query.first_name && req.query.author_last_name){
    mysql.pool.query(getAuthorFirstLastName, [req.query.first_name, req.query.author_last_name], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });
    
  // author id selected
  } else if (req.query.auth_id) {
    mysql.pool.query(getAuthorID, [req.query.auth_id], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

  // author first name selected
  } else if (req.query.first_name) {
    mysql.pool.query(getAuthorFirstName, [req.query.first_name], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

  // author last name selected
  } else if (req.query.author_last_name) {
    mysql.pool.query(getAuthorLastName, [req.query.author_last_name], function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });

  // no fields were selected, show all data
  } else {
    mysql.pool.query(getAllQueryAuth, function(err, rows, fields){
      if(err){
        next(err);
        return;
      }
      context.results = JSON.stringify(rows);
      res.send(context);
    });
  }
});

// functions for MEMBERS
const getMemAllData = (res) => {
  mysql.pool.query(getAllMembers, (err, rows, fields) => {
    if (err) {
      next(err);
      return;
    }
    res.json({'rows': rows });
  })
}

const getMemSearchResults = (req, res) => {
  if (req.query.nameSearch !== "" && req.query.zipSearch !== "") {
    mysql.pool.query('SELECT * FROM members WHERE mem_last_name = ? AND mem_zip_code = ?', [req.query.nameSearch,req.query.zipSearch], (err, rows, fields) => {
      if (err) {
        next(err);
        return;
      }
      res.json({'rows': rows });
    })
  } else if (req.query.nameSearch !== "") {
    mysql.pool.query('SELECT * FROM members WHERE mem_last_name =?', req.query.nameSearch, (err, rows, fields) => {
      if (err) {
        next(err);
        return;
      }
      res.json({'rows': rows });
    })
  } else if (req.query.zipSearch !== "") {
    mysql.pool.query('SELECT * FROM members WHERE mem_zip_code =?', req.query.zipSearch, (err, rows, fields) => {
      if (err) {
        next(err);
        return;
      }
      res.json({'rows': rows });
    })
  } else {
    getMemAllData(res);
  }
 
}

// GET MEMBERS
app.get('/members',function(req,res,next){
  if (Object.keys(req.query).length !== 0) {
    // console.log(req.query)
    getMemSearchResults(req,res);
  } else {
    // console.log(req.query)
    getMemAllData(res);
  }
});

// functions for MEMBERACCOUNT
let memLoanRes = {}
const getMemLoans = (req, res) => {
  mysql.pool.query(getAllLoans, req, (err, rows, fields) => {
    if (err) {
      console.log(req)
      console.log('get mems loan')
      next(err);
      return;
    }

    memLoanRes.loans = rows
    res.json({'loans': memLoanRes.loans});
  })
}

// GET LOAN and RESERVATIONS
app.get('/memberAccount',function(req,res,next){
  let mem_id = req.query.mem_id;
  getMemLoans(mem_id,res);
});


function toISOLocal(d) {
  var z  = n =>  ('0' + n).slice(-2);
  var zz = n => ('00' + n).slice(-3);
  var off = d.getTimezoneOffset();
  var sign = off < 0? '+' : '-';
  off = Math.abs(off);

  return d.getFullYear() + '-'
         + z(d.getMonth()+1) + '-' +
         z(d.getDate()) + 'T' +
         z(d.getHours()) + ':'  + 
         z(d.getMinutes()) + ':' +
         z(d.getSeconds()) + '.' +
         zz(d.getMilliseconds()) +
         sign + z(off/60|0) + ':' + z(off%60); 
}

//  POST route for BOOKS
app.post('/books',function(req,res,next){
  var context = {};
  var {isbn, title, auth_id, year, copies_available} = req.body;   
  mysql.pool.query( insertQuery, [isbn, title, auth_id, year, copies_available], function(err, result){
    if(err){
      next(err);
      return;
    }
    getAllData(res);
  });
});

// POST route for AUTHORS
app.post('/authors',function(req,res,next){
  var context = {};
  console.log(req.body)
  var {auth_first_name, auth_mid_name, auth_last_name} = req.body;   
  mysql.pool.query( insertQueryAuth, [auth_first_name, auth_mid_name, auth_last_name], function(err, result){
    if(err){
      next(err);
      return;
    }
    getAllData(res);
  });
});

// POST MEMBERS
app.post('/members',function(req,res,next){
var {mem_first_name, mem_mid_name, mem_last_name, mem_email, mem_zip_code, mem_id} = req.body;
mysql.pool.query(insertMemberQuery, [mem_first_name, mem_mid_name, mem_last_name, mem_email, mem_zip_code], (err, result) => {
  if(err){
    next(err);
    return;
  }
  getMemAllData(res);
});
});

// POST LOAN
app.post('/memberAccount',function(req,res,next){
  var {mem_id, booksIdSelected} = req.body;
  var newDate = new Date()
  var loan_date = toISOLocal(newDate).slice(0,19).replace('T', ' ')
  mysql.pool.query(insertLoanQuery, [mem_id, loan_date], (err, result) => {
    if(err){
      next(err);
      return;
    }

    for ( let i = 0; i < booksIdSelected.length; i++){
      mysql.pool.query(insertBookLoanQuery, [String(result.insertId), booksIdSelected[i]], (err, result1) => {
        if(err){
          next(err);
          return;
        }

        mysql.pool.query('UPDATE books SET copies_available = copies_available -1 \
                          WHERE book_id = ?', booksIdSelected[i], (err, result1) => {
          if(err){
            next(err);
            return;
          }

          if (i == booksIdSelected.length - 1) {
            getMemLoans(mem_id,res);
          }

        });
      });
    }
  })
});

// DELETE LOAN
app.delete('/memberAccount',function(req,res,next){
  var loan_id = req.body.loan_id;
  var mem_id = req.body.mem_id;
  var loan_status = req.body.loan_status;
  var book_id = req.body.book_id
  mysql.pool.query(deleteLoanQuery, [loan_id, book_id], (err, result) => {
    if(err){
      next(err);
      return;
    }

    if (loan_status == "Active"){
      mysql.pool.query('UPDATE books SET copies_available = copies_available + 1 \
                        WHERE book_id = ? AND copies_available < 10', book_id, (err, result1) => {
        if(err){
          next(err);
          return;
        }
        getMemLoans(mem_id,res);
    })
    } else {
      getMemLoans(mem_id,res);
    }
  });
  });

// deletes BOOKS instance.
app.delete('/books',function(req,res,next){
  var {book_id} = req.body;
  mysql.pool.query(deleteBooks, [book_id], function(err, result){
    if(err){
      next(err);
      return;
    }
    getAllData(res);
  });
});

// deletes AUTHORS instance.
app.delete('/authors',function(req,res,next){
  var {auth_id} = req.body;
  mysql.pool.query(deleteAuthors, [auth_id], function(err, result){
    if(err){
      next(err);
      return;
    }
    getAllData(res);
  });
});

// DELETE MEMBERS
app.delete('/members',function(req,res,next){
  var context ={};
  var mem_id = req.body.id;

  // checks all active book loans_status before member is deleted, and increments copies_available by 1.
  mysql.pool.query(getAllLoans, mem_id, (err, rows, fields) => {
    if (err) {
      next(err);
      return;
    }
    context.results = rows
    loans = context.results
    for ( let i = 0; i < loans.length; i++){
        let bookId = loans[i].book_id
        if (loans[i].loan_status == 1){
          mysql.pool.query('UPDATE books SET copies_available = copies_available +1 \
                            WHERE book_id = ? AND copies_available < 10', bookId, (err, result1) => {
            if(err){
              next(err);
              return;
            }
        })}
    }
  });
  // deletes member 
  mysql.pool.query(deleteMemQuery, mem_id, (err, result) => {
    if(err){
      next(err);
      return;
    }

    getMemAllData(res);
  });
  });

// updates Members instance.
app.put('/members',function(req,res,next){
  var {mem_first_name, mem_mid_name, mem_last_name, mem_email, mem_zip_code, mem_id} = req.body
  console.log(req.body)
  mysql.pool.query(updateMembers,[mem_first_name, mem_mid_name, mem_last_name, mem_email, mem_zip_code, mem_id], function(err, result){
    if(err){
      next(err);
      return;
    }
    getMemAllData(res);
  });
});

// updates BOOKS instance.
app.put('/books',function(req,res,next){
  var context = {};
  var {isbn, title, auth_id, year, copies_available, book_id} = req.body
  mysql.pool.query(updateBooks,[isbn, title, auth_id, year, copies_available, book_id], function(err, result){
    if(err){
      next(err);
      return;
    }
    getAllData(res);
  });
});

// updates AUTHORS instance.
app.put('/authors',function(req,res,next){
  var context = {};
  var {auth_first_name, auth_mid_name, auth_last_name, auth_id} = req.body
  mysql.pool.query(updateAuthors,[auth_first_name, auth_mid_name, auth_last_name, auth_id], function(err, result){
    if(err){
      next(err);
      return;
    }
    getAllData(res);
  });
});

// UPDATE LOAN
app.put('/memberAccount',function(req,res,next){
  var {loan_id, loan_date, loan_status, book_id, mem_id} = req.body
  loan_date = new Date(loan_date)
  loan_date = loan_date.toISOString().slice(0, 19).replace('T', ' ')
  mysql.pool.query(updateLoanQuery,[loan_date, loan_status, loan_id, book_id], function(err, result){
    if(err){
      next(err);
      return;
    }

    if (loan_status == 0){
      mysql.pool.query('UPDATE books SET copies_available = copies_available +1 \
                        WHERE book_id = ? AND copies_available < 10', book_id, (err, result1) => {
        if(err){
          next(err);
          return;
        }
        getMemLoans(mem_id,res);
    })
    } else {
      getMemLoans(mem_id,res);
    }
  });
});

app.use(function(req,res){
  res.status(404);
  res.send('404');
});

app.use(function(err, req, res, next){
  console.error(err.stack);
  res.status(500);
  res.send('500');
});


app.listen(app.get('port'), function(){
  console.log(`Express started on http://${process.env.HOSTNAME}:${app.get('port')}; press Ctrl-C to terminate.`);
});