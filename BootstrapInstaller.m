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


Needs["Utilities`URLTools`"]


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
			$PIImportResult,
			fetchURLOldHeaders
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
		
			If[$VersionNumber >= 10.0,
				(*
					In Mathematica version 10 URLFetch by default always sets
					"Content-Type" header to
					"application/x-www-form-urlencoded" which makes Amazon S3
					service, used by GitHub, return "SignatureDoesNotMatch"
					error.
					
					To prevent it manually set empty "Content-Type" in
					default options of
					Utilities`URLTools`Private`FetchURLInternal. This
					function is called by Utilities`URLTools`FetchURL which is
					used in ProjectInstall and passes options to URLFetch.
					
					It would be better to set it on public function
					Utilities`URLTools`FetchURL, but it's deault options are
					not passed to Utilities`URLTools`Private`FetchURLInternal.
				*)
				fetchURLOldHeaders =
					OptionValue[
						Utilities`URLTools`Private`FetchURLInternal,
						"RequestHeaderFields"
					];
				SetOptions[
					Utilities`URLTools`Private`FetchURLInternal,
					"RequestHeaderFields" -> {"Content-Type" -> ""}
				];
			];

			If[dependencies =!= {},
				Print["Installing " <> name <> " dependencies:"];
				installFunction @@@ dependencies;	
			];
			
			Print["Installing " <> name <> ":"];
			installFunction[name, url];
		
			If[$VersionNumber >= 10.0,
				(* Restore original value of "Headers" option. *)
				SetOptions[
					Utilities`URLTools`Private`FetchURLInternal,
					"RequestHeaderFields" -> fetchURLOldHeaders
				];
			];
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
