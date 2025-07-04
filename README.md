# Simple Delphi Template Engine

This repository is a simple template engine for Delphi. It allows you to replace placeholders in a text template with values.

The component is memory safe.

```delphi
uses
  TemplateEngine;
...
var
  template: string;
  output: string;
begin
  template := 
      'name: <#name>' + #10#13
    + 'id: <#id>' + #10#13
    + 'rounded value: <#rounded-value>';

  output := TTemplateEngine.Create(template)
    .replace('name', 'John Doe')
    .replace('id', 1234)
    .replace('rounded-value', 12.3456, 2)
    .output;  // also destroys TTemplateEngine object

  WriteLine(output);
  // name: John Doe
  // id: 1234
  // rounded value: 12.35
end;
```