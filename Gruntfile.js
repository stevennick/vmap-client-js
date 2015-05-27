'use strict';

module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt);

  require('time-grunt')(grunt);

  var appConfig = {
    app: require('./bower.json').appPath || 'lib',
    dist: 'dist'
  }

  grunt.initConfig({

    plugin: appConfig,

    watch: {
      bower: {
        files: ['bower.json'],
        tasks: []
      },
      js: {
        files: ['vmap-client.js'],
        tasks: [],
        options: {
          livereload: '<%= connect.options.livereload %>'
        }
      },
      gruntfile: {
        files: ['Gruntfile.js'],
        tasks: []
      },
      src: {
        files: ['lib/**/*.js'],
        tasks: ['jshint:src', 'qunit']
      },
    },

    connect: {
      options: {
        port: 9000,
        // Change this to '0.0.0.0' to access the server from outside.
        hostname: '0.0.0.0',
        livereload: 35729
      },
      livereload: {
        options: {
          open: true,
          // middleware: function(connect) {
          //   return [
          //     connect.static('.tmp'),
          //     connect().use(
          //       '/bower_components',
          //       connect.static('/bower_components')
          //     ),
          //     connect.static(appConfig.app)
          //   ];
          // },
          base: '.'
        }
      },
      dist: {
        options: {
          open: true,
          base: '<%= plugin.dist %>'
        }
      }
    }

  });

  grunt.registerTask('serve', 'Compile than start web server', function(target) {
    if(target === 'dist') {
      return grunt.task.run(['build', 'connect:dist:keepalive']);
    }

    grunt.task.run([
      'connect',
      'watch'
    ]);

  });

  grunt.registerTask('default', [
    'connect:livereload',
    'watch'
  ]);

}
