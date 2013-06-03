module.exports = function(grunt){

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
          vendor: "src/jquery/jquery-2.0.2.min.js"
        }
      }
    }
  });

  // enable tasks
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.registerTask('test', ['coffee', 'jasmine']);
};