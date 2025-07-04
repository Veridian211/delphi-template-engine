unit TemplateEngine;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Math,
  Web.HTTPProd;

type
  TReplacement = record
  private
    const
      TAG_BEGIN = '<#';
      TAG_END = '>';
  public
    tag: string;
    replaceWith: string;
    constructor Create(tag: string; replaceWith: string); overload;
    constructor Create(tag: string; replaceWith: integer); overload;
    constructor Create(tag: string; replaceWith: double; decimals: word = 0); overload;
  end;

  TTemplateEngine = class
  private
    template: string;
    replacementList: TList<TReplacement>;
    function getOutput(): string;
  public
    constructor Create(template: string); overload;
    constructor Create(template: TPageProducer); overload;
    function replace(tag: string; replaceWith: string): TTemplateEngine; overload;
    function replace(tag: string; replaceWith: integer): TTemplateEngine; overload;
    function replace(tag: string; replaceWith: double; decimals: word = 0): TTemplateEngine; overload;
    destructor Destroy(); override;

    property output: string read getOutput;
  end;

implementation

{ TReplacement }

constructor TReplacement.Create(tag: string; replaceWith: string);
begin
  self.tag := TAG_BEGIN + tag + TAG_END;
  self.replaceWith := replaceWith;
end;

constructor TReplacement.Create(tag: string; replaceWith: integer);
begin
  Create(tag, IntToStr(replaceWith));
end;

constructor TReplacement.Create(tag: string; replaceWith: double; decimals: word = 0);
begin
  Create(tag, FloatToStr(RoundTo(replaceWith, - decimals)));
end;

{ TTemplateEngine }

constructor TTemplateEngine.Create(template: string);
begin
  inherited Create();
  replacementList := TList<TReplacement>.Create();
  self.template := template;
end;

constructor TTemplateEngine.Create(template: TPageProducer);
begin
  Create(template.Content);
end;

function TTemplateEngine.replace(tag: string; replaceWith: string): TTemplateEngine;
var
  replacement: TReplacement;
begin
  try
    replacement := TReplacement.Create(tag, replaceWith);
    replacementList.Add(replacement);
    exit(self);
  except
    self.Free;
    raise;
  end;
end;

function TTemplateEngine.replace(tag: string; replaceWith: integer): TTemplateEngine;
var
  replacement: TReplacement;
begin
  try
    replacement := TReplacement.Create(tag, replaceWith);
    replacementList.Add(replacement);
    exit(self);
  except
    self.Free;
    raise;
  end;
end;

function TTemplateEngine.replace(tag: string; replaceWith: double; decimals: word = 0): TTemplateEngine;
var
  replacement: TReplacement;
begin
  try
    replacement := TReplacement.Create(tag, replaceWith, decimals);
    replacementList.Add(replacement);
    exit(self);
  except
    self.Free;
    raise;
  end;
end;

function TTemplateEngine.getOutput(): string;
var
  output: string;
  replacement: TReplacement;
begin
  try
    output := template;

    for replacement in replacementList do begin
      output := StringReplace(output, replacement.tag, replacement.replaceWith, [rfReplaceAll]);
    end;

    exit(output);
  finally
    self.Free;
  end;
end;

destructor TTemplateEngine.Destroy();
begin
  replacementList.Clear;
  replacementList.Free;
  inherited;
end;

end.
