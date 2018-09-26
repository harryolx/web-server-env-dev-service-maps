console.log('starting app');

const fs = require('fs');
const os = require('os');

var user = os.userInfo();

fs.appendFile('greetings.txt', `Hello ${user.username}`, (err) => {
  	if (err) throw err;
	console.log('The "data to append" was appended to file!');
});