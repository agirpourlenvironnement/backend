(function () {
    "use strict";

    var gulp = require('gulp'),
        plumber = require('gulp-plumber'),
        tsc = require('gulp-typescript'),
        sourcemaps = require('gulp-sourcemaps'),
        run = require('async-exec-cmd'),
        merge = require('merge2');

    var paths = {
        src: 'src/**/*',
        dest: 'app',
    };

    function applyBump(importance, cb) {
        return run('npm', ['version', importance], cb);
    }

    gulp.task('patch', function (cb) { return applyBump('patch', cb); });
    gulp.task('minor', function (cb) { return applyBump('minor', cb); });
    gulp.task('major', function (cb) { return applyBump('major', cb); });

    var tsProject = tsc.createProject({
        target: 'ES5',
    });

    gulp.task('typescript', function () {
        var tsStreams = gulp.src(paths.src + '.ts')
            .pipe(plumber())
            .pipe(sourcemaps.init())
            .pipe(tsc(tsProject));

        return merge([tsStreams.js, tsStreams.dts])
            .pipe(sourcemaps.write())
            .pipe(gulp.dest(paths.dest));
    });

    gulp.task('watch', ['typescript'], function () {
        return gulp.watch(paths.src, ['typescript']);
    });

    gulp.task('default', function () {
        return gulp.start(['typescript']);
    });

}).call(this);
