module.exports = function(app){

	//home route
	var home = require('../app/controllers/home');
	app.get('/', home.index);

	var game = require('../app/controllers/game');
	app.get('/game', game.index);

	var leap = require('../app/controllers/leap');
	app.get('/leap', leap.index);

};
