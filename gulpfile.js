'use strict'

var gulp        = require('gulp')
  , bump        = require('gulp-bump')
  , chmod       = require('gulp-chmod')
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
        button: {
            reactSimple: [ 'examples/Examples/Graphics/UI/Button/ReactSimple.purs'
                         , 'examples/Examples/Graphics/UI/Button.purs'
                         ]
        },
        colorful: {
            html: [ 'examples/Examples/Graphics/UI/Colorful/HTML.purs'
                  , 'examples/Examples/Graphics/UI/Colorful.purs'
                  ],
            terminal: [ 'examples/Examples/Graphics/UI/Colorful/Terminal.purs'
                      , 'examples/Examples/Graphics/UI/Colorful.purs'
                      ],
            wish: [ 'examples/Examples/Graphics/UI/Colorful/Wish.purs'
                  , 'examples/Examples/Graphics/UI/Colorful.purs'
                  ]
        },
        grouped: {
            html: [ 'examples/Examples/Graphics/UI/Grouped/HTML.purs'
                  , 'examples/Examples/Graphics/UI/Grouped.purs'
                  ],
            wish: [ 'examples/Examples/Graphics/UI/Grouped/Wish.purs'
                , 'examples/Examples/Graphics/UI/Grouped.purs'
                ]
        },
        hello: {
            bodyTag: [ 'examples/Examples/Graphics/UI/Hello/BodyTag.purs'
                     , 'examples/Examples/Graphics/UI/Hello.purs'
                     ],
            html: [ 'examples/Examples/Graphics/UI/Hello/HTML.purs'
                  , 'examples/Examples/Graphics/UI/Hello.purs'
                  ],
            terminal: [ 'examples/Examples/Graphics/UI/Hello/Terminal.purs'
                      , 'examples/Examples/Graphics/UI/Hello.purs'
                      ],
            thermite: [ 'examples/Examples/Graphics/UI/Hello/Thermite.purs'
                      , 'examples/Examples/Graphics/UI/Hello.purs'
                      ],
            wish: [ 'examples/Examples/Graphics/UI/Hello/Wish.purs'
                , 'examples/Examples/Graphics/UI/Hello.purs'
                ]
        },
        logo: {
            reactSimple: [ 'examples/Examples/Graphics/UI/Logo/ReactSimple.purs'
                         , 'examples/Examples/Graphics/UI/Logo.purs'
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
        button: {
            reactSimple: {
                main: 'Examples.Graphics.UI.Button.ReactSimple',
                modules: 'Examples.Graphics.UI.Button.ReactSimple',
                output: 'examples/Examples/Graphics/UI/Button/ReactSimple/button.js'
            }
        },
        colorful: {
            html: {
                main: 'Examples.Graphics.UI.Colorful.HTML',
                modules: 'Examples.Graphics.UI.Colorful.HTML'
            },
            terminal: {
                main: 'Examples.Graphics.UI.Colorful.Terminal',
                modules: 'Examples.Graphics.UI.Colorful.Terminal'
            },
            wish: {
                main: 'Examples.Graphics.UI.Colorful.Wish',
                modules: 'Examples.Graphics.UI.Colorful.Wish'
            }
        },
        grouped: {
            html: {
                main: 'Examples.Graphics.UI.Grouped.HTML',
                modules: 'Examples.Graphics.UI.Grouped.HTML'
            },
            wish: {
                main: 'Examples.Graphics.UI.Grouped.Wish',
                modules: 'Examples.Graphics.UI.Grouped.Wish'
            }
        },
        hello: {
            bodyTag: {
                modules: 'Examples.Graphics.UI.Hello.BodyTag',
                output: 'examples/Examples/Graphics/UI/Hello/BodyTag/hello.js'
            },
            html: {
                main: 'Examples.Graphics.UI.Hello.HTML',
                modules: 'Examples.Graphics.UI.Hello.HTML'
            },
            terminal: {
                main: 'Examples.Graphics.UI.Hello.Terminal',
                modules: 'Examples.Graphics.UI.Hello.Terminal'
            },
            thermite: {
                main: 'Examples.Graphics.UI.Hello.Thermite',
                modules: 'Examples.Graphics.UI.Hello.Thermite',
                output: 'examples/Examples/Graphics/UI/Hello/Thermite/hello.js'
            },
            wish: {
                main: 'Examples.Graphics.UI.Hello.Wish',
                modules: 'Examples.Graphics.UI.Hello.Wish'
            }
        },
        logo: {
            reactSimple: {
                modules: 'Examples.Graphics.UI.Logo.ReactSimple',
                main: 'Examples.Graphics.UI.Logo.ReactSimple',
                output: 'examples/Examples/Graphics/UI/Logo/ReactSimple/logo.js'
            }
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

gulp.task('examples-Button-ReactSimple', function() {
    return compile(purescript.psc, paths.examples.button.reactSimple, options.examples.button.reactSimple);
});

gulp.task('examples-Colorful-HTML', function() {
    return compile(purescript.psc, paths.examples.colorful.html, options.examples.colorful.html)
        .pipe(run('node | cat > examples/Examples/Graphics/UI/Colorful/HTML/index.html'));
});

gulp.task('examples-Colorful-Terminal', function() {
    return compile(purescript.psc, paths.examples.colorful.terminal, options.examples.colorful.terminal)
        .pipe(run('node'));
});

gulp.task('examples-Colorful-Wish-Compile', function() {
    return compile(purescript.psc, paths.examples.colorful.wish, options.examples.colorful.wish)
        .pipe(run('node | cat > examples/Examples/Graphics/UI/Colorful/Wish/colorful.sh'));
});

gulp.task('examples-Colorful-Wish', ['examples-Colorful-Wish-Compile'], function() {
    return gulp.src('examples/Examples/Graphics/UI/Colorful/Wish/colorful.sh')
        .pipe(chmod(755))
        .pipe(gulp.dest('examples/Examples/Graphics/UI/Colorful/Wish/'));
});

gulp.task('examples-Grouped-HTML', function() {
    return compile(purescript.psc, paths.examples.grouped.html, options.examples.grouped.html)
        .pipe(run('node | cat > examples/Examples/Graphics/UI/Grouped/HTML/index.html'));
});

gulp.task('examples-Grouped-Wish-Compile', function() {
    return compile(purescript.psc, paths.examples.grouped.wish, options.examples.grouped.wish)
        .pipe(run('node | cat > examples/Examples/Graphics/UI/Grouped/Wish/grouped.sh'));
});

gulp.task('examples-Grouped-Wish', ['examples-Grouped-Wish-Compile'], function() {
    return gulp.src('examples/Examples/Graphics/UI/Grouped/Wish/grouped.sh')
        .pipe(chmod(755))
        .pipe(gulp.dest('examples/Examples/Graphics/UI/Grouped/Wish/'));
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

gulp.task('examples-Hello-Wish-Compile', function() {
    return compile(purescript.psc, paths.examples.hello.wish, options.examples.hello.wish)
        .pipe(run('node | cat > examples/Examples/Graphics/UI/Hello/Wish/hello.sh'));
});

gulp.task('examples-Hello-Wish', ['examples-Hello-Wish-Compile'], function() {
    return gulp.src('examples/Examples/Graphics/UI/Hello/Wish/hello.sh')
        .pipe(chmod(755))
        .pipe(gulp.dest('examples/Examples/Graphics/UI/Hello/Wish/'));
});

gulp.task('examples-Logo-ReactSimple', function() {
    return compile(purescript.psc, paths.examples.logo.reactSimple, options.examples.logo.reactSimple);
});

gulp.task('examples', [ 'examples-Button-ReactSimple'
                      , 'examples-Colorful-HTML'
                      , 'examples-Colorful-Terminal'
                      , 'examples-Colorful-Wish'
                      , 'examples-Grouped-HTML'
                      , 'examples-Grouped-Wish'
                      , 'examples-Hello-BodyTag'
                      , 'examples-Hello-HTML'
                      , 'examples-Hello-Terminal'
                      , 'examples-Hello-Thermite'
                      , 'examples-Hello-Wish'
                      , 'examples-Logo-ReactSimple'
                      ]);

gulp.task('watch-browser', function() {
    gulp.watch(paths.src, ['browser', 'docs']);
});

gulp.task('watch-make', function() {
    gulp.watch(paths.src, ['make', 'docs']);
});

gulp.task('default', ['make', 'docs']);
