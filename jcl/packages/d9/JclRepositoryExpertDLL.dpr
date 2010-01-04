Library JclRepositoryExpertDLL;
{
-----------------------------------------------------------------------------
     DO NOT EDIT THIS FILE, IT IS GENERATED BY THE PACKAGE GENERATOR
            ALWAYS EDIT THE RELATED XML FILE (JclRepositoryExpertDLL-L.xml)

     Last generated: 04-01-2010  20:33:50 UTC
-----------------------------------------------------------------------------
}

{$R *.res}
{$ALIGN 8}
{$ASSERTIONS ON}
{$BOOLEVAL OFF}
{$DEBUGINFO OFF}
{$EXTENDEDSYNTAX ON}
{$IMPORTEDDATA ON}
{$IOCHECKS ON}
{$LOCALSYMBOLS OFF}
{$LONGSTRINGS ON}
{$OPENSTRINGS ON}
{$OPTIMIZATION ON}
{$OVERFLOWCHECKS OFF}
{$RANGECHECKS OFF}
{$REFERENCEINFO OFF}
{$SAFEDIVIDE OFF}
{$STACKFRAMES OFF}
{$TYPEDADDRESS OFF}
{$VARSTRINGCHECKS ON}
{$WRITEABLECONST OFF}
{$MINENUMSIZE 1}
{$IMAGEBASE $58100000}
{$DESCRIPTION 'JCL Package containing repository wizards'}
{$LIBSUFFIX '90'}
{$IMPLICITBUILD OFF}

{$DEFINE RELEASE}

uses
  ToolsAPI,
  JclOtaTemplates in '..\..\experts\repository\JclOtaTemplates.pas' ,
  JclOtaRepositoryUtils in '..\..\experts\repository\JclOtaRepositoryUtils.pas' ,
  JclOtaExcDlgParams in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgParams.pas' ,
  JclOtaExcDlgWizard in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgWizard.pas' {JclOtaExcDlgForm},
  JclOtaExcDlgFileFrame in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgFileFrame.pas' {JclOtaExcDlgFilePage: TFrame},
  JclOtaExcDlgFormFrame in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgFormFrame.pas' {JclOtaExcDlgFormPage: TFrame},
  JclOtaExcDlgSystemFrame in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgSystemFrame.pas' {JclOtaExcDlgSystemPage: TFrame},
  JclOtaExcDlgLogFrame in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgLogFrame.pas' {JclOtaExcDlgLogPage: TFrame},
  JclOtaExcDlgTraceFrame in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgTraceFrame.pas' {JclOtaExcDlgTracePage: TFrame},
  JclOtaExcDlgThreadFrame in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgThreadFrame.pas' {JclOtaExcDlgThreadPage: TFrame},
  JclOtaExcDlgIgnoreFrame in '..\..\experts\repository\ExceptionDialog\JclOtaExcDlgIgnoreFrame.pas' {JclOtaExcDlgIgnorePage: TFrame},
  JclOtaRepositoryReg in '..\..\experts\repository\JclOtaRepositoryReg.pas' 
  ;

exports
  JCLWizardInit name WizardEntryPoint;

end.
