unit Template.Test;

interface

uses
  DUnitX.TestFramework, TemplateEngine;

type
  [TestFixture]
  TTemplateTest = class
  public
    [Test]
    procedure TestStringReplacement();
    [Test]
    procedure TestIntegerReplacement();
    [Test]
    procedure TestDoubleReplacement();
  end;

implementation

procedure TTemplateTest.TestStringReplacement();
const
  TEMPLATE = 'name: <#name>';
  EXPECTED_OUTPUT = 'name: John Doe';
var
  output: string;
begin
  output := TTemplateEngine.Create(TEMPLATE)
    .replace('name', 'John Doe')
    .output;

  Assert.AreEqual(EXPECTED_OUTPUT, output);
end;

procedure TTemplateTest.TestIntegerReplacement();
const
  TEMPLATE = 'id: <#id>';
  EXPECTED_OUTPUT = 'id: 1234';
var
  output: string;
begin
  output := TTemplateEngine.Create(TEMPLATE)
    .replace('id', 1234)
    .output;

  Assert.AreEqual(EXPECTED_OUTPUT, output);
end;

procedure TTemplateTest.TestDoubleReplacement();
const
  TEMPLATE = 'rounded value: <#rounded-value>';
  EXPECTED_OUTPUT = 'rounded value: 12,35';
var
  output: string;
begin
  output := TTemplateEngine.Create(TEMPLATE)
    .replace('rounded-value', 12.3456, 2)
    .output;

  Assert.AreEqual(EXPECTED_OUTPUT, output);
end;

initialization
  TDUnitX.RegisterTestFixture(TTemplateTest);

end.
