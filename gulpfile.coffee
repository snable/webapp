gulp = require 'gulp'
stylus = require 'gulp-stylus'
jade = require 'gulp-jade'
connect = require 'gulp-connect'
browserify = require 'gulp-browserify'
rename = require 'gulp-rename'
gutil = require 'gulp-util'
# bower = require 'main-bower-files'
spritesmith = require 'gulp.spritesmith'


path = 
	app: './source/'
	build: './build/'
	styles: './source/styles/'
	scripts: './source/scripts/'
	views: './source/views/'
	bower: './bower_components/'
	sprites: './source/sprites/*.png'
	images: './source/images/*'


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
		.pipe connect.reload()


gulp.task 'jade', ->
	gulp.src path.views + 'index.jade'
		.pipe jade 
			pretty: true
		.on 'error', gutil.log
		.pipe gulp.dest path.build
		.pipe connect.reload()


gulp.task 'scripts', ->
	gulp.src path.scripts + 'main.coffee', { read: false }
		.pipe browserify 
			transform: ['coffeeify']
			extensions: ['.coffee']
			shim:
				jquery:
					path: path.bower + 'jquery/dist/jquery.min.js'
					exports: 'jQuery'
		.on 'error', gutil.log
		.pipe rename 'main.js'
		.pipe gulp.dest path.build + 'js'
		.pipe connect.reload()


gulp.task 'sprites', ->
	config = 
		imgName: '../img/sprite.png'
		cssName: '_sprite.styl'
		engine: 'pngsmith'
		algorithm: 'binary-tree'
		cssFormat: 'stylus'
		cssTemplate: './stylus-sprite.mustache'

	sprite = gulp.src path.sprites
		.pipe spritesmith config

	sprite.img.pipe gulp.dest path.build + 'img'
	sprite.css.pipe gulp.dest path.styles
		.pipe connect.reload()


gulp.task 'images', ->
	gulp.src path.images
		.pipe gulp.dest path.build + 'img'
		.pipe connect.reload()


# gulp.task 'bower', ->
# 	gulp.src bower()
# 		.pipe gulp.dest path.build + 'lib'
# 		.pipe connect.reload()


gulp.task 'serve', ->
	connect.server {
		root: [path.build]
		livereload: true
	}


gulp.task 'build', ['stylus', 'jade', 'scripts', 'sprites', 'images'] #, 'bower']


gulp.task 'watch', ->
	gulp.watch path.styles + '**/*.styl', ['stylus']
	gulp.watch path.views + '**/*.jade', ['jade']
	gulp.watch path.scripts + '**/*.coffee', ['scripts']
	# gulp.watch path.bower + '*', ['bower']
	gulp.watch path.sprites, ['sprites']
	gulp.watch path.images, ['images']


gulp.task 'default', ['build', 'serve', 'watch']