'use strict'

var gulp        = require('gulp')
  , bump        = require('gulp-bump')
  , filter      = require('gulp-filter')
  , git         = require('gulp-git')
  , purescript  = require('gulp-purescript')
  , run         = require('gulp-run')
  , runSequence = require('run-sequence')
  , tagVersion  = require('gulp-tag-version')
  ;

var paths = {
    src: 'src/**/*.purs',
    bowerSrc: 'bower_components/purescript-*/src/**/*.purs',
    dest: '',
    docsDest: 'docs/README.md',
    examples: {
        bodyTag: [ 'examples/Examples/Graphics/UI/BodyTag.purs'
                 , 'examples/Examples/Graphics/UI/Hello.purs'
                 ],
        html: [ 'examples/Examples/Graphics/UI/HTML.purs'
              , 'examples/Examples/Graphics/UI/Hello.purs'
              ],
        thermite: [ 'examples/Examples/Graphics/UI/Thermite.purs'
                  , 'examples/Examples/Graphics/UI/Hello.purs'
                  ],
        terminal: [ 'examples/Examples/Graphics/UI/Terminal.purs'
                  , 'examples/Examples/Graphics/UI/Hello.purs'
                  ]
    },
    exampleSrc: 'examples/**/*.purs',
    manifests: [
      'bower.json',
      'package.json'
    ]
};

var options = {
    compiler: {},
    examples: {
        bodyTag: {
            modules: 'Examples.Graphics.UI.BodyTag',
            output: 'examples/Examples/Graphics/UI/BodyTag/hello.js'
        },
        html: {main: 'Examples.Graphics.UI.HTML'},
        thermite: {
            modules: 'Examples.Graphics.UI.Thermite',
            main: 'Examples.Graphics.UI.Thermite',
            output: 'examples/Examples/Graphics/UI/Thermite/hello.js'
        },
        terminal: {main: 'Examples.Graphics.UI.Terminal'}
    },
    pscDocs: {}
};

var compile = function(compiler, src, options) {
    var psc = compiler(options);
    psc.on('error', function(e) {
        console.error(e.message);
        psc.end();
    });
    return gulp.src([paths.src].concat(src).concat(paths.bowerSrc))
        .pipe(psc)
        .pipe(gulp.dest(paths.dest));
};

function bumpType(type) {
    return gulp.src(paths.manifests)
        .pipe(bump({type: type}))
        .pipe(gulp.dest('./'));
}

gulp.task('tag', function() {
    return gulp.src(paths.manifests)
        .pipe(git.commit('Update versions.'))
        .pipe(filter('bower.json'))
        .pipe(tagVersion());
});

gulp.task('bump-major', function() {
    return bumpType('major')
});
gulp.task('bump-minor', function() {
    return bumpType('minor')
});
gulp.task('bump-patch', function() {
    return bumpType('patch')
});

gulp.task('bump-tag-major', function() {
    return runSequence('bump-major', 'tag');
});
gulp.task('bump-tag-minor', function() {
    return runSequence('bump-minor', 'tag');
});
gulp.task('bump-tag-patch', function() {
    return runSequence('bump-patch', 'tag');
});

gulp.task('make', function() {
    return compile(purescript.pscMake, [], options.compiler);
});

gulp.task('browser', function() {
    return compile(purescript.psc, [], options.compiler);
});

gulp.task('docs', function() {
    var pscDocs = purescript.pscDocs(options.pscDocs);
    pscDocs.on('error', function(e) {
        console.error(e.message);
        pscDocs.end();
    });
    return gulp.src(paths.src)
      .pipe(pscDocs)
      .pipe(gulp.dest(paths.docsDest));
});

gulp.task('examples-BodyTag', function() {
    return compile(purescript.psc, paths.examples.bodyTag, options.examples.bodyTag);
});

gulp.task('examples-HTML', function() {
    return compile(purescript.psc, paths.examples.html, options.examples.html)
        .pipe(run('node'))
        .pipe(run('cat > examples/Examples/Graphics/UI/HTML/index.html'));
});

gulp.task('examples-Thermite', function() {
    return compile(purescript.psc, paths.examples.thermite, options.examples.thermite);
});

gulp.task('examples-Terminal', function() {
    return compile(purescript.psc, paths.examples.terminal, options.examples.terminal)
        .pipe(run('node'));
});

gulp.task('examples', [ 'examples-BodyTag'
                      , 'examples-HTML'
                      , 'examples-Thermite'
                      , 'examples-Terminal'
                      ]);

gulp.task('watch-browser', function() {
    gulp.watch(paths.src, ['browser', 'docs']);
});

gulp.task('watch-make', function() {
    gulp.watch(paths.src, ['make', 'docs']);
});

gulp.task('default', ['make', 'docs']);
