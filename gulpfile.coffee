gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
browserify = require 'gulp-browserify'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
sass = require 'gulp-sass'
refresh = require 'gulp-livereload'
rename = require 'gulp-rename'
clean = require 'gulp-clean'
lr_server = require('tiny-lr')()
nodemon = require 'gulp-nodemon'

# Starts the webserver (http://localhost:3000)
gulp.task 'webserver', ->
  nodemon script: './server/app.coffee', options: '--watch ./server'

# Starts the livereload server
gulp.task 'livereload', ->
  lr_server.listen 35729, (err) ->
    console.log err if err?

# Compiles CoffeeScript files into js file and reloads the page
# Specify --minify on the command line to create minified script.
gulp.task 'scripts', ->
  stream = gulp.src('lib/proto/js/proto.coffee', read: false)
    .pipe(browserify(
        transform: ['browserify-handlebars', 'coffeeify', 'brfs']
    ))
		.pipe(rename 'scripts.js')
    .pipe(gulp.dest 'dist/js')    # creates scripts/js/scripts.js
    .pipe(refresh lr_server)
  if gutil.env.minify
    stream.pipe(rename('scripts.min.js'))
      .pipe(uglify())
      .pipe(gulp.dest 'dist/js')
      .pipe(refresh lr_server)

# Compiles Sass files into css file and reloads the styles
gulp.task 'styles', ->
  gulp.src('styles/scss/init.scss')
    .pipe(sass includePaths: ['styles/scss/includes'])
    .pipe(concat 'styles.css')
    .pipe(gulp.dest 'styles/css')
    .pipe(refresh lr_server)

gulp.task 'widget:styles', ->
  gulp.src('lib/**/*.scss')
    .pipe(sass())
    .pipe(concat 'styles.css')
    .pipe(gulp.dest 'dist/styles')
    .pipe(refresh lr_server)

# Reloads the page
gulp.task 'html', ->
	gulp.src('*.html')
		.pipe(refresh lr_server)

# Cleans the dist folder
gulp.task 'clean', ->
  gulp.src('dist')
    .pipe(clean())

# Watches files for changes
gulp.task 'watch', ->
  gulp.watch 'lib/**/*.hbs', ['scripts']
  gulp.watch 'lib/**/*.coffee', ['scripts']
  gulp.watch 'lib/**/*.css', ['widget:styles']
  gulp.watch 'styles/scss/**', ['styles']
  gulp.watch '*.html', ['html']

# The default task
gulp.task 'default', ['webserver', 'livereload', 'clean', 'scripts', 'styles',
                      'widget:styles', 'watch']

