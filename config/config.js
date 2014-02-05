var path = require('path'),
    rootPath = path.normalize(__dirname + '/..'),
    env = process.env.NODE_ENV || 'development';

var config = {
  development: {
    root: rootPath,
    app: {
      name: 'summer-jam'
    },
    port: 3000,
    db: 'mongodb://localhost/summer-jam-development'
  },

  test: {
    root: rootPath,
    app: {
      name: 'summer-jam'
    },
    port: 3000,
    db: 'mongodb://localhost/summer-jam-test'
  },

  production: {
    root: rootPath,
    app: {
      name: 'summer-jam'
    },
    port: 3000,
    db: 'mongodb://localhost/summer-jam-production'
  }
};

module.exports = config[env];
