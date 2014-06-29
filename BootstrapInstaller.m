(* ::Package:: *)

BeginPackage["BootstrapInstaller`"]


(* ::Section:: *)
(*Usage messages*)


BootstrapInstall::usage =
"\
BootstrapInstall[name, url] \
Installs ProjectInstaller and uses it to install project from given url.\

BootstrapInstall[\
name, url, \
{\
{dependencyName1, dependencyUrl1}, \
{dependencyName2, dependencyUrl2}, \
...\
}\
] \
Installs ProjectInstaller and uses it to install dependencies and main \
project from given urls."


(* ::Section:: *)
(*Implementation*)


(*
	Unprotect all symbols in this context
	(all public symbols provided by this package)
*)
Unprotect["`*"]


Begin["`Private`"]


(* ::Subsection:: *)
(*BootstrapInstall*)


Options[BootstrapInstall] = {
	"InstallFunction" -> ((
		ProjectInstaller`ProjectUninstall[#1];
		Print @ ProjectInstaller`ProjectInstall @ URL[#2];
	)&)
	,
	"AdditionalFailureMessage" -> None
}


BootstrapInstall[
	name_String, url_String,
	dependencies:{Repeated[{_String, _String}, {0, Infinity}]}:{},
	OptionsPattern[]
] :=
	Module[
		{
			installFunction = OptionValue["InstallFunction"],
			additionalFailureMessage = OptionValue["AdditionalFailureMessage"],
			$PIImportResult
		}
		,
		
		Quiet[
			$PIImportResult = Needs["ProjectInstaller`"],
			{Get::noopen, Needs::nocont}
		];
		
		If[$PIImportResult === $Failed,
			Print["ProjectInstaller not found, installing it:"];
			Print @ Import @
				"https://raw.github.com/lshifr/ProjectInstaller/master/BootstrapInstall.m";
			$PIImportResult = Needs["ProjectInstaller`"];
		];
	
		If[$PIImportResult === $Failed,
			Print[
				"Unable to load ProjectInstaller.\n",
				"Please make sure your internet connection works.\n",
				"If this problem persists, please ",
				Hyperlink[
					"report this issue",
					"https://github.com/jkuczm/MathematicaBootstrapInstaller/issues"
				],
				"."
			];
			
			If[additionalFailureMessage =!= None,
				Print[additionalFailureMessage];
			];
		(* else *),
			If[dependencies =!= {},
				Print["Installing " <> name <> " dependencies:"];
				installFunction @@@ dependencies;	
			];
			
			Print["Installing " <> name <> ":"];
			installFunction[name, url];
		];
	]


End[]


(* ::Section:: *)
(*Public symbols protection*)


(*
	Protect all symbols in this context
	(all public symbols provided by this package)
*)
Protect["`*"]


EndPackage[]
