# Bootstrap Installer

Package simplifying creation of online bootstrap installer scripts.

[![latest release](http://img.shields.io/github/release/jkuczm/MathematicaBootstrapInstaller.svg)](https://github.com/jkuczm/MathematicaBootstrapInstaller/releases/latest)
[![semantic versioning](http://jkuczm.github.io/media/images/SemVer-2.0.0-brightgreen.svg)](http://semver.org/spec/v2.0.0.html)
[![license: MIT](http://jkuczm.github.io/media/images/license-MIT-blue.svg)](https://github.com/jkuczm/MathematicaBootstrapInstaller/blob/master/LICENSE)


* [Usage examples](#usage-examples)
* [Bugs and requests](#bugs-and-requests)
* [Contributing](#contributing)
* [License](#license)
* [Versioning](#versioning)



## Usage examples

Following code is used as bootstrap installer script of version 1.0.0 of
`TeXUtilities` package:
```Mathematica
Get["https://raw.githubusercontent.com/jkuczm/MathematicaBootstrapInstaller/v0.1.0/BootstrapInstaller.m"]

BootstrapInstall[
    "TeXUtilities",
    "https://github.com/jkuczm/MathematicaTeXUtilities/releases/download/v1.0.0/TeXUtilities.zip",
    "AdditionalFailureMessage" -> 
        Sequence[
            "You can ", 
            Hyperlink[
                "install TeXUtilities package manually", 
                "https://github.com/jkuczm/MathematicaTeXUtilities#manual-installation"
            ],
            "."
        ]
]
```


Following code is used as bootstrap installer script of version 0.1.1 of
MUnitExtras package. It installs the package together with proper versions of
dependencies.
```Mathematica
Get["https://raw.githubusercontent.com/jkuczm/MathematicaBootstrapInstaller/v0.1.0/BootstrapInstaller.m"]

BootstrapInstall[
    "MUnitExtras",
    "https://github.com/jkuczm/MUnitExtras/releases/download/v0.1.1/MUnitExtras.zip"
    ,
    {
        #1
        ,
        "https://github.com/jkuczm/Mathematica" <> #1 <>
        "/releases/download/v" <> #2 <> "/" <> #1 <> ".zip"
    }& @@@ {
        "EvaluationUtilities" -> "0.1.0",
        "MessagesUtilities" -> "0.1.0",
        "OptionsUtilities" -> "0.1.0",
        "PatternUtilities" -> "0.1.0",
        "ProtectionUtilities" -> "0.1.0",
        "StringUtilities" -> "0.1.0"
    }
    ,
    "AdditionalFailureMessage" -> 
        Sequence[
            "You can ", 
            Hyperlink[
                "install MUnitExtras package manually", 
                "https://github.com/jkuczm/MUnitExtras#manual-installation"
            ],
            "."
        ]
]
```



## Bugs and requests

If you find any bugs or have feature request please create an
[issue on GitHub](https://github.com/jkuczm/MathematicaBootstrapInstaller/issues).



## Contributing

Feel free to fork and send pull requests.

All contributions are welcome!



## License

This package is released under
[The MIT License](https://github.com/jkuczm/MathematicaBootstrapInstaller/blob/master/LICENSE).



## Versioning

Releases of this package will be numbered using
[Semantic Versioning guidelines](http://semver.org/).
