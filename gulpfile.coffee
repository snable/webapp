gulp = require 'gulp'
stylus = require 'gulp-stylus'
jade = require 'gulp-jade'
connect = require 'gulp-connect'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
gutil = require 'gulp-util'
bower = require 'main-bower-files'


path = 
	app: './source/'
	build: './build/'
	styles: './source/styles/'
	scripts: './source/scripts/'
	views: './source/views/'
	bower: './bower_components/'


gulp.task 'stylus', ->
	gulp.src path.styles + 'main.styl'
		.pipe stylus {
			use: [
				require('nib')()
				require('jeet')()
			]
		}
		.on 'error', gutil.log
		.pipe gulp.dest path.build + 'css'


gulp.task 'jade', ->
	gulp.src path.views + 'index.jade'
		.pipe jade 
			pretty: true
		.on 'error', gutil.log
		.pipe gulp.dest path.build


gulp.task 'scripts', ->
	gulp.src path.scripts + 'main.coffee', { read: false }
		.pipe browserify 
			transform: ['coffeeify']
			extensions: ['.coffee']
		.on 'error', gutil.log
		.pipe rename 'main.js'
		.pipe gulp.dest path.build + 'js'


gulp.task 'bower', ->
	gulp.src bower()
		.pipe gulp.dest path.build + 'lib'


gulp.task 'serve', ->
	connect.server {
		root: [path.build]
		livereload: true
	}


gulp.task 'reload', ->
	connect.reload()


gulp.task 'build', ['bower', 'stylus', 'jade', 'scripts']


gulp.task 'watch', ->
	gulp.watch path.styles + '**/*.styl', ['stylus', 'reload']
	gulp.watch path.views + '**/*.jade', ['jade', 'reload']
	gulp.watch path.scripts + '**/*.coffee', ['scripts', 'reload']
	gulp.watch path.bower + '*', ['bower', 'reload']


gulp.task 'default', ['build', 'serve', 'watch']