const mysql = require("mysql");
const util = require("util");
const express = require('express');
const ejs = require('ejs');
const bodyParser = require('body-parser');

const PORT = 8000;
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_NAME = 'coursework';
const DB_PASSWORD = '';
const DB_PORT = 3306;

// regex obtained and lightly modified from https://howtodoinjava.com/java/regex/java-regex-validate-email-address/
const emailRegex = /^[\w!#$%&’*+/=?`{|}~^-]+(?:\.[\w!#$%&’*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}$/;

var connection = mysql.createConnection({
	host: DB_HOST,
	user: DB_USER,
	password: DB_PASSWORD,
	database: DB_NAME,
	port: DB_PORT,
});

connection.query = util.promisify(connection.query).bind(connection);

connection.connect(function (err) {
	if (err) {
		console.error(err.stack);
		return;
	}
	console.log("Database connected.");
});

const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));

app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', async (req, res) => {
	const societyCount = await connection.query(
		"SELECT COUNT(*) AS count FROM Society"
	);
	const totalStudentCount = await connection.query(
		"SELECT COUNT(*) AS count FROM Student"
	);
	const studentInSocietyCount = await connection.query(
		"SELECT COUNT(*) AS count FROM Student WHERE URN IN (SELECT URN FROM Partakes)"
	);
	res.render('index', {
		societyCount: societyCount[0].count,
		totalStudentCount: totalStudentCount[0].count,
		studentInSocietyCount: studentInSocietyCount[0].count
	});
});

app.get('/societies', async (req, res) => {
	const societies = await connection.query(
		"SELECT * FROM Society"
	);
	res.render('societies', { societies: societies });
});

app.post("/societies", async (req, res) => {
	if (req.body.Soc_Name.trim().length == 0) {
		const societies = await connection.query(
			"SELECT * FROM Society"
		);
		res.render('societies', { societies: societies });
	} else {
		const societies = await connection.query("SELECT * FROM Society WHERE Soc_Name LIKE ?", [
			req.body.Soc_Name
		]);
		res.render('societies', { societies: societies });
	}
});

app.get('/societies/view/:id', async (req, res) => {
	const society = await connection.query(
		"SELECT * FROM Society WHERE Soc_ID = ?",
		[req.params.id]
		);		
	res.render('society_view', { society: society[0] });
});

app.get('/societies/edit/:id', async (req, res) => {
	const society = await connection.query(
		"SELECT * FROM Society WHERE Soc_ID = ?",
		[req.params.id]
	);	
	res.render('society_edit', { society: society[0], message: '' });
});

app.post("/societies/edit/:id", async (req, res) => {
	if (!(req.body.Soc_Email.match(emailRegex))) {
		message = "Please enter a valid email";
	} else {
		await connection.query("UPDATE Society SET ? WHERE Soc_ID = ?", [
			req.body,
			req.params.id
		]);
		message = "Society updated";
	}
	const society = await connection.query(
		"SELECT * FROM Society WHERE Soc_ID = ?",
		[req.params.id]
	);
	res.render("society_edit", {
		society: society[0],
		message: message
	});
});

app.get('/societies/add', async (req, res) => {
	res.render('society_add', { message: '' });
});

app.post("/societies/add", async (req, res) => {
	if (!(req.body.Soc_Email.match(emailRegex))) {
		message = "Please enter a valid email";
	} else {
		await connection.query("INSERT INTO Society (Soc_Name, Soc_Email) VALUES (?, ?)",[
			req.body.Soc_Name,
			req.body.Soc_Email
		]);
		message = "Society added";
	}
	res.render("society_add", {
		message: message
	});
});

app.get('/societies/delete/:id', async (req, res) => {
	const society = await connection.query(
		"SELECT * FROM Society WHERE Soc_ID = ?",
		[req.params.id]
		);		
	res.render('society_delete', { society: society[0] });
});

app.get('/societies/delete/:id/confirmed', async (req, res) => {
	await connection.query("DELETE FROM Society WHERE Soc_ID = ?", [
		req.params.id
	]);
	const societies = await connection.query(
		"SELECT * FROM Society"
	);
	res.render('societies', { societies: societies });
});

app.listen(PORT, () => {
	console.log(`Listening at http://localhost:${PORT}`);
});
