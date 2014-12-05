module.exports = function(grunt){
  // load all tasks 
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
  require('matchdep').filter('grunt-*').forEach(grunt.loadNpmTasks);

  // Project Configureation
  grunt.initConfig({
    pkg: grunt.file.readJSON("package.json"), 
    
    coffee: {
      compile: {
        files: {
          'build/src/filmstrip.js': 'src/filmstrip.js.coffee',
          'build/test/filmstrip_spec.js': 'test/filmstrip_spec.js.coffee'
        }
      }
    },
    jasmine: {
      pivotal: {
        src: ['build/src/**/*.js'],
        options: {
          specs: 'build/test/*_spec.js',
          vendor: "src/jquery/jquery-2.0.2.min.js",
          outfile: '_SpecRunner.html'
        }
      }
    },
    open: {
      server: {
        path: 'http://localhost:<%= connect.options.port %>'
      }
    }
  });


  // register test
  grunt.registerTask('test', ['coffee', 'jasmine']);
  grunt.registerTask('test-build', ['coffee', 'jasmine:pivotal:build']);

};
