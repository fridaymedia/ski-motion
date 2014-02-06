module.exports = function(app){

	//home route
	var home = require('../app/controllers/home');
	app.get('/', home.index);

    //home route
	var leap = require('../app/controllers/leap');
	app.get('/leap', leap.index);

};
