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
        colorful: {
            html: [ 'examples/Examples/Graphics/UI/Colorful/HTML.purs'
                  , 'examples/Examples/Graphics/UI/Colorful.purs'
                  ],
            terminal: [ 'examples/Examples/Graphics/UI/Colorful/Terminal.purs'
                      , 'examples/Examples/Graphics/UI/Colorful.purs'
                      ]
        },
        hello: {
            bodyTag: [ 'examples/Examples/Graphics/UI/Hello/BodyTag.purs'
                     , 'examples/Examples/Graphics/UI/Hello.purs'
                     ],
            html: [ 'examples/Examples/Graphics/UI/Hello/HTML.purs'
                  , 'examples/Examples/Graphics/UI/Hello.purs'
                  ],
            thermite: [ 'examples/Examples/Graphics/UI/Hello/Thermite.purs'
                      , 'examples/Examples/Graphics/UI/Hello.purs'
                      ],
            terminal: [ 'examples/Examples/Graphics/UI/Hello/Terminal.purs'
                      , 'examples/Examples/Graphics/UI/Hello.purs'
                      ]
        }
    },
    manifests: [
      'bower.json',
      'package.json'
    ]
};

var options = {
    compiler: {},
    examples: {
        colorful: {
            html: {main: 'Examples.Graphics.UI.Colorful.HTML'},
            terminal: {main: 'Examples.Graphics.UI.Colorful.Terminal'}
        },
        hello: {
            bodyTag: {
                modules: 'Examples.Graphics.UI.Hello.BodyTag',
                output: 'examples/Examples/Graphics/UI/Hello/BodyTag/hello.js'
            },
            html: {main: 'Examples.Graphics.UI.Hello.HTML'},
            thermite: {
                modules: 'Examples.Graphics.UI.Hello.Thermite',
                main: 'Examples.Graphics.UI.Hello.Thermite',
                output: 'examples/Examples/Graphics/UI/Hello/Thermite/hello.js'
            },
            terminal: {main: 'Examples.Graphics.UI.Hello.Terminal'}
        }
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

gulp.task('examples-Colorful-HTML', function() {
    return compile(purescript.psc, paths.examples.colorful.html, options.examples.colorful.html)
        .pipe(run('node | cat > examples/Examples/Graphics/UI/Colorful/HTML/index.html'));
});

gulp.task('examples-Colorful-Terminal', function() {
    return compile(purescript.psc, paths.examples.colorful.terminal, options.examples.colorful.terminal)
        .pipe(run('node'));
});

gulp.task('examples-Hello-BodyTag', function() {
    return compile(purescript.psc, paths.examples.hello.bodyTag, options.examples.hello.bodyTag);
});

gulp.task('examples-Hello-HTML', function() {
    return compile(purescript.psc, paths.examples.hello.html, options.examples.hello.html)
        .pipe(run('node | cat > examples/Examples/Graphics/UI/Hello/HTML/index.html'));
});

gulp.task('examples-Hello-Terminal', function() {
    return compile(purescript.psc, paths.examples.hello.terminal, options.examples.hello.terminal)
        .pipe(run('node'));
});

gulp.task('examples-Hello-Thermite', function() {
    return compile(purescript.psc, paths.examples.hello.thermite, options.examples.hello.thermite);
});

gulp.task('examples', [ 'examples-Colorful-HTML'
                      , 'examples-Colorful-Terminal'
                      , 'examples-Hello-BodyTag'
                      , 'examples-Hello-HTML'
                      , 'examples-Hello-Terminal'
                      , 'examples-Hello-Thermite'
                      ]);

gulp.task('watch-browser', function() {
    gulp.watch(paths.src, ['browser', 'docs']);
});

gulp.task('watch-make', function() {
    gulp.watch(paths.src, ['make', 'docs']);
});

gulp.task('default', ['make', 'docs']);
